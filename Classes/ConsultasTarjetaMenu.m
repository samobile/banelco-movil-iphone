//
//  ConsultasTarjetaMenu.m
//  BanelcoMovilIphone
//
//  Created by Ezequiel Aceto on 29/09/10.
//  Copyright 2010 Mobile Computing. All rights reserved.
//

#import "ConsultasTarjetaMenu.h"
#import "MenuOptionsHelper.h"
#import "MenuOption.h"
#import "CommonUIFunctions.h"
#import "CreditCardSaldoVC.h"
#import "MenuBanelcoController.h"

#import "CreditCardMenuResumenVC.h"
#import "CreditCardMenuMovimientosVC.h"
#import "CreditCardMenuDisponibleVC.h"

#import "Rubro.h"
#import "EmpresasList.h"
#import "RubrosList.h"
#import "Deuda.h"

@implementation ConsultasTarjetaMenu
- (id) init {
	NSLog(@"Entrare al init?");
	if ((self = [super init])) {
		NSLog(@"Siiii!!");
		self.title = @"Tarjetas de Crédito";
		
	}
	NSLog(@"No :(");
	return self;
}

-(void) viewDidLoad{
	
	[super viewDidLoad];
	self.title = @"Tarjetas de Crédito";
    self.title.accessibilityLabel = @"Submenú Tarjetas de Crédito";
}

- (void)aceptar:(int)cellIdx {
	
	int selectedIndex = [self getSelectedIndex:cellIdx];
	
	if (selectedIndex == SALDOSTC) {
		
		CreditCardSaldoVC* vc = [[CreditCardSaldoVC alloc] init];	
		
		[[MenuBanelcoController sharedMenuController] pushScreen:vc];
		
	} else if (selectedIndex == ULTIMO_RESUMEN) {
		
		CreditCardMenuResumenVC *list = [[CreditCardMenuResumenVC alloc] init]; 
		
		[[MenuBanelcoController sharedMenuController] pushScreen:list];		
		
	} else if (selectedIndex == ULTIMAS_COMPRAS) {
		CreditCardMenuMovimientosVC *list = [[CreditCardMenuMovimientosVC alloc] init]; 
		
		[[MenuBanelcoController sharedMenuController] pushScreen:list];		
		
	} else if (selectedIndex == DISPONIBLES) {
		
		CreditCardMenuDisponibleVC *list = [[CreditCardMenuDisponibleVC alloc] init]; 
		
		[[MenuBanelcoController sharedMenuController] pushScreen:list];		
	}
    //nuevo
    else if (selectedIndex == PAGO_TARJETA) {
        Context *context = [Context sharedContext];
        if([context.usuario esRestringido]) {
            
            [CommonUIFunctions showRestrictedAlert:@"Tarjetas de Crédito" withDelegate:nil];
            
        } else {
            
             PagosListController *pagosList = [[PagosListController alloc] initWithDeudasTarjeta:nil];
            [[MenuBanelcoController sharedMenuController] pushScreen:pagosList];
            
//            NSMutableArray *dT = [self filtrarDeudas];
//            if (!dT) {
//                Rubro *rubro = [[Rubro alloc] init];
//                rubro.codigo = RUBRO_TARJETAS;
//                rubro.nombre = @"Tarjetas de Crédito";
//                
//                EmpresasList *empresasList = [[EmpresasList alloc] initWithRubro:rubro busqueda:@"" andTipoAccion:EL_PAGOS_TARJETA];
//                [[MenuBanelcoController sharedMenuController] pushScreen:empresasList];
//
//            }
//            else {
//                PagosListController *pagosList = [[PagosListController alloc] initWithDeudas:dT];
//                [[MenuBanelcoController sharedMenuController] pushScreen:pagosList];
//            }
            
        }
        
    }
    
    else {
        
    }
	
}

- (NSMutableArray *)filtrarDeudas {
    NSMutableArray *deudas = [Context sharedContext].deudas;
    if (![Context sharedContext].deudas) {
        deudas = [Deuda getDeudas];
    }
    NSMutableArray *deudasTarjeta = [[[NSMutableArray alloc] init] autorelease];
    for (Deuda *d in deudas) {
        if ([d.codigoRubro isEqualToString:RUBRO_TARJETAS]) {
            [deudasTarjeta addObject:d];
        }
    }
    return deudasTarjeta;
}

- (void)initOptions {
	
	[super.options removeAllObjects];
	
	MenuOptionsHelper *helper = [MenuOptionsHelper sharedMenuHelper];
    
    
	
	if ([helper isEnabled:SALDOSTC]) {
		[super.options addObject:[[MenuOption alloc] initWithOption:SALDOSTC andTitle:@"Saldos"]];
	}
	if ([helper isEnabled:ULTIMO_RESUMEN]) {
		[super.options addObject:[[MenuOption alloc] initWithOption:ULTIMO_RESUMEN andTitle:@"Último Resumen"]];
	}
	if ([helper isEnabled:ULTIMAS_COMPRAS]) {
		[super.options addObject:[[MenuOption alloc] initWithOption:ULTIMAS_COMPRAS andTitle:@"Últimos Movimientos"]];
	}
	if ([helper isEnabled:DISPONIBLES]) {
		[super.options addObject:[[MenuOption alloc] initWithOption:DISPONIBLES andTitle:@"Disponible"]];
	}
    //nuevo
//    NSDictionary *dict = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"Personalizacion"];
//    if ([Context sharedContext].personalizado && [[dict objectForKey:@"idBanco"] isEqualToString:@"BMBS"]) {
//        if ([helper isEnabled:PAGO_TARJETA]) {
//            [super.options addObject:[[MenuOption alloc] initWithOption:PAGO_TARJETA andTitle:@"Pago Tarjeta de Crédito"]];
//        }
//    }
    if ([helper isEnabled:PAGO_TARJETA]) {
        [super.options addObject:[[MenuOption alloc] initWithOption:PAGO_TARJETA andTitle:@"Pago Tarjeta de Crédito"]];
    }
    
	[super.tableView reloadData];
	
}


- (void)dealloc {
    [super dealloc];
}


@end
