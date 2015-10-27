//
//  TipoDePagoController.m
//  BanelcoMovilIphone
//
//  Created by German Levy on 9/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TipoDePagoController.h"
#import "Util.h"
#import "Context.h"
#import "CommonFunctions.h"
#import "CommonUIFunctions.h"
#import "DetalleDeudaController.h"
#import "MenuBanelcoController.h"
#import "WaitingAlert.h"
#import "TicketController.h"

@implementation TipoDePagoController

@synthesize deuda;
//@synthesize detalle;
@synthesize btnTotal, totalSelec, btnOtro, otroSelec, tfPrecio, importeTotal;
//@synthesize listaCuentas, listaCuentasView;
@synthesize blankButton;
//sea
@synthesize botonCuenta, borrarCuenta, textCuenta, cuentas, ut;
@synthesize simbolo;

@synthesize barTeclado,barTecladoButton;

@synthesize lCuenta;


Cuenta *selectedCuenta;
NSMutableArray *listaCuentas;
BOOL pickerInScreen;

- (void)setTitulo:(Deuda *)deuda {
	
	if (deuda && deuda.nombreEmpresa && [deuda.nombreEmpresa length] > 0) {
		self.title = [NSString stringWithFormat:@"Pago %@", deuda.nombreEmpresa];
	} else {
		self.title = @"Pago";
	}
	
}

- (id)initWithDeuda:(Deuda *)ds forImporteTotal:(BOOL)importeTotal {
    if ((self = [super initWithNibName:@"TipoDePago" bundle:nil])) {
		[self setTitulo:ds];
        self.deuda = [ds copy];
		self.importeTotal = importeTotal;
    }
    return self;
}

//- (id)initWithDeuda:(Deuda *)ds andCuentas:(CuentasList *)listaCuentas {
//    if ((self = [super initWithNibName:@"TipoDePago" bundle:nil])) {
//		[self setTitulo:ds];
//        self.deuda = ds;
//		self.listaCuentas = listaCuentas;
//		self.listaCuentasView = listaCuentas.view;
//    
//	}
//    return self;
//}


- (void)setCustomFonts {

	self.tfPrecio.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:18];
	
	textCuenta.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:18];
    simbolo.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:18];
	
	lCuenta.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:18];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
    [self setCustomFonts];
    
	//sea
//	CGRect frame = CGRectMake(21, 124, 278, 132);
//	self.listaCuentas = [[CuentasList alloc] initList:nil 
//											   ofType:CL_PAGAR 
//											withItems:[Context getCuentas]
//											  inFrame:frame
//										 toFullScreen:NO];
//	
//	listaCuentas.pantallaCompleta = NO;
//	
//	[self.listaCuentas viewDidLoad];
//	
//	[self.view addSubview:self.listaCuentas.view];
//	[self.listaCuentas.tableView reloadData];
	
	lCuenta.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	
	NSString *codigo = @"";
	if ([self.deuda.codigoRubro isEqualToString:@"TCIN"] || [self.deuda.codigoRubro isEqualToString:@"TCRE"]) {
		codigo = [Util formatDigits:self.deuda.idCliente];
	} else {
		codigo = self.deuda.idCliente;
	}
	
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 54, 23)];
	label.text = @"ID:";
	label.textAlignment = UITextAlignmentLeft;
	if (![Context sharedContext].personalizado) {
        label.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:18];
    }
    else {
        label.font = [UIFont boldSystemFontOfSize:18];
    }
	label.backgroundColor = [UIColor clearColor];
	label.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	[self.view addSubview:label];
	[label release];
	
	label = [[UILabel alloc] initWithFrame:CGRectMake(74, 20, 240, 23)];
	label.text = codigo;
	label.textAlignment = UITextAlignmentLeft;
	if (![Context sharedContext].personalizado) {
        label.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:18];
    }
    else {
        label.font = [UIFont boldSystemFontOfSize:18];
    }
	label.backgroundColor = [UIColor clearColor];
	label.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	[self.view addSubview:label];
	[label release];
	
	if (![self.deuda.codigoRubro isEqualToString:@"TCIN"]) {
		//detalle.text = [NSString stringWithFormat:@"%@ - %@ Vto. %@", self.deuda.nombreEmpresa, codigo, self.deuda.vencimiento];
		if (self.deuda.vencimiento && ![self.deuda.vencimiento isEqualToString:@""]) {
			//detalle.text = [NSString stringWithFormat:@"%@ Vto. %@", codigo, self.deuda.vencimiento];
			
			label = [[UILabel alloc] initWithFrame:CGRectMake(20, 51, 54, 23)];
			label.text = @"Vto.:";
			label.textAlignment = UITextAlignmentLeft;
			if (![Context sharedContext].personalizado) {
                label.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:18];
            }
            else {
                label.font = [UIFont boldSystemFontOfSize:18];
            }
			label.backgroundColor = [UIColor clearColor];
			label.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
			[self.view addSubview:label];
			[label release];
			
			label = [[UILabel alloc] initWithFrame:CGRectMake(74, 51, 240, 23)];
			label.text = self.deuda.vencimiento;
			label.textAlignment = UITextAlignmentLeft;
			if (![Context sharedContext].personalizado) {
                label.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:18];
            }
            else {
                label.font = [UIFont boldSystemFontOfSize:18];
            }
			label.backgroundColor = [UIColor clearColor];
			label.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
			[self.view addSubview:label];
			[label release];
			
		} 
