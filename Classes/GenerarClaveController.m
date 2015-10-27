//
//  GenerarClaveController.m
//  BanelcoMovilIphone
//
//  Created by Demian on 11/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import "GenerarClaveController.h"

#import "Context.h"
#import "AyudaController.h"


@implementation GenerarClaveController

@synthesize leyenda, pagoMisCuentasBoton;

-(IBAction) volver{
	[self dismissModalViewControllerAnimated:YES];
}

-(IBAction) pagoMisCuentas{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.pagomiscuentas.com"]]; 
}

-(IBAction) homeBanking{
	Context* context = [Context sharedContext];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[context.banco url]]]; 
}

-(IBAction) ayuda{
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

- (void)viewDidLoad {
	[super viewDidLoad];
	leyenda.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	if (![Context sharedContext].personalizado) {
        leyenda.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:17];
    }
    
	//Para HSBC (id: RBTS) no se debe mostrar boton de pago mis cuentas
	if ([[Context sharedContext] personalizado]) {
		NSString *idBco = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"Personalizacion"] objectForKey:@"idBanco"];
		if ([idBco isEqualToString:@"RBTS"]) {
			pagoMisCuentasBoton.hidden = YES;
			leyenda.text = @"Podrás generar tu clave ingresando a PC Banking (Pagos de servicio - Banca Móvil) o través de un Cajero Automático de la Red Banelco (Claves - Generación de Claves - HSBC en tu Celular).";
		}
		else if ([idBco isEqualToString:@"BSTN"]) {
			pagoMisCuentasBoton.hidden = YES;
			leyenda.text = @"Podrás generar tu clave en www.icbc.com.ar desde Access Banking ingresando en la solapa Pago de Servicios opción Banca Móvil o a través de los cajeros automáticos de la red Banelco opción Claves > Generación de Clave > Clave BanelcoMovil.";
		}
		//itau
		else if ([idBco isEqualToString:@"IBAY"]) {
			pagoMisCuentasBoton.hidden = YES;
			leyenda.text = @"Podrás generar tu clave en pagomiscuentas.com ingresando a través de Itaú Home Banking y seleccionando la solapa \"Pagos\".";
		}
		//patagonia
		else if ([idBco isEqualToString:@"SDMR"]) {
			pagoMisCuentasBoton.hidden = YES;
			leyenda.text = @"Podrás generar tu clave ingresando a Patagonia Ebank, desde la opción Otros / Mobile Banking.";
		}
		//patagonia
		else if ([idBco isEqualToString:@"BMBS"]) {
			pagoMisCuentasBoton.hidden = YES;
			leyenda.text = @"Podrás generar tu clave ingresando a Pago Mis Cuentas a través de MacroOnline(https://macronline.com.ar) siguiendo la ruta Pago de Servicios > Pago Mis Cuentas o en cualquier ATM de Macro opción Claves > Generación de Clave > Clave BanelcoMovil.";
		}
	}
    CGRect rv = fondo.frame;
    rv.size.height = IPHONE5_HDIFF(fondo.frame.size.height);
    fondo.frame = rv;
    
    CGRect rv1 = self.view.frame;
    rv1.size.height = IPHONE5_HDIFF(self.view.frame.size.height);
    self.view.frame = rv1;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[leyenda release];
    [super dealloc];
}


@end
