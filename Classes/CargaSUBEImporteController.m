//
//  CargaSUBEImporteController.m
//  BanelcoMovilIphone
//
//  Created by German Levy on 10/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CargaSUBEImporteController.h"
#import "Empresa.h"
#import "CargaCelularPago.h"
#import "MenuBanelcoController.h"
#import "CommonFunctions.h"
#import "CommonUIFunctions.h"
#import "WaitingAlert.h"


@implementation CargaSUBEImporteController

@synthesize importe, botonImporte, botonSaldo, botonContinuar, titulo, empresa, idCliente, descCliente, empresaId;
@synthesize precios;
@synthesize botonCuenta, borrarCuenta, textCuenta, cuentas, ut;

@synthesize barTeclado,barTecladoButton;

@synthesize limporte, lpeso, lcuenta;

NSMutableArray *listaPrecios;

Cuenta *selectedCuenta;
NSMutableArray *listaCuentas;
BOOL pickerInScreen;
WaitingAlert *w;

- (id)initWithTitle:(NSString *)t yEmpresaId:(NSString *)empId {
    if ((self = [super init])) {
        // Custom initialization
		self.title = t;
		self.empresaId = empId;
		
		//Crea pickerView precios
		listaPrecios = [[NSMutableArray alloc] initWithObjects:@"50",@"60",@"70",@"80",@"90",@"100",@"110",@"120",@"130"
						,@"140",@"150",@"160",@"170",@"180",@"190",@"200",@"210",@"220",@"230",@"240",@"250", nil];
		precios = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 361, 320, 216)];
		precios.showsSelectionIndicator = YES;
		precios.delegate = self;
		[self.view addSubview:precios];
		
		//Crea pickerView cuentas
		listaCuentas = [[NSMutableArray alloc] initWithArray:[Context getCuentas]];
		cuentas = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 361, 320, 216)];
		cuentas.showsSelectionIndicator = YES;
		cuentas.delegate = self;
		[self.view addSubview:cuentas];
		
		//toolbar
		CGRect f = CGRectMake(0, 317, 320, 44);
		ut = [[UIToolbar alloc] initWithFrame:f];
		[ut setBarStyle:UIBarStyleDefault];
		ut.tintColor = [UIColor grayColor];
		UIBarButtonItem *btnSelect = [[UIBarButtonItem alloc] initWithTitle:@"Seleccionar" style:UIBarButtonItemStyleBordered target:self action:@selector(ocultarCuentas)];
		UIBarButtonItem *btnMiddle = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
		UIBarButtonItem *btnSaldo = [[UIBarButtonItem alloc] initWithTitle:@"Consultar Saldo" style:UIBarButtonItemStyleBordered target:self action:@selector(consultarSaldo)];
		[ut setItems:[NSArray arrayWithObjects:btnSaldo,btnMiddle,btnSelect,nil]];
		[self.view addSubview:ut];
		
		pickerInScreen = NO;
		
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self borrar:nil];
	
	/*if ([listaCuentas count] == 1) {
	 selectedCuenta = [listaCuentas objectAtIndex:0];
	 textCuenta.text = [selectedCuenta getDescripcion];
	 }*/
	
	pickerInScreen = NO;
	
	barTeclado = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"barra_teclado.png"]];
	barTeclado.alpha = 0;
	
	barTecladoButton = [UIButton buttonWithType:UIButtonTypeCustom];
	barTecladoButton.frame = CGRectMake(222, 488, 88, 29);
	barTecladoButton.alpha =1;
	//	barTecladoButton.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"barra_boton.png"]];
	
	[barTecladoButton setImage:[UIImage imageNamed:@"btn_TecAceptar.png"] forState:UIControlStateNormal];
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

