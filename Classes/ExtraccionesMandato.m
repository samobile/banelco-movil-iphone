//
//  ExtraccionesMandato.m
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 10/14/15.
//
//

#import "ExtraccionesMandato.h"
#import "Context.h"
#import "MandatoBeanMobile.h"
#import "MandatarioBeanMobile.h"
#import "CommonUIFunctions.h"
#import "WS_CancelacionMandato.h"
#import "MandatarioMobileDTO.h"
#import "MandatoMobileDTO.h"
#import "TerminalMobileDTO.h"
#import "WSUtil.h"
#import "CommonFunctions.h"
#import "ExtraccionesConsultas.h"

@interface ExtraccionesMandato ()

@end

@implementation ExtraccionesMandato

@synthesize ordenTitle, destTitle, destLbl, importeTitle, importeLbl, cuentaTitle, cuentaLbl, statusTitle, statusLbl, mandatoBean, fechaLbl, fndTicket, btnAnular, waiting, consultasDelegate;

- (id) initWithTitle:(NSString *)t {
    if ((self = [super init])) {
        self.title = t;
    }
    return self;
}

- (void)setFontTypes {
    if ([Context sharedContext].personalizado) {
        return;
    }
    ordenTitle.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:16];
    destLbl.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:14];
    destTitle.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:14];
    importeTitle.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:14];
    importeLbl.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:14];
    cuentaTitle.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:14];
    cuentaLbl.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:14];
    statusTitle.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:14];
    statusLbl.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:14];
    fechaLbl.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:14];
}

- (void)setTxtColor {
    
    if ([Context sharedContext].personalizado) {
        return;
    }
    
    UIColor *color = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
    
    ordenTitle.textColor = color;
    destLbl.textColor = color;
    destTitle.textColor = color;
    importeTitle.textColor = color;
    importeLbl.textColor = color;
    cuentaTitle.textColor = color;
    cuentaLbl.textColor = color;
    statusTitle.textColor = color;
    statusLbl.textColor = color;
    fechaLbl.textColor = color;
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

- (NSString *)getNombreStatus:(int)tipo {
    NSString *n = nil;
    switch (tipo) {
        case 0:
            n = @"Pendiente"; //-1
            break;
        case 1:
            n = @"Cancelado";
            break;
        case 2:
            n = @"Bloqueado";
            break;
        case 3:
            n = @"Cobrado";
            break;
        case 4:
            n = @"Vencido";
            break;
        default:
            n = @"";
            break;
    }
    return n;
}

- (NSString *)getDescCuenta:(NSString *)tipo {
    NSString *n = nil;
    if ([tipo isEqualToString:@"01"]) {
        n = @"CC $";
    }
    else if ([tipo isEqualToString:@"11"]) {
        n = @"CA $";
    }
    else if ([tipo isEqualToString:@"02"]) {
        n = @"CC U$S";
    }
    else if ([tipo isEqualToString:@"12"]) {
        n = @"CA U$S";
    }
    return n;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setFontTypes];
    [self setTxtColor];
    
    destLbl.text = [NSString stringWithFormat:@"%@ %@", [self getNombreTipo:[self.mandatoBean.tipoDocumentoBeneficiario intValue]], self.mandatoBean.numeroDocumentoBeneficiario];
    NSString *im = self.mandatoBean.montoMandato;
    importeLbl.text = [NSString stringWithFormat:@"$ %@", [im stringByReplacingOccurrencesOfString:@"." withString:@","]];
    cuentaLbl.text = [NSString stringWithFormat:@"%@ %@", [self getDescCuenta:self.mandatoBean.mandatario.tipoCuentaMandatario], self.mandatoBean.mandatario.nroCuentaMandatario];
    statusLbl.text = [self getNombreStatus:[self.mandatoBean.estado intValue]];
    fechaLbl.text = [NSString stringWithFormat:@"%@", self.mandatoBean.fechaAlta];
    
    if (!IS_IPHONE_5) {
        CGRect r = self.fndTicket.frame;
        r.size.height = 250;
        self.fndTicket.frame = r;
        
        r = self.btnAnular.frame;
        r.origin.y = 277;
        self.btnAnular.frame = r;
    }
    
    if (![self.mandatoBean.estado isEqualToString:@"0"]) {
        self.btnAnular.hidden = YES;
    }
    else {
        self.waiting = [[[WaitingAlert alloc] init] autorelease];
        [self.view addSubview:waiting];
    }
}

