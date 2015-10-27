//
//  GenerarClaveRestringidaController.m
//  BanelcoMovilIphone
//
//  Created by German Levy on 5/15/12.
//  Copyright 2012 Banelco. All rights reserved.
//

#import "GenerarClaveRestringidaController.h"
#import "WSUtil.h"
#import "WS_GenerarClave.h"
#import "WS_Login_ConPerfil.h"
#import "LoginResponse.h"
#import "Context.h"
#import "CommonFunctions.h"
#import "CommonUIFunctions.h"
#import "Util.h"
#import "LoginController.h"
#import "ExecuteLogin.h"
#import "CustomDatePicker.h"
#import "AyudaController.h"


@implementation GenerarClaveRestringidaController

@synthesize ltdoc, lTipoDocumento, dniField, fechaNacField, areaField, celField, lCarrier;
@synthesize nroTarjetaField, fechaTarjetaField, contenedorFecha, contenedorFechaVenc, fechaSeleccionada;
@synthesize passField, pass2Field;
@synthesize subMenuDNI, subMenuCarrier;
@synthesize alert, blankButton;
@synthesize barTeclado,barTecladoButton;
@synthesize controllerLogin;
@synthesize lblTipoDoc, lbl0, lbl15, lblSelOper, fndImage, mustBack;

UIDatePicker* selectorFecha;
CustomDatePicker* selectorFechaVenc;
UIImageView* fondoDatepicker;

UITextField* selectedField;

BOOL claveGenerada;


- (id)initFromController:(UIViewController *)controller {
	
    if ((self = [super init])) {
        self.mustBack = NO;
		self.controllerLogin = controller;
		claveGenerada = NO;
		
    }
    return self;
}

