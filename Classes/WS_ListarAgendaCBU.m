//
//  WS_ListarAgendaCBU.m
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 9/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WS_ListarAgendaCBU.h"
#import "Cuenta.h"
#import "CommonFunctions.h"

@implementation WS_ListarAgendaCBU

@synthesize userToken;

-(NSString *)getWSName {
	return @"listarAgendaCBU";
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
//			 "<n0:listarAgendaCBU id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
//			 "<in0 i:type=\"d:string\">%@</in0>\n" // Token
//			 "</n0:listarAgendaCBU>\n"
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
			 "<n0:listarAgendaCBU id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
			 "<in0 i:type=\"d:string\">%@</in0>\n" // Token
			 "<in1 i:type=\"d:string\">%@</in1>\n" // Security Token
			 "</n0:listarAgendaCBU>\n"
			 "</v:Body>\n"
			 "</v:Envelope>\n", userToken, [WSRequest securityToken]
			 ];
	
}

-(id)parseResponse:(NSData *)data {
#if WSDEBUG
    return [self getDebugResponse];
#endif
	NSError *error = [[NSError alloc]init];
	
	NSString *msj = [CommonFunctions returnXMLMasterTagFromText:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] withTag:@"out"];
	
	NSData *rdata = [NSData dataWithBytes:[msj UTF8String] length:[msj lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
	
	GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:rdata options:0 error:&error];
	GDataXMLElement *movSoap = doc.rootElement;
	
	return [Cuenta parseCuentasCBU:movSoap];
	
}

- (id)getDebugResponse {
    NSMutableArray *cuentasCBU = [[NSMutableArray alloc] init];
	for (int i = 0; i<10; i++) {
		Cuenta *c = [[Cuenta alloc] init];
        c.accountType = C_CBU;
        c.codigo = @"4435";
        c.cuit = @"213123334556";
        c.nombre = @"Nombre";
        c.propia = @"Si";
        [cuentasCBU addObject:c];
        [c release];
	}
	
	return cuentasCBU;
}

@end
