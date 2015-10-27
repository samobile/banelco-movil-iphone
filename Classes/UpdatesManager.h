//
//  UpdateManager.h
//  BanelcoMovilIphone
//
//  Created by German Levy on 9/25/10.
//  Copyright 2010 -. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UpdatesManager : NSObject {
	
	/** Bandera que indica si es necesario obtener los filtros de menu */
	BOOL obtenerMenues;
		
}

/** Cantidad de niveles que tiene el numero de version. */
extern int const NIVELES_VERSION;

/** Constante que indica que hay una nueva versión. */
extern int const NEW_VERSION;

/** Constante que indica que no hay una nueva version */
extern int const SAME_VERSION;

/** Constante que indica que hubo un error de conexion */
extern int const CONN_ERROR;


- (int) existNewVersion ;

@end