- (void)setCustomFonts {
    ltdoc.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:15];
	lTipoDocumento.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:15];
	
	dniField.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:15];
	fechaNacField.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:15];
	areaField.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:15];
    celField.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:15];

	lCarrier.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:15];
    
	nroTarjetaField.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:15];
	fechaTarjetaField.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:15];
	passField.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:15];
	pass2Field.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:15];
    
    self.lblTipoDoc.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:15];;
    self.lbl0.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:15];
    self.lbl15.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:15];
    self.lblSelOper.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:15];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    self.mustBack = NO;
    if (![Context sharedContext].personalizado) {
        [self setCustomFonts];
    }
    
	ltdoc.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	lTipoDocumento.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	lTipoDocumento.text = @"DNI";
	dniField.delegate = self;
	passField.delegate = self;
	
	Context* context = [Context sharedContext];
	
	// Tipo Documento
	subMenuDNI = [[UIActionSheet alloc] init];
	NSArray *elemTipoDoc = [NSArray arrayWithObjects:@"DNI", @"CI", @"PAS", @"LC", @"LE", nil];	
	for (NSString *el in elemTipoDoc) {
		[subMenuDNI addButtonWithTitle:el];
	} 
	subMenuDNI.delegate = self;
	
	// Carriers
	subMenuCarrier = [[UIActionSheet alloc] init];
	NSArray *elemCarriers = [NSArray arrayWithObjects:@"Claro", @"Movistar", @"Nextel", @"Personal", @"Tuenti", nil];
	for (NSString *el in elemCarriers) {
		[subMenuCarrier addButtonWithTitle:el];
	} 
	subMenuCarrier.delegate = self;
	
	///// DATE PICKER ////////////////////////////////////////////////////////////////////////
	
	//self.contenedorFecha = [[UIView alloc] initWithFrame:CGRectMake(0, 460, 320, 260)];
    self.contenedorFecha = [[UIView alloc] initWithFrame:CGRectMake(0, IPHONE5_HDIFF(460), 320, 260)];
    self.contenedorFecha.backgroundColor = [UIColor whiteColor];
	
	// Toolbar
	UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	UIBarButtonItem *btnCerrar = [[UIBarButtonItem alloc] initWithTitle:@"Cerrar" 
																  style:UIBarButtonItemStyleBordered 
																 target:self 
																 action:@selector(cerrarSelectorFecha)];
	
	UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace 
																				   target:nil 
																				   action:nil];
	
	UIBarButtonItem *btnAceptar = [[UIBarButtonItem alloc] initWithTitle:@"Aceptar" 
																  style:UIBarButtonItemStyleBordered 
																 target:self 
																 action:@selector(aceptarSelectorFecha)];
	
	[toolBar setItems:[NSArray arrayWithObjects:btnCerrar, flexibleSpace, btnAceptar, nil]];
	
	// DatePicker
	selectorFecha = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, 320, 216)];
    [selectorFecha setIsAccessibilityElement:YES];
	[selectorFecha setDatePickerMode:UIDatePickerModeDate];
	selectorFecha.date = [NSDate date];

	// Inicio el string para evitar campos con "(null)"
	self.fechaSeleccionada = [NSString stringWithFormat:@"%@", 
							  [CommonFunctions dateToNSString:selectorFecha.date 
												   withFormat:[CommonFunctions WSFormatProfileDOBInSpanish]]];

	[self.contenedorFecha addSubview:toolBar];
	[self.contenedorFecha addSubview:selectorFecha];
	[self.view addSubview:self.contenedorFecha];
	
	///// FIN DATE PICKER ////////////////////////////////////////////////////////////////////

	
	///// CUSTOM DATE PICKER /////////////////////////////////////////////////////////////////

	//self.contenedorFechaVenc = [[UIView alloc] initWithFrame:CGRectMake(0, 460, 320, 260)];
    self.contenedorFechaVenc = [[UIView alloc] initWithFrame:CGRectMake(0, IPHONE5_HDIFF(460), 320, 260)];
    self.contenedorFechaVenc.backgroundColor = [UIColor whiteColor];
	
	// Toolbar
	UIToolbar *toolBarVenc = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	UIBarButtonItem *btnCerrarVenc = [[UIBarButtonItem alloc] initWithTitle:@"Cerrar" 
																  style:UIBarButtonItemStyleBordered 
																 target:self 
																 action:@selector(cerrarSelectorFecha)];
	
	UIBarButtonItem *flexibleSpaceVenc = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace 
																				   target:nil 
																				   action:nil];
	
	UIBarButtonItem *btnAceptarVenc = [[UIBarButtonItem alloc] initWithTitle:@"Aceptar" 
																   style:UIBarButtonItemStyleBordered 
																  target:self 
																  action:@selector(aceptarSelectorFechaVenc)];
	
	[toolBarVenc setItems:[NSArray arrayWithObjects:btnCerrarVenc, flexibleSpaceVenc, btnAceptarVenc, nil]];
	
	// DatePicker
	selectorFechaVenc = [[CustomDatePicker alloc] init];
    [selectorFechaVenc setIsAccessibilityElement:YES];
	selectorFechaVenc.showsSelectionIndicator = YES;
	selectorFechaVenc.frame = CGRectMake(0, 44, 320, 216);

	[self.contenedorFechaVenc addSubview:toolBarVenc];
	[self.contenedorFechaVenc addSubview:selectorFechaVenc];
	[self.view addSubview:self.contenedorFechaVenc];
	
	///// FIN CUSTOM DATE PICKER /////////////////////////////////////////////////////////////

	
	UIImageView* imV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 9, 320, 41)];
	imV.image = [UIImage imageNamed:[[[Context sharedContext] banco] imagenTitulo]];
	
	[self.view addSubview:imV];
	
	// Para cerrar teclado
	self.blankButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.blankButton.accessibilityLabel = @"Cerrar teclado";
	//self.blankButton.frame = CGRectMake(0, 0, 320, 199);
    self.blankButton.frame = CGRectMake(0, 0, 320, IPHONE5_HDIFF(199));
	self.blankButton.backgroundColor = [UIColor clearColor];
	self.blankButton.alpha = 0.1;
	[self.blankButton setTitle:@"" forState:UIControlStateNormal];
	[self.blankButton addTarget:self action:@selector(hideKeyboard) forControlEvents:UIControlEventTouchUpInside];	
	
	dniField.delegate = self;
	areaField.delegate = self;
	celField.delegate = self;
	nroTarjetaField.delegate = self;
	passField.delegate = self;	
	pass2Field.delegate = self;
	
    if ([Context sharedContext].personalizado) {
        NSString *idBco = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"Personalizacion"] objectForKey:@"idBanco"];
        if ([idBco isEqualToString:@"IBAY"]) {
            fechaTarjetaField.text = @"12/2050";
        }
    }
	//personalizacion
