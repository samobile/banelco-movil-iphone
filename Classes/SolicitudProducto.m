//
//  SolicitudProducto.m
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SolicitudProducto.h"
#import "Producto.h"
#import "CommonFunctions.h"
#import "CommonUIFunctions.h"
#import "MenuBanelcoController.h"
#import "Context.h"

@implementation SolicitudProducto

@synthesize textProducto, textTelContacto, textTelAlter, textEmail, textDominio, botonAceptar, arroba, productoSelected;
@synthesize botonProducto, borrarProducto, productos, listaProductos, barTeclado, barTecladoButton, toolBarCta, waiting, blankButton;

- (id) initWithTitle:(NSString *)t {
	if ((self = [super init])) {
		
		self.title = t;
		
		productos = [[UIPickerView alloc] initWithFrame:CGRectMake(0, IPHONE5_HDIFF(361), 320, 216)];
		productos.showsSelectionIndicator = YES;
		productos.delegate = self;
        productos.backgroundColor = [UIColor whiteColor];
		[self.view addSubview:productos];
		
		CGRect f = CGRectMake(0, IPHONE5_HDIFF(317), 320, 44);
		toolBarCta = [[UIToolbar alloc] initWithFrame:f];
		[toolBarCta setBarStyle:UIBarStyleDefault];
		toolBarCta.tintColor = [UIColor grayColor];
		UIBarButtonItem *btnSelect = [[UIBarButtonItem alloc] initWithTitle:@"Seleccionar" style:UIBarButtonItemStyleBordered target:self action:@selector(ocultarProductos)];
		UIBarButtonItem *btnMiddle = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
		//btnSaldo = [[UIBarButtonItem alloc] initWithTitle:@"Consultar Saldo" style:UIBarButtonItemStyleBordered target:self action:@selector(consultarSaldo)];
		
		[toolBarCta setItems:[NSArray arrayWithObjects:btnMiddle, btnSelect,nil]];
		[btnSelect release];
		[btnMiddle release];
		
		[self.view addSubview:toolBarCta];
		
		listaProductos = [[NSMutableArray alloc] init];
		
	}
	return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (![Context sharedContext].personalizado) {
        self.textDominio.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:17];
        self.textEmail.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:17];
        self.textProducto.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:17];
        self.textTelAlter.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:17];
        self.textTelContacto.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:17];
        self.arroba.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:17];
    }
	
    self.productos.backgroundColor = [UIColor whiteColor];
    
	barTeclado = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"barra_teclado.png"]];
	barTeclado.alpha = 0;
	
	barTecladoButton = [UIButton buttonWithType:UIButtonTypeCustom];
	barTecladoButton.frame = CGRectMake(222, IPHONE5_HDIFF(488), 88, 29);
	barTecladoButton.alpha =1;
	
	[barTecladoButton setImage:[UIImage imageNamed:@"btn_TecAceptar.png"] forState:UIControlStateNormal];
    barTecladoButton.accessibilityLabel = @"Aceptar";
	[barTecladoButton setTitle:@"" forState:UIControlStateNormal];
	[barTecladoButton addTarget:self action:@selector(keyboardButtonAction) forControlEvents:UIControlEventTouchUpInside];
	
	[self.view addSubview:barTeclado];
	[self.view addSubview:barTecladoButton];
	
	UIColor *color = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	arroba.textColor = color;
	
	waiting = [[WaitingAlert alloc] init];
	[self.view addSubview:waiting];
	
	NSString *telUser = [[[Context sharedContext] usuario] celular];
	if (telUser && ![telUser isEqualToString:@""]) {
		textTelContacto.text = telUser;
	}
	
	self.blankButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.blankButton.accessibilityLabel = @"Cerrar teclado";
	self.blankButton.frame = CGRectMake(0, 0, 320, IPHONE5_HDIFF(480));
	self.blankButton.alpha =0.1;
	[self.blankButton setTitle:@"" forState:UIControlStateNormal];
	[self.blankButton addTarget:self action:@selector(dismissAll) forControlEvents:UIControlEventTouchUpInside];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark PickerView Protocol

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return listaProductos ? [listaProductos count] : 0;
	
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	
	//return [NSString stringWithFormat:@"%@ - %@",[[listaCuentas objectAtIndex:row] descripcionCortaTipoCuenta],[[listaCuentas objectAtIndex:row] numero]];
	//return [[listaCuentas objectAtIndex:row] numero];
	return [(Producto *)[listaProductos objectAtIndex:row] nombre];
}

