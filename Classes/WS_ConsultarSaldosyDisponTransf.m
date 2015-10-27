//
//  ConsultarSaldosyDisponTransf_WSRequest.m
//  BanelcoMovil
//
//  Created by German Levy on 9/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WS_ConsultarSaldosyDisponTransf.h"
#import "WSUtil.h"
#import "SaldosTransfMobileDTO.h"
#import "GDataXMLNode.h"


@implementation WS_ConsultarSaldosyDisponTransf

@synthesize userToken, nroCuenta, tipoCuenta, codMoneda;


-(NSString *)getWSName {
	return @"consultarSaldosYDisponiblesTransf";
}

-(NSString *)getSoapParams {
	return [NSArray arrayWithObjects:userToken, nroCuenta, tipoCuenta, codMoneda, nil];
}

// ORIGINAL
//-(NSString *)getSoapMessage {
//	
//	return [NSString stringWithFormat:
//			@"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
//			"<v:Header />\n"
//			"<v:Body>\n"
//			"<n0:%@ id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
//			"<in0 i:type=\"d:string\">%@</in0>\n" // Token
//			"<in1 i:type=\"d:string\">%@</in1>\n" // nro cuenta
//			"<in2 i:type=\"d:int\">%@</in2>\n" // tipo cta
//			"<in3 i:type=\"d:int\">%@</in3>\n" // cod moneda
//			"</n0:%@>\n"
//			"</v:Body>\n"
//			"</v:Envelope>\n", [self getWSName], userToken, nroCuenta, [tipoCuenta stringValue], [codMoneda stringValue], [self getWSName]
//			];
//	
//}

// SERVICIOS 2.0
-(NSString *)getSoapMessage {
	
	return [NSString stringWithFormat:
			@"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
			"<v:Header />\n"
			"<v:Body>\n"
			"<n0:%@ id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
			"<in0 i:type=\"d:string\">%@</in0>\n" // Token
			"<in1 i:type=\"d:string\">%@</in1>\n" // Security Token
			"<in2 i:type=\"d:string\">%@</in2>\n" // nro cuenta
			"<in3 i:type=\"d:int\">%@</in3>\n" // tipo cta
			"<in4 i:type=\"d:int\">%@</in4>\n" // cod moneda
			"</n0:%@>\n"
			"</v:Body>\n"
			"</v:Envelope>\n", [self getWSName], userToken, [WSRequest securityToken], nroCuenta, [tipoCuenta stringValue], [codMoneda stringValue], [self getWSName]
			];
	
}

-(id)parseResponse:(NSData *)data {
	
	GDataXMLElement *rootSoap = [WSUtil getRootElement:@"out" inData:data];
	
	return [SaldosTransfMobileDTO parseSaldosTransfMobileDTO:rootSoap];
	
}

@end
