//
//  WS_GenerarClave.m
//  BanelcoMovilIphone
//
//  Created by German Levy on 5/16/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "WS_GenerarClave.h"
#import "CommonFunctions.h"


@implementation WS_GenerarClave

@synthesize tipoDoc, nroDoc, codBanco, fechaNac, codCarrier, nroCel, nroTarjeta, fechaTarjeta, clave, userToken;

-(NSString *)getWSName {
	return @"generarClave";
}

-(NSMutableArray *)getSoapParams {
	return [NSArray arrayWithObjects:userToken, @"O", codBanco, codCarrier, tipoDoc, nroDoc, fechaNac, nroTarjeta, fechaTarjeta, nroCel, clave, nil];
}

-(NSString *)getSoapMessage {
	
	return  [NSString stringWithFormat:
			 @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
			 "<v:Header />\n"
			 "<v:Body>\n"
			 "<n0:generarClave id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
			 "<in0 i:type=\"d:string\">%@</in0>\n"   // Token
			 "<in1 i:type=\"d:string\">%@</in1>\n"   // Canal
			 "<in2 i:type=\"d:string\">%@</in2>\n"   // Cod banco
			 "<in3 i:type=\"d:string\">%@</in3>\n"   // Cod Carrier
			 "<in4 i:type=\"d:string\">%@</in4>\n"   // Tipo documento
			 "<in5 i:type=\"d:string\">%@</in5>\n"   // Nro documento
			 "<in6 i:type=\"d:string\">%@</in6>\n"   // Fecha Nacimiento
			 "<in7 i:type=\"d:string\">%@</in7>\n"   // Nro tarjeta
			 "<in8 i:type=\"d:string\">%@</in8>\n"   // Fecha vto tarjeta
			 "<in9 i:type=\"d:string\">%@</in9>\n"   // Nro celular
			 "<in10 i:type=\"d:string\">%@</in10>\n" // Clave
			 "</n0:generarClave>\n"
			 "</v:Body>\n"
			 "</v:Envelope>\n", userToken, @"O", codBanco, codCarrier, tipoDoc, nroDoc, fechaNac, nroTarjeta, fechaTarjeta, nroCel, clave
			 ];
	
}

-(id)parseResponse:(NSData *)data {
		
	NSError *error = [[NSError alloc]init];
	
	NSString *msj = [CommonFunctions returnXMLMasterTagFromText:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] withTag:@"out"];
	//NSLog([NSString stringWithFormat:@"Login Response: %@", msj]);	
	NSData *rdata = [NSData dataWithBytes:[msj UTF8String] length:[msj lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
	
	GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:rdata options:0 error:&error];
	GDataXMLElement *regisSoap = doc.rootElement;
	
	GDataXMLElement *usuarioSoap = [[regisSoap elementsForName:@"usuario"] objectAtIndex:0];
	GDataXMLElement *idSoap = [[usuarioSoap elementsForName:@"datosIdentificacion"] objectAtIndex:0];
	
	NSString *tokenSeguridad = [[[idSoap elementsForName:@"tokenSeguridad"] objectAtIndex:0] stringValue];
		
	[doc release];
	
	return tokenSeguridad;
	
}


@end
