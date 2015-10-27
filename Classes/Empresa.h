
//
//  Empresa.h
//  BanelcoMovil
//
//  Created by German Levy on 8/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Context.h"
#import "Util.h"
#import "GDataXMLNode.h"

@interface Empresa : NSObject {

	NSString * codigo;
	
	NSString * nombre;
	
	int importePermitido;
	
	int tipoPago;
	
	NSString * tipoEmpresa;
	
	int codMoneda;
	
	NSString * simboloMoneda;
	
	BOOL soloConsulta;
	
	NSString * datoAdicional;
	
	NSString * tituloIdentificacion;
	
	NSString * rubro;

	//Empresa Prepago
	int datosPrePago;
	
	int nroLeyenda;
	
	NSString * Id;
	//---------------

	int nroSecuencia; // Para el paginado
    
    NSString *codigoBarra;
	
}

@property (nonatomic, retain) NSString * codigo;

@property (nonatomic, retain) NSString * nombre;

@property int importePermitido;

@property int tipoPago;

@property (nonatomic, retain) NSString * tipoEmpresa;

@property int codMoneda;

@property (nonatomic, retain) NSString * simboloMoneda;

@property BOOL soloConsulta;

@property (nonatomic, retain) NSString * datoAdicional;

@property (nonatomic, retain) NSString * tituloIdentificacion;

@property (nonatomic, retain) NSString * rubro;

@property int datosPrePago;

@property int nroLeyenda;

@property (nonatomic, retain) NSString * Id;

@property int nroSecuencia;

@property (nonatomic, retain) NSString *codigoBarra;


// Tipos Empresa

extern NSString * const TIPO_CINES;

extern NSString * const TIPO_AFIP;

extern NSString * const TIPO_MONOTRIBUTO;

extern NSString * const TIPO_RENTAS;

extern NSString * const TIPO_EMPRESA_MIXTA;

extern NSString * const TIPO_PREPAGO_PES;

// Tipos Pago

extern int const TIPO_PAGO_CON_DEUDA;

extern int const TIPO_PAGO_SIN_DEUDA;

extern int const TIPO_PAGO_SIN_DEUDA_ADIC;

extern int const TIPO_PAGO_CON_FACTURA;

extern int const TIPO_PAGO_MIXTO;

// Importe Permitido

extern int const IMPORTE_IGUAL_DEUDA;

extern int const IMPORTE_MAYORIGUAL_DEUDA;

extern int const IMPORTE_NOIGUAL_DEUDA;



- (NSMutableArray *) getIDs;
+ (NSMutableArray *) getEmpresas:(NSString *)rubro conFiltro:(NSString *)filtro soloConsulta:(BOOL)soloConsulta;
- (NSMutableArray *) getUltimosPagos:(NSInteger)secuencia;
+ (NSMutableArray *) getEmpresasPrepagos:(NSString *)rubro;
- (NSMutableArray *) getDeudasTarjeta:(NSString *)idCliente;
+ (Empresa *) getEmpresa:(NSString *)empresaId;
+ (Empresa *) parse:(GDataXMLElement *)soapObject forSecuencia:(int)secuencia;
+ (Empresa *) parseForCodBarra:(GDataXMLElement *)soapObject withCodBarra:(NSString *)cod;


@end
