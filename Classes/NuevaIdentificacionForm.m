//
//  NuevaIdentificacionForm.m
//  BanelcoMovilIphone
//
//  Created by German Levy on 9/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NuevaIdentificacionForm.h"
#import "CommonUIFunctions.h"
#import "RubrosList.h"
#import "PagosListController.h"
#import "MenuBanelcoController.h"
#import "DatoAdicionalForm.h"
#import "TipoDePagoController.h"
#import "WaitingAlert.h"

@implementation NuevaIdentificacionForm

@synthesize txtNroTarjeta_CUIT, txtCUIT_Generador, labelEmpresa, labelLeyenda;
@synthesize leyenda,blankButton;
@synthesize leyendaEmpresa, lCUITCon, lCUITGen;

@synthesize barTeclado,barTecladoButton;


BOOL screenMoved;

- (id)initWithTitle:(NSString *)title andEmpresa:(Empresa *)_empresa {
	
	self.title = title;
	empresa = _empresa;
	
	
	self.blankButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.blankButton.accessibilityLabel = @"Cerrar teclado";
	self.blankButton.frame = CGRectMake(0, 0, 320, 140);
	self.blankButton.alpha =0.1;
	[self.blankButton setTitle:@"" forState:UIControlStateNormal];
	[self.blankButton addTarget:self action:@selector(hideKeyboard) forControlEvents:UIControlEventTouchUpInside];
	
	
	if ([empresa.rubro isEqualToString:RUBRO_TARJETAS]) {
		
		if ((self = [super initWithNibName:@"NuevaIdentificacion" bundle:nil])) {
			
		}
		
	} else if ([empresa.tipoEmpresa isEqualToString:TIPO_AFIP]) {
		
		if ((self = [super initWithNibName:@"NuevaIdentificacionAFIP" bundle:nil])) {

		}
		
	} else {
		
		if ((self = [super initWithNibName:@"NuevaIdentificacion" bundle:nil])) {
			//self.title = @"Ingrese Número de Cuit";
			labelEmpresa.text = empresa.nombre;
		}
		
	}

	
    return self;
}


-(void) hideKeyboard {
	[txtNroTarjeta_CUIT resignFirstResponder];
	
	[txtCUIT_Generador resignFirstResponder];
	
	[self.blankButton removeFromSuperview];
}

-(void) dismissAll{
	[self hideKeyboard];
}


- (IBAction)dismissKeyboard:(id)sender {
	
	[sender resignFirstResponder];
	[self.blankButton removeFromSuperview];
	
}

- (IBAction) activarBoton {
	[self.view addSubview:self.blankButton];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
    if (![Context sharedContext].personalizado) {
        labelLeyenda.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:17];
        labelEmpresa.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:17];
        leyendaEmpresa.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:17];
        lCUITCon.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:15];
        lCUITGen.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:15];
        txtCUIT_Generador.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:15];
        txtNroTarjeta_CUIT.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:15];
    }
    
	labelLeyenda.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	labelEmpresa.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	leyendaEmpresa.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	lCUITCon.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	lCUITGen.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	
	txtCUIT_Generador.delegate = self;
	
//	if (![empresa.rubro isEqualToString:RUBRO_TARJETAS] || ![empresa.tipoEmpresa isEqualToString:TIPO_AFIP]) {
//		
//		labelLeyenda.text = [NSString stringWithString:self.title];
//		
//		self.title = @"Pago";
//		
//		labelEmpresa.text = empresa.nombre;
//		
//	}

	if ([empresa.rubro isEqualToString:RUBRO_TARJETAS]) {
		
		labelLeyenda.text = [NSString stringWithFormat:@"Ingresá %@", empresa.tituloIdentificacion];
		labelEmpresa.text = empresa.nombre;
		
	} else if (![empresa.tipoEmpresa isEqualToString:TIPO_AFIP]) {
				
		labelLeyenda.text = [NSString stringWithFormat:@"Ingresá %@", empresa.tituloIdentificacion];
		self.title = @"Pago";
		labelEmpresa.text = empresa.nombre;
		
	}
	
	screenMoved = NO;
	//[txtCUIT_Generador addTarget:self action:@selector(moveScreenUp) forControlEvents:UIControlEventEditingDidBegin];
	//[txtCUIT_Generador addTarget:self action:@selector(moveScreenDown) forControlEvents:UIControlEventEditingDidEnd];
	
	
	barTeclado = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"barra_teclado.png"]];
	barTeclado.alpha = 0;
	
	barTecladoButton = [UIButton buttonWithType:UIButtonTypeCustom];
	barTecladoButton.frame = CGRectMake(222, IPHONE5_HDIFF(488), 88, 29);
	barTecladoButton.alpha =1;
	//	barTecladoButton.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"barra_boton.png"]];
	
	[barTecladoButton setImage:[UIImage imageNamed:@"btn_TecContinuar.png"] forState:UIControlStateNormal];
    barTecladoButton.accessibilityLabel = @"Continuar";
	[barTecladoButton setTitle:@"" forState:UIControlStateNormal];
	[barTecladoButton addTarget:self action:@selector(accion) forControlEvents:UIControlEventTouchUpInside];
	
	
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
	
	CGRect rect = [[self view] frame];
	
	rect.origin.y -= 80; 
	
	
	barTeclado.frame = CGRectMake(0, IPHONE5_HDIFF(480), 320, 45);
	barTeclado.alpha = 1;
	
	barTecladoButton.frame = CGRectMake(222, IPHONE5_HDIFF(488), 88, 29);
	barTecladoButton.alpha =1;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	barTeclado.frame = CGRectMake(0, IPHONE5_HDIFF(194), 320, 45);
	barTecladoButton.frame = CGRectMake(222, IPHONE5_HDIFF(202), 88, 29);
	
	
	[[self view] setFrame:rect];
	[UIView commitAnimations];
	
}

