//
//  CargaCelularImporte.m
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 9/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CargaCelularImporteController.h"
#import "Empresa.h"
#import "CargaCelularPago.h"
#import "MenuBanelcoController.h"
#import "CommonFunctions.h"
#import "CommonUIFunctions.h"
#import "WaitingAlert.h"
#import "WS_ConsultarListaImportes.h"
#import "WSUtil.h"

@implementation CargaCelularImporteController

@synthesize importe, botonSaldo, botonContinuar, titulo, empresa, idCliente, descCliente, empresaId;
@synthesize botonCuenta, borrarCuenta, textCuenta, cuentas, ut;

@synthesize barTeclado,barTecladoButton;

@synthesize limporte, lpeso, lcuenta;

@synthesize infoContainer, operadorLbl, carrierLbl, otroBtn, ceroLbl, quinceLbl, codTf, nroTf, importeToolBar, importesList, carrierSeleccionado, subMenuCarrier, importesDict, empresasRecarga;

Cuenta *selectedCuenta;
NSMutableArray *listaCuentas;
BOOL pickerInScreen;
WaitingAlert *w;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

- (id)initWithTitle:(NSString *)t yEmpresaId:(NSString *)empId {
    if ((self = [super init])) {
        // Custom initialization
		self.title = t;
		self.empresaId = empId;
		
		self.importesList = nil;
        self.importesDict = nil;
		
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Crea pickerView
    listaCuentas = [[NSMutableArray alloc] initWithArray:[Context getCuentas]];
    cuentas = [[UIPickerView alloc] initWithFrame:CGRectMake(0, IPHONE5_HDIFF(361), 320, 216)];
    cuentas.showsSelectionIndicator = YES;
    cuentas.backgroundColor = [UIColor whiteColor];
    cuentas.delegate = self;
    
    [self.view addSubview:cuentas];
    
    //toolbar
    CGRect f = CGRectMake(0, IPHONE5_HDIFF(317), 320, 44);
    ut = [[UIToolbar alloc] initWithFrame:f];
    [ut setBarStyle:UIBarStyleDefault];
    ut.tintColor = [UIColor grayColor];
    UIBarButtonItem *btnSelect = [[UIBarButtonItem alloc] initWithTitle:@"Seleccionar" style:UIBarButtonItemStyleBordered target:self action:@selector(ocultarCuentas)];
    UIBarButtonItem *btnMiddle = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *btnSaldo = [[UIBarButtonItem alloc] initWithTitle:@"Consultar Saldo" style:UIBarButtonItemStyleBordered target:self action:@selector(consultarSaldo)];
    [ut setItems:[NSArray arrayWithObjects:btnSaldo,btnMiddle,btnSelect,nil]];
    [self.view addSubview:ut];
    
    
    //importe
    //toolbar
    f = CGRectMake(0, IPHONE5_HDIFF(317), 320, 44);
    self.importeToolBar = [[UIToolbar alloc] initWithFrame:f];
    [self.importeToolBar setBarStyle:UIBarStyleDefault];
    self.importeToolBar.tintColor = [UIColor grayColor];
    btnSelect = [[UIBarButtonItem alloc] initWithTitle:@"Seleccionar" style:UIBarButtonItemStyleBordered target:self action:@selector(ocultarImportes)];
    btnMiddle = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [self.importeToolBar setItems:[NSArray arrayWithObjects:btnMiddle,btnSelect,nil]];
    [self.view addSubview:self.importeToolBar];
    
    pickerInScreen = NO;
    
    if (self.empresaId) {
        self.infoContainer.hidden = YES;
    }
    else {
        // Carriers
        self.subMenuCarrier = [[[UIActionSheet alloc] init] autorelease];
        //NSArray *elemCarriers = [NSArray arrayWithObjects:@"Claro", @"Movistar", @"Nextel", @"Personal", @"Quam", nil];
        for (NSString *el in [Context sharedContext].carrierNames) {
            [self.subMenuCarrier addButtonWithTitle:el];
        }
        self.subMenuCarrier.delegate = self;
        self.carrierSeleccionado = 1;
        self.carrierLbl.text = [self.subMenuCarrier buttonTitleAtIndex:0];
    }

    if (![Context sharedContext].personalizado) {
        importe.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:17];
        textCuenta.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:17];
        limporte.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:17];
        lpeso.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:17];
        lcuenta.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:17];
    }
    
	[self borrar:nil];
		
	/*if ([listaCuentas count] == 1) {
		selectedCuenta = [listaCuentas objectAtIndex:0];
		textCuenta.text = [selectedCuenta getDescripcion];
	}*/
	
	pickerInScreen = NO;

	barTeclado = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"barra_teclado.png"]];
	barTeclado.alpha = 0;
	
	barTecladoButton = [UIButton buttonWithType:UIButtonTypeCustom];
	barTecladoButton.frame = CGRectMake(222, IPHONE5_HDIFF(488), 88, 29);
	barTecladoButton.alpha =1;
	//	barTecladoButton.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"barra_boton.png"]];
	
	[barTecladoButton setImage:[UIImage imageNamed:@"btn_TecAceptar.png"] forState:UIControlStateNormal];
    barTecladoButton.accessibilityLabel = @"Aceptar";
	[barTecladoButton setTitle:@"" forState:UIControlStateNormal];
	[barTecladoButton addTarget:self action:@selector(dismissAll) forControlEvents:UIControlEventTouchUpInside];
	
	
	[self.view addSubview:barTeclado];
	[self.view addSubview:barTecladoButton];
	
	limporte.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	lpeso.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	lcuenta.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
	


}

