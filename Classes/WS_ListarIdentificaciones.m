//
//  ListarIdentificaciones_WSRequest.m
//  BanelcoMovil
//
//  Created by German Levy on 8/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WS_ListarIdentificaciones.h"
#import "WSUtil.h"

@implementation WS_ListarIdentificaciones

@synthesize userToken, codigo;


-(NSString *)getWSName {
	return @"listarIdentificaciones";
}

-(NSMutableArray *)getSoapParams {
	return [NSArray arrayWithObjects:userToken, codigo, nil];
}

// ORIGINAL
//-(NSString *)getSoapMessage {
//	
//	return  [NSString stringWithFormat:
//			 @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
//			 "<v:Header />\n"
//			 "<v:Body>\n"
//			 "<n0:listarIdentificaciones id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
//			 "<in0 i:type=\"d:string\">%@</in0>\n" // Token
//			 "<in1 i:type=\"d:string\">%@</in1>\n" // Rubro
//			 "</n0:listarIdentificaciones>\n"
//			 "</v:Body>\n"
//			 "</v:Envelope>\n", userToken, codigo
//			 ];
//	
//}

// SERVICIOS 2.0
-(NSString *)getSoapMessage {
    NSLog(@"aca esta");
	return  [NSString stringWithFormat:
			 @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
			 "<v:Header />\n"
			 "<v:Body>\n"
			 "<n0:listarIdentificaciones id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
			 "<in0 i:type=\"d:string\">%@</in0>\n" // Token
			 "<in1 i:type=\"d:string\">%@</in1>\n" // Security Token
			 "<in2 i:type=\"d:string\">%@</in2>\n" // Rubro
			 "</n0:listarIdentificaciones>\n"
			 "</v:Body>\n"
			 "</v:Envelope>\n", userToken, [WSRequest securityToken], codigo
			 ];
	
}

-(id)parseResponse:(NSData *)data {
	
	NSMutableArray *IDs = [[NSMutableArray alloc] init];
	
	GDataXMLElement *rootSoap = [WSUtil getRootElement:@"out" inData:data];
	
	NSArray *idsSoap = [rootSoap elementsForName:@"string"];
	
	for (GDataXMLElement *idSoap in idsSoap) {
		[IDs addObject:[idSoap stringValue]];
	}
	
	return IDs;	
}

@end
