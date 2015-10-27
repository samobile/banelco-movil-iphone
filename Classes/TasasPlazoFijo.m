//
//  TasasPlazoFijo.m
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 8/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TasasPlazoFijo.h"
#import "Context.h"
#import "CommonUIFunctions.h"
#import "CommonFunctions.h"
#import "Util.h"
#import "TasasPlazoFijoResult.h"
#import "MenuBanelcoController.h"

@implementation TasasPlazoFijo

@synthesize botonAceptar, importeText, importeLabel, botonCtaPlazo, borrarPlazo;
@synthesize textCtaPlazo, cuentas, ctaPlazoSelected, listaCuentas, barTeclado, barTecladoButton, textPlazo, blankButton;
@synthesize toolBarCta;

- (id) initWithTitle:(NSString *)t {
	if ((self = [super init])) {
		
		self.title = t;
		
		cuentas = [[UIPickerView alloc] initWithFrame:CGRectMake(0, IPHONE5_HDIFF(361), 320, 216)];
		cuentas.showsSelectionIndicator = YES;
		cuentas.delegate = self;
        cuentas.backgroundColor = [UIColor whiteColor];
		[self.view addSubview:cuentas];
		
		CGRect f = CGRectMake(0, IPHONE5_HDIFF(317), 320, 44);
		toolBarCta = [[UIToolbar alloc] initWithFrame:f];
		[toolBarCta setBarStyle:UIBarStyleDefault];
		toolBarCta.tintColor = [UIColor grayColor];
		UIBarButtonItem *btnSelect = [[UIBarButtonItem alloc] initWithTitle:@"Seleccionar" style:UIBarButtonItemStyleBordered target:self action:@selector(ocultarCuentas)];
		UIBarButtonItem *btnMiddle = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
		//btnSaldo = [[UIBarButtonItem alloc] initWithTitle:@"Consultar Saldo" style:UIBarButtonItemStyleBordered target:self action:@selector(consultarSaldo)];

		[toolBarCta setItems:[NSArray arrayWithObjects:btnMiddle, btnSelect,nil]];
		[btnSelect release];
		[btnMiddle release];
		
		[self.view addSubview:toolBarCta];
		
		listaCuentas = [[NSMutableArray alloc] init];
		
	}
	return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
    if (![Context sharedContext].personalizado) {
        self.importeLabel.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:17];
        self.textCtaPlazo.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:17];
        self.textPlazo.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:17];
        self.importeText.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:17];
    }
    
	barTeclado = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"barra_teclado.png"]];
	barTeclado.alpha = 0;
	
	barTecladoButton = [UIButton buttonWithType:UIButtonTypeCustom];
	barTecladoButton.frame = CGRectMake(222, IPHONE5_HDIFF(488), 88, 29);
	barTecladoButton.alpha =1;
	
	[barTecladoButton setImage:[UIImage imageNamed:@"btn_TecAceptar.png"] forState:UIControlStateNormal];
    barTecladoButton.accessibilityLabel = @"Aceptar";
	[barTecladoButton setTitle:@"" forState:UIControlStateNormal];
	[barTecladoButton addTarget:self action:@selector(dismissAll) forControlEvents:UIControlEventTouchUpInside];
	
	[self.view addSubview:barTeclado];
	[self.view addSubview:barTecladoButton];
	
	UIColor *color = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	importeLabel.textColor = color;
	
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
	return listaCuentas ? [listaCuentas count] : 0;
	
}

//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//	
//	//return [NSString stringWithFormat:@"%@ - %@",[[listaCuentas objectAtIndex:row] descripcionCortaTipoCuenta],[[listaCuentas objectAtIndex:row] numero]];
//	//return [[listaCuentas objectAtIndex:row] numero];
//	return [[listaCuentas objectAtIndex:row] getDescripcionCuentaPlazo];
//}

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
    tView.text = [[listaCuentas objectAtIndex:row] getDescripcionCuentaPlazo];
    return tView;
}

- (IBAction) selectCuenta:(id)sender {
	
	[self dismissAll];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	[UIView setAnimationDuration:0.35];
	
//	CGRect rect = [[self view] frame];
//	rect.origin.y -= 20;//65;
//	rect.size.height += 20;//65;
//	[[self view] setFrame: rect];
		
	[toolBarCta setFrame:CGRectMake(0, IPHONE5_HDIFF(77), 320, 44)];
	cuentas.frame = CGRectMake(0, IPHONE5_HDIFF(121), 320, 216);
	
	[UIView commitAnimations];
	
}