-(IBAction)cambiarCarrier {
    
    if (self.subMenuCarrier.numberOfButtons > 0) {
        [self.subMenuCarrier showInView:self.view]; 
    }
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet {
    
    [self dismissAll];
    if (pickerInScreen) {
        if (cuentasPicker) {
            [self ocultarCuentas];
        }
        else {
            [self ocultarImportes];
        }
    }
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (actionSheet == self.subMenuCarrier) {
        if (self.carrierSeleccionado == (int)buttonIndex + 1) {
            return;
        }
        self.importe.text = @"";
        self.carrierLbl.text = [self.subMenuCarrier buttonTitleAtIndex:buttonIndex];
        self.carrierSeleccionado = (int)buttonIndex + 1;
        self.importesList = [self.importesDict objectForKey:[[Context sharedContext].carrierCodeNames objectAtIndex:buttonIndex]];
        
    }
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


- (void) keyboardWillShow: (NSNotification*) aNotification {	
	
	
	NSLog(@"kWs");
	
	barTeclado.frame = CGRectMake(0, IPHONE5_HDIFF(480), 320, 45);
	barTeclado.alpha = 1;
	
	barTecladoButton.frame = CGRectMake(222, IPHONE5_HDIFF(488), 88, 29);
	barTecladoButton.alpha =1;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	
//	CGRect rect = [[self view] frame];
//	rect.origin.y -= 20;
//	rect.size.height += 20;
//	[[self view] setFrame: rect];
	
	barTeclado.frame = CGRectMake(0, IPHONE5_HDIFF(114), 320, 45);
	barTecladoButton.frame = CGRectMake(222, IPHONE5_HDIFF(122), 88, 29);
	
	[UIView commitAnimations];
	
	
	
	
	
}

- (void) keyboardWillHide: (NSNotification*) aNotification {
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	
//	CGRect rect = [[self view] frame];
//	rect.origin.y += 20;
//	rect.size.height -= 20;
//	[[self view] setFrame: rect];
	
	barTeclado.frame = CGRectMake(0, IPHONE5_HDIFF(480), 320, 50);
	barTeclado.alpha =0;
	barTecladoButton.frame = CGRectMake(222, IPHONE5_HDIFF(488), 88, 29);
	barTecladoButton.alpha =1;
	
	
	
	[UIView commitAnimations];
}


- (IBAction)continuar {
	
	if (pickerInScreen) {
        [self ocultarCuentas];
    }
    
    if (![self validacionOk]) {
		return;
	}
	
	if (empresa && empresa.codMoneda != selectedCuenta.codigoMoneda) {
		[CommonUIFunctions showAlert:@"Pago" withMessage:@"El tipo de moneda de la cuenta debe ser igual al del pago." andCancelButton:@"Aceptar"];
		return;
	}
		
	CargaCelularPago *p = [[CargaCelularPago alloc] initWithTitle:@"Estás cargando"];
    p.empresa = self.empresa ? self.empresa : [self.empresasRecarga objectForKey:[[Context sharedContext].carrierCodeNames objectAtIndex:self.carrierSeleccionado-1]];
	p.importe = self.importe.text;
    p.idCliente = self.idCliente ? self.idCliente : [NSString stringWithFormat:@"%@%@", self.codTf.text, self.nroTf.text];
	p.descCliente = self.descCliente;
	p.selectedCuenta = selectedCuenta;
	[[MenuBanelcoController sharedMenuController] pushScreen:p];
}

- (BOOL)validacionOk {
	
	if ([importe.text isEqualToString:@""] || [importe.text isEqualToString:@"0,00"]) {
		[CommonUIFunctions showAlert:self.title withMessage:@"Debes completar el importe" andCancelButton:@"Aceptar"];
		return NO;
	}
	else if (selectedCuenta == nil) {
		[CommonUIFunctions showAlert:self.title withMessage:@"Debes seleccionar una cuenta" andCancelButton:@"Aceptar"];
		return NO;
	}
    else if (!self.infoContainer.hidden) {
        if ([self.codTf.text length] + [self.nroTf.text length] != 10) {
            [CommonUIFunctions showAlert:self.title withMessage:@"Debes cargar un número de celular válido" andCancelButton:@"Aceptar"];
            return NO;
        }
    }

	return YES;
}

- (void)accionWithDelegate:(WheelAnimationController *)delegate {
	
    self.empresa = nil;
    BOOL error = NO;
    if (self.empresaId) {
        self.empresa = [Empresa getEmpresa:self.empresaId];
        
        if (!self.empresa) {
            [CommonUIFunctions showAlert:@"Mi Celular" withMessage:@"Tu operador celular no está disponible" cancelButton:@"Aceptar" andDelegate:self];
            error = YES;
        }
        else if ([self.empresa isKindOfClass:[NSError class]]) {
            
            NSString *errorCode = [[(NSError *)self.empresa userInfo] valueForKey:@"faultCode"];
            if ([errorCode isEqualToString:@"ss"]) {
                return;
            }
            
            NSString *errorDesc = [[(NSError *)self.empresa userInfo] valueForKey:@"description"];
            [CommonUIFunctions showAlert:self.title withMessage:errorDesc cancelButton:@"Volver" andDelegate:self];
            error = YES;
        }
        else {
            
            // Se filtra el listado de cuentas segun moneda del pago
            if (empresa) {
                
                if (listaCuentas) {
                    [listaCuentas release];
                }
                listaCuentas = [[NSMutableArray alloc] initWithArray:[Context getCuentas:empresa.codMoneda]];
            }
            
            //controla que tenga disponible al menos 1 cuenta para seleccionar
            if (listaCuentas) {
                
                if ([listaCuentas count] == 1) {
                    selectedCuenta = [listaCuentas objectAtIndex:0];
                    textCuenta.text = [selectedCuenta getDescripcion];
					textCuenta.accessibilityLabel = [CommonFunctions replaceSymbolVoice:textCuenta.text];
                	textCuenta.accessibilityValue = @"";
                }
                else if ([listaCuentas count] == 0) {
                    [CommonUIFunctions showAlert:self.title withMessage:@"No se puede efectuar la operación seleccionada. Para realizar la recarga deberás poseer una cuenta en pesos" cancelButton:@"Volver" andDelegate:self];
                    error = YES;
                }
            }
            else {
                [CommonUIFunctions showAlert:self.title withMessage:@"No se puede efectuar la operación seleccionada. Para realizar la recarga deberás poseer una cuenta en pesos" cancelButton:@"Volver" andDelegate:self];
                error = YES;
            }
            
            //[cuentas reloadAllComponents];
            ////////////////////////////////////////////////////////
            
            CGRect r = CGRectMake(20, 20, 250, 30);
            UILabel *emp = [[UILabel alloc] initWithFrame:r];
            emp.text = [NSString stringWithFormat:@"%@",empresa.nombre];
            if (![Context sharedContext].personalizado) {
                emp.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:18];
            }
            else {
                emp.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
            }
            emp.backgroundColor = [UIColor clearColor];
            emp.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
            [self.view addSubview:emp];
            [emp release];
            
            r = CGRectMake(20, 71, 250, 30);
            UILabel *idC = [[UILabel alloc] initWithFrame:r];
            if (self.descCliente != nil && ![self.descCliente isEqualToString:@""]) {
                idC.text = [NSString stringWithFormat:@"ID: %@",self.descCliente];
            }
            else {
                idC.text = [NSString stringWithFormat:@"ID: %@",self.idCliente];
            }
            if (![Context sharedContext].personalizado) {
                idC.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:18];
            }
            else {
                idC.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
            }
            idC.backgroundColor = [UIColor clearColor];
            idC.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
            [self.view addSubview:idC];
            [idC release];
            
        }
    }
    if (!error) {
        //traer importes y empresas recarga, si da error mostrar mensaje y salir
        self.empresasRecarga = [[[NSMutableDictionary alloc] init] autorelease];
        self.importesDict = [[[NSMutableDictionary alloc] init] autorelease];
        BOOL first = YES;
        for (NSString *carrier in [Context sharedContext].carrierCodeNames) {
            Empresa *e = [Empresa getEmpresa:carrier];
            if (e) {
                [self.empresasRecarga setObject:e forKey:carrier];
            }
            else {
                [CommonUIFunctions showAlert:self.title withMessage:@"No se puede efectuar la operación seleccionada." cancelButton:@"Volver" andDelegate:self];
                break;
            }
            NSMutableArray *a = [self getImportes:carrier];
            if (a && [a count] > 0) {
                [self.importesDict setObject:a forKey:carrier];
                if (first) {
                    self.importesList = a;
                    first = NO;
                }
            }
            else {
                [CommonUIFunctions showAlert:self.title withMessage:@"No se puede efectuar la operación seleccionada." cancelButton:@"Volver" andDelegate:self];
                break;
            }
        }
        //repe, remo, quam, renx
        //self.importesList = [[[NSMutableArray alloc] initWithObjects:@"10",@"20",@"30",@"40",@"50", nil] autorelease];
    }
    
	

	[delegate accionFinalizada:TRUE];
}

