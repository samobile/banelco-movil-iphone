//
//  ListarSubRubros_WSRequest.m
//  BanelcoMovil
//
//  Created by German Levy on 8/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WS_ListarSubRubros.h"
#import "GDataXMLNode.h"
#import "WSUtil.h"
#import "Rubro.h"


@implementation WS_ListarSubRubros

@synthesize userToken, rubro;

-(NSString *)getWSName {
	return @"listarSubRubros";
}

-(NSMutableArray *)getSoapParams {
	return [NSArray arrayWithObjects:userToken, rubro, nil];
}

// ORIGINAL
//-(NSString *)getSoapMessage {
//	
//	return  [NSString stringWithFormat:
//			 @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
//			 "<v:Header />\n"
//			 "<v:Body>\n"
//			 "<n0:listarSubRubros id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
//			 "<in0 i:type=\"d:string\">%@</in0>\n" // Token
//			 "<in1 i:type=\"d:string\">%@</in1>\n" // Rubro
//			 "</n0:listarSubRubros>\n"
//			 "</v:Body>\n"
//			 "</v:Envelope>\n", userToken, rubro
//			 ];
//	
//}

// SERVICIOS 2.0
-(NSString *)getSoapMessage {
	
	return  [NSString stringWithFormat:
			 @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
			 "<v:Header />\n"
			 "<v:Body>\n"
			 "<n0:listarSubRubros id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
			 "<in0 i:type=\"d:string\">%@</in0>\n" // Token
			 "<in1 i:type=\"d:string\">%@</in1>\n" // Security Token
			 "<in2 i:type=\"d:string\">%@</in2>\n" // Rubro
			 "</n0:listarSubRubros>\n"
			 "</v:Body>\n"
			 "</v:Envelope>\n", userToken, [WSRequest securityToken], rubro
			 ];
	
}

-(id)parseResponse:(NSData *)data {
	
	GDataXMLElement *rootSoap = [WSUtil getRootElement:@"out" inData:data];
	
	return [Rubro parseRubros:rootSoap];
	
}

@end
