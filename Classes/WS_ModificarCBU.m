//
//  WS_ModificarCBU.m
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 30/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WS_ModificarCBU.h"


@implementation WS_ModificarCBU

@synthesize userToken, cuentaCBU;

-(NSString *)getWSName {
	return @"modificarCBU";
}

-(NSMutableArray *)getSoapParams {
	return [NSArray arrayWithObjects:userToken, cuentaCBU, nil];
}

// ORIGINAL
//-(NSString *)getSoapMessage {
//	
//	return  [NSString stringWithFormat:
//			 @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
//			 "<v:Header />\n"
//			 "<v:Body>\n"
//			 "<n0:modificarCBU id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
//			 "<in0 i:type=\"d:string\">%@</in0>\n" // Token
//			 "<in1 i:type=\":\">%@</in1>\n" //Cuenta
//			 "</n0:modificarCBU>\n"
//			 "</v:Body>\n"
//			 "</v:Envelope>\n", userToken, [cuentaCBU toSoapObject]
//			 ];
//	
//}

// SERVICIOS 2.0
-(NSString *)getSoapMessage {
	
	return  [NSString stringWithFormat:
			 @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
			 "<v:Header />\n"
			 "<v:Body>\n"
			 "<n0:modificarCBU id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
			 "<in0 i:type=\"d:string\">%@</in0>\n" // Token
			 "<in1 i:type=\"d:string\">%@</in1>\n" // Security Token
			 "<in2 i:type=\":\">%@</in2>\n" //Cuenta
			 "</n0:modificarCBU>\n"
			 "</v:Body>\n"
			 "</v:Envelope>\n", userToken, [WSRequest securityToken], [cuentaCBU toSoapObject]
			 ];
	
}

-(id)parseResponse:(NSData *)data {
	
	return nil;
	
}


@end