- (NSMutableArray *)getImportes:(NSString *)cod {
    
    WS_ConsultarListaImportes * request = [[WS_ConsultarListaImportes alloc] init];
    Context *context = [Context sharedContext];
    request.userToken = [context getToken];
    request.rCel = cod;
    NSMutableArray *res = [WSUtil execute:request];
    
    return res;
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
	
	
	if (![CommonFunctions hasNumbers:string]) {
		return NO;
	}
    if ([self.codTf.text length] + [self.nroTf.text length] + [string length] > 10) {
        return NO;
    }
    else if (textField == self.codTf) {
        if ([self.codTf.text length] + [string length] > 3) {
            return NO;
        }
    }
    else if (textField == self.nroTf) {
        if ([self.nroTf.text length] + [string length] > 8) {
            return NO;
        }
    }
	//textField.text = [Util formatImporte:textField.text appendingValue:string];
	
	return YES;
}



- (void)textFieldDidEndEditing:(UITextField *)textField {
	[textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField*) textField {
    [textField resignFirstResponder]; 
    return YES;
}

- (void) dismissAll {
	
	if ([self.codTf isFirstResponder]) {
        [self.codTf resignFirstResponder];
    }
    else if ([self.nroTf isFirstResponder]) {
        [self.nroTf resignFirstResponder];
    }
}

- (IBAction) selectCuenta:(id)sender {
	
	if (pickerInScreen) {
		return;
	}
	
	[self dismissAll];
    
    cuentasPicker = YES;
    [cuentas reloadAllComponents];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	[UIView setAnimationDuration:0.35];
	
	CGRect rect = [[self view] frame];
	rect.origin.y -= 155;
	rect.size.height += 155;
	[[self view] setFrame: rect];
	[ut setFrame:CGRectMake(0, IPHONE5_HDIFF(60)+155, 320, 44)];
	cuentas.frame = CGRectMake(0, IPHONE5_HDIFF(104)+155, 320, 216);
    
    [importeToolBar setFrame:CGRectMake(0, importeToolBar.frame.origin.y+155, 320, 44)];
	
	
	//[ut setFrame:CGRectMake(0, 77, 320, 44)];
//	cuentas.frame = CGRectMake(0, 121, 320, 216);
	
	[UIView commitAnimations];
	
	pickerInScreen = YES;
	
}

- (void) ocultarCuentas {
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration:0.35];
	
	CGRect rect = [[self view] frame];
	rect.origin.y += 155;
	rect.size.height -= 155;
	[[self view] setFrame: rect];
	[ut setFrame:CGRectMake(0, IPHONE5_HDIFF(317), 320, 44)];
	cuentas.frame = CGRectMake(0, IPHONE5_HDIFF(361), 320, 216);
	
    [importeToolBar setFrame:CGRectMake(0, IPHONE5_HDIFF(317), 320, 44)];
    
	[UIView commitAnimations];
	
	NSUInteger selectedItem = [cuentas selectedRowInComponent:0];
	
	selectedCuenta = [listaCuentas objectAtIndex:selectedItem];
	textCuenta.text = [selectedCuenta getDescripcion];
	textCuenta.accessibilityLabel = [CommonFunctions replaceSymbolVoice:textCuenta.text];
    textCuenta.accessibilityValue = @"";
	
	pickerInScreen = NO;
	
}

