//
//  Movimiento.h
//  BanelcoMovil
//
//  Created by German Levy on 8/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Context.h"
#import "Util.h"
#import "GDataXMLNode.h"

@interface Movimiento : NSObject {

	NSString * fechaMovimiento;

	NSString * importe;

	NSString * canal;

	NSString * nombre;
	
}

@property (nonatomic, retain) NSString * fechaMovimiento;

@property (nonatomic, retain) NSString * importe;

@property (nonatomic, retain) NSString * canal;

@property (nonatomic, retain) NSString * nombre;

- (NSString *) getDescripcion;
+ (NSArray *) parseMovimientos:(GDataXMLElement *)movimientosSoap;
+ (Movimiento *) parseMovimiento:(GDataXMLElement *)movimiento;

+ (NSString *)getFechaConsulta;
+ (void)setFechaConsulta:(NSString *)fecha;
+ (NSString *)getSaldo;
+ (void)setSaldo:(NSString *)s;
	

@end
