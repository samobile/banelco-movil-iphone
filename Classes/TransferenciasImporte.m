//
//  TransferenciasImporte.m
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 9/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TransferenciasImporte.h"
#import "Cuenta.h"
#import "CommonFunctions.h"
#import "Transfer.h"
#import "Cotizacion.h"
#import "Context.h"
#import "CommonUIFunctions.h"
#import "TransferenciasConcepto.h"
#import "TransferenciasEjecutar.h"
#import "MenuBanelcoController.h"
#import "WS_ListarConceptos.h"
#import "BaseModel.h"
#import "WSUtil.h"
#import "SaldosTransfMobileDTO.h"
#import "WaitingAlert.h"

@implementation TransferenciasImporte

@synthesize botonContinuar, botonPeso, botonDolar, importeText, monedaLabel, titulo, importeLabel;
@synthesize origenLabel, destinoLabel, botonCtaOrigen, botonCtaDestino, cuentas, destinoTitulo, borrarOrigen, borrarDestino;
@synthesize barTeclado,barTecladoButton;
@synthesize origenTitulo;
@synthesize tarjetaText;

//internal
int monedaSelected;
Cuenta *origen;
Cuenta *destino;

NSMutableArray *listaCuentas;
NSMutableArray *listaCuentaOrigen;
NSMutableArray *listaCuentaDestino;

UIToolbar *ut;
UIBarButtonItem *btnSaldo;
UIBarButtonItem *btnSelect;
UIBarButtonItem *btnMiddle;
int buttonSelected;

int tipoCtas;

int const CTAS_VINCULADAS = 0;
int const CTAS_AGENDADAS = 1;

int const BTN_ORIGEN = 0;
int const BTN_DESTINO = 1;
int const BTN_NONE = -1;

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

- (id) initWithTitle:(NSString *)t tipoCuentas:(int)tipo {
	if ((self = [super init])) {
		
		self.title = t;
		
		tipoCtas = tipo;
		
		//listaCuentaOrigen = o;
		//listaCuentaDestino = d;
		
		//Crea pickerView
		//listaCuentas = [[NSMutableArray alloc] initWithArray:[Context getCuentas]];
		cuentas = [[UIPickerView alloc] initWithFrame:CGRectMake(0, IPHONE5_HDIFF(361), 320, 216)];
        [cuentas setIsAccessibilityElement:YES];
		cuentas.showsSelectionIndicator = YES;
		cuentas.delegate = self;
        cuentas.backgroundColor = [UIColor whiteColor];
		[self.view addSubview:cuentas];
		
		CGRect f = CGRectMake(0, IPHONE5_HDIFF(317), 320, 44);
		ut = [[UIToolbar alloc] initWithFrame:f];
		[ut setBarStyle:UIBarStyleDefault];
		ut.tintColor = [UIColor grayColor];
		btnSelect = [[UIBarButtonItem alloc] initWithTitle:@"Seleccionar" style:UIBarButtonItemStyleBordered target:self action:@selector(ocultarCuentas)];
		btnMiddle = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
		btnSaldo = [[UIBarButtonItem alloc] initWithTitle:@"Consultar Saldo" style:UIBarButtonItemStyleBordered target:self action:@selector(consultarSaldo)];
		
		[ut setItems:[NSArray arrayWithObjects:btnSaldo,btnMiddle,btnSelect,nil]];
		[self.view addSubview:ut];
		
		if (tipoCtas == CTAS_AGENDADAS) {
			destinoTitulo.text = @"CBU Destino";
			destinoLabel.placeholder = @"Seleccioná CBU";
          
            
		}
        else{
            tarjetaText.hidden = YES;
            botonContinuar.frame = CGRectMake(botonContinuar.frame.origin.x, botonContinuar.frame.origin.y-50, botonContinuar.frame.size.width, botonContinuar.frame.size.height);
        }
		
		origen = nil;
		destino = nil;
		buttonSelected = BTN_NONE;
		
		
	}
	return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (![Context sharedContext].personalizado) {
        importeText.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:17];
        importeLabel.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:17];
        origenLabel.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:17];
        destinoLabel.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:17];
        destinoTitulo.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:17];
        monedaLabel.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:17];
        origenTitulo.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:17];
        tarjetaText.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:17];
    }
	
	//Selecciona por defecto $
	//[self monedaButtonClicked:botonPeso];
	//monedaSelector.alpha = 0;
	[self visualizarMoneda:NO];
	
	//w = [[WaitingAlert alloc] init];