//	if (![[Context sharedContext] personalizado]) {
//		volverB = [UIButton buttonWithType:UIButtonTypeCustom];
//		volverB.frame = CGRectMake(10, 15, 59,27);
//		//	[inicio setTitle:@"Inicio" forState:UIControlStateNormal];
//		[volverB setBackgroundImage:[UIImage imageNamed:@"btn_volver.png"] forState:UIControlStateNormal];
//		[volverB setBackgroundImage:[UIImage imageNamed:@"btn_volverselec.png"] forState:UIControlStateHighlighted];
//		[volverB addTarget:self action:@selector(volver) forControlEvents:UIControlEventTouchUpInside];
//		volverB.alpha =1.0;
//		[self.view addSubview:volverB];
//	}
	
	// Barra teclado
	barTeclado = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"barra_teclado.png"]];
	barTeclado.userInteractionEnabled = YES;
	
	barTecladoButton = [UIButton buttonWithType:UIButtonTypeCustom];
	barTecladoButton.frame = CGRectMake(222, 8, 88, 29);
	[barTecladoButton setImage:[UIImage imageNamed:@"btn_TecSiguiente.png"] forState:UIControlStateNormal];
    barTecladoButton.accessibilityLabel = @"Siguiente";
	[barTecladoButton setTitle:@"" forState:UIControlStateNormal];
	[barTecladoButton addTarget:self action:@selector(keyboardButtonAction) forControlEvents:UIControlEventTouchUpInside];
	
	[barTeclado addSubview:barTecladoButton];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
	
    CGRect fi = self.fndImage.frame;
    fi.size.height = IPHONE5_HDIFF(fi.size.height);
    self.fndImage.frame = fi;
}

- (void) keyboardWillShow: (NSNotification*) aNotification {	
	
	//[self.view addSubview:self.blankButton];
	
	[self.view addSubview:barTeclado];

	if ([pass2Field isFirstResponder]) {
		[barTecladoButton setImage:[UIImage imageNamed:@"btn_TecIngresar.png"] forState:UIControlStateNormal];
        barTecladoButton.accessibilityLabel = @"Ingresar";
	} else {
		[barTecladoButton setImage:[UIImage imageNamed:@"btn_TecSiguiente.png"] forState:UIControlStateNormal];
        barTecladoButton.accessibilityLabel = @"Siguiente";
	}
	
	//barTeclado.frame = CGRectMake(0, 480, 320, 45);
    barTeclado.frame = CGRectMake(0, IPHONE5_HDIFF(480), 320, 45);
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	//barTeclado.frame = CGRectMake(0, 199 + animatedDistance, 320, 45);
    barTeclado.frame = CGRectMake(0, IPHONE5_HDIFF(199) + animatedDistance, 320, 45);
	[UIView commitAnimations];
	
}

- (void) keyboardDidShow: (NSNotification*) aNotification {	
	
	//self.blankButton.alpha = 0.0;
	[self.view addSubview:self.blankButton];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	//self.blankButton.alpha = 0.3;
	[UIView commitAnimations];
	
}

- (void) keyboardWillHide: (NSNotification*) aNotification {
	
	self.blankButton.frame = CGRectMake(blankButton.frame.origin.x, 
										blankButton.frame.origin.y - animatedDistance, 
										blankButton.frame.size.width, 
										blankButton.frame.size.height);

	[barTeclado removeFromSuperview];

	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	//barTeclado.frame = CGRectMake(0, 480, 320, 50);
    barTeclado.frame = CGRectMake(0, IPHONE5_HDIFF(480), 320, 50);
	[UIView commitAnimations];
}