//		else {
//			detalle.text = codigo;
//		}

	} 
//	else {
//		//detalle.text = [NSString stringWithFormat:@"%@ - %@", self.deuda.nombreEmpresa, codigo];
//		detalle.text = codigo;
//	}

	tfPrecio.text = @"0,00";
	tfPrecio.delegate = self;

	// Deuda con importe
	if (importeTotal) {
		
		[self bloquearPrecio];

		// Importe no modificable
		if (self.deuda.importePermitido == 0) {
			//btnOtro.enabled = NO;
			btnTotal.hidden = YES;
			btnOtro.hidden = YES;
			
			UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 81, 120, 32)];
			lbl.text = @"Total:";
			lbl.textAlignment = UITextAlignmentLeft;
			if (![Context sharedContext].personalizado) {
                lbl.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:18];
            }
            else {
                lbl.font = [UIFont boldSystemFontOfSize:18];
            }
			lbl.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
			lbl.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
			
			[self.view addSubview:lbl];
		}
		
	// Deuda nueva sin importe
	} else {
		//[self otroPrecio];
		btnTotal.hidden = YES;
		btnOtro.hidden = YES;
		
		UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 79, 150, 32)];
		lbl.text = @"Ingresá Importe:";
		lbl.textAlignment = UITextAlignmentLeft;
		if (![Context sharedContext].personalizado) {
            lbl.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:18];
        }
        else {
            lbl.font = [UIFont boldSystemFontOfSize:18];
        }
		lbl.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
		lbl.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
		
		[self.view addSubview:lbl];
	}
	
	self.blankButton = [UIButton buttonWithType:UIButtonTypeCustom];
	self.blankButton.frame = CGRectMake(0, 0, 320, IPHONE5_HDIFF(105));
    self.blankButton.accessibilityLabel = @"Cerrar teclado";
	self.blankButton.alpha = 0.1;
	[self.blankButton setTitle:@"" forState:UIControlStateNormal];
	[self.blankButton addTarget:self action:@selector(hideKeyboard) forControlEvents:UIControlEventTouchUpInside];
	
	//Crea pickerView
	listaCuentas = [[NSMutableArray alloc] initWithArray:[Context getCuentas:deuda.monedaCodigo]];
	cuentas = [[UIPickerView alloc] initWithFrame:CGRectMake(0, IPHONE5_HDIFF(361), 320, 216)];
    [cuentas setIsAccessibilityElement:YES];
    cuentas.backgroundColor = [UIColor whiteColor];
	cuentas.showsSelectionIndicator = YES;
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
	
	pickerInScreen = NO;
	[self borrar:nil];
	
	//muestra el simbolo de moneda que viene en la deuda ($ por defecto)
	simbolo.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	if (deuda.monedaSimbolo && ![deuda.monedaSimbolo isEqualToString:@""]) {
		simbolo.text = deuda.monedaSimbolo;
	}
	
	if (listaCuentas) {
		
		if ([listaCuentas count] == 1) {
			selectedCuenta = [listaCuentas objectAtIndex:0];
			textCuenta.text = [selectedCuenta getDescripcion];
            textCuenta.accessibilityLabel = [CommonFunctions replaceSymbolVoice:textCuenta.text];
            textCuenta.accessibilityValue = @"";
		}
		else if ([listaCuentas count] == 0) {
			[CommonUIFunctions showAlert:self.title withMessage:@"No se puede efectuar la operación seleccionada. Para realizar el pago deberás poseer una cuenta en la misma moneda que la deuda a pagar" cancelButton:@"Volver" andDelegate:self];
		}
	}
	else {
		[CommonUIFunctions showAlert:self.title withMessage:@"No se puede efectuar la operación seleccionada. Para realizar el pago deberás poseer una cuenta en la misma moneda que la deuda a pagar" cancelButton:@"Volver" andDelegate:self];
	}
	
	
	barTeclado = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"barra_teclado.png"]];
	barTeclado.alpha = 0;
	
	barTecladoButton = [UIButton buttonWithType:UIButtonTypeCustom];
	barTecladoButton.frame = CGRectMake(222, IPHONE5_HDIFF(488), 88, 29);
	barTecladoButton.alpha =1;
	//	barTecladoButton.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"barra_boton.png"]];
	
	[barTecladoButton setImage:[UIImage imageNamed:@"btn_TecAceptar.png"] forState:UIControlStateNormal];
	[barTecladoButton setTitle:@"" forState:UIControlStateNormal];
    barTecladoButton.accessibilityLabel = @"Aceptar";
	[barTecladoButton addTarget:self action:@selector(dismissAll) forControlEvents:UIControlEventTouchUpInside];
	
	
	[self.view addSubview:barTeclado];
	[self.view addSubview:barTecladoButton];
	
	
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
	
	
}