//	[self.view addSubview:w];
	
	
	
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

	UIColor *color = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	origenTitulo.textColor = color;
	destinoTitulo.textColor = color;
	monedaLabel.textColor = color;
	importeLabel.textColor = color;
    tarjetaText.textColor = color;
	
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
//}
//
//- (void)viewDidDisappear:(BOOL)animated {
//    [super viewDidDisappear:animated];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
//}

- (IBAction)monedaButtonClicked:(id)sender {
	if (sender == botonPeso) {
		[botonPeso setImage:[UIImage imageNamed:@"btn_pesoselec.png"] forState:UIControlStateNormal];
		//[botonDolar setImage:[UIImage imageNamed:@"btn_U$S.png"] forState:UIControlStateNormal];
		[botonDolar setImage:nil forState:UIControlStateNormal];
		monedaSelected = 32;
	}
	else {
		//[botonPeso setImage:[UIImage imageNamed:@"btn_$.png"] forState:UIControlStateNormal];
		[botonPeso setImage:nil forState:UIControlStateNormal];
		[botonDolar setImage:[UIImage imageNamed:@"btn_dolarselec.png"] forState:UIControlStateNormal];
		monedaSelected = 840;
	}
}

- (BOOL)validacionOk {
	
	BOOL ok = YES;
	if (origen == nil || destino == nil) {
		[CommonUIFunctions showAlert:self.title withMessage:@"Debes seleccionar las cuentas" andCancelButton:@"Aceptar"];
		ok = NO;
	}
	else if (origen == destino) {
		[CommonUIFunctions showAlert:self.title withMessage:@"Debes seleccionar distintas cuentas" andCancelButton:@"Aceptar"];
		ok = NO;
	}
	else if ([importeText.text isEqualToString:@""] || [importeText.text isEqualToString:@"0,00"]) {
		[CommonUIFunctions showAlert:self.title withMessage:@"Debes completar el importe" andCancelButton:@"Aceptar"];
		ok = NO;
	}
    else if (destino.accountType == C_CBU && tarjetaText.text.length < 6) {
        [CommonUIFunctions showAlert:self.title withMessage:@"Debes completar los 6 últimos dígitos de la tarjeta de débito" andCancelButton:@"Aceptar"];
		ok = NO;
    }

	return ok;
}

- (IBAction)continuar {
	[self.view endEditing:YES];
    
	if ([importeText isFirstResponder]){
		//return;
        [importeText resignFirstResponder];
	}
	
	if (![self validacionOk]) {
		return;
	}
	
	//si es transferencia cruzada consulto Cotizaciones
	BOOL transCruzada;
	if (destino.accountType == C_CBU) {
		transCruzada = NO;
	}
	else {
		transCruzada = (origen.codigoMoneda != destino.codigoMoneda);
	}

	//Armo Transfer para pasarle a TransferenciasEjecutar
	Transfer *trans = [[Transfer alloc] init];
	trans.cuentaOrigen = origen;
	trans.cuentaDestino = destino;
	trans.importe = [importeText.text stringByReplacingOccurrencesOfString:@"," withString:@"."];
	trans.moneda = monedaSelected;
	trans.cruzada = transCruzada;
	
	if (destino.accountType == C_CBU) {
		
        trans.tarjeta = self.tarjetaText.text;
		TransferenciasConcepto *tc = [[TransferenciasConcepto alloc] init];
		tc.transfer = trans;
       
		[[MenuBanelcoController sharedMenuController] pushScreen:tc];
		
	}
	else {
		TransferenciasEjecutar *t = [[TransferenciasEjecutar alloc] initWithTitle:self.title];
		t.transfer = trans;
        
		[[MenuBanelcoController sharedMenuController] pushScreen:t];
	}
	
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

//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
//    
//}

//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//	
//	//return [NSString stringWithFormat:@"%@ - %@",[[listaCuentas objectAtIndex:row] descripcionCortaTipoCuenta],[[listaCuentas objectAtIndex:row] numero]];
//	//return [[listaCuentas objectAtIndex:row] numero];
//	NSString *st = [NSString stringWithFormat:@"%@", [[listaCuentas objectAtIndex:row] getDescripcion]];
//    st.accessibilityLabel = [st stringByReplacingOccurrencesOfString:@"U$S" withString:@"dolares"];
//    st.accessibilityLabel = [st stringByReplacingOccurrencesOfString:@"$" withString:@"pesos"];
//    return st;
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
    tView.text = [[listaCuentas objectAtIndex:row] getDescripcion];
    tView.accessibilityLabel = [CommonFunctions replaceSymbolVoice:tView.text];
    return tView;
}

