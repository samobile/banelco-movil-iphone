//
//  DatoAdicionalForm.m
//  BanelcoMovilIphone
//
//  Created by German Levy on 9/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DatoAdicionalForm.h"
#import "Deuda.h"
#import "CommonUIFunctions.h"
#import "TipoDePagoController.h"
#import "MenuBanelcoController.h"

@implementation DatoAdicionalForm

@synthesize empresa, idCliente, btnContinuar, txtDato, lblDato;

- (id)initForEmpresa:(Empresa *)_empresa withIdCliente:(NSString *)_idCliente {
	
    if ((self = [super initWithNibName:@"DatoAdicional" bundle:nil])) {
		self.title = @"Datos Adicionales";
		empresa = _empresa;
		idCliente = _idCliente;
    }
    return self;
	
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
    if (![Context sharedContext].personalizado) {
        lblDato.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:17];
        txtDato.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:17];
    }
    
	lblDato.text = empresa.datoAdicional;
	
	//Teclado+
//	barTeclado = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"barra_teclado.png"]];
//	barTeclado.alpha = 0;
//	
//	barTecladoButton = [UIButton buttonWithType:UIButtonTypeCustom];
//	barTecladoButton.frame = CGRectMake(222, 488, 88, 29);
//	barTecladoButton.alpha =1;
//	//	barTecladoButton.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"barra_boton.png"]];
//	
//	[barTecladoButton setImage:[UIImage imageNamed:@"btn_TecContinuar.png"] forState:UIControlStateNormal];
//	[barTecladoButton setTitle:@"" forState:UIControlStateNormal];
//	[barTecladoButton addTarget:self action:@selector(continuar) forControlEvents:UIControlEventTouchUpInside];
//	
//	[self.view addSubview:barTeclado];
//	[self.view addSubview:barTecladoButton];
	
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
	//Teclado-
}

- (void)dismissAll {
	[txtDato resignFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	[textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField*) textField {
	[textField resignFirstResponder]; 
	
	[self continuar];
	
    return YES;
}

- (IBAction)continuar {

	[self dismissAll];
	
	//NSString *leyenda = lblDato.text;
	NSString *leyenda = txtDato.text;
	// validamos la entrada
	if ([leyenda isEqualToString:@""]) {
		[CommonUIFunctions showAlert:@"" withMessage:@"El dato adicional no debe estar vacío." andCancelButton:@"Cerrar"];
		return;
	}
	
	if (empresa.importePermitido > 0 || (empresa.tipoPago != TIPO_PAGO_CON_FACTURA && empresa.tipoPago != TIPO_PAGO_CON_DEUDA)) {
		
		Deuda *deuda = [[Deuda alloc] init];
		deuda.codigoEmpresa = empresa.codigo;
		deuda.idCliente = self.idCliente;
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
		
//		if (deuda.importePermitido == 1) {
//			NSString *strImporte = txtDato.text;
//			//[Util solo strImporte];
//			int iImporte = [strImporte intValue] / 100;
//			
//		}
		
		TipoDePagoController *deudaController = [[TipoDePagoController alloc] initWithDeuda:deuda forImporteTotal:NO];
		[[MenuBanelcoController sharedMenuController] pushScreen:deudaController];
	}
	else {
		// Es un error del sistema, no puede ser que tenga un pago sin factura
		// y no permita modificar el importe.
		[CommonUIFunctions showAlert:@"" withMessage:@"Error del sistema. Comuníquese con Banelco por favor." andCancelButton:@"Cerrar"];
	}
}

- (void)viewDidUnload {
	[super viewDidUnload];
//	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

//- (void) keyboardWillShow: (NSNotification*) aNotification {			
//	
//	barTeclado.frame = CGRectMake(0, 480, 320, 45);
//	barTeclado.alpha = 1;
//	
//	barTecladoButton.frame = CGRectMake(222, 488, 88, 29);
//	barTecladoButton.alpha =1;
//	
//	[UIView beginAnimations:nil context:NULL];
//	[UIView setAnimationDuration:0.3];
//	barTeclado.frame = CGRectMake(0, 114, 320, 45);
//	barTecladoButton.frame = CGRectMake(222, 122, 88, 29);
//	[UIView commitAnimations];
//		
//}		
//
//- (void) keyboardWillHide: (NSNotification*) aNotification {
//		
//	[UIView beginAnimations:nil context:NULL];
//	[UIView setAnimationDuration:0.3];
//	barTeclado.frame = CGRectMake(0, 480, 320, 50);
//	barTeclado.alpha =0;
//	barTecladoButton.frame = CGRectMake(222, 488, 88, 29);
//	barTecladoButton.alpha =1;
//	[UIView commitAnimations];
//}
	
- (void)dealloc {
	
	[empresa release]; 
	[idCliente release]; 
	[btnContinuar release]; 
	[txtDato release];
	[lblDato release];
    [super dealloc];
}


@end