- (void)keyboardButtonAction {
		
	if([dniField isFirstResponder]) {
		
		[dniField resignFirstResponder];
		[self abrirSelectorFechaNac];
		
	} else if([areaField isFirstResponder]) {
		
		[celField becomeFirstResponder];
			
	} else if([celField isFirstResponder]) {
		
		[nroTarjetaField becomeFirstResponder];
		
	} else if([nroTarjetaField isFirstResponder]) {
			
		[nroTarjetaField resignFirstResponder];
		[self abrirSelectorFechaVenc];
			
	} else if ([passField isFirstResponder]) {
		
		[pass2Field becomeFirstResponder];
		[barTecladoButton setImage:[UIImage imageNamed:@"btn_TecIngresar.png"] forState:UIControlStateNormal];
        barTecladoButton.accessibilityLabel = @"Ingresar";
		
	} else if ([pass2Field isFirstResponder]) {
		
		[self.blankButton removeFromSuperview];
		[pass2Field resignFirstResponder];
		
		[NSThread detachNewThreadSelector:@selector(generarClave) toTarget:self withObject:nil];
		
	} else {
		[self.blankButton removeFromSuperview];
	}
	
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
	
	CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
	CGFloat numerator = midline - viewRect.origin.y - 0.2 * viewRect.size.height;
	CGFloat denominator = (0.8 - 0.2) * viewRect.size.height;
	CGFloat heightFraction = numerator / denominator;
	
	if (heightFraction < 0.0) {
		heightFraction = 0.0;
	}
	else if (heightFraction > 1.0) {
		heightFraction = 1.0;
	}
	
	UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
	if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
		animatedDistance = floor(216 * heightFraction);
	}
	else {
		animatedDistance = floor(162 * heightFraction);
	}
	
	CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
	
	[self cerrarSelectorFecha];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:0.3];

	self.blankButton.frame = CGRectMake(blankButton.frame.origin.x, 
										animatedDistance, 
										blankButton.frame.size.width, 
										blankButton.frame.size.height);
	
	//barTeclado.frame = CGRectMake(0, 199 + animatedDistance, 320, 45);
    barTeclado.frame = CGRectMake(0, IPHONE5_HDIFF(199) + animatedDistance, 320, 45);
	
	[self.view setFrame:viewFrame];
	
	[UIView commitAnimations];
	
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    CGRect viewFrame = self.view.frame;
    
    viewFrame.origin.y += animatedDistance;
	
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3];
	
    [self.view setFrame:viewFrame];
	
    [UIView commitAnimations];
    
	[textField resignFirstResponder];
	
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

	int cant = [textField.text length] + [string length];
	
	if(textField == passField || textField == pass2Field) {
		if(cant > 8) return NO;
	} else if (textField == nroTarjetaField) {
		if(cant > 4) return NO;
	} else if (textField == areaField) {
		if(cant > 4) return NO;
	} else if (textField == celField) {
		if(cant > 8) return NO;
	}
	
	return YES;

}

- (BOOL)textFielsShouldReturn:(UITextField *)textField {
	if (self.pass2Field==textField){
		[self ingresar];
	}
	return YES;
}

-(IBAction)generarClave {
	
	if(([dniField.text length] < 1)) {
		[CommonUIFunctions showAlert:@"Generar Clave" withMessage:@"El Nro de documento no debe estar vacío." andCancelButton:@"Aceptar"];
		return;
	}

	if ([fechaNacField.text length] == 0) {	
		[CommonUIFunctions showAlert:@"Generar Clave" withMessage:@"La fecha de nacimiento no debe estar vacía." andCancelButton:@"Aceptar"];
		return;
	}
	
	if ([areaField.text length] == 0 || [celField.text length] == 0) {
		[CommonUIFunctions showAlert:@"Generar Clave" withMessage:@"El Nro de celular no debe estar vacío." andCancelButton:@"Aceptar"];
		return;
	}
	
	if ([nroTarjetaField.text length] == 0) {
		[CommonUIFunctions showAlert:@"Generar Clave" withMessage:@"El Nro de tarjeta no debe estar vacío." andCancelButton:@"Aceptar"];
		return;
	}
	
	if ([fechaTarjetaField.text length] == 0) {	
		[CommonUIFunctions showAlert:@"Generar Clave" withMessage:@"La fecha de vencimiento de la tarjeta no debe estar vacía." andCancelButton:@"Aceptar"];
		return;
	}
	
	if([passField.text length] != 8) {
		[CommonUIFunctions showAlert:@"Generar Clave" withMessage:@"La clave debe tener 8 digitos." andCancelButton:@"Aceptar"];
		return;
	}
	
	if(![passField.text isEqualToString:pass2Field.text]) {
		[CommonUIFunctions showAlert:@"Generar Clave" withMessage:@"La clave nueva difiere de la clave de confirmación." andCancelButton:@"Aceptar"];
		return;
	}
	
	NSString *errorClave = [Util validPassword:passField.text withDni:dniField.text];
	if(errorClave) {
		[CommonUIFunctions showAlert:@"Generar Clave" withMessage:errorClave andCancelButton:@"Aceptar"];
		return;
	}
	
	[self hideKeyboard];
	
	alert = [[WaitingAlert alloc] initWithH:20];
	[self.view addSubview:alert];
	[alert startWithSelector:@"doGenerarClave" fromTarget:self andFinishSelector:@"finishAlert" formTarget:self];
	
	
}

