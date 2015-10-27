//
//  ExtraccionesResult.m
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 10/14/15.
//
//

#import "ExtraccionesResult.h"
#import "AltaMandatoMobileDTO.h"
#import "Cuenta.h"
#import "Context.h"
#import "MandatarioMobileDTO.h"
#import "MandatoMobileDTO.h"
#import "CommonUIFunctions.h"


@interface ExtraccionesResult ()

@end

@implementation ExtraccionesResult

@synthesize ordenTitle, destTitle, destLbl, importeTitle, importeLbl, cuentaTitle, cuentaLbl, codigoTitle, codigoLbl, leyendaTilte, vigenteTitle, altaMandato, cuenta, mandato, mandatario;

- (id) initWithTitle:(NSString *)t {
    if ((self = [super init])) {
        self.title = t;
        self.nav_volver = NO;
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
    codigoTitle.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:14];
    codigoLbl.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:14];
    leyendaTilte.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:12];
    vigenteTitle.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:12];
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
    codigoTitle.textColor = color;
    codigoLbl.textColor = color;
    leyendaTilte.textColor = color;
    vigenteTitle.textColor = color;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setFontTypes];
    [self setTxtColor];
    
    destLbl.text = [NSString stringWithFormat:@"%@ %@", [self getNombreTipo:[self.mandato.tipoDocBeneficiario intValue]], self.mandato.nroDocBeneficiario];
    NSString *im = self.mandato.montoMandato;
    importeLbl.text = [NSString stringWithFormat:@"$ %@", [im stringByReplacingOccurrencesOfString:@"." withString:@","]];
    cuentaLbl.text = [self.cuenta getDescripcion];
    codigoLbl.text = self.altaMandato.codigoIdentificacionMandato;
    vigenteTitle.text = [NSString stringWithFormat:@"Vigente hasta %@", self.altaMandato.fechaVencimiento];
}

- (IBAction)copiarPortapapeles:(id)sender {
    [CommonUIFunctions showAlert:self.title withMessage:@"El código se copió en el portapapeles." andCancelButton:@"Aceptar"];
    [UIPasteboard generalPasteboard].string = self.altaMandato.codigoIdentificacionMandato;
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
    self.codigoTitle = nil;
    self.codigoLbl = nil;
    self.leyendaTilte = nil;
    self.vigenteTitle = nil;
    self.altaMandato = nil;
    self.cuenta = nil;
    self.mandatario = nil;
    self.mandato = nil;
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