- (void)viewDidUnload {
    [super viewDidUnload];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


- (void) keyboardWillShow: (NSNotification*) aNotification {	
	
	
	NSLog(@"kWs");
	
	barTeclado.frame = CGRectMake(0, 480 + 20, 320, 45);
	barTeclado.alpha = 1;
	
	barTecladoButton.frame = CGRectMake(222, 488 + 20, 88, 29);
	barTecladoButton.alpha =1;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	
	CGRect rect = [[self view] frame];
	rect.origin.y -= 20;
	rect.size.height += 20;
	[[self view] setFrame: rect];
	
	barTeclado.frame = CGRectMake(0, 114 + 20, 320, 45);
	barTecladoButton.frame = CGRectMake(222, 122 + 20, 88, 29);
	
	[UIView commitAnimations];
	
	
	
	
	
}

- (void) keyboardWillHide: (NSNotification*) aNotification {
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	
	CGRect rect = [[self view] frame];
	rect.origin.y += 20;
	rect.size.height -= 20;
	[[self view] setFrame: rect];
	
	barTeclado.frame = CGRectMake(0, 480, 320, 50);
	barTeclado.alpha =0;
	barTecladoButton.frame = CGRectMake(222, 488, 88, 29);
	barTecladoButton.alpha =1;
	
	
	
	[UIView commitAnimations];
}


- (IBAction)continuar {
	
	if (![self validacionOk]) {
		return;
	}
	
	if (empresa.codMoneda != selectedCuenta.codigoMoneda) {
		[CommonUIFunctions showAlert:@"Pago" withMessage:@"El tipo de moneda de la cuenta debe ser igual al del pago." andCancelButton:@"Aceptar"];
		return;
	}
	
	CargaCelularPago *p = [[CargaCelularPago alloc] initWithTitle:@"Usted está cargando"];
	p.empresa = self.empresa;
	p.importe = self.importe.text;
	p.idCliente = self.idCliente;
	p.descCliente = self.descCliente;
	p.selectedCuenta = selectedCuenta;
	[[MenuBanelcoController sharedMenuController] pushScreen:p];
}

- (BOOL)validacionOk {
	
	if ([importe.text isEqualToString:@""] || [importe.text isEqualToString:@"0,00"]) {
		[CommonUIFunctions showAlert:self.title withMessage:@"Debe completar el importe" andCancelButton:@"Aceptar"];
		return NO;
	}
	else if (selectedCuenta == nil) {
		[CommonUIFunctions showAlert:self.title withMessage:@"Debe seleccionar una cuenta" andCancelButton:@"Aceptar"];
		return NO;
	}
	
	return YES;
}

- (void)accionWithDelegate:(WheelAnimationController *)delegate {
	
	self.empresa = [Empresa getEmpresa:self.empresaId];
	
	if (!self.empresa) {
		[CommonUIFunctions showAlert:@"Mi Celular" withMessage:@"Su operador celular no está disponible" cancelButton:@"Aceptar" andDelegate:self];
	}
	else if ([self.empresa isKindOfClass:[NSError class]]) {
        NSString *errorCode = [[(NSError *)self.empresa userInfo] valueForKey:@"faultCode"];
        if ([errorCode isEqualToString:@"ss"]) {
            return;
        }
		NSString *errorDesc = [[(NSError *)self.empresa userInfo] valueForKey:@"description"];
		[CommonUIFunctions showAlert:self.title withMessage:errorDesc cancelButton:@"Volver" andDelegate:self];
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
			}
			else if ([listaCuentas count] == 0) {
				[CommonUIFunctions showAlert:self.title withMessage:@"No se puede efectuar la operación seleccionada. Para realizar la recarga deberá poseer una cuenta en pesos" cancelButton:@"Volver" andDelegate:self];
			}
		}
		else {
			[CommonUIFunctions showAlert:self.title withMessage:@"No se puede efectuar la operación seleccionada. Para realizar la recarga deberá poseer una cuenta en pesos" cancelButton:@"Volver" andDelegate:self];
		}
		
		[cuentas reloadAllComponents];
		////////////////////////////////////////////////////////
		
		CGRect r = CGRectMake(20, 20, 250, 21);
		UILabel *emp = [[UILabel alloc] initWithFrame:r];
		emp.text = [NSString stringWithFormat:@"%@",empresa.nombre];
		emp.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
		emp.backgroundColor = [UIColor clearColor];
		emp.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
		[self.view addSubview:emp];
		[emp release];
		
		r = CGRectMake(20, 62, 250, 21);
		UILabel *idC = [[UILabel alloc] initWithFrame:r];
		if (self.descCliente != nil && ![self.descCliente isEqualToString:@""]) {
			idC.text = [NSString stringWithFormat:@"ID: %@",self.descCliente];
		}
		else {
			idC.text = [NSString stringWithFormat:@"ID: %@",self.idCliente];
		}
		idC.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
		idC.backgroundColor = [UIColor clearColor];
		idC.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
		[self.view addSubview:idC];
		[idC release];
		
	}
	
	[delegate accionFinalizada:TRUE];
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
	textField.text = [Util formatImporte:textField.text appendingValue:string];
	
	return NO;
}



