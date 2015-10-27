//
//  ConsultarUltimoResumenTC.m
//  BanelcoMovil
//
//  Created by German Levy on 9/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WS_ConsultarUltimoResumenTC.h"
#import "WSUtil.h"
#import "CreditCardResumen.h"
#import "CommonFunctions.h"

@implementation WS_ConsultarUltimoResumenTC

@synthesize userToken, codBanco, tipoDoc, nroDoc, nroTarjeta;

-(NSString *)getWSName {
	return @"consultarUltimoResumenTC";
}

// ORIGINAL
//-(NSString *)getSoapMessage {
//	return  [NSString stringWithFormat:
//			 @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
//			 "<v:Header />\n"
//			 "<v:Body>\n"
//			 "<n0:consultarUltimoResumenTC id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
//			 "<in0 i:type=\"d:string\">%@</in0>\n" // User Token
//			 "<in1 i:type=\"d:string\">%@</in1>\n" // Codigo Banco
//			 "<in2 i:type=\"d:string\">%@</in2>\n" // Tipo DOC
//			 "<in3 i:type=\"d:string\">%@</in3>\n" // DNI
//			 "<in4 i:type=\"d:string\">%@</in4>\n" // Nro Tarjeta		 
//			 "</n0:consultarUltimoResumenTC>\n"
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
			 "<n0:consultarUltimoResumenTC id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
			 "<in0 i:type=\"d:string\">%@</in0>\n" // User Token
			 "<in1 i:type=\"d:string\">%@</in1>\n" // Security Token
			 "<in2 i:type=\"d:string\">%@</in2>\n" // Codigo Banco
			 "<in3 i:type=\"d:string\">%@</in3>\n" // Tipo DOC
			 "<in4 i:type=\"d:string\">%@</in4>\n" // DNI
			 "<in5 i:type=\"d:string\">%@</in5>\n" // Nro Tarjeta		 
			 "</n0:consultarUltimoResumenTC>\n"
			 "</v:Body>\n"
			 "</v:Envelope>\n", userToken, [WSRequest securityToken], codBanco, tipoDoc, nroDoc, nroTarjeta
			 ];
}

-(id)parseResponse:(NSData *)data {

	//GDataXMLElement *rootSoap = [WSUtil getRootElement:@"ArrayOfRubroMobileDTO" inData:data];
	
	// TODO
	
	//return nil;
	
	NSError *error = [[NSError alloc]init];
	
	NSString *msj = [CommonFunctions returnXMLMasterTagFromText:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] withTag:@"out"];
	
	NSData *rdata = [NSData dataWithBytes:[msj UTF8String] length:[msj lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
	
	GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:rdata options:0 error:&error];
	GDataXMLElement *movSoap = doc.rootElement;
	
	CreditCardResumen *response = [CreditCardResumen parseResumen:movSoap];
	
	return response;
	
	
}

- (id)getDebugResponse {
    CreditCardResumen *res = [[CreditCardResumen alloc] init];
    
	res.fechaVencimiento = @"21/11/2013";
    
	res.minAPagarDolares = @"34";
    
	res.minAPagarPesos = @"565";
    
	res.nroTarjeta = @"245452324";
    
	res.totalAPagarDolares = @"453";
    
	res.totalAPagarPesos = @"5654";
    
	return res;
}

@end
