//
//  RubrosList.m
//  BanelcoMovilIphone
//
//  Created by German Levy on 9/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RubrosList.h"
#import "Context.h"
#import "Rubro.h"
#import "WheelAnimationController.h"
#import "MenuBanelcoController.h"
#import "EmpresasList.h"
#import "BuscarEmpresa.h"
#import "Empresa.h"
#import "CommonUIFunctions.h"

@implementation RubrosList

@synthesize codRubro;


int const RUBRO = 0;

int const SUB_RUBRO = 1;

NSString * const RUBRO_TARJETAS = @"TCIN";

NSString * const RUBRO_AFIP = @"AFIP";



- (id)initWithAction:(int)action {
    if ((self = [super init])) {
        typeList = RUBRO;
		typeAction = action;
		self.title = @"Elegí Rubro";
    }
    return self;
}

- (id)initWithAction:(int)action andRubro:(NSString *)cRubro {
    if ((self = [super init])) {
		typeList = SUB_RUBRO;
		typeAction = action;
		self.title = @"Elegí Subrubro";
        self.codRubro = cRubro;
    }
    return self;
}


- (void)accionWithDelegate:(WheelAnimationController *)delegate {
	
	self.sourceDictionary = [[NSMutableDictionary alloc] init];
	
	@try {
		
		NSMutableArray *rubros;
		
		if (typeList == RUBRO) {
			rubros = [Rubro getRubros];
		} else {
			rubros = [Rubro getSubRubros:self.codRubro];
		}
		
		if (![rubros isKindOfClass:[NSError class]]) {
			
			self.sourceKeys = [[NSMutableArray alloc] init];
			for (Rubro *rubro in rubros) {
				
				[sourceDictionary setValue:rubro forKey:rubro.nombre];
				
			}
			
			self.sourceKeys = [[sourceDictionary allKeys] sortedArrayUsingSelector:@selector(compare:)];
			self.filteredKeys = [NSArray arrayWithArray:self.sourceKeys];
			
			[tableView reloadData];
			
		} else {
            
            NSString *errorCode = [[(NSError *)rubros userInfo] valueForKey:@"faultCode"];
            if ([errorCode isEqualToString:@"ss"]) {
                return;
            }
			
			NSString *errorDesc = [[(NSError *)rubros userInfo] valueForKey:@"description"];
			[CommonUIFunctions showAlert:@"Lista de Rubros" withMessage:errorDesc cancelButton:@"Cerrar" andDelegate:self];
			
		}
		
		
	}
	@catch (NSException * e) {
		// TODO
	}
	
	[delegate accionFinalizada:TRUE];
	
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	[searchBar resignFirstResponder];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	Rubro *rubroSelected = [self getItem:indexPath.row];
	NSString *codigo = rubroSelected.codigo;
	
	if ([rubroSelected.tipo isEqualToString:@""]) {
		
		RubrosList *subRubrosList = [[RubrosList alloc] initWithAction:typeAction andRubro:codigo];
		[[MenuBanelcoController sharedMenuController] pushScreen:subRubrosList];
		
	} else {
		
		waiting = [[WaitingAlert alloc] init];
		[self.view addSubview:waiting];
		//[NSThread sleepForTimeInterval:5];

		[waiting startWithSelector:@"executeSelectedRubro:" fromTarget:self withObject:rubroSelected/*codigo*/];
		
	}
	
}

- (void)executeSelectedRubro:(id)rubro {

	BOOL soloConsulta = (typeAction == EL_ULTIMOS_PAGOS);
	NSMutableArray *result = [Empresa getEmpresas:((Rubro *)rubro).codigo conFiltro:@"" soloConsulta:soloConsulta];
	
	if (![result isKindOfClass:[NSError class]]) {
		
		EmpresasList *empresasList = [[EmpresasList alloc] initWithRubro:rubro withEmpresas:result andTipoAccion:typeAction];
		[[MenuBanelcoController sharedMenuController] pushScreen:empresasList];
		
	} else { 
			
		//NSString *errorDesc = [[(NSError *)result userInfo] valueForKey:@"description"];
		//[CommonUIFunctions showAlert:@"Lista de empresas" withMessage:errorDesc andCancelButton:@"Cerrar"];
        
        NSString *errorCode = [[(NSError *)result userInfo] valueForKey:@"faultCode"];
        if ([errorCode isEqualToString:@"ss"]) {
            return;
        }
		
		if ([[[(NSError *)result userInfo] valueForKey:@"tipoError"] isEqualToString:@"LE"]) {
			
			BuscarEmpresa *buscarEmpresa = [[BuscarEmpresa alloc] initWithType:BE_LIMITE tipoAccion:typeAction andRubro:rubro];
			[[MenuBanelcoController sharedMenuController] pushScreen:buscarEmpresa];
			
		}
		
	}
	
}


- (void)dealloc {
    [super dealloc];
	[waiting release];

}


@end
