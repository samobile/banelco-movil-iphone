//
//  OtrasOperacionesMenu.m
//  BanelcoMovilIphone
//
//  Created by German Levy on 9/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "OtrasOperacionesMenu.h"
#import "MenuOptionsHelper.h"
#import "MenuOption.h"
#import "RubrosList.h"
#import "MenuBanelcoController.h"
#import "EmpresasList.h"
#import "CuentasList.h"
#import "ConfiguracionAvisosController.h"
#import "BuscarEmpresa.h"
#import "CommonUIFunctions.h"


@implementation OtrasOperacionesMenu

- (id) init {
	if ((self = [super initWithColor:AM_AZUL])) {
		self.title = @"Otras Operaciones";
        self.title.accessibilityLabel = @"Submenú Otras Operaciones";
	}
	return self;
}

- (void)aceptar:(int)cellIdx {

	int selectedIndex = [self getSelectedIndex:cellIdx];
	Context *context = [Context sharedContext];
	
	if (selectedIndex == SALDOS_Y_DISPONIBLES) {
		
		CuentasList *cl = [[CuentasList alloc] initConSaldo:NO andTipoLista:CL_SALDOS_Y_DISPONIBLES];
		[[MenuBanelcoController sharedMenuController] pushScreen:cl];
		
	} else if (selectedIndex == AVISOS) {
		
		ConfiguracionAvisosController* ca = [[ConfiguracionAvisosController alloc] init];
		[[MenuBanelcoController sharedMenuController] pushScreen:ca];
		
	} else if (selectedIndex == OTRAS_TARJETAS) {
		
		if([context.usuario esRestringido]) {
		
			[CommonUIFunctions showRestrictedAlert:@"Tarjetas de Crédito" withDelegate:nil];
		
		} else {
			Rubro *rubro = [[Rubro alloc] init];
			rubro.codigo = RUBRO_TARJETAS;
			rubro.nombre = @"Tarjetas de Crédito";
			
			EmpresasList *empresasList = [[EmpresasList alloc] initWithRubro:rubro busqueda:@"" andTipoAccion:EL_PAGOS_TARJETA];
			[[MenuBanelcoController sharedMenuController] pushScreen:empresasList];
		}
		
	} else if (selectedIndex == OTRAS_CUENTAS) {
		
		if([context.usuario esRestringido]) {
			
			[CommonUIFunctions showRestrictedAlert:@"Otras Cuentas" withDelegate:nil];
			
		} else {
			BuscarEmpresa *buscarEmpresa = [[BuscarEmpresa alloc] initWithType:BE_INICIAL tipoAccion:EL_OTRAS_CUENTAS andRubro:nil];
			[[MenuBanelcoController sharedMenuController] pushScreen:buscarEmpresa];
		}
		
	} else if (selectedIndex == MIS_COMPROBANTES) {
		
		//RubrosList *rubrosList = [[RubrosList alloc] initWithAction:EL_ULTIMOS_PAGOS];
		//[[MenuBanelcoController sharedMenuController] pushScreen:rubrosList];
		BuscarEmpresa *buscarEmpresa = [[BuscarEmpresa alloc] initWithType:BE_INICIAL tipoAccion:EL_ULTIMOS_PAGOS andRubro:nil];
		[[MenuBanelcoController sharedMenuController] pushScreen:buscarEmpresa];
		
	} else {
		
	}
	
}

- (void)initOptions {

	[super.options removeAllObjects];
	
	MenuOptionsHelper *helper = [MenuOptionsHelper sharedMenuHelper];
	
	if ([helper isEnabled:OTRAS_CUENTAS]) {
		[super.options addObject:[[MenuOption alloc] initWithOption:OTRAS_CUENTAS andTitle:@"Otras Cuentas"]];
	}
	if ([helper isEnabled:OTRAS_TARJETAS]) {
		[super.options addObject:[[MenuOption alloc] initWithOption:OTRAS_TARJETAS andTitle:@"Tarjetas de Crédito"]];
	}
	if ([helper isEnabled:AVISOS]) {
		[super.options addObject:[[MenuOption alloc] initWithOption:AVISOS andTitle:@"Configuración de Avisos"]];
	}
	if ([helper isEnabled:SALDOS_Y_DISPONIBLES]) {
		[super.options addObject:[[MenuOption alloc] initWithOption:SALDOS_Y_DISPONIBLES andTitle:@"Saldos y Disponibles"]];
	}
	if ([helper isEnabled:MIS_COMPROBANTES]) {
		[super.options addObject:[[MenuOption alloc] initWithOption:MIS_COMPROBANTES andTitle:@"Mis Comprobantes"]];
	}
	
	[super.tableView reloadData];
	
}


-(void) dealloc{

	[super dealloc];
	
}

@end
