//
//  Deuda.h
//  BanelcoMovilIphone
//
//  Created by German Levy on 9/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"


@interface Deuda : NSObject <NSCopying> {

	NSString *codigoEmpresa;
	
	NSString *codigoRubro;
	
	NSString *descPantalla;
	
	NSString *descripcionUsuario;
	
	NSString *error;
	
	NSString *idAdelanto;
	
	NSString *idCliente;
	
	NSString *importe;
	
	int importePermitido;
	
	int monedaCodigo;
	
	NSString *monedaSimbolo;
	
	NSString *nombreEmpresa;
	
	NSString *nroFactura;
	
	NSString *otroImporte;
	
	NSString *tipoEmpresa;
	
	int tipoPago;
	
	NSString *tituloIdentificacion;
	
	NSString *vencimiento;
	
	GDataXMLElement *creator;
	
	NSString *datoAdicional;
	
	NSString *leyenda; // Se ingresa si se paga con tarjeta y empresa.tipoPago == Empresa.TIPO_PAGO_SIN_DEUDA_ADIC
	
	BOOL agregadaManualmente;
	
}

@property (nonatomic, retain) NSString *codigoEmpresa;

@property (nonatomic, retain) NSString *codigoRubro;

@property (nonatomic, retain) NSString *descPantalla;

@property (nonatomic, retain) NSString *descripcionUsuario;

@property (nonatomic, retain) NSString *error;

@property (nonatomic, retain) NSString *idAdelanto;

@property (nonatomic, retain) NSString *idCliente;

@property (nonatomic, retain) NSString *importe;

@property int importePermitido;

@property int monedaCodigo;

@property (nonatomic, retain) NSString *monedaSimbolo;

@property (nonatomic, retain) NSString *nombreEmpresa;

@property (nonatomic, retain) NSString *nroFactura;

@property (nonatomic, retain) NSString *otroImporte;

@property (nonatomic, retain) NSString *tipoEmpresa;

@property int tipoPago;

@property (nonatomic, retain) NSString *tituloIdentificacion;

@property (nonatomic, retain) NSString *vencimiento;

@property (nonatomic, retain) GDataXMLElement *creator;

@property (nonatomic, retain) NSString *datoAdicional;

@property (nonatomic, retain) NSString *leyenda; // Se ingresa si se paga con tarjeta y empresa.tipoPago == Empresa.TIPO_PAGO_SIN_DEUDA_ADIC

@property BOOL agregadaManualmente;


-(NSString*) toSoapObject;

+ (NSMutableArray *) getDeudasConCodEmpresa:(NSString *)cod;

@end
