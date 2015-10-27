//
//  WS_ConsultarCBUCuenta.m
//  BanelcoMovilIphone
//
//  Created by Demian on 9/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WS_ConsultarCBUCuenta.h"
#import "CommonFunctions.h"
@implementation WS_ConsultarCBUCuenta

@synthesize userToken,numeroCuenta,tipoCuenta,codigoMoneda;


-(NSString *)getWSName {
	return @"consultarCBUCuenta";
}




-(NSMutableArray *)getSoapParams {
	return [NSArray arrayWithObjects:userToken, numeroCuenta,tipoCuenta,codigoMoneda,nil];
}

// ORIGINAL
//-(NSString *)getSoapMessage {
//	
//	NSLog(@"getSoapMessage ??? ");
//	NSLog(@"User token = %@ , Numero Cuenta = %@  , Tipo Cuenta = %d , Codigo Moneda = %d", userToken,numeroCuenta,tipoCuenta,codigoMoneda);
//	return  [NSString stringWithFormat:
//			 @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
//			 "<v:Header />\n"
//			 "<v:Body>\n"
//			 "<n0:consultarCBUCuenta id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
//			 "<in0 i:type=\"d:string\">%@</in0>\n" // User Token
//			 "<in1 i:type=\"d:string\">%@</in1>\n" // Numero de cuenta
//			 "<in2 i:type=\"d:int\">%d</in2>\n" // tipo de cuenta
//			 "<in3 i:type=\"d:int\">%d</in3>\n" //codigo moneda
//			 "</n0:consultarCBUCuenta>\n"
//			 "</v:Body>\n"
//			 "</v:Envelope>\n", userToken,numeroCuenta,tipoCuenta,codigoMoneda
//			 ];
//	
//}

// SERVICIOS 2.0
-(NSString *)getSoapMessage {
	
	return  [NSString stringWithFormat:
			 @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
			 "<v:Header />\n"
			 "<v:Body>\n"
			 "<n0:consultarCBUCuenta id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
			 "<in0 i:type=\"d:string\">%@</in0>\n" // User Token
			 "<in1 i:type=\"d:string\">%@</in1>\n" // Security Token
			 "<in2 i:type=\"d:string\">%@</in2>\n" // Numero de cuenta
			 "<in3 i:type=\"d:int\">%d</in3>\n" // tipo de cuenta
			 "<in4 i:type=\"d:int\">%d</in4>\n" //codigo moneda
			 "</n0:consultarCBUCuenta>\n"
			 "</v:Body>\n"
			 "</v:Envelope>\n", userToken,[WSRequest securityToken],numeroCuenta,tipoCuenta,codigoMoneda
			 ];
	
}


-(id)parseResponse:(NSData *)data {
#if WSDEBUG
    return @"342342342";
#endif
	NSError *error = [[NSError alloc]init];
	NSString *msj = [CommonFunctions returnXMLMasterTagFromText:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] withTag:@"out"];
	NSData *rdata = [NSData dataWithBytes:[msj UTF8String] length:[msj lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
	GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:rdata options:0 error:&error];
	GDataXMLElement *cbuSoap = doc.rootElement;
	NSString* cbu = [[[cbuSoap elementsForName:@"string"] objectAtIndex:0] stringValue];
	return cbu;	
	
}



- (void)dealloc {
	[numeroCuenta release];
	[userToken release];
    [super dealloc];
}


@end
