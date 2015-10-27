//
//  WS_ListarCuentasPlazo.m
//  BanelcoMovilIphone
//
//  Created by German Levy on 9/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WS_ListarCuentasPlazo.h"
#import "Cuenta.h"
#import "CommonFunctions.h"

@implementation WS_ListarCuentasPlazo

@synthesize userToken;

-(NSString *)getWSName {
	return @"listarCuentasPlazo";
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
//			 "<n0:listarCuentasPlazo id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
//			 "<in0 i:type=\"d:string\">%@</in0>\n" // Token
//			 "</n0:listarCuentasPlazo>\n"
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
			 "<n0:listarCuentasPlazo id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
			 "<in0 i:type=\"d:string\">%@</in0>\n" // Token
			 "<in1 i:type=\"d:string\">%@</in1>\n" // Security Token
			 "</n0:listarCuentasPlazo>\n"
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
	
	return [Cuenta parseCuentasPlazo:movSoap];
	
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
        c.codigoMoneda = 1;
        c.organizacion = @"Reeree";
        c.titular = @"Pepito";
        c.numero = @"342342344234";
        c.simboloMoneda = @"$";
        [cuentasCBU addObject:c];
        [c release];
	}
	
	return cuentasCBU;
}

@end