- (void)viewDidUnload {
    [super viewDidUnload];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void) keyboardWillShow: (NSNotification*) aNotification {	
	
		
	barTeclado.frame = CGRectMake(0, IPHONE5_HDIFF(480), 320, 45);
	barTeclado.alpha = 1;
	
	barTecladoButton.frame = CGRectMake(222, IPHONE5_HDIFF(488), 88, 29);
	barTecladoButton.alpha =1;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	barTeclado.frame = CGRectMake(0, IPHONE5_HDIFF(114), 320, 45);
	barTecladoButton.frame = CGRectMake(222, IPHONE5_HDIFF(122), 88, 29);
	[UIView commitAnimations];
	
	
	
	
	
}

- (void) keyboardWillHide: (NSNotification*) aNotification {
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	barTeclado.frame = CGRectMake(0, IPHONE5_HDIFF(480), 320, 50);
	barTeclado.alpha =0;
	barTecladoButton.frame = CGRectMake(222, IPHONE5_HDIFF(488), 88, 29);
	barTecladoButton.alpha =1;
	
	
	
	[UIView commitAnimations];
}




-(IBAction) activarBoton {

	[self.view addSubview:self.blankButton];
}

-(void) hideKeyboard {
	
	[self.tfPrecio resignFirstResponder];
	[self.blankButton removeFromSuperview];
	
}

- (IBAction)bloquearPrecio {
	
	if (!totalSelec) {
		totalSelec = [UIImage imageNamed:@"btn_totalmitadselec.png"];
	}

	[btnTotal setImage:totalSelec forState:UIControlStateNormal];
	[btnOtro setImage:nil forState:UIControlStateNormal];
	
	tfPrecio.text = [Util formatInput:self.deuda.importe];
	tfPrecio.enabled = NO;
	tfPrecio.alpha = 0.50;
}

- (IBAction)otroPrecio {
	
	if (!otroSelec) {
		otroSelec = [UIImage imageNamed:@"btn_otromitadselec.png"];
	}
	
	[btnTotal setImage:nil forState:UIControlStateNormal];
	[btnOtro setImage:otroSelec forState:UIControlStateNormal];
	
	tfPrecio.enabled = YES;
	tfPrecio.alpha = 1;
}

- (IBAction) selectCuenta:(id)sender {
	
	if (pickerInScreen) {
		return;
	}
	
	[self dismissAll];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	[UIView setAnimationDuration:0.35];
	CGFloat f = 165;//IPHONE5_HDIFF(165);
	CGRect rect = [[self view] frame];
	rect.origin.y -= f;
	rect.size.height += f;
	[[self view] setFrame: rect];
	[ut setFrame:CGRectMake(0, IPHONE5_HDIFF(60)+f, 320, 44)];
	cuentas.frame = CGRectMake(0, IPHONE5_HDIFF(104)+f, 320, 216);
	
	[UIView commitAnimations];
	
	pickerInScreen = YES;
	
}

- (void) ocultarCuentas {
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration:0.35];
	CGFloat f = 165;//IPHONE5_HDIFF(165);
	CGRect rect = [[self view] frame];
	rect.origin.y += f;
	rect.size.height -= f;
	[[self view] setFrame: rect];
	[ut setFrame:CGRectMake(0, IPHONE5_HDIFF(317), 320, 44)];
	cuentas.frame = CGRectMake(0, IPHONE5_HDIFF(361), 320, 216);
	
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
	selectedCuenta = nil;
    
    textCuenta.accessibilityLabel = @"";
    textCuenta.accessibilityValue = @"";
}


- (IBAction)consultarSaldo {

	
	WaitingAlert *waiting = [[WaitingAlert alloc] initWithH:80];
	[self.view addSubview:waiting];
	//[NSThread sleepForTimeInterval:5];
	
	[waiting startWithSelector:@"consultarSaldoConWaiting" fromTarget:self];
	[waiting release];
}


