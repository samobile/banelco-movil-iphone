//
//  WS_ConsultaTitularidad.m
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 2/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WS_ConsultaTitularidad.h"
#import "TitularidadMobileDTO.h"
#import "CommonFunctions.h"

@implementation WS_ConsultaTitularidad

@synthesize userToken, cbu, cuentaOrigen;

-(NSString *)getWSName {
	return @"consultaTitularidadCuenta";
}

-(NSMutableArray *)getSoapParams {
	return [NSArray arrayWithObjects:userToken, cbu, cuentaOrigen, nil];
}

// ORIGINAL
//-(NSString *)getSoapMessage {
//	
//	return  [NSString stringWithFormat:
//			 @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
//			 "<v:Header />\n"
//			 "<v:Body>\n"
//			 "<n0:consultarTitularidadCuenta id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
//			 "<in0 i:type=\"d:string\">%@</in0>\n" // Token
//			 "<in1 i:type=\"d:string\">%@</in1>\n" // cbu
//			 "<in2 i:type=\":\">%@</in2>\n"        // cuenta origen
//			 "</n0:consultarTitularidadCuenta>\n"
//			 "</v:Body>\n"
//			 "</v:Envelope>\n", userToken, cbu, [cuentaOrigen toSoapObject]
//			 ];
//	
//}

// SERVICIOS 2.0
-(NSString *)getSoapMessage {
	
	return  [NSString stringWithFormat:
			 @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
			 "<v:Header />\n"
			 "<v:Body>\n"
			 "<n0:consultarTitularidadCuenta id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
			 "<in0 i:type=\"d:string\">%@</in0>\n" // Token
			 "<in1 i:type=\"d:string\">%@</in1>\n" // Security Token
			 "<in2 i:type=\"d:string\">%@</in2>\n" // cbu
			 "<in3 i:type=\":\">%@</in3>\n"        // cuenta origen
			 "</n0:consultarTitularidadCuenta>\n"
			 "</v:Body>\n"
			 "</v:Envelope>\n", userToken, [WSRequest securityToken], cbu, [cuentaOrigen toSoapObject]
			 ];
	
}

-(id)parseResponse:(NSData *)data {
	
	NSError *error = [[NSError alloc]init];
	
	NSString *msj = [CommonFunctions returnXMLMasterTagFromText:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] withTag:@"out"];
	
	NSData *rdata = [NSData dataWithBytes:[msj UTF8String] length:[msj lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
	
	GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:rdata options:0 error:&error];
	GDataXMLElement *movSoap = doc.rootElement;

	TitularidadMobileDTO *tresponse = [[TitularidadMobileDTO alloc] init];
	//completar con lo devuelto por el ws
	
	tresponse.nombreTitular = [[[movSoap elementsForName:@"nombreTitular"] objectAtIndex:0] stringValue];
	tresponse.nombreBanco = [[[movSoap elementsForName:@"nombreBanco"] objectAtIndex:0] stringValue];
	tresponse.fiidBanco = [[[movSoap elementsForName:@"fiidBanco"] objectAtIndex:0] stringValue];
	
	tresponse.cuentaDestino = [Cuenta parseCuenta:[[movSoap elementsForName:@"ctaDestino"] objectAtIndex:0]];

	GDataXMLElement *cuitsSoap = [[movSoap elementsForName:@"cuits"] objectAtIndex:0];
	NSArray *cuits = [cuitsSoap elementsForName:@"string"];
	tresponse.cuits = [[NSMutableArray alloc] init];
	for (GDataXMLElement *cSoap in cuits) {
		[tresponse.cuits addObject:[cSoap stringValue]];
	}
	
	return tresponse;
}


@end