- (IBAction) selectProducto:(id)sender {
	
	[self dismissAll];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	[UIView setAnimationDuration:0.35];
	
	[toolBarCta setFrame:CGRectMake(0, IPHONE5_HDIFF(77), 320, 44)];
	productos.frame = CGRectMake(0, IPHONE5_HDIFF(121), 320, 216);
	
	[UIView commitAnimations];
	
}

- (void) ocultarProductos {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration:0.35];
	
	[toolBarCta setFrame:CGRectMake(0, IPHONE5_HDIFF(317), 320, 44)];
	productos.frame = CGRectMake(0, IPHONE5_HDIFF(361), 320, 216);
	
	[UIView commitAnimations];
	
	NSUInteger selectedItem = [productos selectedRowInComponent:0];
	
	productoSelected = [listaProductos objectAtIndex:selectedItem];
	textProducto.text = [productoSelected nombre];
	
}

- (IBAction)borrar:(id)sender {
	
	textProducto.text = @"";
	productoSelected = nil;	
}

- (BOOL)validacionOk {
	
	BOOL ok = YES;
	if (productoSelected == nil) {
		[CommonUIFunctions showAlert:self.title withMessage:@"Debe seleccionar un producto" andCancelButton:@"Aceptar"];
		ok = NO;
	}
	else if ([textTelContacto.text isEqualToString:@""]) {
		[CommonUIFunctions showAlert:self.title withMessage:@"Debe completar el teléfono de contacto" andCancelButton:@"Aceptar"];
		ok = NO;
	}
	else if ([textTelAlter.text isEqualToString:@""]) {
		[CommonUIFunctions showAlert:self.title withMessage:@"Debe completar el teléfono alternativo" andCancelButton:@"Aceptar"];
		ok = NO;
	}
	else if ([textEmail.text isEqualToString:@""] || [textDominio.text isEqualToString:@""]) {
		[CommonUIFunctions showAlert:self.title withMessage:@"Debe completar el e-mail" andCancelButton:@"Aceptar"];
		ok = NO;
	}
	
	return ok;
}

- (void)enviarSolicitud {
	
	id result = [Producto enviarSolicitud:textProducto.text 
							  telContacto:textTelContacto.text 
								 telAlter:textTelAlter.text 
									email:[textEmail.text stringByAppendingFormat:@"@%@",textDominio.text]
				 ];
	
	[waiting detener];
	
	if (result && [result isKindOfClass:[NSError class]]) {
        
        NSString *errorCode = [[(NSError *)result userInfo] valueForKey:@"faultCode"];
        if ([errorCode isEqualToString:@"ss"]) {
            return;
        }
        
		NSString *errorDesc = [[(NSError *)result userInfo] valueForKey:@"description"];
		[CommonUIFunctions showAlert:self.title withMessage:errorDesc andCancelButton:@"Cerrar"];
		return;
	}
	
	[CommonUIFunctions showAlert:self.title withMessage:@"Gracias por contactarse. Un asesor se comunicará con usted dentro de las 48 horas." cancelButton:@"Aceptar" andDelegate:self];
	
}

- (IBAction)aceptar:(id)sender {
	
	if (![self validacionOk]) {
		return;
	}
	
	[waiting startWithSelector:@"enviarSolicitud" fromTarget:self];
	
}

- (void)accionWithDelegate:(WheelAnimationController *)delegate {
	
	listaProductos = [Producto getProductos];
	
	if (listaProductos && [listaProductos isKindOfClass:[NSError class]]) {
        
        NSString *errorCode = [[(NSError *)listaProductos userInfo] valueForKey:@"faultCode"];
        if ([errorCode isEqualToString:@"ss"]) {
            return;
        }
        
		NSString *errorDesc = [[(NSError *)listaProductos userInfo] valueForKey:@"description"];
		listaProductos = nil;
		[CommonUIFunctions showAlert:self.title withMessage:errorDesc cancelButton:@"Volver" andDelegate:self];
	}
	else if (!listaProductos || [listaProductos count] == 0) {
		[CommonUIFunctions showAlert:self.title withMessage:@"No se encontraron productos. Para mas información comuníquese con su banco" cancelButton:@"Volver" andDelegate:self];
	}
	
	[productos reloadAllComponents];
	
	[delegate accionFinalizada:TRUE];
}

#pragma mark TextField Protocol

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	
	if ((textTelContacto == textField || textTelAlter == textField) && ![CommonFunctions hasNumbers:string]) {
		return NO;
	}
	
	if ((textEmail == textField || textDominio == textField) && ![CommonFunctions hasAlphabetAndSpecial:string]) {
		return NO;
	}
	
	return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	[textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField*) textField {
	
	[textField resignFirstResponder];
	
	//[self continuar];
	
    return YES;
}

