//
//  CargaCelularMenu.m
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 9/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CargaCelularMenu.h"
#import "MenuOptionsHelper.h"
#import "MenuOption.h"
#import "Context.h"
#import "CargaCelularImporteController.h"
#import "CargaCelularOtroController.h"
#import "MenuBanelcoController.h"
#import "Empresa.h"
#import "CommonUIFunctions.h"
#import "Deuda.h"

#import "GAITracker.h"
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

@implementation CargaCelularMenu

- (void)GAItrack {
    // May return nil if a tracker has not already been initialized with a
    // property ID.
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    // This screen name value will remain set on the tracker and sent with
    // hits until it is set to a new value or to nil.
    [tracker set:kGAIScreenName value:@"Pantalla Carga Celular"];
    // New SDK versions
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

- (id) init {
	if ((self = [super init])) {

	}
	return self;
	
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	//self.title = @"Recargas";
	self.title = @"Recarga de Celular";
	
	[self performSelectorOnMainThread:@selector(crearTextView) withObject:nil waitUntilDone:YES];
	
}

- (void) crearTextView {
    
    if ([Context sharedContext].nuevaRecarga) {
        return;
    }
	
	CGRect frameText = CGRectMake(12, IPHONE5_HDIFF(210), 296, 317 - 210);
	UITextView *textView = [[UITextView alloc] initWithFrame:frameText];
	textView.backgroundColor = [UIColor clearColor];
	if (![Context sharedContext].personalizado) {
        textView.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:14];
    }
    textView.text = @"Para registrar otros números o cambio de compañía de los existentes deberás acceder a pagomiscuentas.com o al canal habilitado por tu Banco.";
	textView.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	textView.editable = NO;
	textView.userInteractionEnabled	= NO;
	textView.autocorrectionType = UITextAutocorrectionTypeNo;
	[self.view addSubview:textView];	
}


- (void)aceptar:(int)cellIdx {
	
	int selectedIndex = [self getSelectedIndex:cellIdx];
	Context *context = [Context sharedContext];
	
	if (selectedIndex == MI_CELULAR) {
		
		if([context.usuario esRestringido]) {
			
			[CommonUIFunctions showRestrictedAlert:@"Mi celular" withDelegate:nil];
			
		} else {
			
			[self miCelular];
			
		}
		
	} else if (selectedIndex == OTRO_NUMERO) {
		
		[self otroNumero];
		
	} else if (selectedIndex == TARJETA_SUBE) {
		
		[self tarjetaSUBE];
		
	}
	
}

- (void)initOptions {
	
	[super.options removeAllObjects];
	
	MenuOptionsHelper *helper = [MenuOptionsHelper sharedMenuHelper];
	
	if ([helper isEnabled:MI_CELULAR]) {
		[super.options addObject:[[MenuOption alloc] initWithOption:MI_CELULAR andTitle:@"Mi Celular"]];
	}
	if ([helper isEnabled:OTRO_NUMERO]) {
		[super.options addObject:[[MenuOption alloc] initWithOption:OTRO_NUMERO andTitle:@"Otro Número"]];
	}
//	if ([helper isEnabled:TARJETA_SUBE]) {
//		[super.options addObject:[[MenuOption alloc] initWithOption:TARJETA_SUBE andTitle:@"SUBE"]];
//	}
	
	[super.tableView reloadData];
	
}

- (void)miCelular {
	
//	CargaCelularImporteController *i = [[CargaCelularImporteController alloc] init];
//	i.titulo = @"Mi Celular";
//	i.descCliente = @"1112345678";
//	i.idCliente = @"test";
//	[[MenuBanelcoController sharedMenuController] pushScreen:i];
	
	Context *c = [Context sharedContext];
	NSString *operador = c.usuario.operadorCelular;
	NSString *empresaId;
	
	if ((empresaId = [self buscarCarrier:operador]) != nil) {
		
		CargaCelularImporteController *i = [[CargaCelularImporteController alloc] initWithTitle:@"Mi Celular" yEmpresaId:empresaId];
		i.idCliente = [[[Context sharedContext] usuario] celular];
		i.descCliente = nil;
		[[MenuBanelcoController sharedMenuController] pushScreen:i];
		return;
		
//		//consulta empresa (operador) en el WS
//		Empresa *empresa = [Empresa getEmpresa:empresaId];
//		
//		if (empresa) {
//			CargaCelularImporteController *i = [[CargaCelularImporteController alloc] init];
//			i.empresa = empresa;
//			i.titulo = @"Mi Celular";
//			i.descCliente = nil;
//			i.idCliente = [[[Context sharedContext] usuario] celular];
//			[[MenuBanelcoController sharedMenuController] pushScreen:i];
//			return;
//		}
	}
	[CommonUIFunctions showAlert:@"Mi Celular" withMessage:@"Su operador celular no está disponible" andCancelButton:@"Aceptar"];
}

- (void)otroNumero {
	
	CargaCelularOtroController *o = [[CargaCelularOtroController alloc] init];
	[[MenuBanelcoController sharedMenuController] pushScreen:o];
	
}

//- (void)tarjetaSUBE {
//	
//	CargaSUBEOtroController *o = [[CargaSUBEOtroController alloc] init];
//	[[MenuBanelcoController sharedMenuController] pushScreen:o];
//	
//}

//busca id empresa (carrier usuario) en habilitados para recarga movil
- (NSString *)buscarCarrier:(NSString *)carrierId {
	
	Context *c = [Context sharedContext];
	if (!c.carrierCodes && !c.carrierCodeNames) {
		return nil;
	}
	for (int i = 0; i < [c.carrierCodes count]; i++) {
		if ([[c.carrierCodes objectAtIndex:i] isEqualToString:carrierId]) {
			return [c.carrierCodeNames objectAtIndex:i];
		}
	}
	return nil;
}

- (NSMutableArray *)getOtrosCelulares {
	
	NSMutableArray *result = [[NSMutableArray alloc] init];
	Context *c = [Context sharedContext];
	if (c.carrierCodes && c.carrierCodeNames) {

		for (NSString *ccode in c.carrierCodeNames) {
			NSMutableArray *deudas = [Deuda getDeudasConCodEmpresa:ccode];
			if (deudas && [deudas isKindOfClass:[NSError class]]) {
				continue;
			}
            else if ([deudas isKindOfClass:[NSError class]]) {
                NSString *errorCode = [[(NSError *)deudas userInfo] valueForKey:@"faultCode"];
                if ([errorCode isEqualToString:@"ss"]) {
                    return nil;
                }
            }
			if (deudas && [deudas count] > 0) {
				[result addObjectsFromArray:deudas];
			}
		}
				
	}
	return result;
}

//- (NSMutableArray *) getDeudas:(NSMutableArray *)deudas conEmpresaId:(NSString *)empresaId {
//	NSMutableArray *da = [[NSMutableArray alloc] init];
//	for (Deuda *d in deudas) {
//		if ([d.codigoEmpresa isEqualToString:empresaId]) {
//			[da addObject:d];
//		}
//	}
//	return da;
//}

- (void)dealloc {

	
	[super dealloc];
}

@end