- (void) keyboardWillHide: (NSNotification*) aNotification {
	
	CGRect rect = [[self view] frame];
	
	rect.origin.y += 80; 
	
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	barTeclado.frame = CGRectMake(0, IPHONE5_HDIFF(480), 320, 50);
	barTeclado.alpha =0;
	barTecladoButton.frame = CGRectMake(222, IPHONE5_HDIFF(488), 88, 29);
	barTecladoButton.alpha =1;
	
	[[self view] setFrame: rect];
	
	[UIView commitAnimations];
	
}



- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
	
	
	
}


-(void) accion{

	
	[self dismissAll];
	
	[self continuar];
	
}

- (IBAction)continuar {
    
    [self.view endEditing:YES];
    
	NSLog(@"Accion");
	if (![self checkInputs]) {
		return;
	}
	
	@try {
		
		NSString *txt;
		
		if ([empresa.tipoEmpresa isEqualToString:TIPO_AFIP]) {
			//NSRange range = NSMakeRange (2, txtCUIT_Generador.text.length - 1);
			txt = [NSString stringWithFormat:@"%@%@", txtNroTarjeta_CUIT.text, [txtCUIT_Generador.text substringFromIndex:2]];
		} else {
			txt = txtNroTarjeta_CUIT.text;
		}
		
		if (empresa.tipoPago == TIPO_PAGO_CON_FACTURA) {
			WaitingAlert* alert = [[WaitingAlert alloc] init];
			[self.view addSubview:alert];
			[alert startWithSelector:@"pagosConFactura" fromTarget:self];
			[alert release];
			//[self pagosConFactura:txt];
		} else {
			[self pagoSinFactura:txt];
		}
		
	}
	@catch (NSException * e) {
		[CommonUIFunctions showAlert:@"" withMessage:nil andCancelButton:@"Cerrar"];
	}
	
	

}

/**
 * Chequea que las entradas obligatorias estÈn ingresadas
 * */
- (BOOL) checkInputs {

	NSString *mensaje;
	
	NSCharacterSet *espacio = [NSCharacterSet whitespaceCharacterSet];
	
	if ([[txtNroTarjeta_CUIT.text stringByTrimmingCharactersInSet:espacio] length] == 0) {
		
		if ([empresa.rubro isEqualToString:RUBRO_TARJETAS]) {

			mensaje = @"El número de tarjeta no debe estar vacío.";
			
		} else if ([empresa.tipoEmpresa isEqualToString:TIPO_AFIP]) {
			
			mensaje = @"El CUIT del Contribuyente del VEP a pagar no debe estar vacío.";
			
		} else {
			
			mensaje = [NSString stringWithFormat:@"El %@ no debe estar vacío.", empresa.tituloIdentificacion];
			
		}
		
		[CommonUIFunctions showAlert:mensaje withMessage:nil andCancelButton:@"Cerrar"];
		
		return FALSE;

	} else {
		
		if ([empresa.tipoEmpresa isEqualToString:TIPO_AFIP] && 
			[[txtCUIT_Generador.text stringByTrimmingCharactersInSet:espacio] length] == 0 ) {
		
			mensaje = @"El CUIT del Generador del VEP a pagar no debe estar vacío.";
			[CommonUIFunctions showAlert:mensaje withMessage:nil andCancelButton:@"Cerrar"];

			return FALSE;
		}
		
	}
	
	return TRUE;

}



- (void) pagosConFactura{
	
	NSString* iden;
	if ([empresa.tipoEmpresa isEqualToString:TIPO_AFIP]) {
		//NSRange range = NSMakeRange (2, txtCUIT_Generador.text.length - 1);
		iden = [NSString stringWithFormat:@"%@%@", txtNroTarjeta_CUIT.text, [txtCUIT_Generador.text substringFromIndex:2]];
	} else {
		iden = txtNroTarjeta_CUIT.text;
	}
	
	[self pagosConFactura:iden];
}
/**
 * Pagos con tarjeta cuando la empresa tiene facturas
 * */