- (void)doGenerarClave {
	id result;
	
	WS_GenerarClave *request = [[WS_GenerarClave alloc] init];
	
	Context *context = [Context sharedContext];
	
	NSString *token = [Util getSecurityToken:context.banco.idBanco forDni:request.nroDoc];
	
	NSString *vencTarjeta = [NSString stringWithFormat:@"%@%@",
							 [fechaTarjetaField.text substringToIndex:2], 
							 [fechaTarjetaField.text substringFromIndex:5]];
	
	request.userToken = token;	
	request.codBanco = context.banco.idBanco;
	request.codCarrier = [NSString stringWithFormat:@"%d",carrierSeleccionado+1];
	request.tipoDoc = [NSString stringWithFormat:@"%d",tipoSeleccionado+1];
	request.nroDoc = dniField.text;
	request.fechaNac = [fechaNacField.text stringByReplacingOccurrencesOfString:@"/" withString:@""];
	request.nroTarjeta = nroTarjetaField.text;
	request.fechaTarjeta = vencTarjeta;
	request.nroCel = [NSString stringWithFormat:@"%@%@", areaField.text, celField.text];
	request.clave = passField.text;
	
	[WSRequest setSecurityToken:request.userToken];
	
	result = [WSUtil execute:request];
	
	if ([result isKindOfClass:[NSError class]]) {

        NSString *errorCode = [[(NSError *)result userInfo] valueForKey:@"faultCode"];
        if ([errorCode isEqualToString:@"ss"]) {
            return;
        }
        
		NSString *errorDesc = [[(NSError *)result userInfo] valueForKey:@"description"];
		[CommonUIFunctions showAlert:@"Generar Clave" withMessage:errorDesc cancelButton:@"Volver" andDelegate:self];
		claveGenerada = NO;
		return;
		
	} else {
		
		[Util setSecurityToken:result forBank:request.codBanco andDni:request.nroDoc];
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Generar Clave" message:@"Tu clave ha sido generada exitosamente." 
													   delegate:self 
											  cancelButtonTitle:@"Aceptar" otherButtonTitles:nil]; 
		claveGenerada = YES;
		
		//[alert show];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
		[alert release];
	}
	
}






- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	
	if(claveGenerada) {
        ExecuteLogin *e = [[ExecuteLogin alloc] initFromController:self.controllerLogin withDoc:dniField.text
                                                            ofType:[NSString stringWithFormat:@"%d",tipoSeleccionado+1]
                                                             andPW:passField.text];
        [e executeLogin];
        
        self.mustBack = YES;
        
        [self dismissModalViewControllerAnimated:NO];
	}
	
}

- (void) finishAlert {
	[alert performSelectorOnMainThread:@selector(detener) withObject:nil waitUntilDone:NO];
}

- (void) volver {
	[self dismissModalViewControllerAnimated:YES];
}

-(void) hideKeyboard {
	
	[self.dniField resignFirstResponder];
	[self.fechaNacField resignFirstResponder];
	[self.areaField resignFirstResponder];
	[self.celField resignFirstResponder];
	[self.nroTarjetaField resignFirstResponder];
	[self.fechaTarjetaField resignFirstResponder];
	[self.passField resignFirstResponder];	
	[self.pass2Field resignFirstResponder];
	
	[self.blankButton removeFromSuperview];
	
}


-(IBAction)cambiarTipoDocumento {
	
	if (subMenuDNI.numberOfButtons > 0) {
		[subMenuDNI showInView:self.view];		
	}
}

-(IBAction)cambiarCarrier {
	
	if (subMenuCarrier.numberOfButtons > 0) {
		[subMenuCarrier showInView:self.view];		
	}
}

//// ACTION SHEET DELEGATE //////////////////////////////////////////////

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet {

	[self hideKeyboard];
	[self cerrarSelectorFecha];

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if (actionSheet == subMenuDNI) {
		
		self.lTipoDocumento.text = [subMenuDNI buttonTitleAtIndex:buttonIndex];
		tipoSeleccionado = buttonIndex;
		
	} else if (actionSheet == subMenuCarrier) {
		
		self.lCarrier.text = [subMenuCarrier buttonTitleAtIndex:buttonIndex];
		carrierSeleccionado = buttonIndex;
		
	}
	
}

/////////////////////////////////////////////////////////////////////////


//// DATE PICKER ////////////////////////////////////////////////////////

