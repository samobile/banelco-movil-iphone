//
//  EmpresasList.h
//  BanelcoMovilIphone
//
//  Created by German Levy on 9/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WheelAnimationController.h"
#import "SearchTableController.h"
#import "Rubro.h"

@class WaitingAlert;

@interface EmpresasList : SearchTableController {

	NSString *rubro;
	
	NSString *busqueda;
	
	int tipoAccion;
	
	WaitingAlert* alert;
	
	NSMutableArray *listaEmpresas;
	
	NSArray *paraFiltrar;
		
}

@property (nonatomic, retain) NSString *rubro;

@property (nonatomic, retain) WaitingAlert* alert;

@property (nonatomic, retain) NSString *busqueda;


extern int const EL_ULTIMOS_PAGOS;

extern int const EL_PAGOS_TARJETA;

extern int const EL_OTRAS_CUENTAS;

extern int const EL_OTRAS_CUENTAS_COD;


- (id)initWithCodigoRubro:(NSString *)codRubro busqueda:(NSString *)filtro andTipoAccion:(BOOL)accion;

- (id)initWithRubro:(Rubro *)rubro busqueda:(NSString *)filtro andTipoAccion:(BOOL)accion;
	
- (id)initWithRubro:(Rubro *)_rubro withEmpresas:(NSMutableArray *)empresas andTipoAccion:(BOOL)accion;

- (id)initWithRubro:(Rubro *)_rubro withEmpresasDictionary:(NSMutableDictionary *)empresasDict andTipoAccion:(BOOL)accion;


@end
