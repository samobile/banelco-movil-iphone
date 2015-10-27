    //
//  TransferenciasConsultaMenu.m
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 8/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TransferenciasConsultaMenu.h"
#import "MenuOptionsHelper.h"
#import "CuentasList.h"
#import "MenuBanelcoController.h"
#import "MenuOption.h"
#import "UltimasTransferenciasController.h"

@implementation TransferenciasConsultaMenu

- (id) init {
	if ((self = [super init])) {
		
	}
	return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Consultas Transferencias";
    self.title.accessibilityLabel = @"Submenú Consultas Transferencias";
}


- (void)aceptar:(int)cellIdx {
	
	int selectedIndex = [self getSelectedIndex:cellIdx];
	
	if (selectedIndex == AGENDA) {
		
		CuentasList* clist = [[CuentasList alloc] initConSaldo:NO andTipoLista:CL_AGENDA];	
		[[MenuBanelcoController sharedMenuController] pushScreen:clist];
		
		
	}
	else if (selectedIndex == SALDOS_Y_DISP_TRANSF) {
		
		CuentasList* clist = [[CuentasList alloc] initConSaldo:NO andTipoLista:CL_SALDOS_Y_DISPONIBLES_TRANSFER];	
		[[MenuBanelcoController sharedMenuController] pushScreen:clist];
		
		
	} 
	else if (selectedIndex == CONSULTA_ULTIMAS_TRANSF) {
		
		UltimasTransferenciasController *u = [[UltimasTransferenciasController alloc] init];
		[[MenuBanelcoController sharedMenuController] pushScreen:u];
	} 
	else {
		
	}
	
}

- (void)initOptions {
	
	[super.options removeAllObjects];
	
	MenuOptionsHelper *helper = [MenuOptionsHelper sharedMenuHelper];

	if ([helper isEnabled:AGENDA]) {
		[super.options addObject:[[MenuOption alloc] initWithOption:AGENDA andTitle:@"Agenda"]];
	}	
	if ([helper isEnabled:CONSULTA_ULTIMAS_TRANSF]) {
		[super.options addObject:[[MenuOption alloc] initWithOption:CONSULTA_ULTIMAS_TRANSF andTitle:@"Transferencias a Otras Ctas."]];
	}
	if ([helper isEnabled:SALDOS_Y_DISP_TRANSF]) {
		[super.options addObject:[[MenuOption alloc] initWithOption:SALDOS_Y_DISP_TRANSF andTitle:@"Saldos y Disponibles"]];
	}
	
	[super.tableView reloadData];
	
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