- (void)textFieldDidEndEditing:(UITextField *)textField {
	[textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField*) textField {
    [textField resignFirstResponder]; 
    return YES;
}

- (void) dismissAll {
	
	if ([importe isFirstResponder]) {
		[importe resignFirstResponder];
	}
}

- (IBAction) selectPrecio:(id)sender {
	
	if (pickerInScreen) {
		return;
	}
	
	[self dismissAll];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	[UIView setAnimationDuration:0.35];
	
	CGRect rect = [[self view] frame];
	rect.origin.y -= 155;
	rect.size.height += 155;
	[[self view] setFrame: rect];
	[ut setFrame:CGRectMake(0, 60+155, 320, 44)];
	precios.frame = CGRectMake(0, 104+155, 320, 216);
	
	
	//[ut setFrame:CGRectMake(0, 77, 320, 44)];
	//	cuentas.frame = CGRectMake(0, 121, 320, 216);
	
	[UIView commitAnimations];
	
	pickerInScreen = YES;
	
}

- (IBAction) selectCuenta:(id)sender {
	
	if (pickerInScreen) {
		return;
	}
	
	[self dismissAll];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	[UIView setAnimationDuration:0.35];
	
	CGRect rect = [[self view] frame];
	rect.origin.y -= 155;
	rect.size.height += 155;
	[[self view] setFrame: rect];
	[ut setFrame:CGRectMake(0, 60+155, 320, 44)];
	cuentas.frame = CGRectMake(0, 104+155, 320, 216);
	
	
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
	[ut setFrame:CGRectMake(0, 317, 320, 44)];
	cuentas.frame = CGRectMake(0, 361, 320, 216);
	
	[UIView commitAnimations];
	
	NSUInteger selectedItem = [cuentas selectedRowInComponent:0];
	
	selectedCuenta = [listaCuentas objectAtIndex:selectedItem];
	textCuenta.text = [selectedCuenta getDescripcion];
	
	pickerInScreen = NO;
	
}

- (IBAction)borrar:(id)sender {
	
	textCuenta.text = @"";
	selectedCuenta = nil;
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
	
}


#pragma mark PickerView Protocol

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	if(pickerView == precios) {
		return [listaPrecios count];
	} else {
		return [listaCuentas count];
	}
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	if(pickerView == precios) {
		return [listaPrecios objectAtIndex:row];
	} else {
		//return [NSString stringWithFormat:@"%@ - %@",[[listaCuentas objectAtIndex:row] descripcionCortaTipoCuenta],[[listaCuentas objectAtIndex:row] numero]];
		//return [[listaCuentas objectAtIndex:row] numero];
		return [[listaCuentas objectAtIndex:row] getDescripcion];
	}
}



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
	
	[super dealloc];
}


@end
