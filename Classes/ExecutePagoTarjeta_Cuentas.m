//
//  ExecutePagoTarjeta_Cuentas.m
//  BanelcoMovilIphone
//
//  Created by German Levy on 9/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ExecutePagoTarjeta_Cuentas.h"
#import "EmpresasList.h"
#import "IdentificacionesList.h"
#import "MenuBanelcoController.h"
#import "NuevaIdentificacionForm.h"
#import "CommonUIFunctions.h"


@implementation ExecutePagoTarjeta_Cuentas

@synthesize empresa;

- (id)initWithEmpresa:(Empresa *)_empresa andNextAction:(int)action {
    if ((self = [super init])) {
        self.empresa = _empresa;
		nextAction = action;
    }
    return self;
}  

- (void)execute {

	NSMutableArray *IDs  = nil;
	
	@try {
		IDs = [self.empresa getIDs];
	}
	@catch (NSException * e) {
		// TODO
		NSLog(@"%@",e);
	}
	
	NSString *strTitulo;
	
	
	if (IDs && ![IDs isKindOfClass:[NSError class]]) {
		
		if ([IDs count] > 0) {
			
			if (nextAction != EL_PAGOS_TARJETA) {
				
				strTitulo = self.empresa.tituloIdentificacion;
				
				[IDs addObject:[NSString stringWithFormat:@"Otro/a %@", strTitulo]];
				
			} else {
				
				strTitulo = @"Nro. de Tarjeta";
				
				[IDs addObject:@"Otro Número de tarjeta"];
				
			}
			
			IdentificacionesList *idsList = [[IdentificacionesList alloc] initWithTitle:strTitulo andItems:IDs forEmpresa:self.empresa];
			[[MenuBanelcoController sharedMenuController] pushScreen:idsList];
			
			
		} else {
			
//			if (nextAction != EL_PAGOS_TARJETA) {
//				strTitulo = [NSString stringWithFormat:@"Ingrese %@", empresa.tituloIdentificacion];
//			} else {
//				strTitulo = @"Ingrese Nro. de Tarjeta";
//			}

			strTitulo = [NSString stringWithFormat:@"%@", self.empresa.tituloIdentificacion];

			NuevaIdentificacionForm *pagosTarjetaForm = [[NuevaIdentificacionForm alloc] initWithTitle:strTitulo andEmpresa:self.empresa];
			[[MenuBanelcoController sharedMenuController] pushScreen:pagosTarjetaForm];
			
		}
		
	} else {
		
        NSString *errorCode = [[(NSError *)IDs userInfo] valueForKey:@"faultCode"];
        if ([errorCode isEqualToString:@"ss"]) {
            return;
        }
        
		NSString *errorDesc = [[(NSError *)IDs userInfo] valueForKey:@"description"];
		[CommonUIFunctions showAlert:@"Lista de identificaciones" withMessage:errorDesc andCancelButton:@"Cerrar"];
		
	}

}

- (void)dealloc {
    self.empresa = nil;
    [super dealloc];
}



@end
