//
//  WS_ListarIdentificacionesRecargaMovil.m
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 9/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WS_ListarIdentificacionesRecargaMovil.h"
#import "CommonFunctions.h"
#import "Deuda.h"
#import "WSUtil.h"

@implementation WS_ListarIdentificacionesRecargaMovil

@synthesize userToken, codigo;


-(NSString *)getWSName {
	return @"listarIdentificacionesRecargaMovil";
}

-(NSMutableArray *)getSoapParams {
	return [NSArray arrayWithObjects:userToken, codigo, nil];
}

// ORIGINAL
//-(NSString *)getSoapMessage {
//	
//	return  [NSString stringWithFormat:
//			 @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
//			 "<v:Header />\n"
//			 "<v:Body>\n"
//			 "<n0:listarIdentificacionesRecargaMovil id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
//			 "<in0 i:type=\"d:string\">%@</in0>\n" // Token
//			 "<in1 i:type=\"d:string\">%@</in1>\n" // codigo Empresa
//			 "</n0:listarIdentificacionesRecargaMovil>\n"
//			 "</v:Body>\n"
//			 "</v:Envelope>\n", userToken, codigo
//			 ];
//	
//}

// SERVICIOS 2.0
-(NSString *)getSoapMessage {
	
	return  [NSString stringWithFormat:
			 @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
			 "<v:Header />\n"
			 "<v:Body>\n"
			 "<n0:listarIdentificacionesRecargaMovil id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
			 "<in0 i:type=\"d:string\">%@</in0>\n" // Token
			 "<in1 i:type=\"d:string\">%@</in1>\n" // Security Token
			 "<in2 i:type=\"d:string\">%@</in2>\n" // codigo Empresa
			 "</n0:listarIdentificacionesRecargaMovil>\n"
			 "</v:Body>\n"
			 "</v:Envelope>\n", userToken, [WSRequest securityToken], codigo
			 ];
	
}

-(id)parseResponse:(NSData *)data {
	
	NSMutableArray *deudas = [[NSMutableArray alloc] init];
	
	GDataXMLElement *rootSoap = [WSUtil getRootElement:@"out" inData:data];
	
	NSArray *deudasSoap = [rootSoap elementsForName:@"DeudaMobileDTO"];
	
	for (GDataXMLElement *soap in deudasSoap) {
		
		Deuda *d = [[Deuda alloc] init];
		d.agregadaManualmente = [WSUtil getBooleanProperty:@"agregadaManualmente" ofSoap:soap];
		d.codigoEmpresa = [WSUtil getStringProperty:@"codigoEmpresa" ofSoap:soap];
		d.codigoRubro = [WSUtil getStringProperty:@"codigoRubro" ofSoap:soap];
		d.descPantalla = [WSUtil getStringProperty:@"descPantalla" ofSoap:soap];
		d.descripcionUsuario = [WSUtil getStringProperty:@"descripcionUsuario" ofSoap:soap];
		d.error = [WSUtil getStringProperty:@"error" ofSoap:soap];
		d.idAdelanto = [WSUtil getStringProperty:@"idAdelanto" ofSoap:soap];
		d.idCliente = [WSUtil getStringProperty:@"idCliente" ofSoap:soap];
		d.importe = [WSUtil getStringProperty:@"importe" ofSoap:soap];
		d.importePermitido = [WSUtil getIntegerProperty:@"importePermitido" ofSoap:soap];
		d.monedaCodigo = [WSUtil getIntegerProperty:@"monedaCodigo" ofSoap:soap];
		d.monedaSimbolo = [WSUtil getStringProperty:@"monedaSimbolo" ofSoap:soap];
		d.nombreEmpresa = [WSUtil getStringProperty:@"nombreEmpresa" ofSoap:soap];
		d.nroFactura = [WSUtil getStringProperty:@"nroFactura" ofSoap:soap];
		d.otroImporte = [WSUtil getStringProperty:@"otroImporte" ofSoap:soap];
		d.tipoEmpresa = [WSUtil getStringProperty:@"tipoEmpresa" ofSoap:soap];
		d.tipoPago = [WSUtil getIntegerProperty:@"tipoPago" ofSoap:soap];
		d.tituloIdentificacion = [WSUtil getStringProperty:@"tituloIdentificacion" ofSoap:soap];
		d.vencimiento = [WSUtil getStringProperty:@"vencimiento" ofSoap:soap];
		
		[deudas addObject:d];
		[d release];
		
	}
	
	return deudas;
	
}


@end
