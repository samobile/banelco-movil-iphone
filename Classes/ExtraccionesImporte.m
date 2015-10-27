//
//  ExtraccionesImporte.m
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 10/8/15.
//
//

#import "ExtraccionesImporte.h"
#import "Context.h"
#import "Cuenta.h"
#import "WaitingAlert.h"
#import "CommonUIFunctions.h"
#import "CommonFunctions.h"
#import "Util.h"
#import "ExtraccionesDetalle.h"
#import "MenuBanelcoController.h"

@interface ExtraccionesImporte ()

@end

@implementation ExtraccionesImporte

@synthesize importe, botonSaldo, botonContinuar, textCuenta, botonCuenta, borrarCuenta, cuentas, ut, barTeclado, limporte, lpeso, lcuenta, containerTercero, selectedCuenta, dniTxt, extraTerceros, listaCuentas, subMenuDNI, barTecladoButton, lTipoDoc;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.selectedCuenta = nil;
    tipoSeleccionado = 0;
    
    //Crea pickerView
    self.listaCuentas = [[[NSMutableArray alloc] initWithArray:[Context getCuentas]] autorelease];
    self.cuentas = [[[UIPickerView alloc] initWithFrame:CGRectMake(0, IPHONE5_HDIFF(361), 320, 216)] autorelease];
    cuentas.showsSelectionIndicator = YES;
    cuentas.backgroundColor = [UIColor whiteColor];
    cuentas.delegate = self;
    
    [self.view addSubview:cuentas];
    
    //toolbar
    CGRect f = CGRectMake(0, IPHONE5_HDIFF(317), 320, 44);
    self.ut = [[[UIToolbar alloc] initWithFrame:f] autorelease];
    [ut setBarStyle:UIBarStyleDefault];
    ut.tintColor = [UIColor grayColor];
    UIBarButtonItem *btnSelect = [[UIBarButtonItem alloc] initWithTitle:@"Seleccionar" style:UIBarButtonItemStyleBordered target:self action:@selector(ocultarCuentas)];
    UIBarButtonItem *btnMiddle = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *btnSaldo = [[UIBarButtonItem alloc] initWithTitle:@"Consultar Saldo" style:UIBarButtonItemStyleBordered target:self action:@selector(consultarSaldo)];
    [ut setItems:[NSArray arrayWithObjects:btnSaldo,btnMiddle,btnSelect,nil]];
    [self.view addSubview:ut];
    
    pickerInScreen = NO;
    
    if (![Context sharedContext].personalizado) {
        importe.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:17];
        textCuenta.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:17];
        limporte.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:17];
        lpeso.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:17];
        lcuenta.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:17];
        dniTxt.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:17];
        lTipoDoc.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:17];
    }
    
    [self borrar:nil];
    
    limporte.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
    lpeso.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
    lcuenta.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
    
    UIImageView *barTecladoIm = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"barra_teclado.png"]];
    self.barTecladoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    barTecladoButton.frame = CGRectMake(222, 8, 88, 29);
    [barTecladoButton setImage:[UIImage imageNamed:@"btn_TecAceptar.png"] forState:UIControlStateNormal];
    barTecladoButton.accessibilityLabel = @"Aceptar";
    [barTecladoButton setTitle:@"" forState:UIControlStateNormal];
    [barTecladoButton addTarget:self action:@selector(closeKeyb:) forControlEvents:UIControlEventTouchUpInside];
    
    self.barTeclado = [[[UIView alloc] initWithFrame:CGRectMake(0, IPHONE5_HDIFF(480), barTecladoIm.bounds.size.width, barTecladoIm.bounds.size.height)] autorelease];
    self.barTeclado.backgroundColor = [UIColor clearColor];
    [self.barTeclado addSubview:barTecladoIm];
    [barTecladoIm release];
    [self.barTeclado addSubview:barTecladoButton];
    
    [self.view addSubview:self.barTeclado];
    
    if (self.extraTerceros) {
        self.title = @"Extracciones para Terceros";
        
        // Tipo Documento
        self.subMenuDNI = [[[UIActionSheet alloc] init] autorelease];
        NSArray *elemTipoDoc = [NSArray arrayWithObjects:@"DNI", @"CI", @"PAS", @"LC", @"LE", nil];
        for (NSString *el in elemTipoDoc) {
            [subMenuDNI addButtonWithTitle:el];
        }
        subMenuDNI.delegate = self;
        
        
    }
    else {
        self.title = @"Extracciones Propias";
        self.containerTercero.hidden = YES;
    }
}