- (IBAction)borrar:(id)sender {
	
	textCuenta.text = @"";
	textCuenta.accessibilityLabel = @"";
    textCuenta.accessibilityValue = @"";
	selectedCuenta = nil;
}


- (IBAction) selectImporte:(id)sender {
    
    if (pickerInScreen) {
        return;
    }
    
    [self dismissAll];
    
    cuentasPicker = NO;
    [cuentas reloadAllComponents];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.35];
    
    CGRect rect = [[self view] frame];
    rect.origin.y -= 85;
    rect.size.height += 85;
    [[self view] setFrame: rect];
    [importeToolBar setFrame:CGRectMake(0, IPHONE5_HDIFF(60)+85, 320, 44)];
    cuentas.frame = CGRectMake(0, IPHONE5_HDIFF(104)+85, 320, 216);
    
    [ut setFrame:CGRectMake(0, ut.frame.origin.y+85, 320, 44)];
    
    
//    [ut setFrame:CGRectMake(0, 77, 320, 44)];
//    cuentas.frame = CGRectMake(0, 121, 320, 216);
    
    [UIView commitAnimations];
    
    pickerInScreen = YES;
    
}

- (void) ocultarImportes {
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.35];
    
    CGRect rect = [[self view] frame];
    rect.origin.y += 85;
    rect.size.height -= 85;
    [[self view] setFrame: rect];
    [importeToolBar setFrame:CGRectMake(0, IPHONE5_HDIFF(317), 320, 44)];
    cuentas.frame = CGRectMake(0, IPHONE5_HDIFF(361), 320, 216);
    
    [ut setFrame:CGRectMake(0, IPHONE5_HDIFF(317), 320, 44)];
    
    [UIView commitAnimations];
    
    NSUInteger selectedItem = [cuentas selectedRowInComponent:0];
    
    importe.text = (NSString *)[importesList objectAtIndex:selectedItem];
    
    pickerInScreen = NO;
    
}