- (void) keyboardWillShow: (NSNotification*) aNotification {	
	
	[self.view addSubview:self.blankButton];
	
	if ([textTelContacto isFirstResponder] || [textTelAlter isFirstResponder] || [textEmail isFirstResponder]){
		[barTecladoButton setImage:[UIImage imageNamed:@"btn_TecAceptar.png"] forState:UIControlStateNormal];
        barTecladoButton.accessibilityLabel = @"Aceptar";
	}else{
		[barTecladoButton setImage:[UIImage imageNamed:@"btn_TecAceptar.png"] forState:UIControlStateNormal];
        barTecladoButton.accessibilityLabel = @"Aceptar";
	}
	
	barTeclado.frame = CGRectMake(0, IPHONE5_HDIFF(480), 320, 45);
	if ([textEmail isFirstResponder] || [textDominio isFirstResponder]) {
		barTeclado.alpha = 0;
	}
	else {
		barTeclado.alpha = 1;
	}
	
	barTecladoButton.frame = CGRectMake(222, IPHONE5_HDIFF(488), 88, 29);
	if ([textEmail isFirstResponder] || [textDominio isFirstResponder]) {
		barTecladoButton.alpha =0;
	}
	else {
		barTecladoButton.alpha =1;
	}
	
	[self.view bringSubviewToFront:barTecladoButton];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	
	CGRect rect = [[self view] frame];
	int dif;
	if ([textTelAlter isFirstResponder]) {
		dif = 50;
	}
	else if ([textEmail isFirstResponder]) {
		dif = 100;
	}
	else if ([textDominio isFirstResponder]) {
		dif = 140;
	}
	else {
		dif = 5;
	}
	rect.origin.y -= dif;
	
	barTeclado.frame = CGRectMake(0, IPHONE5_HDIFF(114) + dif, 320, 45);
	barTecladoButton.frame = CGRectMake(222, IPHONE5_HDIFF(122) + dif, 88, 29);
	
	[[self view] setFrame: rect];
	
	[UIView commitAnimations];
	
}

- (void) keyboardWillHide: (NSNotification*) aNotification {
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	
	CGRect rect = [[self view] frame];
	int dif;
	if ([textTelAlter isFirstResponder]) {
		dif = 50;
	}
	else if ([textEmail isFirstResponder]) {
		dif = 100;
	}
	else if ([textDominio isFirstResponder]) {
		dif = 140;
	}
	else {
		dif = 5;
	}
	rect.origin.y += dif;
	
	
	barTeclado.frame = CGRectMake(0, IPHONE5_HDIFF(480), 320, 50);
	barTeclado.alpha =0;
	barTecladoButton.frame = CGRectMake(222, IPHONE5_HDIFF(488), 88, 29);
	barTecladoButton.alpha =1;
	
	[[self view] setFrame: rect];
	
	[UIView commitAnimations];
}

- (void) dismissAll {
	if ([textTelContacto isFirstResponder]) {
		[textTelContacto resignFirstResponder];
	}
	else if ([textTelAlter isFirstResponder]) {
		[textTelAlter resignFirstResponder];
	}
	else if ([textEmail isFirstResponder]) {
		[textEmail resignFirstResponder];
	}
	else if ([textDominio isFirstResponder]) {
		[textDominio resignFirstResponder];
	}
    
	[self.blankButton removeFromSuperview];
}

- (IBAction)keyboardButtonAction{
	
	
	if([textTelContacto isFirstResponder]){
		//[textTelAlter becomeFirstResponder];
		//[barTecladoButton setImage:[UIImage imageNamed:@"btn_TecSiguiente.png"] forState:UIControlStateNormal];
		[textTelContacto resignFirstResponder];
		[self.blankButton removeFromSuperview];
		
		
	}else if ([textTelAlter isFirstResponder]){
		//[textEmail becomeFirstResponder];
		//[barTecladoButton setImage:[UIImage imageNamed:@"btn_TecSiguiente.png"] forState:UIControlStateNormal];
		[textTelAlter resignFirstResponder];
		[self.blankButton removeFromSuperview];
		
	}
	else if ([textEmail isFirstResponder]){
		//[textDominio becomeFirstResponder];
		//[barTecladoButton setImage:[UIImage imageNamed:@"btn_TecAceptar.png"] forState:UIControlStateNormal];
		[textEmail resignFirstResponder];
		[self.blankButton removeFromSuperview];
		
	}
	
	else if ([textDominio isFirstResponder]) {
		[textDominio resignFirstResponder];
		[self.blankButton removeFromSuperview];
	}
	
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