- (IBAction)anularExtraccion:(id)sender {
    [CommonUIFunctions showConfirmationAlert:self.title withMessage:@"¿Confirma que desea anular el mandato?" andDelegate:self];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [waiting startWithSelector:@"ejecutarAnular" fromTarget:self];
    }
}

- (void)ejecutarAnular {
    WS_CancelacionMandato *request = [[WS_CancelacionMandato alloc] init];
    request.userToken = [[Context sharedContext] getToken];
    request.codBanco = [Context sharedContext].banco.idBanco;
    MandatarioMobileDTO *mandatario = [[MandatarioMobileDTO alloc] init];
    mandatario.tipoDocMandatario = self.mandatoBean.mandatario.tipoDocMandatario;
    mandatario.nroDocMandatario = self.mandatoBean.mandatario.nroDocMandatario;
    mandatario.tipoCuentaMandatario = self.mandatoBean.mandatario.tipoCuentaMandatario;
    mandatario.nroCuentaMandatario = self.mandatoBean.mandatario.nroCuentaMandatario;
    request.mandatario = mandatario;
    [mandatario release];
    MandatoMobileDTO *mandato = [[MandatoMobileDTO alloc] init];
    mandato.tipoDocBeneficiario = self.mandatoBean.tipoDocumentoBeneficiario;
    mandato.nroDocBeneficiario = self.mandatoBean.numeroDocumentoBeneficiario;
    mandato.codigoIdentificacionMandato = self.mandatoBean.codigoIdentificacionMandato;
    mandato.montoMandato = [self.mandatoBean.montoMandato stringByReplacingOccurrencesOfString:@"," withString:@"."];
    NSDate *d = [CommonFunctions NSStringToNSDate:self.mandatoBean.fechaVencimiento withFormat:[CommonFunctions WSFormatProfileDOBInSpanish]];
    mandato.fechaVencimiento = [CommonFunctions dateToNSString:d withFormat:[CommonFunctions BEWSFormat]];
    mandato.isBaja = NO;
    request.mandato = mandato;
    [mandato release];
    TerminalMobileDTO *ter = [[TerminalMobileDTO alloc] init];
    ter.terminal = nil;
    ter.datosTerminal = nil;
    ter.canal = @"O";
    ter.direccionIp = [WSRequest securityToken];
    request.terminal = ter;
    [ter release];
    
    id result = [WSUtil execute:request];
    
    if ([result isKindOfClass:[NSNumber class]]) {
        if ([(NSNumber *)result boolValue] == YES) {
            [self performSelectorOnMainThread:@selector(refreshDatos) withObject:nil waitUntilDone:NO];
            self.consultasDelegate.ejecutarConsulta = NO;
        }
        else {
            [CommonUIFunctions showAlert:self.title withMessage:@"En este momento no se puede realizar la operación. Reintenta más tarde." cancelButton:@"Aceptar" andDelegate:nil];
        }
    }
    else if ([result isKindOfClass:[NSError class]]) {
        NSString *errorCode = [[(NSError *)result userInfo] valueForKey:@"faultCode"];
        if ([errorCode isEqualToString:@"ss"]) {
            return;
        }
        NSString *errorDesc = [[(NSError *)result userInfo] valueForKey:@"description"];
        [CommonUIFunctions showAlert:self.title withMessage:errorDesc cancelButton:@"Aceptar" andDelegate:nil];
        return;
    }
    else {
        [CommonUIFunctions showAlert:self.title withMessage:@"En este momento no se puede realizar la operación. Reintenta más tarde." cancelButton:@"Aceptar" andDelegate:nil];
    }
}

- (void)refreshDatos {
    self.statusLbl.text = @"Anulado";
    self.btnAnular.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.ordenTitle = nil;
    self.destTitle = nil;
    self.destLbl = nil;
    self.importeTitle = nil;
    self.importeLbl = nil;
    self.cuentaTitle = nil;
    self.cuentaLbl = nil;
    self.statusTitle = nil;
    self.statusLbl = nil;
    self.fechaLbl = nil;
    self.mandatoBean = nil;
    self.btnAnular = nil;
    self.fndTicket = nil;
    self.waiting = nil;
    self.consultasDelegate = nil;
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