- (void)filtrarCuenta:(Cuenta *)cuenta deLista:(NSMutableArray *)lista {
	
	if (listaCuentas) {
		[listaCuentas release];
		listaCuentas = nil;
	}
	listaCuentas = [[NSMutableArray alloc] init];
	for (int i = 0; i < [lista count]; i++) {
		if ([lista objectAtIndex:i] != cuenta) {
			[listaCuentas addObject:[lista objectAtIndex:i]];
		}
	}
}

- (void)BloquearFondo:(BOOL)bloqueo  {
    [botonDolar setEnabled:!bloqueo];
    [botonPeso setEnabled:!bloqueo];
    [botonContinuar setEnabled:!bloqueo];
    [tarjetaText setEnabled:!bloqueo];
    [importeText setEnabled:!bloqueo];
}

- (IBAction) selectCuenta:(id)sender {
	
	if (buttonSelected != BTN_NONE) {
		return;
	}
	
	[self dismissAll];
	
	if (sender == botonCtaOrigen) {
		buttonSelected = BTN_ORIGEN;
		//listaCuentas = listaCuentaOrigen;
		[self filtrarCuenta:destino deLista:listaCuentaOrigen];
	}
	else {
		buttonSelected = BTN_DESTINO;
		//listaCuentas = listaCuentaDestino;
		[self filtrarCuenta:origen deLista:listaCuentaDestino];
	}
	if (buttonSelected == BTN_DESTINO && tipoCtas == CTAS_AGENDADAS) {
		[ut setItems:[NSArray arrayWithObjects:btnMiddle,btnSelect,nil]];
		//btnSaldo.enabled = NO;
	}
	else {
		[ut setItems:[NSArray arrayWithObjects:btnSaldo,btnMiddle,btnSelect,nil]];
		//btnSaldo.enabled = YES;
	}
	
	
	[cuentas reloadAllComponents];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	[UIView setAnimationDuration:0.35];
	//[ut setFrame:CGRectMake(0, 71, 320, 30)];
//	cuentas.frame = CGRectMake(0, 101, 320, 216);
	
	if (sender == botonCtaDestino) {
		CGRect rect = [[self view] frame];
		rect.origin.y -= 100;//65;
		rect.size.height += 100;//65;
		[[self view] setFrame: rect];
		[ut setFrame:CGRectMake(0, IPHONE5_HDIFF(57)+100, 320, 44)];
		cuentas.frame = CGRectMake(0, IPHONE5_HDIFF(101)+100, 320, 216);
        [self BloquearFondo:YES];
        
        
	}
	else {
		
		CGRect rect = [[self view] frame];
		rect.origin.y -= 20;//65;
		rect.size.height += 20;//65;
		[[self view] setFrame: rect];
		
		[ut setFrame:CGRectMake(0, IPHONE5_HDIFF(77), 320, 44)];
		cuentas.frame = CGRectMake(0, IPHONE5_HDIFF(121), 320, 216);
      [self BloquearFondo:YES];
	}

	
	[UIView commitAnimations];
	
}

