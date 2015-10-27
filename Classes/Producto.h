//
//  Producto.h
//  BanelcoMovil
//
//  Created by German Levy on 8/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Context.h"

@interface Producto : NSObject {

	NSString * nombre;

	NSString * codigo;

	NSString * tipo;
	
}

@property (nonatomic, retain) NSString * nombre;

@property (nonatomic, retain) NSString * codigo;

@property (nonatomic, retain) NSString * tipo;

+ (NSMutableArray *)parseProductos:(GDataXMLElement *)cuentasSoap;
+ (Producto *)parseProducto:(GDataXMLElement *)cuentaSoap;
+ (NSMutableArray *) getProductos;

+ (id)enviarSolicitud:(NSString *)nombreProd telContacto:(NSString *)tel1 telAlter:(NSString *)tel2 email:(NSString *)email;

@end