-(IBAction)abrirSelectorFechaNac {
    
    [self cerrarSelectorFecha];
    
	selectedField = self.fechaNacField;
	[self hideKeyboard];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4];
	//contenedorFecha.frame = CGRectMake(0, 200, 320, 260);
    contenedorFecha.frame = CGRectMake(0, IPHONE5_HDIFF(200), 320, 260);
	//selectorFecha.date = [NSDate date];
	selectorFecha.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	if ([self.fechaNacField.text length] > 0) {
        NSDateFormatter *tempFormatter = [[[NSDateFormatter alloc] init] autorelease];
//        [tempFormatter setDateFormat:@"yyyy-mm-dd hh:mm:ss"];
//        selectorFecha.date = [tempFormatter dateFromString:@"1980-01-01 00:00:00"];

        [tempFormatter setDateFormat:@"dd/MM/yyyy"];
        selectorFecha.date = [tempFormatter dateFromString:self.fechaNacField.text];
    }
    else {
        NSDateFormatter *tempFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [tempFormatter setDateFormat:@"dd/MM/yyyy"];
        selectorFecha.date = [tempFormatter dateFromString:@"01/01/1980"];
    }
	
	[UIView commitAnimations];
}

-(IBAction)abrirSelectorFechaVenc {
    
    [self cerrarSelectorFecha];
    
	selectedField = self.fechaTarjetaField;
	[self hideKeyboard];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	//contenedorFechaVenc.frame = CGRectMake(0, 200, 320, 260);
    contenedorFechaVenc.frame = CGRectMake(0, IPHONE5_HDIFF(200), 320, 260);
	[UIView commitAnimations];
}

-(IBAction)cerrarSelectorFecha {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4];
	//contenedorFecha.frame = CGRectMake(0, 460, 320, 260);
    contenedorFecha.frame = CGRectMake(0, IPHONE5_HDIFF(460), 320, 260);
	//contenedorFechaVenc.frame = CGRectMake(0, 460, 320, 260);
    contenedorFechaVenc.frame = CGRectMake(0, IPHONE5_HDIFF(460), 320, 260);
	[UIView commitAnimations];
}

-(IBAction)aceptarSelectorFecha {
	NSDate *date = [selectorFecha date];
	NSString *format;
	if(selectedField == self.fechaNacField) {
		format = [CommonFunctions WSFormatProfileDOBInSpanish];
	} else if(selectedField == self.fechaTarjetaField) {
		format = [CommonFunctions WSFormatTarjeta];
	}
	
	self.fechaSeleccionada = [NSString stringWithFormat:@"%@", 
							  [CommonFunctions dateToNSString:date 
												   withFormat:format]];
	
	selectedField.text = [NSString stringWithFormat:@"%@", self.fechaSeleccionada];
    
    selectedField.accessibilityLabel = [NSString stringWithFormat:@"Fecha de nacimiento %@", selectedField.text];
    
	[self cerrarSelectorFecha];

	// Se da foco al campo que sigue
	if(selectedField == self.fechaNacField) {
		[areaField becomeFirstResponder];
	} else if(selectedField == self.fechaTarjetaField) {
		[passField becomeFirstResponder];
	}

}

-(IBAction)aceptarSelectorFechaVenc {
	
	self.fechaSeleccionada = [selectorFechaVenc getDateString];
	
	selectedField.text = [NSString stringWithFormat:@"%@", self.fechaSeleccionada];
	[self cerrarSelectorFecha];
	
	// Se da foco al campo que sigue
	if(selectedField == self.fechaNacField) {
		[areaField becomeFirstResponder];
	} else if(selectedField == self.fechaTarjetaField) {
		[passField becomeFirstResponder];
	}
	
}

/////////////////////////////////////////////////////////////////////////



- (IBAction) mostrarAyuda{
	
	AyudaController* ac = [[AyudaController alloc] initWithNibName:@"AyudaFullScreen" bundle:nil];
	[self presentModalViewController:ac animated:YES];
	[ac autorelease];
	return; 
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.mustBack) {
        [self volver];
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)resetKeyboard {
    
}

- (void)dealloc {
    self.lblTipoDoc = nil;
    self.lbl0 = nil;
    self.lbl15 = nil;
    self.lblSelOper = nil;
	[ltdoc release];
	[lTipoDocumento release];
	[dniField release];
	[fechaNacField release];
	[areaField release];
	[celField release];
	[lCarrier release];
	[nroTarjetaField release];
	[fechaTarjetaField release];
	[passField release];
	[pass2Field release];
	[subMenuDNI release];
	[subMenuCarrier release];
	[alert release];
    self.fndImage = nil;
    [super dealloc];
}


@end
