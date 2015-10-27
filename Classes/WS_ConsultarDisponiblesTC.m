//
//  ConsultarDisponiblesTC_WSRequest.m
//  BanelcoMovil
//
//  Created by German Levy on 8/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WS_ConsultarDisponiblesTC.h"
#import "CommonFunctions.h"
#import "Context.h"
#import "WSUtil.h"

@implementation WS_ConsultarDisponiblesTC

@synthesize userToken, codBanco, tipoDoc, nroDoc, nroTarjeta;


-(NSString *)getWSName {
	return @"consultarDisponibleTC";
}

// ORIGINAL
//-(NSString *)getSoapMessage {
//	
//	return  [NSString stringWithFormat:
//			 @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
//			 "<v:Header />\n"
//			 "<v:Body>\n"
//			 "<n0:consultarDisponibleTC id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
//			 "<in0 i:type=\"d:string\">%@</in0>\n" // Token
//			 "<in1 i:type=\"d:string\">%@</in1>\n" // Cod banco
//			 "<in2 i:type=\"d:string\">%@</in2>\n" // Tipo documento
//			 "<in3 i:type=\"d:string\">%@</in3>\n" // Nro documento
//			 "<in4 i:type=\"d:string\">%@</in4>\n" // Numero tarjeta
//			 "</n0:consultarDisponibleTC>\n"
//			 "</v:Body>\n"
//			 "</v:Envelope>\n", userToken, codBanco, tipoDoc, nroDoc, nroTarjeta 
//			 ];
//	
//}

// SERVICIOS 2.0
-(NSString *)getSoapMessage {
	
	return  [NSString stringWithFormat:
			 @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
			 "<v:Header />\n"
			 "<v:Body>\n"
			 "<n0:consultarDisponibleTC id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
			 "<in0 i:type=\"d:string\">%@</in0>\n" // Token
			 "<in1 i:type=\"d:string\">%@</in1>\n" // Security Token
			 "<in2 i:type=\"d:string\">%@</in2>\n" // Cod banco
			 "<in3 i:type=\"d:string\">%@</in3>\n" // Tipo documento
			 "<in4 i:type=\"d:string\">%@</in4>\n" // Nro documento
			 "<in5 i:type=\"d:string\">%@</in5>\n" // Numero tarjeta
			 "</n0:consultarDisponibleTC>\n"
			 "</v:Body>\n"
			 "</v:Envelope>\n", userToken, [WSRequest securityToken], codBanco, tipoDoc, nroDoc, nroTarjeta 
			 ];
	
}

-(id)parseResponse:(NSData *)data {
#if WSDEBUG
    [self getDebugResponse];
#endif
	
	NSMutableDictionary *disponibles = [[NSMutableDictionary alloc] init];
	
	GDataXMLElement *rootSoap = [WSUtil getRootElement:@"out" inData:data];
	
	GDataXMLElement *disponiblesE = [[rootSoap elementsForName:@"disponibles"] objectAtIndex:0];

	NSArray *limites = [disponiblesE elementsForName:@"Limite"];
	
	for (GDataXMLElement * soapLimite in limites) {
		
		NSString *desc = [(GDataXMLElement *)[[soapLimite elementsForName:@"descripcion"] objectAtIndex:0] stringValue];
		NSString *valor = [(GDataXMLElement *)[[soapLimite elementsForName:@"pesos"] objectAtIndex:0] stringValue];
        
		[disponibles setObject:valor forKey:desc];
		
		[desc release];
		[valor release];
		
	}
	
	CreditCardDisponibles *ccDisponibles = [[CreditCardDisponibles alloc] init];
	ccDisponibles.disponibles = disponibles;
	
	return ccDisponibles;
	
}

- (id)getDebugResponse {
    NSMutableDictionary *disponibles = [[NSMutableDictionary alloc] init];
    for (int i = 0; i<1; i++) {
        [disponibles setObject:@"1111" forKey:@"312"];
    }
    CreditCardDisponibles *ccDisponibles = [[CreditCardDisponibles alloc] init];
	ccDisponibles.disponibles = disponibles;
	
	return ccDisponibles;
}

@end