- (void) pagosConFactura:(NSString *)identificador {

	PagosListController *pagosList;
	
	// Obtengo las deudas del cliente
	NSMutableArray *deudas = [empresa getDeudasTarjeta:identificador];
	
	
	if ([deudas isKindOfClass:[NSError class]]) {
        
        NSString *errorCode = [[(NSError *)deudas userInfo] valueForKey:@"faultCode"];
        if ([errorCode isEqualToString:@"ss"]) {
            return;
        }
        
		NSString *errorDesc = [[(NSError *)deudas userInfo] valueForKey:@"description"];
		
		if (!errorDesc){
			UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Pago" message:@"En este momento no se puede realizar la operación. Reintentá más tarde." delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
			//[alertView show];
            [alertView performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
			[alertView release];
			return;
		}else{
			UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Pago" message:errorDesc delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
			//[alertView show];
            [alertView performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
			[alertView release];
			return ;
		}
		
	
	}
	
	if (deudas) {
		
		pagosList = [[PagosListController alloc] initWithDeudas:deudas];
		[[MenuBanelcoController sharedMenuController] pushScreen:pagosList];
		
	} else {
	
		[CommonUIFunctions showAlert:@"Al momento no contamos con información de tus facturas pendientes de pago" 
						 withMessage:nil andCancelButton:@"Cerrar"];
	
	}
 
}

/**
 * Pagos con tarjeta cuando la empresa no tiene facturas
 * */
- (void) pagoSinFactura:(NSString *)identificador {

	@try {
		if (empresa.tipoPago == TIPO_PAGO_SIN_DEUDA_ADIC) {
			
			DatoAdicionalForm *datoAdicionalForm = [[DatoAdicionalForm alloc] initForEmpresa:empresa withIdCliente:identificador];
			[[MenuBanelcoController sharedMenuController] pushScreen:datoAdicionalForm];
			
		} else {
			
			Deuda *deuda = [[Deuda alloc] init];
			deuda.codigoEmpresa = empresa.codigo;
			deuda.idCliente = identificador;
			deuda.monedaCodigo = empresa.codMoneda;
			deuda.nombreEmpresa = empresa.nombre;
			deuda.importe = @"";//[self.txtNroTarjeta_CUIT.text stringByReplacingOccurrencesOfString:@"," withString:@"."];
			deuda.vencimiento = @"";
			deuda.codigoRubro = empresa.rubro;
			deuda.monedaSimbolo = empresa.simboloMoneda;
			deuda.tipoPago = empresa.tipoPago;
			deuda.importePermitido = empresa.importePermitido;
			deuda.tipoEmpresa = empresa.tipoEmpresa;
			deuda.datoAdicional = empresa.datoAdicional;
			deuda.leyenda = leyenda? leyenda : @"";
			deuda.agregadaManualmente = TRUE;
			// Datos que no estan, pero se pueden pasar en vacío si es pago sin factura
			deuda.descPantalla = @"";
			deuda.descripcionUsuario = @"";
			deuda.error = @"";
			deuda.idAdelanto = deuda.leyenda;
			deuda.nroFactura = @"";
			deuda.tituloIdentificacion = @"";
			
			Context *context = [Context sharedContext];
			context.selectedDeuda = deuda;
			
			if (deuda.importePermitido == 1) {
				NSString *strImporte = txtNroTarjeta_CUIT.text;
				//[Util solo strImporte];
				int iImporte = [strImporte intValue] / 100;
				
			}
			
			TipoDePagoController *deudaController = [[TipoDePagoController alloc] initWithDeuda:deuda forImporteTotal:NO];
			[[MenuBanelcoController sharedMenuController] pushScreen:deudaController];
						
		}
	} @catch (NSException *e) {
		[CommonUIFunctions showAlert:@"Excepcion en Pago sin factura." 
						 withMessage:nil andCancelButton:@"Cerrar"];
	}

}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {

	[textField resignFirstResponder];
	
	//demi
	if ([empresa.tipoEmpresa isEqualToString:TIPO_AFIP]) {
		if (txtNroTarjeta_CUIT == textField){
			[txtCUIT_Generador becomeFirstResponder];
			return NO;
		}
	}
	
	[self continuar];
	return YES;

}

- (void) moveScreenUp {	
	
	screenMoved = YES;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	CGRect rect = [[self view] frame];
	rect.origin.y -= 70; 
	[[self view] setFrame: rect];
	[UIView commitAnimations];
	
}

- (void) moveScreenDown {
	
	if (screenMoved) {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3];
		CGRect rect = [[self view] frame];
		rect.origin.y += 70; 
		[[self view] setFrame: rect];
		[UIView commitAnimations];
		screenMoved = NO;
		
	}
	
}

- (void)dealloc {
	[barTeclado release];
	[barTecladoButton release];

	[blankButton release];
	[txtNroTarjeta_CUIT release];
	[txtCUIT_Generador release];
	[labelEmpresa release];
	
	[leyendaEmpresa release];
	[lCUITCon release];
	[lCUITGen release];
    [super dealloc];
}


@end