- (IBAction)cambiarTipoDocumento {
    
    [self dismissAll];
    
    if (subMenuDNI.numberOfButtons > 0) {
        [subMenuDNI showInView:self.view];
    }
}

//// ACTION SHEET DELEGATE //////////////////////////////////////////////

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet {
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (actionSheet == subMenuDNI) {
        
        self.lTipoDoc.text = [subMenuDNI buttonTitleAtIndex:buttonIndex];
        tipoSeleccionado = buttonIndex;
        
    }
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (pickerInScreen) {
        [self ocultarCuentas];
    }
    
    if (self.extraTerceros) {
        if (textField == self.importe) {
            [barTecladoButton setImage:[UIImage imageNamed:@"btn_TecSiguiente.png"] forState:UIControlStateNormal];
            barTecladoButton.accessibilityLabel = @"Siguiente";
        }
        else {
            [barTecladoButton setImage:[UIImage imageNamed:@"btn_TecAceptar.png"] forState:UIControlStateNormal];
            barTecladoButton.accessibilityLabel = @"Aceptar";
        }
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.2];
    
    CGFloat y = 0;
    if (textField == dniTxt) {
        y = IS_IPHONE_5 ? 60 : 100;
    }
    CGRect r = self.view.frame;
    r.origin.y -= y;
    self.view.frame = r;
    
    self.barTeclado.frame = CGRectMake(0, IPHONE5_HDIFF(114) + y, self.barTeclado.frame.size.width, self.barTeclado.frame.size.height);
    
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.2];
    
    CGRect r = self.view.frame;
    r.origin.y = 0;
    self.view.frame = r;
    
    self.barTeclado.frame = CGRectMake(0, IPHONE5_HDIFF(480), self.barTeclado.frame.size.width, self.barTeclado.frame.size.height);
    [UIView commitAnimations];
}

- (void)closeKeyb:(UIButton *)btn {
    if ([importe isFirstResponder] && self.extraTerceros) {
        [self.dniTxt becomeFirstResponder];
    }
    else {
        [self dismissAll];
    }
}

- (void)dismissAll {
    if ([self.importe isFirstResponder]) {
        [self.importe resignFirstResponder];
    }
    if([self.dniTxt isFirstResponder]){
        [self.dniTxt resignFirstResponder];
    }
}

- (IBAction)borrar:(id)sender {
    
    textCuenta.text = @"";
    textCuenta.accessibilityLabel = @"";
    textCuenta.accessibilityValue = @"";
    self.selectedCuenta = nil;
}

- (IBAction)selectCuenta:(id)sender {
    
    [self dismissAll];
    
    pickerInScreen = YES;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.35];
    [ut setFrame:CGRectMake(0, IPHONE5_HDIFF(77), 320, 44)];
    cuentas.frame = CGRectMake(0, IPHONE5_HDIFF(121), 320, 216);
    [UIView commitAnimations];
    
}

- (void)ocultarCuentas {
    
    pickerInScreen = YES;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.35];
    
    [ut setFrame:CGRectMake(0, IPHONE5_HDIFF(317), 320, 44)];
    cuentas.frame = CGRectMake(0, IPHONE5_HDIFF(361), 320, 216);
    
    [UIView commitAnimations];
    
    NSUInteger selectedItem = [cuentas selectedRowInComponent:0];
    self.selectedCuenta = [listaCuentas objectAtIndex:selectedItem];
    textCuenta.text = [self.selectedCuenta getDescripcion];
    textCuenta.accessibilityLabel = [CommonFunctions replaceSymbolVoice:textCuenta.text];
    textCuenta.accessibilityValue = @"";
    
}

