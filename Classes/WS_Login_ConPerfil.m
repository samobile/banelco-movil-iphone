//
//  WS_Login_ConPerfil.m
//  BanelcoMovilIphone
//
//  Created by German Levy on 6/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "WS_Login_ConPerfil.h"
#import "CommonFunctions.h"
#import "CommonFuncBanelco.h"
#import "Usuario.h"
#import "Context.h"
#import "Cuenta.h"
#import "LoginResponse.h"


@implementation WS_Login_ConPerfil


-(NSString *)getWSName {
	//return @"loginWithPerfil";
    return @"loginWithTypeDocNumberAndAditionalData";
    //return @"loginVerifPassword";
}

-(NSString *)getSoapMessage {
	
//	return  [NSString stringWithFormat:
//			 @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
//			 "<v:Header />\n"
//			 "<v:Body>\n"
//			 "<n0:loginWithPerfilAndLastAccessDate id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
//			 "<in0 i:type=\"d:string\">%@</in0>\n" // Tipo documento
//			 "<in1 i:type=\"d:string\">%@</in1>\n" // Nro documento
//			 "<in2 i:type=\"d:string\">%@</in2>\n" // Cod banco
//			 "<in3 i:type=\"d:string\">%@</in3>\n" // Clave
//			 "<in4 i:type=\"d:string\">%@</in4>\n" // Cod app
//			 "<in5 i:type=\"d:string\">%@</in5>\n" // App origen
//			 "<in6 i:type=\"d:string\">%@</in6>\n" // Token
//			 "</n0:loginWithPerfilAndLastAccessDate>\n"
//			 "</v:Body>\n"
//			 "</v:Envelope>\n", tipoDoc, nroDoc, codBanco, clave, codApp, appOrigen, userToken
//			 ];
    
    return  [NSString stringWithFormat:
			 @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
			 "<v:Header />\n"
			 "<v:Body>\n"
//			 "<n0:loginVerifPassword id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
             "<n0:loginWithTypeDocNumberAndAditionalData id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
			 "<in0 i:type=\"d:string\">%@</in0>\n" // Tipo documento
			 "<in1 i:type=\"d:string\">%@</in1>\n" // Nro documento
			 "<in2 i:type=\"d:string\">%@</in2>\n" // Cod banco
			 "<in3 i:type=\"d:string\">%@</in3>\n" // Clave
			 "<in4 i:type=\"d:string\">%@</in4>\n" // Cod app
			 "<in5 i:type=\"d:string\">%@</in5>\n" // App origen
			 "<in6 i:type=\"d:string\">%@</in6>\n" // Token
             "<in7 i:type=\"d:string\">%@</in7>\n" // Datos App
//             "</n0:loginVerifPassword>\n"
             "</n0:loginWithTypeDocNumberAndAditionalData>\n"
			 "</v:Body>\n"
			 "</v:Envelope>\n", tipoDoc, nroDoc, codBanco, clave, codApp, appOrigen, userToken,datosApp
			 ];
}