- (IBAction)borrarImporte:(id)sender {
    
    importe.text = @"";
}


- (void)consultarSaldo {
	
	w = [[WaitingAlert alloc] initWithH:65];
	
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


#pragma mark PickerView Protocol

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (cuentasPicker) {
        return [listaCuentas count];
    }
    return [importesList count];
	
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
    if (cuentasPicker) {
        tView.text = [[listaCuentas objectAtIndex:row] getDescripcion];
    }
    else {
        [tView setTextAlignment:UITextAlignmentCenter];
        tView.text = [importesList objectAtIndex:row];
    }
    
    tView.accessibilityLabel = [CommonFunctions replaceSymbolVoice:tView.text];
    return tView;
}

/*- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	
	//return [NSString stringWithFormat:@"%@ - %@",[[listaCuentas objectAtIndex:row] descripcionCortaTipoCuenta],[[listaCuentas objectAtIndex:row] numero]];
	//return [[listaCuentas objectAtIndex:row] numero];
    if (cuentasPicker) {
        return [[listaCuentas objectAtIndex:row] getDescripcion];
    }
    return [importesList objectAtIndex:row];
}*/



- (void)dealloc {
	
    [idCliente release];
	[descCliente release];
	[listaCuentas release];
	[importe release];
	[botonSaldo release];
	[botonContinuar release];
	[titulo release];
	[empresa release];
	
	[limporte release];
	[lpeso release];
	[lcuenta release];
    
    self.infoContainer = nil;
    self.operadorLbl = nil;
    self.carrierLbl = nil;
    self.otroBtn = nil;
    self.ceroLbl = nil;
    self.quinceLbl = nil;
    self.codTf = nil;
    self.nroTf = nil;
    self.importeToolBar = nil;
    self.subMenuCarrier = nil;
    
    self.empresasRecarga = nil;
    
	[super dealloc];
}


@end
