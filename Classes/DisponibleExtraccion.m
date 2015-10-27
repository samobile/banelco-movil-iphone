//
//  DisponibleExtraccion.m
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 7/13/15.
//
//

#import "DisponibleExtraccion.h"
#import "Cuenta.h"
#import "WS_ConsultarSaldos.h"
#import "Context.h"
#import "CommonUIFunctions.h"
#import "WSUtil.h"
#import "MenuBanelcoController.h"
#import "CommonFunctions.h"
#import "Util.h"

@interface DisponibleExtraccion ()

@end

@implementation DisponibleExtraccion

@synthesize descripcion, importe, cuenta;

-(id) initWithCuenta:(Cuenta*) c{
    
    if(self = [super init]){
        self.cuenta = c;
        self.title = @"Disponible de Extracción";
    }
    
    return self;
}

- (void)accionWithDelegate:(WheelAnimationController *)delegate {
    Cuenta *result = nil;
    
    WS_ConsultarSaldos *request = [[WS_ConsultarSaldos alloc] init];
    
    
    Context *context = [Context sharedContext];
    request = [[WS_ConsultarSaldos alloc] init];
    request.userToken = [context getToken];
    request.numeroCuenta = self.cuenta.numero;
    request.codigoTipoCuenta = [self.cuenta.codigoTipoCuenta intValue];
    request.codigoMonedaCuenta = self.cuenta.codigoMoneda;
    result = [WSUtil execute:request];
    
    if (![result isKindOfClass:[NSError class]]) {
        
        NSLog(@"EL SALDO ES = %@",[result disponible]);
        [self performSelectorOnMainThread:@selector(mostrarDisponible:) withObject:[Util formatSaldo:[result disponible]] waitUntilDone:NO];
        
    } else {
        NSString *errorCode = [[(NSError *)result userInfo] valueForKey:@"faultCode"];
        if ([errorCode isEqualToString:@"ss"]) {
            return;
        }
        else {
            NSString *errorDesc = [[(NSError *)result userInfo] valueForKey:@"description"];
            [CommonUIFunctions showAlert:@"Disponible de Extracción" withMessage:errorDesc cancelButton:@"Volver" andDelegate:self];
            
            [delegate accionFinalizada:FALSE];
            return;
        }
        
    }
    [delegate accionFinalizada:FALSE];
    
}

- (void)mostrarDisponible:(NSString *)disp {
    self.importe.text = [NSString stringWithFormat:@"$ %@", disp];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.descripcion.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
    self.descripcion.backgroundColor = [UIColor clearColor];
    if (![Context sharedContext].personalizado) {
        self.descripcion.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:15];
    }
    self.descripcion.text = [NSString stringWithFormat:@"Disponible diario de extracción en cajeros Banco %@", [Context sharedContext].banco.nombre];
    self.importe.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
    self.importe.backgroundColor = [UIColor clearColor];
    if (![Context sharedContext].personalizado) {
        self.importe.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:15];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.cuenta = nil;
    self.descripcion = nil;
    self.importe = nil;
    [super dealloc];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