- (void) ocultarCuentas {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration:0.35];
	
	[toolBarCta setFrame:CGRectMake(0, IPHONE5_HDIFF(317), 320, 44)];
	cuentas.frame = CGRectMake(0, IPHONE5_HDIFF(361), 320, 216);
	
	[UIView commitAnimations];
	
	NSUInteger selectedItem = [cuentas selectedRowInComponent:0];
	
	ctaPlazoSelected = [listaCuentas objectAtIndex:selectedItem];
	textCtaPlazo.text = [ctaPlazoSelected getDescripcionCuentaPlazo];
	
}

- (IBAction)borrar:(id)sender {
	
	textCtaPlazo.text = @"";
	ctaPlazoSelected = nil;	
}

- (BOOL)validacionOk {
	
	BOOL ok = YES;
	if (ctaPlazoSelected == nil) {
		[CommonUIFunctions showAlert:self.title withMessage:@"Debe seleccionar una cuenta" andCancelButton:@"Aceptar"];
		ok = NO;
	}
	else if ([importeText.text isEqualToString:@""] || [importeText.text isEqualToString:@"0,00"]) {
		[CommonUIFunctions showAlert:self.title withMessage:@"Debe completar el importe" andCancelButton:@"Aceptar"];
		ok = NO;
	}
	else if ([textPlazo.text isEqualToString:@""]) {
		[CommonUIFunctions showAlert:self.title withMessage:@"Debe completar el plazo" andCancelButton:@"Aceptar"];
		ok = NO;
	}
	
	return ok;
}

- (IBAction)aceptar:(id)sender {
	
//	if ([importeText isFirstResponder]){
//		return;
//	}
	
	if (![self validacionOk]) {
		return;
	}
	
	TasasPlazoFijoResult *tr = [[TasasPlazoFijoResult alloc] initWithTitle:@"Tasas Plazo Fijo" 
																  ctaPlazo:ctaPlazoSelected 
																   importe:importeText.text 
																	 plazo:textPlazo.text
								];
	[[MenuBanelcoController sharedMenuController] pushScreen:tr];
	
}


- (void)accionWithDelegate:(WheelAnimationController *)delegate {
	
	listaCuentas = [Cuenta getCuentasPlazo];

	if (listaCuentas && [listaCuentas isKindOfClass:[NSError class]]) {
        
        NSString *errorCode = [[(NSError *)listaCuentas userInfo] valueForKey:@"faultCode"];
        if ([errorCode isEqualToString:@"ss"]) {
            return;
        }
        
		NSString *errorDesc = [[(NSError *)listaCuentas userInfo] valueForKey:@"description"];
		listaCuentas = nil;
		[CommonUIFunctions showAlert:self.title withMessage:errorDesc cancelButton:@"Volver" andDelegate:self];
	}
	else if (!listaCuentas || [listaCuentas count] == 0) {
		[CommonUIFunctions showAlert:self.title withMessage:@"Momentáneamente Ud. no posee cuentas plazo. Para mas información comuníquese con su banco" cancelButton:@"Volver" andDelegate:self];
	}
	
	[cuentas reloadAllComponents];
	
	[delegate accionFinalizada:TRUE];
}

#pragma mark TextField Protocol

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	
	if (textPlazo == textField && ([textField.text length] + [string length] > 3)) {
		return NO;
	}
	
	if (importeText == textField && ([textField.text length] + [string length] > 10)) {
		return NO;
	}
	
	if (![CommonFunctions hasNumbers:string]) {
		return NO;
	}
	
	if (importeText == textField) {
		textField.text = [Util formatImporte:textField.text appendingValue:string];
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
	[self.view bringSubviewToFront:barTecladoButton];
	
	barTeclado.frame = CGRectMake(0, IPHONE5_HDIFF(480), 320, 45);
	barTeclado.alpha = 1;
	
	barTecladoButton.frame = CGRectMake(222, IPHONE5_HDIFF(488), 88, 29);
	barTecladoButton.alpha =1;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	
	CGRect rect = [[self view] frame];
	int dif;
	if ([importeText isFirstResponder]) {
		dif = 50;
	}
	else {
		dif = 120;
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
	if ([importeText isFirstResponder]) {
		dif = 50;
	}
	else {
		dif = 120;
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
	if ([importeText isFirstResponder]) {
		[importeText resignFirstResponder];
	}
	else if ([textPlazo isFirstResponder]) {
		[textPlazo resignFirstResponder];
	}
	[self.blankButton removeFromSuperview];

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
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


- (void)dealloc {
    [super dealloc];
}


@end
