//
//  ConsultarTarjetasVisa_WSRequest.m
//  BanelcoMovil
//
//  Created by German Levy on 8/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WS_ConsultarTarjetasVisa.h"
#import "Context.h"
#import "Usuario.h"
#import "CommonFunctions.h"
#import "Cuenta.h"
#import "WSUtil.h"


@implementation WS_ConsultarTarjetasVisa

@synthesize userToken, codBanco, tipoDoc, nroDoc;

-(NSString *)getWSName {
	return @"consultarTarjetasVisaDatosAdicionales";
}

// ORIGINAL
//-(NSString *)getSoapMessage {
//	
//	return  [NSString stringWithFormat:
//			 @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
//			 "<v:Header />\n"
//			 "<v:Body>\n"
//			 "<n0:consultarTarjetasVisa id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
//			 "<in0 i:type=\"d:string\">%@</in0>\n" // User Token
//			 "<in1 i:type=\"d:string\">%@</in1>\n" // Codigo Banco
//			 "<in2 i:type=\"d:string\">%@</in2>\n" // Tipo DOC
//			 "<in3 i:type=\"d:string\">%@</in3>\n" // DNI
//			 "</n0:consultarTarjetasVisa>\n"
//			 "</v:Body>\n"
//			 "</v:Envelope>\n", userToken, codBanco, tipoDoc, nroDoc
//			 ];
//	
//}

// SERVICIOS 2.0
-(NSString *)getSoapMessage {
	
	return  [NSString stringWithFormat:
			 @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
			 "<v:Header />\n"
			 "<v:Body>\n"
			 "<n0:consultarTarjetasVisaDatosAdicionales id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
			 "<in0 i:type=\"d:string\">%@</in0>\n" // User Token
			 "<in1 i:type=\"d:string\">%@</in1>\n" // Security Token
			 "<in2 i:type=\"d:string\">%@</in2>\n" // Codigo Banco
			 "<in3 i:type=\"d:string\">%@</in3>\n" // Tipo DOC
			 "<in4 i:type=\"d:string\">%@</in4>\n" // DNI
			 "</n0:consultarTarjetasVisaDatosAdicionales>\n"
			 "</v:Body>\n"
			 "</v:Envelope>\n", userToken, [WSRequest securityToken], codBanco, tipoDoc, nroDoc
			 ];
	
}

-(id)parseResponse:(NSData *)data {

	NSMutableArray *tarjetasDeCredito = [[NSMutableArray alloc]init];
	
	GDataXMLElement *rootSoap = [WSUtil getRootElement:@"out" inData:data];

	NSArray *tarjetas = [rootSoap elementsForName:@"TarjetaDatosAdicionales"];
	
	for (GDataXMLElement * tarjeta in tarjetas) {
			
		NSString *numero = [(GDataXMLElement *)[[tarjeta elementsForName:@"numero"] objectAtIndex:0] stringValue];
		NSString *producto = [(GDataXMLElement *)[[tarjeta elementsForName:@"producto"] objectAtIndex:0] stringValue];	
		NSString *vencimiento = [(GDataXMLElement *)[[tarjeta elementsForName:@"vencimiento"] objectAtIndex:0] stringValue];
		NSString *fechaCierreActual = [(GDataXMLElement *)[[tarjeta elementsForName:@"fechaCierreActual"] objectAtIndex:0] stringValue];
        NSString *fechaProximoCierre = [(GDataXMLElement *)[[tarjeta elementsForName:@"fechaProximoCierre"] objectAtIndex:0] stringValue];
        NSString *fechaProxVto = [(GDataXMLElement *)[[tarjeta elementsForName:@"fechaProximoVto"] objectAtIndex:0] stringValue];
        
        
		CreditCard *aCreditCard = [[CreditCard alloc] init];
		
		aCreditCard.numero = [NSString stringWithString:numero];
		aCreditCard.nombre = [NSString stringWithString:producto];
        aCreditCard.fechaVencimiento = [NSString stringWithString:[WSUtil formatDateFromWS:vencimiento]];
        aCreditCard.fechaProxVenc= [NSString stringWithString:[WSUtil formatDateFromWS:fechaProxVto]];
        aCreditCard.fechaProxCierre= [NSString stringWithString:[WSUtil formatDateFromWS:fechaProximoCierre]];
        aCreditCard.fechaCierreActual = [NSString stringWithString:[WSUtil formatDateFromWS:fechaCierreActual]];
	
		[tarjetasDeCredito addObject:aCreditCard];
		
//		[numero release];
//		[producto release];
//		[vencimiento release];
		
		[aCreditCard release];
			
	}
	

	
	// TODO	
	return tarjetasDeCredito;	
}

- (id)getDebugResponse {
    NSMutableArray *disponibles = [[NSMutableArray alloc] init];
    for (int i = 0; i<10; i++) {
        CreditCard *aCard = [[CreditCard alloc]init];
		
		aCard.numero = @"67567567";
		aCard.fechaVencimiento = @"21/10/2013";
		aCard.nombre = @"aaddd";
		
		[disponibles addObject:aCard];
        [aCard release];
    }
    return disponibles;
}

@end