- (void) ocultarCuentas {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration:0.35];
	
	if (buttonSelected == BTN_DESTINO) {
		CGRect rect = [[self view] frame];
		rect.origin.y += 100;//65;
		rect.size.height -= 100;//65;
		[[self view] setFrame: rect];
	}
	else if (buttonSelected == BTN_ORIGEN) {
		CGRect rect = [[self view] frame];
		rect.origin.y += 20;
		rect.size.height -= 20;
		[[self view] setFrame: rect];
	}

	[ut setFrame:CGRectMake(0, IPHONE5_HDIFF(317), 320, 44)];
	cuentas.frame = CGRectMake(0, IPHONE5_HDIFF(361), 320, 216);
     [self BloquearFondo:NO];
	
	[UIView commitAnimations];
	
	NSUInteger selectedItem = [cuentas selectedRowInComponent:0];
	
	if (buttonSelected == BTN_ORIGEN) {
		origen = [listaCuentas objectAtIndex:selectedItem];
		//origenLabel.text = [NSString stringWithFormat:@"%@ - %@",[[listaCuentas objectAtIndex:selectedItem] descripcionCortaTipoCuenta],[[listaCuentas objectAtIndex:selectedItem] numero]];
		origenLabel.text = [[listaCuentas objectAtIndex:selectedItem] getDescripcion];
	}
	else {
		destino = [listaCuentas objectAtIndex:selectedItem];
		//destinoLabel.text = [NSString stringWithFormat:@"%@ - %@",[[listaCuentas objectAtIndex:selectedItem] descripcionCortaTipoCuenta],[[listaCuentas objectAtIndex:selectedItem] numero]];
		destinoLabel.text = [[listaCuentas objectAtIndex:selectedItem] getDescripcion];
	}
	
	
	if (tipoCtas == CTAS_VINCULADAS) {
		
		if ([listaCuentaOrigen count] == 2) {

			if ([listaCuentas count] == 2) {
				NSUInteger selected2 = selectedItem==0?1:0;
				if (buttonSelected == BTN_ORIGEN) {
					//if (destino == nil) {
					destino = [listaCuentas objectAtIndex:selected2];
					destinoLabel.text = [[listaCuentas objectAtIndex:selected2] getDescripcion];
					//}
				}
				else if (buttonSelected == BTN_DESTINO) {
					//if (origen == nil) {
					origen = [listaCuentas objectAtIndex:selected2];
					origenLabel.text = [[listaCuentas objectAtIndex:selected2] getDescripcion];
					//}
				}
			
			}
		}
	}
	
	buttonSelected = BTN_NONE;
	
	if (origen != nil && destino != nil) {
		
		//Chequeo que existan ambas monedas (fix para las cuentas agendadas donde no se carga el codigoMoneda)
		if (origen.codigoMoneda && destino.codigoMoneda) {
			
			if (origen.codigoMoneda != destino.codigoMoneda && ![self monedaEnPantalla]) {
				//monedaSelector.alpha = 1;
				[self visualizarMoneda:YES];
				
				if ([origen.simboloMoneda isEqualToString:@"$"]) {
					[self monedaButtonClicked:botonPeso];
				}
				else {
					[self monedaButtonClicked:botonDolar];
				}
			}
			else if (origen.codigoMoneda == destino.codigoMoneda) {
				//monedaSelector.alpha = 0;
				[self visualizarMoneda:NO];
			
			}
		}
	}
    
    origenLabel.accessibilityLabel = [CommonFunctions replaceSymbolVoice:origenLabel.text];
    destinoLabel.accessibilityLabel = [CommonFunctions replaceSymbolVoice:destinoLabel.text];
    origenLabel.accessibilityValue = @"";
    destinoLabel.accessibilityValue = @"";

}

- (void)consultarSaldo {

	if (buttonSelected == BTN_DESTINO) {
		w = [[WaitingAlert alloc] initWithH:40];
	}
	else {
		w = [[WaitingAlert alloc] init];
	}

	[self.view addSubview:w];
	[w startWithSelector:@"consultarSaldoTransf" fromTarget:self];
	
}

- (void)consultarSaldoTransf {
	NSUInteger selectedItem = [cuentas selectedRowInComponent:0];
	Cuenta *selectedCuenta = [listaCuentas objectAtIndex:selectedItem];
	if (selectedCuenta) {
		
		SaldosTransfMobileDTO *resp = [Transfer getSaldoTransfer:selectedCuenta];
		if ([resp isKindOfClass:[NSError class]]) {
            
            NSString *errorCode = [[(NSError *)resp userInfo] valueForKey:@"faultCode"];
            if ([errorCode isEqualToString:@"ss"]) {
                return;
            }
            
			NSString *errorDesc = [[(NSError *)resp userInfo] valueForKey:@"description"];
			[CommonUIFunctions showAlert:self.title withMessage:errorDesc cancelButton:@"Cerrar" andDelegate:nil];
		}
		else {
            NSString *st = [NSString stringWithFormat:@"%@", [resp getDescripcionSaldoTransf:selectedCuenta]];
            //st.accessibilityLabel = [CommonFunctions replaceSymbolVoice:st];
            [CommonUIFunctions showCustomAlert:@"" withMessage:st andCancelButton:@"Cerrar" andDelegate:nil];
			//[CommonUIFunctions showAlert:st withMessage:nil andCancelButton:@"Cerrar"];
		}
	}
	[w detener];
}

- (BOOL) monedaEnPantalla {
	if (monedaLabel.alpha == 1) {
		return YES;
	}
	return NO;
}

- (void)visualizarMoneda:(BOOL)ver {
	
	if (ver && monedaLabel.alpha == 1) {
		return;
	}
	if (!ver && monedaLabel.alpha == 0) {
		return;
	}
	
	if (ver) {
		CGRect frame = importeText.frame;
		frame.origin.y += 20;
		importeText.frame = frame;
		
		frame = importeLabel.frame;
		frame.origin.y += 20;
		importeLabel.frame = frame;
	}
	else {
		CGRect frame = importeText.frame;
		frame.origin.y -= 20;
		importeText.frame = frame;
		
		frame = importeLabel.frame;
		frame.origin.y -= 20;
		importeLabel.frame = frame;
	}
	
	int op = ver?1:0;
	monedaLabel.alpha = op;
	botonPeso.alpha = op;
	botonDolar.alpha = op;
}