-(void) consultarSaldoConWaiting{
	//Cuenta *selectedCuenta = [listaCuentas getSelectedCuenta];
	NSUInteger selectedItem = [cuentas selectedRowInComponent:0];
	Cuenta *selectedCuenta2 = [Cuenta getSaldo:[listaCuentas objectAtIndex:selectedItem] withLyD:YES];
	
	if (!selectedCuenta2) {
		[CommonUIFunctions showAlert:@"Pago" withMessage:@"Debes seleccionar una cuenta." andCancelButton:@"Aceptar"];
		return;
	}
	
	
	//[NSThread sleepForTimeInterval:5];
	
	
	//Cuenta *cuenta = [Cuenta getSaldo:selectedCuenta2 withLyD:YES];
	

	if (![selectedCuenta2 isKindOfClass:[NSError class]]) {
		//[CommonUIFunctions showAlert:[selectedCuenta2 getDescripcionSaldoAlerta:YES] withMessage:nil andCancelButton:@"Cerrar"];
        [CommonUIFunctions showCustomAlert:nil withMessage:[selectedCuenta2 getDescripcionSaldoAlerta:YES] andCancelButton:@"Cerrar" andDelegate:nil];
	}
    else {
        NSString *errorCode = [[(NSError *)selectedCuenta2 userInfo] valueForKey:@"faultCode"];
        if ([errorCode isEqualToString:@"ss"]) {
            return;
        }
    }
	
	
}


- (IBAction)continuar {

    if (pickerInScreen) {
        [self ocultarCuentas];
    }
    
	//Cuenta *selectedCuenta = [listaCuentas getSelectedCuenta];
	if (!selectedCuenta || [tfPrecio.text length] == 0) {
		[CommonUIFunctions showAlert:@"Pago" withMessage:@"Debes seleccionar una cuenta." andCancelButton:@"Aceptar"];
		return;
	}
	
	if ([self.tfPrecio.text isEqualToString:@"0,00"]) {
		[CommonUIFunctions showAlert:@"Pago" withMessage:@"Debes completar el importe" andCancelButton:@"Aceptar"];
		return;
	}
	
	if (deuda.monedaCodigo != selectedCuenta.codigoMoneda) {
		[CommonUIFunctions showAlert:@"Pago" withMessage:@"El tipo de moneda de la cuenta debe ser igual al de la deuda." andCancelButton:@"Aceptar"];
		return;
	}
	
	Context *context = [Context sharedContext];
	context.selectedCuenta = selectedCuenta;
	
	NSString *importe = [tfPrecio.text stringByReplacingOccurrencesOfString:@"," withString:@"."];
	deuda.importe = importe;
	deuda.otroImporte = importe;

	context.selectedDeuda = [deuda copy];

	DetalleDeudaController *detalle = [[DetalleDeudaController alloc] 
									   initWithDeuda:self.deuda andCuenta:selectedCuenta];

	[[MenuBanelcoController sharedMenuController] pushScreen:detalle];
	
	//TicketController* tController =  = [[TicketController alloc] 
	//									initWithDeuda:self.deuda andCuenta:selectedCuenta];
	//[[MenuBanelcoController sharedMenuController] pushScreen:tController];
}

#pragma mark PickerView Protocol

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	
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

//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//	
//	//return [NSString stringWithFormat:@"%@ - %@",[[listaCuentas objectAtIndex:row] descripcionCortaTipoCuenta],[[listaCuentas objectAtIndex:row] numero]];
//	//return [[listaCuentas objectAtIndex:row] numero];
//    NSString *st = [NSString stringWithFormat:@"%@",[[listaCuentas objectAtIndex:row] getDescripcion]];
//    st.accessibilityLabel = [st stringByReplacingOccurrencesOfString:@"U$S" withString:@"dolares"];
//    st.accessibilityLabel = [st stringByReplacingOccurrencesOfString:@"$" withString:@"pesos"];
//	return st;
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[tfPrecio resignFirstResponder];
	return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

	if ([CommonFunctions hasNumbers:string]) {
		tfPrecio.text = [Util formatImporte:textField.text appendingValue:string];
	}
	
    return NO;
}


- (IBAction)dismissKeyboard:(id)sender{
	NSLog(@"dismiss");
	[sender resignFirstResponder];
	[self.blankButton removeFromSuperview];
}

- (void)dismissAll {
	
	if ([tfPrecio isFirstResponder]) {
		[tfPrecio resignFirstResponder];
		[self.blankButton removeFromSuperview];
	}
}


- (void)dealloc {
	
	[barTeclado release];
	[barTecladoButton release];
	
	[lCuenta release];
	[blankButton  release];
	[deuda release];
	[simbolo release];
    [super dealloc];
}


@end