#pragma mark PickerView Protocol

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"Selected!");
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [listaCuentas count];
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* tView = (UILabel*)view;
    if (!tView){
        CGRect frame = CGRectMake(0.0, 0.0, 270, 32);
        tView = [[[UILabel alloc] initWithFrame:frame] autorelease];
        [tView setTextAlignment:UITextAlignmentLeft];
        [tView setBackgroundColor:[UIColor clearColor]];
        if (![Context sharedContext].personalizado) {
            [tView setFont:[UIFont fontWithName:@"BanelcoBeau-Bold" size:16]];
        }
        else {
            [tView setFont:[UIFont boldSystemFontOfSize:16]];
        }
    }
    tView.text = [[listaCuentas objectAtIndex:row] getDescripcion];
    tView.accessibilityLabel = [CommonFunctions replaceSymbolVoice:tView.text];
    return tView;
}

- (void)consultarSaldo {
    
    WaitingAlert *w = [[WaitingAlert alloc] initWithH:65];
    
    [self.view addSubview:w];
    
    [w startWithSelector:@"consultarSaldoPago" fromTarget:self];
    
    [w release];
    
}

- (void)consultarSaldoPago {
    
    NSUInteger selectedItem = [cuentas selectedRowInComponent:0];
    
    Cuenta *cuenta = [Cuenta getSaldo:[listaCuentas objectAtIndex:selectedItem] withLyD:YES];
    if (![cuenta isKindOfClass:[NSError class]]) {
        [CommonUIFunctions showAlert:[cuenta getDescripcionSaldoAlerta:YES] withMessage:nil andCancelButton:@"Cerrar"];
    }
    else {
        NSString *errorCode = [[(NSError *)cuenta userInfo] valueForKey:@"faultCode"];
        if ([errorCode isEqualToString:@"ss"]) {
            return;
        }
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if(textField == importe) {
        if ([textField.text length] + [string length] > 10) {
            return NO;
        }
        
        if (![CommonFunctions hasNumbers:string]) {
            return NO;
        }
        
        importe.text = [Util formatImporte:textField.text appendingValue:string];
    }
    else if(textField == dniTxt) {
        
        if (![CommonFunctions hasNumbers:string]) {
            return NO;
        }
        
        return YES;
    }
    
    return NO;
}

- (BOOL)validacionOk {
    
    if (self.selectedCuenta == nil) {
        [CommonUIFunctions showAlert:self.title withMessage:@"Debes seleccionar una cuenta" andCancelButton:@"Aceptar"];
        return NO;
    }
    if ([importe.text isEqualToString:@""] || [importe.text isEqualToString:@"0,00"]) {
        [CommonUIFunctions showAlert:self.title withMessage:@"Debes completar el importe" andCancelButton:@"Aceptar"];
        return NO;
    }
    else {
        CGFloat imp = [importe.text doubleValue];
        if (fmod(imp, 100) != 0.0) {
            [CommonUIFunctions showAlert:self.title withMessage:@"El importe debe ser múltiplo de 100" andCancelButton:@"Aceptar"];
            return NO;
        }
    }
    
    if (!self.containerTercero.hidden) {
        if(([self.dniTxt.text length] < 1)) {
            [CommonUIFunctions showAlert:self.title withMessage:@"El número de documento no debe estar vacío." andCancelButton:@"Aceptar"];
            return NO;
        }
    }
    
    return YES;
}

- (IBAction)continuar:(id)sender {
    if (![self validacionOk]) {
        return;
    }
    ExtraccionesDetalle *p = [[ExtraccionesDetalle alloc] initWithTitle:self.title];
    p.importe = self.importe.text;
    p.tipoDoc = [Context sharedContext].usuario.tipoDocumento;
    p.nroDoc = [Context sharedContext].usuario.nroDocumento;
    if (self.extraTerceros) {
        p.tipoDoc = [NSString stringWithFormat:@"%li", tipoSeleccionado+1];
        p.nroDoc = self.dniTxt.text;
    }
    p.selectedCuenta = self.selectedCuenta;
    [[MenuBanelcoController sharedMenuController] pushScreen:p];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    self.lTipoDoc = nil;
    self.barTecladoButton = nil;
    self.subMenuDNI = nil;
    self.listaCuentas = nil;
    self.importe = nil;
    self.botonSaldo = nil;
    self.botonContinuar = nil;
    self.textCuenta = nil;
    self.botonCuenta = nil;
    self.borrarCuenta = nil;
    self.cuentas = nil;
    self.ut = nil;
    self.barTeclado = nil;
    self.limporte = nil;
    self.lpeso = nil;
    self.lcuenta = nil;
    self.dniTxt = nil;
    [super dealloc];
}

@end
