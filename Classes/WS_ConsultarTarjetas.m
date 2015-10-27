//
//  ConsultarTarjetas.m
//  BanelcoMovil
//
//  Created by German Levy on 8/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WS_ConsultarTarjetas.h"
#import "Context.h"
#import "Usuario.h"
#import "CommonFunctions.h"
#import "Cuenta.h"
#import "WSUtil.h"
#import "CreditCard.h"

@implementation WS_ConsultarTarjetas

@synthesize userToken;

-(NSString *)getWSName {
	return @"consultarTarjetaCredito";
}

// ORIGINAL
//-(NSString *)getSoapMessage {
//	
//	return  [NSString stringWithFormat:
//			 @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
//			 "<v:Header />\n"
//			 "<v:Body>\n"
//			 "<n0:consultarTarjetaCredito id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
//			 "<in0 i:type=\"d:string\">%@</in0>\n" // User Token
//			 "</n0:consultarTarjetaCredito>\n"
//			 "</v:Body>\n"
//			 "</v:Envelope>\n", userToken
//			 ];
//	
//}

// SERVICIOS 2.0
-(NSString *)getSoapMessage {
	
	return  [NSString stringWithFormat:
			 @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
			 "<v:Header />\n"
			 "<v:Body>\n"
			 "<n0:consultarTarjetaCredito id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
			 "<in0 i:type=\"d:string\">%@</in0>\n" // User Token
			 "<in1 i:type=\"d:string\">%@</in1>\n" // Security Token
			 "</n0:consultarTarjetaCredito>\n"
			 "</v:Body>\n"
			 "</v:Envelope>\n", userToken, [WSRequest securityToken]
			 ];
	
}

-(id)parseResponse:(NSData *)data {
#if WSDEBUG
    return [self getDebugResponse];
#endif
	NSMutableArray *disponibles = [[NSMutableArray alloc] init];
	
	GDataXMLElement *rootSoap = [WSUtil getRootElement:@"out" inData:data];
	
	NSArray *tarjetas = [rootSoap elementsForName:@"TarjetaCreditoMobileDTO"];
	
	for (GDataXMLElement * tarjeta in tarjetas) {
		
		NSLog(@"%@",tarjeta);

	
		NSString *fechaVencimiento = [(GDataXMLElement *)[[tarjeta elementsForName:@"fechaVencimiento"] objectAtIndex:0] stringValue];
		NSString *numero = [(GDataXMLElement *)[[tarjeta elementsForName:@"numero"] objectAtIndex:0] stringValue];

		NSString *saldoPesos = [(GDataXMLElement *)[[tarjeta elementsForName:@"saldoPesos"] objectAtIndex:0] stringValue];
		NSString *saldoDolares = [(GDataXMLElement *)[[tarjeta elementsForName:@"saldoDolares"] objectAtIndex:0] stringValue];
	
		NSString *pagoMinimo = [(GDataXMLElement *)[[tarjeta elementsForName:@"pagoMinimo"] objectAtIndex:0] stringValue];

		NSString *codigo = [(GDataXMLElement *)[[tarjeta elementsForName:@"codigo"] objectAtIndex:0] stringValue];
        
        //NSString *vencimiento = [(GDataXMLElement *)[[tarjeta elementsForName:@"vencimiento"] objectAtIndex:0] stringValue];
        NSString *fechaCierreActual = [(GDataXMLElement *)[[tarjeta elementsForName:@"fechaCierreActual"] objectAtIndex:0] stringValue];
        NSString *fechaProximoCierre = [(GDataXMLElement *)[[tarjeta elementsForName:@"fechaProximoCierre"] objectAtIndex:0] stringValue];
        NSString *fechaProxVto = [(GDataXMLElement *)[[tarjeta elementsForName:@"fechaProxVto"] objectAtIndex:0] stringValue];
		
		CreditCard *aCard = [[CreditCard alloc]init];
		
		aCard.numero = numero;
		//aCard.fechaVencimiento = fechaVencimiento;
		aCard.saldoPesos = saldoPesos;
		aCard.saldoDolares = saldoDolares;		
		aCard.pagoMinimo = pagoMinimo;
		aCard.codigo = codigo;
        aCard.fechaVencimiento = [NSString stringWithString:[WSUtil formatDateFromWS:fechaVencimiento]];
        aCard.fechaProxVenc= [NSString stringWithString:[WSUtil formatDateFromWS:fechaProxVto]];
        aCard.fechaProxCierre= [NSString stringWithString:[WSUtil formatDateFromWS:fechaProximoCierre]];
        aCard.fechaCierreActual = [NSString stringWithString:[WSUtil formatDateFromWS:fechaCierreActual]];
		
		[disponibles addObject:aCard];
		
//		[fechaVencimiento release];
//		[numero release];
//		[saldoPesos release];
//		[saldoDolares release];
//		[pagoMinimo release];		
//		[codigo release];
//		[aCard release];
		
	}
	
	return disponibles;	
}

- (id)getDebugResponse {
    NSMutableArray *disponibles = [[NSMutableArray alloc] init];
    for (int i = 0; i<10; i++) {
        CreditCard *aCard = [[CreditCard alloc]init];
		
		aCard.numero = @"34242313123";
		aCard.fechaVencimiento = @"21/10/2013";
		aCard.saldoPesos = @"13123";
		aCard.saldoDolares = @"324";
		aCard.pagoMinimo = @"234";
		aCard.codigo = @"2367";
        aCard.fechaCierreActual = @"**/**/****";
        aCard.fechaProxCierre = @"**/**/****";
        aCard.fechaProxVenc = @"**/**/****";
		
		[disponibles addObject:aCard];
        [aCard release];
    }
    return disponibles;
}



@end
