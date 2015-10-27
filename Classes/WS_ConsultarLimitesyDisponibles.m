//
//  WS_ConsultarLimitesyDisponibles.m
//  BanelcoMovilIphone
//
//  Created by Demian on 9/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WS_ConsultarLimitesyDisponibles.h"
#import "Cuenta.h"
#import "CommonFunctions.h"


@implementation WS_ConsultarLimitesyDisponibles
@synthesize userToken,codigoCuenta;

-(NSString *)getWSName {
	return @"consultarLimitesyDisponibles";
}




-(NSMutableArray *)getSoapParams {
	return [NSArray arrayWithObjects:userToken, codigoCuenta,nil];
}

// ORIGINAL
//-(NSString *)getSoapMessage {
//	
//	return  [NSString stringWithFormat:
//			 @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
//			 "<v:Header />\n"
//			 "<v:Body>\n"
//			 "<n0:consultarLimitesyDisponibles id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
//			 "<in0 i:type=\"d:string\">%@</in0>\n" // User Token
//			 "<in1 i:type=\"d:string\">%@</in1>\n" // Codigo de Cuenta
//			 "</n0:consultarLimitesyDisponibles>\n"
//			 "</v:Body>\n"
//			 "</v:Envelope>\n", userToken,codigoCuenta
//			 ];
//	
//}

// SERVICIOS 2.0
-(NSString *)getSoapMessage {
	
	return  [NSString stringWithFormat:
			 @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
			 "<v:Header />\n"
			 "<v:Body>\n"
			 "<n0:consultarLimitesyDisponibles id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
			 "<in0 i:type=\"d:string\">%@</in0>\n" // User Token
			 "<in1 i:type=\"d:string\">%@</in1>\n" // Security Token
			 "<in2 i:type=\"d:string\">%@</in2>\n" // Codigo de Cuenta
			 "</n0:consultarLimitesyDisponibles>\n"
			 "</v:Body>\n"
			 "</v:Envelope>\n", userToken, [WSRequest securityToken], codigoCuenta
			 ];
	
}

-(id)parseResponse:(NSData *)data {
#if WSDEBUG
    return [Cuenta getDebugCuenta];
#endif
	Cuenta *cuenta = [[Cuenta alloc] init];
	
	
	NSError *error = [[NSError alloc]init];
	
	NSString *msj = [CommonFunctions returnXMLMasterTagFromText:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] withTag:@"out"];
	//NSLog([NSString stringWithFormat:@"Login Response: %@", msj]);	
	NSData *rdata = [NSData dataWithBytes:[msj UTF8String] length:[msj lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
	
	GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:rdata options:0 error:&error];
	GDataXMLElement *dispSoap = doc.rootElement;
	
	
	cuenta = [Cuenta parseCuenta:dispSoap];
	
	return cuenta;
		
	
}



- (void)dealloc {
	[codigoCuenta release];
	[userToken release];
    [super dealloc];
}



@end
