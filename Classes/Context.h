//
//  Context.h
//  BanelcoMovil_Prueba
//
//  Created by German Levy on 8/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CreditCard.h"
#import "Cuenta.h"
#import "Usuario.h"
#import "Banco.h"
#import "Deuda.h"

@interface Context : NSObject {

	
	int bankCount;
	
	NSArray *bankCodes;
	
	NSArray *bankNames;

	/** Nombre de los logos de cada banco. */
	NSArray *nombreImagenBancos;
	

	NSString *specialDigits;
	
	long maxSessionTime;
	
	long maxInactivityTime;

	NSString *appOrigen;
	
	NSArray *menuesBancos;
	
	NSString *opcionesDeMenu;
	
	/** Indica que bancos utilizan la "nueva registracion" */
	NSString *condRegistracion;
	
	NSString *applicationName;
	
	NSString *token;
	NSString *tipoDoc;
	NSString *dni;
	Banco *banco;
	
	CreditCard *visaSeleccionada;
	
	NSMutableArray *cuentas;
	
	NSMutableArray *deudas;
	
	NSMutableArray *rubros;
	
	NSMutableArray *productos;
	
	NSMutableArray *conceptos;
	
	/**
	 * Esta variable se setea en null cunado se entra en el modulo de Pagos.
	 * Indica cual es la deuda que se seleccionÛ para pagar. Cuando se
	 * selecciona una Deuda en PagosList, se guarda cual fue.
	 */
	Deuda *selectedDeuda;
	
	Cuenta *selectedCuenta;
	
	Usuario *usuario;
	
	double startAppHour;
	double lastActivityHour;
	
	NSMutableDictionary *mascaraCuentas;
	
	//Agregadas x Dem
	NSMutableArray* bancosSeleccionados;
	NSMutableArray*  bancosNoSeleccionados;
	
	//sea
	NSMutableArray *carrierCodes;
	NSMutableArray *carrierCodeNames;
	
	NSString *appOpcional;
	NSString *urlVersion;
	
	BOOL allowRequest;
	
	//personalizacion
	BOOL personalizado;

    //Bimo
    long maxInactivityTimeBimo;
    NSString *listaBancosBimo;
    
    NSDate *expirationDate;
    BOOL expirationEnabled;
    
    NSMutableArray *carrierNames;
    
    BOOL nuevaRecarga;
    BOOL scanEnabled;
    
    BOOL extraccionEnabled;
}

@property BOOL extraccionEnabled;

@property BOOL allowRequest;

@property int bankCount;

@property (nonatomic, retain) NSArray *bankCodes;

@property (nonatomic, retain) NSArray *bankNames;

@property (nonatomic, retain) NSArray *nombreImagenBancos;

@property (nonatomic, retain) NSString *specialDigits;

@property long maxSessionTime;

@property long maxInactivityTime;

@property (nonatomic, retain) NSString *appOrigen;

@property (nonatomic, retain) NSArray *menuesBancos;

@property (nonatomic, retain) NSString *opcionesDeMenu;

@property (nonatomic, retain) NSString *condRegistracion;

@property (nonatomic, retain) NSString *applicationName;

@property (nonatomic, retain) NSString *token;
@property (nonatomic, retain) NSString *tipoDoc;
@property (nonatomic, retain) NSString *dni;
@property (nonatomic, retain) Banco *banco;


@property (nonatomic, retain) CreditCard *visaSeleccionada;

@property (nonatomic, retain) NSMutableArray *cuentas;
@property (nonatomic, retain) NSMutableArray *cuentasCBU;

@property (nonatomic, retain) NSMutableArray *deudas;

@property (nonatomic, retain) NSMutableArray *rubros;

@property (nonatomic, retain) NSMutableArray *productos;

@property (nonatomic, retain) NSMutableArray *conceptos;


@property (nonatomic, retain) Deuda *selectedDeuda;

@property (nonatomic, retain) Cuenta *selectedCuenta;

@property (nonatomic, retain) Usuario *usuario;

@property double startAppHour;
@property double lastActivityHour;

@property (nonatomic, retain) NSMutableDictionary *mascaraCuentas;

//Agregadas x Dem
@property (nonatomic, retain) NSMutableArray* bancosSeleccionados;
@property (nonatomic, retain) NSMutableArray*  bancosNoSeleccionados;

//sea
//Se llena desde Update.txt
@property (nonatomic, retain) NSMutableArray *carrierCodes;
@property (nonatomic, retain) NSMutableArray *carrierCodeNames;

@property (nonatomic, retain) NSString *appOpcional;
@property (nonatomic, retain) NSString *urlVersion;

//personalizacion
@property BOOL personalizado;

//Bimo
@property long maxInactivityTimeBimo;
@property (nonatomic, retain) NSString *listaBancosBimo;

@property (nonatomic, retain) NSDate *expirationDate;
@property BOOL expirationEnabled;

@property (nonatomic, retain) NSMutableArray *carrierNames;

@property BOOL nuevaRecarga;
@property BOOL scanEnabled;

- (void)resetContext;

+(Context *)sharedContext;

+(NSMutableArray *)getCuentas;

+(NSMutableArray *)getCuentas:(int)codMoneda;

+(void)setCuentas:(NSMutableArray *)ctas;

- (BOOL)isLogued;

- (NSString *)getToken;

+(NSMutableArray *)getCuentasCBU;
+(void)setCuentasCBU:(NSMutableArray *)ctas;

//personalizacion
//- (NSString *)getPersonalizationProperty:(NSString *)key;
- (UIColor *)UIColorFromRGBProperty:(NSString *)prop;

@end
