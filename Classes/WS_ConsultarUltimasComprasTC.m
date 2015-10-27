//
//  ConsultarUltimasComprasTC_WSRequest.m
//  BanelcoMovil
//
//  Created by German Levy on 9/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WS_ConsultarUltimasComprasTC.h"
#import "WSUtil.h"
#import "CreditCardCompra.h"

@implementation WS_ConsultarUltimasComprasTC

@synthesize userToken, codBanco, tipoDoc, nroDoc, nroTarjeta;

-(NSString *)getWSName {
	return @"consultarUltimasComprasTC";
}

// ORIGINAL
//-(NSString *)getSoapMessage {
//	return  [NSString stringWithFormat:
//			 @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
//			 "<v:Header />\n"
//			 "<v:Body>\n"
//			 "<n0:consultarUltimasComprasTC id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
//			 "<in0 i:type=\"d:string\">%@</in0>\n" // User Token
//			 "<in1 i:type=\"d:string\">%@</in1>\n" // Codigo Banco
//			 "<in2 i:type=\"d:string\">%@</in2>\n" // Tipo DOC
//			 "<in3 i:type=\"d:string\">%@</in3>\n" // DNI
//			 "<in4 i:type=\"d:string\">%@</in4>\n" // Nro Tarjeta		 
//			 "</n0:consultarUltimasComprasTC>\n"
//			 "</v:Body>\n"
//			 "</v:Envelope>\n", userToken, codBanco, tipoDoc, nroDoc, nroTarjeta
//			 ];
//}

// SERVICIOS 2.0
-(NSString *)getSoapMessage {
	return  [NSString stringWithFormat:
			 @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
			 "<v:Header />\n"
			 "<v:Body>\n"
			 "<n0:consultarUltimasComprasTC id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
			 "<in0 i:type=\"d:string\">%@</in0>\n" // User Token
			 "<in1 i:type=\"d:string\">%@</in1>\n" // Security Token
			 "<in2 i:type=\"d:string\">%@</in2>\n" // Codigo Banco
			 "<in3 i:type=\"d:string\">%@</in3>\n" // Tipo DOC
			 "<in4 i:type=\"d:string\">%@</in4>\n" // DNI
			 "<in5 i:type=\"d:string\">%@</in5>\n" // Nro Tarjeta		 
			 "</n0:consultarUltimasComprasTC>\n"
			 "</v:Body>\n"
			 "</v:Envelope>\n", userToken, [WSRequest securityToken], codBanco, tipoDoc, nroDoc, nroTarjeta
			 ];
}

-(id)parseResponse:(NSData *)data {

	GDataXMLElement *rootSoap = [WSUtil getRootElement:@"out" inData:data];
	
	return [CreditCardCompra parse:rootSoap];
	
}

- (id)getDebugResponse {
    NSMutableArray *compras = [[NSMutableArray alloc] init];
	
	NSString *codigo = @"23423424";
		
	for (int i = 0; i<10; i++) {
		
		CreditCardCompra *c = [[CreditCardCompra alloc] init];
		c.nroTarjeta = codigo;
		c.concepto = @"pablito clavo un clavito, que clavito clavo pablito";
		c.fechaCompra = @"13/12/2013";
		c.valor = @"455";
		
		[compras addObject:c];
		[c release];
	}
    
	return compras;
}

@end
