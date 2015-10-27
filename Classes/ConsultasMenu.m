//
//  ConsultasMenu.m
//  BanelcoMovilIphone
//
//  Created by German Levy on 9/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ConsultasMenu.h"
#import "MenuOptionsHelper.h"
#import "MenuOption.h"
#import "CommonUIFunctions.h"
#import "CuentasList.h"
#import "MenuBanelcoController.h"
#import "ConsultasTarjetaMenu.h"
#import "TasasPlazoFijo.h"
#import "SolicitudProducto.h"
#import "UltimasTransferenciasController.h"

#import "GAITracker.h"
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

@implementation ConsultasMenu

- (void)GAItrack {
    // May return nil if a tracker has not already been initialized with a
    // property ID.
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    // This screen name value will remain set on the tracker and sent with
    // hits until it is set to a new value or to nil.
    [tracker set:kGAIScreenName value:@"Pantalla Consultas"];
    // New SDK versions
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

- (id) init {
	NSLog(@"Entrare al init?");
	if ((self = [super init])) {
		NSLog(@"Siiii!!");
		self.title = @"Consultas";
		
	}
	NSLog(@"No :(");
	return self;
}

-(void) viewDidLoad{
	
	[super viewDidLoad];
	self.title = @"Consultas";
    self.title.accessibilityLabel = @"Submenú consultas";
}

- (void)aceptar:(int)cellIdx {
	
	int selectedIndex = [self getSelectedIndex:cellIdx];
	
	if (selectedIndex == SALDOS) {
		
	//	[CommonUIFunctions showAlert:@"JOJO" withMessage:nil andCancelButton:@"Cerrar"];
		
		CuentasList* clist = [[CuentasList alloc] initConSaldo:YES andTipoLista:CL_SALDOS];	
		
		[[MenuBanelcoController sharedMenuController] pushScreen:clist];
		
		
	} else if (selectedIndex == ULTIMOS_MOVIMIENTOS) {
		
		CuentasList* clist = [[CuentasList alloc] initConSaldo:NO andTipoLista:CL_ULT_MOVIMIENTOS];	
		
		[[MenuBanelcoController sharedMenuController] pushScreen:clist];
		
	} else if (selectedIndex == CONSULTA_CBU) {
		
		CuentasList* clist = [[CuentasList alloc] initConSaldo:NO andTipoLista:CL_CONSULTA_CBU];	
		
		[[MenuBanelcoController sharedMenuController] pushScreen:clist];
		
	} else if (selectedIndex == TARJETAS_CREDITO) {
		
		ConsultasTarjetaMenu *clist = [[ConsultasTarjetaMenu alloc]initWithColor:AM_FUCSIA];
		
		[[MenuBanelcoController sharedMenuController] pushScreen:clist];
	
	} else if (selectedIndex == TASAS_PLAZO_FIJO) {
		
		TasasPlazoFijo *tpf = [[TasasPlazoFijo alloc] initWithTitle:@"Tasas Plazo Fijo"];
		
		[[MenuBanelcoController sharedMenuController] pushScreen:tpf];
		
    } else if (selectedIndex == SOLICITUD_PRODUCTO) {
		
		SolicitudProducto *p = [[SolicitudProducto alloc] initWithTitle:@"Solicitud de Producto"];
		
		[[MenuBanelcoController sharedMenuController] pushScreen:p];
	
		
	}
    else if (selectedIndex == CONSULTA_ULTIMAS_TRANSF) {
		
		UltimasTransferenciasController *u = [[UltimasTransferenciasController alloc] init];
		[[MenuBanelcoController sharedMenuController] pushScreen:u];
	}
    else if (selectedIndex == DISPONIBLE_EXTRACCION) {
        
        CuentasList* clist = [[CuentasList alloc] initConSaldo:NO andTipoLista:CL_DISPONIBLES];
        
        [[MenuBanelcoController sharedMenuController] pushScreen:clist];
        
    }
    else {
		
	}
	
}

- (void)initOptions {
	
	[super.options removeAllObjects];
	
	MenuOptionsHelper *helper = [MenuOptionsHelper sharedMenuHelper];
	
	if ([helper isEnabled:SALDOS]) {
		[super.options addObject:[[MenuOption alloc] initWithOption:SALDOS andTitle:@"Saldos"]];
	}
	if ([helper isEnabled:ULTIMOS_MOVIMIENTOS]) {
		[super.options addObject:[[MenuOption alloc] initWithOption:ULTIMOS_MOVIMIENTOS andTitle:@"Últimos Movimientos"]];
	}
	if ([helper isEnabled:CONSULTA_CBU]) {
		[super.options addObject:[[MenuOption alloc] initWithOption:CONSULTA_CBU andTitle:@"Consulta de CBU"]];
	}
	if ([helper isEnabled:TARJETAS_CREDITO]) {
		[super.options addObject:[[MenuOption alloc] initWithOption:TARJETAS_CREDITO andTitle:@"Tarjetas de Crédito"]];
	}
	
	//tasas y solicitud producto
	if ([helper isEnabled:TASAS_PLAZO_FIJO]) {
		[super.options addObject:[[MenuOption alloc] initWithOption:TASAS_PLAZO_FIJO andTitle:@"Tasas Plazo Fijo"]];
	}
	if ([helper isEnabled:SOLICITUD_PRODUCTO]) {
		[super.options addObject:[[MenuOption alloc] initWithOption:SOLICITUD_PRODUCTO andTitle:@"Solicitud de Producto"]];
	}
    
    if ([helper isEnabled:CONSULTA_ULTIMAS_TRANSF]) {
		[super.options addObject:[[MenuOption alloc] initWithOption:CONSULTA_ULTIMAS_TRANSF andTitle:@"Transferencias a Otras Ctas."]];
	}
    
    if ([helper isEnabled:DISPONIBLE_EXTRACCION]) {
        [super.options addObject:[[MenuOption alloc] initWithOption:DISPONIBLE_EXTRACCION andTitle:@"Disponible de Extracción"]];
    }
	
	[super.tableView reloadData];
	
}


-(void) dealloc{
	//	[fondo release];
	[super dealloc];
}

@end
