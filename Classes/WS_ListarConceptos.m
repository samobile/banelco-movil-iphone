//
//  WS_ListarConceptos.m
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 9/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WS_ListarConceptos.h"
#import "WSUtil.h"
#import "BaseModel.h"


@implementation WS_ListarConceptos

@synthesize userToken;

-(NSString *)getWSName {
	return @"listarConceptos";
}

-(NSMutableArray *)getSoapParams {
	return [NSArray arrayWithObjects:userToken, nil];
}

// ORIGINAL
//-(NSString *)getSoapMessage {
//	
//	return  [NSString stringWithFormat:
//			 @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
//			 "<v:Header />\n"
//			 "<v:Body>\n"
//			 "<n0:listarConceptos id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
//			 "<in0 i:type=\"d:string\">%@</in0>\n" // Token
//			 "</n0:listarConceptos>\n"
//			 "</v:Body>\n"
//			 "</v:Envelope>\n", userToken
//			 ];
//	
//}

// SERVICIOS 2.0
-(NSString *)getSoapMessage {
	
	return  [NSString stringWithFormat:
			 @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
			 "<v:Header />\n"
			 "<v:Body>\n"
			 "<n0:listarConceptos id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
			 "<in0 i:type=\"d:string\">%@</in0>\n" // Token
			 "<in1 i:type=\"d:string\">%@</in1>\n" // Security Token
			 "</n0:listarConceptos>\n"
			 "</v:Body>\n"
			 "</v:Envelope>\n", userToken, [WSRequest securityToken]
			 ];
	
}


-(id)parseResponse:(NSData *)data {
	
	NSMutableArray *conceptos = [[NSMutableArray alloc] init];
	
	GDataXMLElement *rootSoap = [WSUtil getRootElement:@"out" inData:data];
	
	NSArray *conceptosSoap = [rootSoap elementsForName:@"BaseMobileDTO"];
	
	for (GDataXMLElement *cSoap in conceptosSoap) {
		[conceptos addObject:[BaseModel parse:cSoap]];
	}
	
	return conceptos;
	
}


@end
