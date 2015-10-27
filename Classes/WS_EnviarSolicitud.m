//
//  EnviarSolicitud_WSRequest.m
//  BanelcoMovil
//
//  Created by German Levy on 8/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WS_EnviarSolicitud.h"
#import "CommonFunctions.h"

@implementation WS_EnviarSolicitud

@synthesize userToken, codBanco, body, email;

-(NSString *)getWSName {
	return @"enviarSolicitud";
}

-(NSMutableArray *)getSoapParams {
	return [NSArray arrayWithObjects:userToken, codBanco, body, email, nil];
}

// ORIGINAL
//-(NSString *)getSoapMessage {
//	
//	return  [NSString stringWithFormat:
//			 @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
//			 "<v:Header />\n"
//			 "<v:Body>\n"
//			 "<n0:enviarSolicitud id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
//			 "<in0 i:type=\"d:string\">%@</in0>\n" // Token
//			 "<in1 i:type=\"d:string\">%@</in1>\n" // codBanco
//			 "<in2 i:type=\"d:string\">%@</in2>\n" // body
//			 "<in3 i:type=\"d:string\">%@</in3>\n" // email
//			 "</n0:enviarSolicitud>\n"
//			 "</v:Body>\n"
//			 "</v:Envelope>\n", userToken, codBanco, body, email
//			 ];
//	
//}

// SERVICIOS 2.0
-(NSString *)getSoapMessage {
	
	return  [NSString stringWithFormat:
			 @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
			 "<v:Header />\n"
			 "<v:Body>\n"
			 "<n0:enviarSolicitud id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
			 "<in0 i:type=\"d:string\">%@</in0>\n" // Token
			 "<in1 i:type=\"d:string\">%@</in1>\n" // Security Token
			 "<in2 i:type=\"d:string\">%@</in2>\n" // codBanco
			 "<in3 i:type=\"d:string\">%@</in3>\n" // body
			 "<in4 i:type=\"d:string\">%@</in4>\n" // email
			 "</n0:enviarSolicitud>\n"
			 "</v:Body>\n"
			 "</v:Envelope>\n", userToken, [WSRequest securityToken], codBanco, body, email
			 ];
	
}

-(id)parseResponse:(NSData *)data {
	
//	NSError *error = [[NSError alloc]init];
//	
//	NSString *msj = [CommonFunctions returnXMLMasterTagFromText:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] withTag:@"out"];
//	
//	NSData *rdata = [NSData dataWithBytes:[msj UTF8String] length:[msj lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
//	
//	GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:rdata options:0 error:&error];
//	GDataXMLElement *movSoap = doc.rootElement;
	
	return nil;
	
}

@end