-(id)parseResponse:(NSData *)data {
#if WSDEBUG
    return [self getDebugResponse];
#endif
	LoginResponse *response = [[LoginResponse alloc] init];
	Usuario *u = [[Usuario alloc] init];
	
	NSError *error = [[NSError alloc]init];
	
	NSString *msj = [CommonFunctions returnXMLMasterTagFromText:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] withTag:@"out"];
    
    if (!msj) {
        return nil;
    }
    
	//NSLog([NSString stringWithFormat:@"Login Response: %@", msj]);	
	NSData *rdata = [NSData dataWithBytes:[msj UTF8String] length:[msj lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
	
	GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:rdata options:0 error:&error];
	GDataXMLElement *loginSoap = doc.rootElement;
    
    if (!loginSoap) {
        return nil;
    }
	
	u.celular = [[[loginSoap elementsForName:@"celular"] objectAtIndex:0] stringValue];
    
	response.cuentas = [Cuenta parseCuentas:[[loginSoap elementsForName:@"cuentas"] objectAtIndex:0]];
	
    
	
	for (int i=0;i<[response.cuentas count];i++){
		
		Cuenta* c = (Cuenta*)[[response cuentas] objectAtIndex:i];
		c.saldo = @""; 
	}
	
	u.email = [[[loginSoap elementsForName:@"email"] objectAtIndex:0] stringValue];
	u.firstLogin = [[[[loginSoap elementsForName:@"firstLogin"] objectAtIndex:0] stringValue] isEqualToString:@"true"]? TRUE : FALSE;
	u.fullname = [[[loginSoap elementsForName:@"fullname"] objectAtIndex:0] stringValue];
	u.marcaInfo = [[[[loginSoap elementsForName:@"marcaNovedades"] objectAtIndex:0] stringValue] isEqualToString:@"true"]? TRUE : FALSE;
	u.marcaVencim = [[[[loginSoap elementsForName:@"marcaVencimientos"] objectAtIndex:0] stringValue] isEqualToString:@"true"]? TRUE : FALSE;
	u.needsPinChange = [[[[loginSoap elementsForName:@"needsPinChange"] objectAtIndex:0] stringValue] isEqualToString:@"true"]? TRUE : FALSE;
	u.operadorCelular = [[[loginSoap elementsForName:@"operadorCelular"] objectAtIndex:0] stringValue];
	u.profile = [[[loginSoap elementsForName:@"perfil"] objectAtIndex:0] stringValue];
	u.showInfo = [[[[loginSoap elementsForName:@"showNovedades"] objectAtIndex:0] stringValue] isEqualToString:@"true"]? TRUE : FALSE;
	u.showVencim = [[[[loginSoap elementsForName:@"showVencimientos"] objectAtIndex:0] stringValue] isEqualToString:@"true"]? TRUE : FALSE;
	u.token = [[[loginSoap elementsForName:@"token"] objectAtIndex:0] stringValue];
	response.tokenSeguridad = [[[loginSoap elementsForName:@"tokenSeguridad"] objectAtIndex:0] stringValue];
	u.userName = [[[loginSoap elementsForName:@"username"] objectAtIndex:0] stringValue];
	u.viewTerminos = [[[[loginSoap elementsForName:@"viewTerminos"] objectAtIndex:0] stringValue] isEqualToString:@"true"]? TRUE : FALSE;
    u.nroDocumento = [[[loginSoap elementsForName:@"nroDocumento"] objectAtIndex:0] stringValue];
    u.tipoDocumento = [[[loginSoap elementsForName:@"tipoDocumento"] objectAtIndex:0] stringValue];
    
    NSString *fecha = [[[loginSoap elementsForName:@"fechaVencimientoPassword"] objectAtIndex:0] stringValue];
    fecha = [fecha substringToIndex:19];//El largo del filtro , corto el GMT porque trae problemas en IOS5
    
    u.vencimiento = [CommonFuncBanelco NSStringToNSDate:fecha withFormat:@"yyyy-MM-dd'T'HH:mm:ss"] ;
    
    fecha = [[[loginSoap elementsForName:@"ultimoAcceso"] objectAtIndex:0] stringValue];
    fecha = [fecha substringToIndex:19];//El largo del filtro , corto el GMT porque trae problemas en IOS5
    
    u.ultimoLogin = [CommonFuncBanelco NSStringToNSDate:fecha withFormat:@"yyyy-MM-dd'T'HH:mm:ss"] ;
	response.usuario = u;
    
	//response.usuario = u;
	
	[doc release];
	
	return response;
	
}

- (id)getDebugResponse {
    LoginResponse *response = [[LoginResponse alloc] init];
	Usuario *u = [[Usuario alloc] init];
    u.celular = @"13131313";
	response.cuentas = [NSMutableArray arrayWithObjects:[Cuenta getDebugCuenta],[Cuenta getDebugCuenta],[Cuenta getDebugCuenta], nil];
	for (int i=0;i<[response.cuentas count];i++){
		
		Cuenta* c = (Cuenta*)[[response cuentas] objectAtIndex:i];
		c.saldo = @"";
	}
	
	u.email = @"rwerwr.com";
	u.firstLogin = FALSE;
	u.fullname = @"pepe pepe";
	u.marcaInfo = FALSE;
	u.marcaVencim = FALSE;
	u.needsPinChange = FALSE;
	u.operadorCelular = @"MOV";
	u.profile = @"perf";
	u.showInfo = FALSE;
	u.showVencim = FALSE;
	u.token = @"324234";
	response.tokenSeguridad = @"45456656";
	u.userName = @"pepe";
	u.viewTerminos = FALSE;
	
	response.usuario = u;
	
	return response;
}

@end
