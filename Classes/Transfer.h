//
//  Transfer.h
//  BanelcoMovil_Prueba
//
//  Created by German Levy on 8/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Context.h"
#import "Util.h"
#import "Cuenta.h"
#import "BaseModel.h"
#import "SaldosTransfMobileDTO.h"
#import "GDataXMLNode.h"
#import "TitularidadMobileDTO.h"

@interface Transfer : NSObject {

	Cuenta * cuentaOrigen;

	BaseModel * concepto;

	Cuenta * cuentaDestino;

	int type;

	NSString * importe;

	int moneda;

	NSString * cotizacion;

	NSString * importeConvertido;

	NSString * referencia;

	BOOL cruzada;
	
	TitularidadMobileDTO *tInmediata;
    
    NSString * tarjeta;
}

@property (nonatomic, retain) Cuenta * cuentaOrigen;

@property (nonatomic, retain) BaseModel * concepto;

@property (nonatomic, retain) Cuenta * cuentaDestino;

@property int type;

@property (nonatomic, retain) NSString * importe;

@property int moneda;

@property (nonatomic, retain) NSString * cotizacion;

@property (nonatomic, retain) NSString * importeConvertido;

@property (nonatomic, retain) NSString * referencia;

@property BOOL cruzada;

@property (nonatomic, retain) TitularidadMobileDTO *tInmediata;

@property (nonatomic, retain) NSString * tarjeta;


+ (SaldosTransfMobileDTO *) getSaldoTransfer:(Cuenta *)account;

- (NSString *) createConfirmMessage;

+ (NSMutableArray *) getUltimasTransferencias;

- (NSString *) toSoapObjectCBU;


@end
