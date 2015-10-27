//
//  SelectGuestWSRequest.m
//  MING_iPad
//
//  Created by German Levy on 7/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WS_Login.h"
#import "CommonFunctions.h"
#import "Usuario.h"
#import "Context.h"
#import "Cuenta.h"
#import "LoginResponse.h"


@implementation WS_Login

@synthesize tipoDoc, nroDoc, codBanco, clave, codApp, appOrigen, userToken, datosApp;


-(NSString *)getWSName {
	return @"loginWithAppCode";
}

-(NSMutableArray *)getSoapParams {
	return [NSArray arrayWithObjects:tipoDoc, nroDoc, codBanco, clave, codApp, appOrigen, userToken, nil];
}

-(NSString *)getSoapMessage {
	
	return  [NSString stringWithFormat:
			 @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
			 "<v:Header />\n"
			 "<v:Body>\n"
			 "<n0:loginWithAppCode id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
			 "<in0 i:type=\"d:string\">%@</in0>\n" // Tipo documento
			 "<in1 i:type=\"d:string\">%@</in1>\n" // Nro documento
			 "<in2 i:type=\"d:string\">%@</in2>\n" // Cod banco
			 "<in3 i:type=\"d:string\">%@</in3>\n" // Clave
			 "<in4 i:type=\"d:string\">%@</in4>\n" // Cod app
			 "<in5 i:type=\"d:string\">%@</in5>\n" // App origen
			 "<in6 i:type=\"d:string\">%@</in6>\n" // Token
			 "</n0:loginWithAppCode>\n"
			 "</v:Body>\n"
			 "</v:Envelope>\n", tipoDoc, nroDoc, codBanco, clave, codApp, appOrigen, userToken
			 ];
	
}

-(id)parseResponse:(NSData *)data {
	
	LoginResponse *response = [[LoginResponse alloc] init];
	Usuario *u = [[Usuario alloc] init];
	
	NSError *error = [[NSError alloc]init];
	
	NSString *msj = [CommonFunctions returnXMLMasterTagFromText:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] withTag:@"out"];
	//NSLog([NSString stringWithFormat:@"Login Response: %@", msj]);	
	NSData *rdata = [NSData dataWithBytes:[msj UTF8String] length:[msj lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
	
	GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:rdata options:0 error:&error];
	GDataXMLElement *loginSoap = doc.rootElement;
	
	u.celular = [[[loginSoap elementsForName:@"celular"] objectAtIndex:0] stringValue];
	response.cuentas = [Cuenta parseCuentas:[[loginSoap elementsForName:@"cuentas"] objectAtIndex:0]];
	
	
	for (int i=0;i<[response.cuentas count];i++){
		
		Cuenta* c = (Cuenta*)[[response cuentas] objectAtIndex:i];
		c.saldo =@""; 
	}
	
	u.email = [[[loginSoap elementsForName:@"email"] objectAtIndex:0] stringValue];
	u.firstLogin = [[[[loginSoap elementsForName:@"firstLogin"] objectAtIndex:0] stringValue] isEqualToString:@"true"]? TRUE : FALSE;
	u.fullname = [[[loginSoap elementsForName:@"fullname"] objectAtIndex:0] stringValue];
	u.marcaInfo = [[[[loginSoap elementsForName:@"marcaNovedades"] objectAtIndex:0] stringValue] isEqualToString:@"true"]? TRUE : FALSE;
	u.marcaVencim = [[[[loginSoap elementsForName:@"marcaVencimientos"] objectAtIndex:0] stringValue] isEqualToString:@"true"]? TRUE : FALSE;
	u.needsPinChange = [[[[loginSoap elementsForName:@"needsPinChange"] objectAtIndex:0] stringValue] isEqualToString:@"true"]? TRUE : FALSE;
	u.operadorCelular = [[[loginSoap elementsForName:@"operadorCelular"] objectAtIndex:0] stringValue];
	u.showInfo = [[[[loginSoap elementsForName:@"showNovedades"] objectAtIndex:0] stringValue] isEqualToString:@"true"]? TRUE : FALSE;
	u.showVencim = [[[[loginSoap elementsForName:@"showVencimientos"] objectAtIndex:0] stringValue] isEqualToString:@"true"]? TRUE : FALSE;
	u.token = [[[loginSoap elementsForName:@"token"] objectAtIndex:0] stringValue];
	response.tokenSeguridad = [[[loginSoap elementsForName:@"tokenSeguridad"] objectAtIndex:0] stringValue];
	u.userName = [[[loginSoap elementsForName:@"userName"] objectAtIndex:0] stringValue];
	u.viewTerminos = [[[[loginSoap elementsForName:@"viewTerminos"] objectAtIndex:0] stringValue] isEqualToString:@"true"]? TRUE : FALSE;
 
  
	
	[doc release];
	
	return response;
	
}

@end