- (IBAction)borrar:(id)sender {
	
	if (sender == borrarOrigen) {
		if (!origen) {
			return;
		}
		origenLabel.text = @"";
		origen = nil;
        origenLabel.accessibilityLabel = @"";
        origenLabel.accessibilityValue = @"";
	}
	else {
		if (!destino) {
			return;
		}
		destinoLabel.text = @"";
		destino = nil;
        destinoLabel.accessibilityLabel = @"";
        destinoLabel.accessibilityValue = @"";
	}
	if ([self monedaEnPantalla]) {
		[self visualizarMoneda:NO];
	}
}

- (void)accionWithDelegate:(WheelAnimationController *)delegate {
	
	listaCuentaOrigen = [Context getCuentas];
	if (tipoCtas == CTAS_VINCULADAS) {
		listaCuentaDestino = listaCuentaOrigen;
	}
	else if (tipoCtas == CTAS_AGENDADAS) {
		listaCuentaDestino = [Cuenta getCuentasCBU];
		if (listaCuentaDestino && [listaCuentaDestino isKindOfClass:[NSError class]]) {
            
            NSString *errorCode = [[(NSError *)listaCuentaDestino userInfo] valueForKey:@"faultCode"];
            if ([errorCode isEqualToString:@"ss"]) {
                return;
            }
            
			NSString *errorDesc = [[(NSError *)listaCuentaDestino userInfo] valueForKey:@"description"];
			listaCuentaDestino = nil;
			[CommonUIFunctions showAlert:self.title withMessage:errorDesc cancelButton:@"Volver" andDelegate:self];
		}
		else if (!listaCuentaDestino || [listaCuentaDestino count] == 0) {
			[CommonUIFunctions showAlert:@"Transferencias" withMessage:@"Momentáneamente no posees cuentas con CBU agendada. Para mas información comunicate con tu banco" cancelButton:@"Volver" andDelegate:self];
		}

	}

	[delegate accionFinalizada:TRUE];
}


#pragma mark TextField Protocol

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if(textField == importeText)
    {
	if ([textField.text length] + [string length] > 10) {
		return NO;
	}
	
	if (![CommonFunctions hasNumbers:string]) {
		return NO;
	}
	
	textField.text = [Util formatImporte:textField.text appendingValue:string];
	}
    if(textField == tarjetaText)
    {
        if ([textField.text length] + [string length] > 6) {
            return NO;
        }
        return  YES;
    }
    
	return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	[textField resignFirstResponder];
    
    [self keyboardWillHide:nil];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self keyboardWillShow:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField*) textField {
	
	[textField resignFirstResponder]; 
	
	//[self continuar];
	
    return YES;
}



- (void) keyboardWillShow: (NSNotification*) aNotification {	
	
	barTeclado.frame = CGRectMake(0, IPHONE5_HDIFF(480), 320, 45);
	barTeclado.alpha = 1;
	
	barTecladoButton.frame = CGRectMake(222, IPHONE5_HDIFF(488), 88, 29);
	barTecladoButton.alpha =1;

	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	CGRect rect = [[self view] frame];
	if ([self monedaEnPantalla]) {
		rect.origin.y -= 180;
		barTeclado.frame = CGRectMake(0,IPHONE5_HDIFF(296), 320, 45);
		barTecladoButton.frame = CGRectMake(222,IPHONE5_HDIFF(304), 88, 29);
	}
	else {
		rect.origin.y -= 160;
		barTeclado.frame = CGRectMake(0, IPHONE5_HDIFF(276), 320, 45);
		barTecladoButton.frame = CGRectMake(222, IPHONE5_HDIFF(284), 88, 29);
	}
	
	
	
	[[self view] setFrame: rect];
	[UIView commitAnimations];
	
}

- (void) keyboardWillHide: (NSNotification*) aNotification {

	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	CGRect rect = [[self view] frame];
	if ([self monedaEnPantalla]) {
		rect.origin.y += 180;
	}
	else {
		rect.origin.y += 160;
	}
	
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
    if([tarjetaText isFirstResponder]){
       [tarjetaText resignFirstResponder];
    }
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	
//	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


- (void)dealloc {
	[barTeclado release];
	[barTecladoButton release];
	[botonContinuar release];
	[botonPeso release];
	[botonDolar release];
	[importeText release];
	[origenLabel release];
	[destinoLabel release];
	[botonCtaOrigen release];
	[botonCtaDestino release];
	[cuentas release];
	//[monedaSelector release];
	[tarjetaText release];
    [super dealloc];
}


@end
