//
//  ExtraccionesDetalle.m
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 10/13/15.
//
//

#import "ExtraccionesDetalle.h"
#import "Cuenta.h"
#import "WaitingAlert.h"
#import "Context.h"
#import "Usuario.h"
#import "Util.h"
#import "CommonUIFunctions.h"
#import "WS_AltaMandato.h"
#import "AltaMandatoMobileDTO.h"
#import "MandatarioMobileDTO.h"
#import "MandatoMobileDTO.h"
#import "DatosAutenticacionMobileDTO.h"
#import "TerminalMobileDTO.h"
#import "WSUtil.h"
#import "MenuBanelcoController.h"
#import "ExtraccionesResult.h"
#import "CommonFunctions.h"
#import "WSRequest.h"

@interface ExtraccionesDetalle ()

@end

@implementation ExtraccionesDetalle

@synthesize botonPagar, selectedCuenta, tipoDoc, importe, nroDoc;

- (id) initWithTitle:(NSString *)t {
    if ((self = [super init])) {
        self.title = t;
        self.botonPagar = [[UIButton alloc] init];
        self.botonPagar.accessibilityLabel = @"Aceptar";
        [self.botonPagar setBackgroundImage:[UIImage imageNamed:@"btn_aceptar.png"] forState:UIControlStateNormal];
        [self.botonPagar setBackgroundImage:[UIImage imageNamed:@"btn_aceptarselec.png"] forState:UIControlStateHighlighted];
        [self.botonPagar addTarget:self action:@selector(extraer) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    waiting = [[WaitingAlert alloc] init];
    [self.view addSubview:waiting];
    
    [self iniciar];
    
    int limite = 260;
    self.tableView.frame = CGRectMake(5, 5, 310, limite - 5);
    
    self.botonPagar.frame = CGRectMake(109, 265, 102, 32);
    [self.view addSubview:self.botonPagar];
    
    [self.tableView reloadData];
    
}

- (void)iniciar {
    
    // Empresa
    [titulos addObject: @""];
    [datos addObject:@"Orden de Extracción"];
    
    // Importe
    [titulos addObject: @"De"];
    [datos addObject:[self.selectedCuenta getDescripcion]];
    
    // Descripcion cliente
    [titulos addObject:@"A"];
    if (self.nroDoc) {
        [datos addObject:[NSString stringWithFormat:@"%@ %@", [self getNombreTipo:[self.tipoDoc intValue]], self.nroDoc]];
    }
    else {
        [datos addObject:[NSString stringWithFormat:@"%@ %@", [self getNombreTipo:[[Context sharedContext].usuario.tipoDocumento intValue]], [Context sharedContext].usuario.nroDocumento]];
    }
    
    // Importe
    [titulos addObject:@"Importe"];
    [datos addObject:[NSString stringWithFormat:@"$ %@",[Util formatSaldo:self.importe]]];
    
}

- (NSString *)getNombreTipo:(int)tipo {
    NSString *n = nil;
    switch (tipo) {
        case 1:
            n = @"DNI";
            break;
        case 2:
            n = @"CI";
            break;
        case 3:
            n = @"PAS";
            break;
        case 4:
            n = @"LC";
            break;
        case 5:
            n = @"LE";
            break;
        default:
            n = @"";
            break;
    }
    return n;
}

- (void)extraer {
    
    [waiting startWithSelector:@"ejecutarExtraccion" fromTarget:self];
    
}

- (void)ejecutarExtraccion {
    
    WS_AltaMandato *request = [[WS_AltaMandato alloc] init];
    request.userToken = [[Context sharedContext] getToken];
    request.codBanco = [Context sharedContext].banco.idBanco;
    MandatarioMobileDTO *mandatario = [[MandatarioMobileDTO alloc] init];
    mandatario.tipoDocMandatario = [Context sharedContext].usuario.tipoDocumento;
    mandatario.nroDocMandatario = [Context sharedContext].usuario.nroDocumento;
    mandatario.tipoCuentaMandatario = self.selectedCuenta.codigoTipoCuenta;
    mandatario.nroCuentaMandatario = self.selectedCuenta.numero;
    request.mandatario = mandatario;
    [mandatario release];
    MandatoMobileDTO *mandato = [[MandatoMobileDTO alloc] init];
    mandato.tipoDocBeneficiario = self.tipoDoc;
    mandato.nroDocBeneficiario = self.nroDoc;
    mandato.codigoIdentificacionMandato = nil;
    mandato.montoMandato = [self.importe stringByReplacingOccurrencesOfString:@"," withString:@"."];
    mandato.fechaVencimiento = [CommonFunctions dateToNSString:[NSDate date] withFormat:[CommonFunctions BEWSFormat]];
    mandato.isBaja = NO;
    request.mandato = mandato;
    [mandato release];
    DatosAutenticacionMobileDTO *dat = [[DatosAutenticacionMobileDTO alloc] init];
    dat.factor = @"O";
    dat.nroSecuenciaAutenticacion = @"0";
    dat.fechaHoraAutenticacion = [CommonFunctions dateToNSString:[NSDate date] withFormat:[CommonFunctions BEWSFormat]];
    request.autenticacion = dat;
    [dat release];
    TerminalMobileDTO *ter = [[TerminalMobileDTO alloc] init];
    ter.terminal = nil;
    ter.datosTerminal = nil;
    ter.canal = @"O";
    ter.direccionIp = [WSRequest securityToken];
    request.terminal = ter;
    [ter release];
    
    id result = [WSUtil execute:request];
    
    if ([result isKindOfClass:[AltaMandatoMobileDTO class]]) {
        ExtraccionesResult *r = [[ExtraccionesResult alloc] initWithTitle:self.title];
        r.altaMandato = result;
        r.mandatario = request.mandatario;
        r.mandato = request.mandato;
        r.cuenta = self.selectedCuenta;
        [[MenuBanelcoController sharedMenuController] pushScreen:r];
    }
    else if ([result isKindOfClass:[NSError class]]) {
        NSString *errorCode = [[(NSError *)result userInfo] valueForKey:@"faultCode"];
        if ([errorCode isEqualToString:@"ss"]) {
            return;
        }
        NSString *errorDesc = [[(NSError *)result userInfo] valueForKey:@"description"];
        [CommonUIFunctions showAlert:self.title withMessage:errorDesc cancelButton:@"Cerrar" andDelegate:nil];
        return;
    }
    else {
        [CommonUIFunctions showAlert:self.title withMessage:@"En este momento no se puede realizar la operación. Reintenta más tarde." cancelButton:@"Aceptar" andDelegate:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.botonPagar = nil;
    self.selectedCuenta = nil;
    self.tipoDoc = nil;
    self.importe = nil;
    self.nroDoc = nil;
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
