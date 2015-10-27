//
//  WS_ConsultarTasa.m
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WS_ConsultarTasa.h"
#import "CommonFunctions.h"

@implementation WS_ConsultarTasa

@synthesize userToken, importe, plazo, numCuentaPlazo, numCuenta, codTipoCta, codMoneda;

-(NSString *)getWSName {
	return @"consultarTasa";
}

-(NSMutableArray *)getSoapParams {
	return [NSArray arrayWithObjects:userToken, importe, plazo, numCuentaPlazo, numCuenta, codTipoCta, codMoneda, nil];
}

// ORIGINAL
//-(NSString *)getSoapMessage {
//	
//	return  [NSString stringWithFormat:
//			 @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
//			 "<v:Header />\n"
//			 "<v:Body>\n"
//			 "<n0:consultarTasa id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
//			 "<in0 i:type=\"d:string\">%@</in0>\n" // Token
//			 "<in1 i:type=\"d:string\">%@</in1>\n" // num cuenta plazo
//			 "<in2 i:type=\"d:string\">%@</in2>\n"        // num cuenta
//			 "<in3 i:type=\"d:int\">%@</in3>\n"        // cod tipo cuenta
//			 "<in4 i:type=\"d:int\">%i</in4>\n"        // cod moneda
//			 "<in5 i:type=\"d:string\">%@</in5>\n"        // importe
//			 "<in6 i:type=\"d:string\">%@</in6>\n"        // plazo
//			 "</n0:consultarTasa>\n"
//			 "</v:Body>\n"
//			 "</v:Envelope>\n", userToken, numCuentaPlazo, numCuenta, codTipoCta, codMoneda, importe, plazo
//			 ];
//
//}

// SERVICIOS 2.0
-(NSString *)getSoapMessage {
	
	return  [NSString stringWithFormat:
			 @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
			 "<v:Header />\n"
			 "<v:Body>\n"
			 "<n0:consultarTasa id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
			 "<in0 i:type=\"d:string\">%@</in0>\n" // Token
			 "<in1 i:type=\"d:string\">%@</in1>\n" // Security Token
			 "<in2 i:type=\"d:string\">%@</in2>\n" // num cuenta plazo
			 "<in3 i:type=\"d:string\">%@</in3>\n"        // num cuenta
			 "<in4 i:type=\"d:int\">%@</in4>\n"        // cod tipo cuenta
			 "<in5 i:type=\"d:int\">%i</in5>\n"        // cod moneda
			 "<in6 i:type=\"d:string\">%@</in6>\n"        // importe
			 "<in7 i:type=\"d:string\">%@</in7>\n"        // plazo
			 "</n0:consultarTasa>\n"
			 "</v:Body>\n"
			 "</v:Envelope>\n", userToken, [WSRequest securityToken], numCuentaPlazo, numCuenta, codTipoCta, codMoneda, importe, plazo
			 ];
	
}

-(id)parseResponse:(NSData *)data {
	
	//NSError *error = [[NSError alloc]init];
	
	NSString *msj = [CommonFunctions returnXMLMasterTagFromText:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] withTag:@"out"];
	
	if (!msj) {
		return nil;
	}
	NSRange rinit = [msj rangeOfString:@"<string>"];
	NSRange rend = [msj rangeOfString:@"</string>"];
	
	if (rinit.location == NSNotFound || rend.location == NSNotFound) {
		return nil;
	}
	return [msj substringWithRange:NSMakeRange(rinit.location + rinit.length, rend.location - (rinit.location + rinit.length))];
}


@end
