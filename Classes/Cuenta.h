//
//  Cuenta.h
//  BanelcoMovil_Prueba
//
//  Created by German Levy on 8/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
#import "Cuenta.h"


@interface Cuenta : NSObject {

	NSString *codigo;
	int codigoMoneda;
	NSString *codigoTipoCuenta;
	BOOL ctaEspecial;
	NSString *descripcionCortaTipoCuenta;
	NSString *descripcionLargaTipoCuenta;
	NSString *disponible;
	NSString *limite;
	NSString *numero;
	NSString *saldo;
	NSString *simboloMoneda;
	int accountType;
	NSString *nombre;
	NSString *cuit;
	NSString *propia;
	NSString *organizacion;
	NSString *titular;
	NSString *segmento;
	
	NSString *mascara;
	
}

extern int const C_ACCOUNT;
extern int const C_CBU; 
extern int const C_PLAZO;
-(NSString*)descripcionParaCBU;
@property (nonatomic,retain) NSString *codigo;
@property int codigoMoneda;
@property (nonatomic,retain) NSString *codigoTipoCuenta;
@property BOOL ctaEspecial;
@property (nonatomic,retain) NSString *descripcionCortaTipoCuenta;
@property (nonatomic,retain) NSString *descripcionLargaTipoCuenta;
@property (nonatomic,retain) NSString *disponible;
@property (nonatomic,retain) NSString *limite;
@property (nonatomic,retain) NSString *numero;
@property (nonatomic,retain) NSString *saldo;
@property (nonatomic,retain) NSString *simboloMoneda;
@property int accountType;
@property (nonatomic,retain) NSString *nombre;
@property (nonatomic,retain) NSString *cuit;
@property (nonatomic,retain) NSString *propia;
@property (nonatomic,retain) NSString *organizacion;
@property (nonatomic,retain) NSString *titular;
@property (nonatomic,retain) NSString *segmento;

@property (nonatomic,retain) NSString *mascara;

+ (NSMutableArray *)parseCuentas:(GDataXMLElement *)cuentasSoap;
+ (Cuenta *)parseCuenta:(GDataXMLElement *)cuentaSoap;

+ (Cuenta *) getSaldo:(Cuenta*)cuenta withLyD:(BOOL)limitesYDisponibles;

+ (void) setMascara:(NSString *)masc;
+ (NSString *) getMascara;
+ (NSMutableArray *)getCuentas;
+ (void)setCuentas:(NSMutableArray *)ctas;

- (NSString *) getDescripcion;
- (NSString *)getDescripcionSaldoAlerta:(BOOL)limitesYDisponibles;

+ (NSMutableArray *) getUltimosMovimientos:(Cuenta *)cuenta;

+ (NSMutableArray *)parseCuentasCBU:(GDataXMLElement *)cuentasSoap;
+ (Cuenta *)parseCuentaCBU:(GDataXMLElement *)cuentaSoap;
+ (NSMutableArray *)getCuentasCBU;

+ (NSMutableArray *)parseCuentasPlazo:(GDataXMLElement *)cuentasSoap;
+ (Cuenta *)parseCuentaPlazo:(GDataXMLElement *)cuentaSoap;
+ (NSMutableArray *)getCuentasPlazo;
- (NSString *)getDescripcionCuentaPlazo;

+ (Cuenta *)getDebugCuenta;

@end
