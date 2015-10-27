//
//  WS_CambiarPin.m
//  BanelcoMovilIphone
//
//  Created by German Levy on 9/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WS_CambiarPin.h"
#import "CommonFunctions.h"
#import "Context.h"

@implementation WS_CambiarPin

@synthesize userToken, actualPW, newPW;

-(NSString *)getWSName {
	return @"cambiarPin";
}

/*-(NSString *)paramsToXml {
	return [super paramsToXml];
}

-(NSString *)getSoapMessage:(NSMutableArray *)params {
	return [super getSoapMessage:params];	
}*/

-(NSMutableArray *)getSoapParams {
	return [NSArray arrayWithObjects:userToken, actualPW, newPW, nil];
}

// ORIGINAL
//-(NSString *)getSoapMessage {
// 
//	 return  [NSString stringWithFormat:
//	 @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
//	 "<v:Header />\n"
//	 "<v:Body>\n"
//	 "<n0:cambiarPin id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
//	 "<in0 i:type=\"d:string\">%@</in0>\n" // Token
//	 "<in1 i:type=\"d:string\">%@</in1>\n" // PW actual
//	 "<in2 i:type=\"d:string\">%@</in2>\n" // PW nuevo
//	 "</n0:cambiarPin>\n"
//	 "</v:Body>\n"
//	 "</v:Envelope>\n", userToken, actualPW, newPW
//	 ];
// 
// }

// SERVICIOS 2.0
-(NSString *)getSoapMessage {
    
	return  [NSString stringWithFormat:
			 @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
			 "<v:Header />\n"
			 "<v:Body>\n"
			 "<n0:cambiarPin id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
			 "<in0 i:type=\"d:string\">%@</in0>\n" // Token
			 "<in1 i:type=\"d:string\">%@</in1>\n" // Security Token
			 "<in2 i:type=\"d:string\">%@</in2>\n" // PW actual
			 "<in3 i:type=\"d:string\">%@</in3>\n" // PW nuevo
			 "</n0:cambiarPin>\n"
			 "</v:Body>\n"
             "</v:Envelope>\n", userToken, [WSRequest securityToken], actualPW, newPW
			 ];
	
}


-(id)parseResponse:(NSData *)data {
	
#if (WSDEBUG == FALSE)
    
	//GDataXMLElement *rootSoap = [WSUtil getRootElement:@"ArrayOfRubroMobileDTO" inData:data];
	NSError *error = [[NSError alloc]init];
	
	NSString *msj = [CommonFunctions returnXMLMasterTagFromText:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] withTag:@"out"];
	NSLog([NSString stringWithFormat:@"CambioPin Response: %@", msj]);	
	
#endif
	// Este servicio no envia respuesta.
	
	return nil;
	
}

- (void)dealloc {
	
	[userToken release];
	[actualPW release];
	[newPW release];
    [super dealloc];
}


@end
