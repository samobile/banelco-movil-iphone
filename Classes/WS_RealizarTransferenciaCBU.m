//
//  WS_RealizarTransferenciaCBU.m
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 9/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WS_RealizarTransferenciaCBU.h"
#import "Transfer.h"
#import "CommonFunctions.h"
#import "Ticket.h"

@implementation WS_RealizarTransferenciaCBU

@synthesize userToken, transfer;

-(NSString *)getWSName {
	return @"realizarTransferenciaCBU";
}

-(NSMutableArray *)getSoapParams {
	return [NSArray arrayWithObjects:userToken, transfer, nil];
}

// ORIGINAL
//-(NSString *)getSoapMessage {
//	
//	return  [NSString stringWithFormat:
//			 @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
//			 "<v:Header />\n"
//			 "<v:Body>\n"
//			 "<n0:realizarTransferenciaCBU id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
//			 "<in0 i:type=\"d:string\">%@</in0>\n" // Token
//			 "<in1 i:type=\":\">%@</in1>\n"
//			 "</n0:realizarTransferenciaCBU>\n"
//			 "</v:Body>\n"
//			 "</v:Envelope>\n", userToken, [transfer toSoapObjectCBU]
//			 ];
//	
//}

// SERVICIOS 2.0
-(NSString *)getSoapMessage {
	
	return  [NSString stringWithFormat:
			 @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
			 "<v:Header />\n"
			 "<v:Body>\n"
			 "<n0:realizarTransferenciaCBUWithTarjeta id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
			 "<in0 i:type=\"d:string\">%@</in0>\n" // Token
			 "<in1 i:type=\"d:string\">%@</in1>\n" // Security Token
			 "<in2 i:type=\":\">%@</in2>\n"
			 "</n0:realizarTransferenciaCBUWithTarjeta>\n"
			 "</v:Body>\n"
			 "</v:Envelope>\n", userToken, [WSRequest securityToken], [transfer toSoapObjectCBU]
			 ];
	
}

-(id)parseResponse:(NSData *)data {
	
	NSError *error = [[NSError alloc]init];
	
	NSString *msj = [CommonFunctions returnXMLMasterTagFromText:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] withTag:@"out"];
	
	NSData *rdata = [NSData dataWithBytes:[msj UTF8String] length:[msj lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
	
	GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:rdata options:0 error:&error];
	GDataXMLElement *movSoap = doc.rootElement;
	
	//La respuesta de realizarTransferenciaPropia es un Ticket
	Ticket *response = [[Ticket alloc] init];
	response.fechaPago = [[[movSoap elementsForName:@"fechaPago"] objectAtIndex:0] stringValue];
	response.empresa = [[[movSoap elementsForName:@"empresa"] objectAtIndex:0] stringValue];
	response.nroTransaccion = [[[movSoap elementsForName:@"nroTransaccion"] objectAtIndex:0] stringValue];
	response.clienteId = [[[movSoap elementsForName:@"clientId"] objectAtIndex:0] stringValue];
	response.cuenta = [[[movSoap elementsForName:@"cuenta"] objectAtIndex:0] stringValue];
	response.fiid = [[[movSoap elementsForName:@"fiid"] objectAtIndex:0] stringValue];
	response.importe = [[[movSoap elementsForName:@"importe"] objectAtIndex:0] stringValue];
	response.moneda = [[[movSoap elementsForName:@"moneda"] objectAtIndex:0] stringValue];
	response.nroControl = [[[movSoap elementsForName:@"nroControl"] objectAtIndex:0] stringValue];
	response.canal = [[[movSoap elementsForName:@"canal"] objectAtIndex:0] stringValue];
	
	return response;
	
}


@end
