//
//  WS_RealizarPago.m
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 9/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WS_RealizarPago.h"
#import "CommonFunctions.h"
#import "Ticket.h"


@implementation WS_RealizarPago

@synthesize userToken, deuda, codCuenta;

-(NSString *)getWSName {
	return @"realizarPago";
}

-(NSMutableArray *)getSoapParams {
	return [NSArray arrayWithObjects:userToken, deuda, codCuenta, nil];
}

// ORIGINAL
//-(NSString *)getSoapMessage {
//	
//	//Revisar si esta bien armado el XML
//	return  [NSString stringWithFormat:
//			 @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
//			 "<v:Header />\n"
//			 "<v:Body>\n"
//			 "<n0:realizarPago id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
//			 "<in0 i:type=\"d:string\">%@</in0>\n" // Token
//			 "<in1 i:type=\":\">%@</in1>\n" // Deuda
//			 "<in2 i:type=\"d:string\">%@</in2>\n" // Cod Cuenta
//			 "</n0:realizarPago>\n"
//			 "</v:Body>\n"
//			 "</v:Envelope>\n", userToken, [deuda toSoapObject], codCuenta
//			 ];
//	
//}

// SERVICIOS 2.0
-(NSString *)getSoapMessage {
	
	return  [NSString stringWithFormat:
			 @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
			 "<v:Header />\n"
			 "<v:Body>\n"
			 "<n0:realizarPago id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
			 "<in0 i:type=\"d:string\">%@</in0>\n" // Token
			 "<in1 i:type=\"d:string\">%@</in1>\n" // Security Token
			 "<in2 i:type=\":\">%@</in2>\n" // Deuda
			 "<in3 i:type=\"d:string\">%@</in3>\n" // Cod Cuenta
			 "</n0:realizarPago>\n"
			 "</v:Body>\n"
			 "</v:Envelope>\n", userToken, [WSRequest securityToken], [deuda toSoapObject], codCuenta
			 ];
	
}

-(id)parseResponse:(NSData *)data {

#if WSDEBUG
    return [self returnDebugResponse];
#else
    
	NSError *error = [[NSError alloc]init];
	
	NSString *msj = [CommonFunctions returnXMLMasterTagFromText:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] withTag:@"out"];
	
	NSData *rdata = [NSData dataWithBytes:[msj UTF8String] length:[msj lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
	
	GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:rdata options:0 error:&error];
	GDataXMLElement *movSoap = doc.rootElement;
	
	//La respuesta de realizarPago es un Ticket
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
#endif
}

- (id)returnDebugResponse {
    Ticket *response = [[Ticket alloc] init];
	response.fechaPago = @"22/12/2013";
	response.empresa = @"Banelco";
	response.nroTransaccion = @"2313";
	response.clienteId = @"100";
	response.cuenta = @"0001230002319393";
	response.fiid = @"231";
	response.importe = @"350";
	response.moneda = @"1";
	response.nroControl = @"123";
	response.canal = @"1";
	return response;
}

@end
