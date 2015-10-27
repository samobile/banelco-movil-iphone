//
//  WS_ConsultarCotizacion.m
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 9/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WS_ConsultarCotizacion.h"
#import "Cotizacion.h"
#import "CommonFunctions.h"

@implementation WS_ConsultarCotizacion

@synthesize userToken, numeroCuenta, codigoTipoCuenta, codMonedaOrigen, importe, codMonedaDest;

-(NSString *)getWSName {
	return @"consultarCotizacion";
}

-(NSMutableArray *)getSoapParams {
	return [NSArray arrayWithObjects:userToken, numeroCuenta, codMonedaOrigen, importe, codMonedaDest, nil];
}

// ORIGINAL
//-(NSString *)getSoapMessage {
//	
//	//Revisar si esta bien armado el XML
//	return  [NSString stringWithFormat:
//			 @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
//			 "<v:Header />\n"
//			 "<v:Body>\n"
//			 "<n0:consultarCotizacion id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
//			 "<in0 i:type=\"d:string\">%@</in0>\n" // Token
//			 "<in1 i:type=\"d:string\">%@</in1>\n" //numero cuenta
//			 "<in2 i:type=\"d:int\">%d</in2>\n" // Cod tipo Cuenta
//			 "<in3 i:type=\"d:int\">%d</in3>\n" // Cod moneda cuenta
//			 "<in4 i:type=\"d:string\">%@</in4>\n" // importe
//			 "<in5 i:type=\"d:int\">%d</in5>\n" // Cod moneda a convertir
//			 "</n0:consultarCotizacion>\n"
//			 "</v:Body>\n"
//			 "</v:Envelope>\n", userToken, numeroCuenta, codigoTipoCuenta, codMonedaOrigen, importe, codMonedaDest
//			 ];
//	
//}

// SERVICIOS 2.0
-(NSString *)getSoapMessage {
	
	return  [NSString stringWithFormat:
			 @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
			 "<v:Header />\n"
			 "<v:Body>\n"
			 "<n0:consultarCotizacion id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
			 "<in0 i:type=\"d:string\">%@</in0>\n" // Token
			 "<in1 i:type=\"d:string\">%@</in1>\n" // Security Token
			 "<in2 i:type=\"d:string\">%@</in2>\n" //numero cuenta
			 "<in3 i:type=\"d:int\">%d</in3>\n" // Cod tipo Cuenta
			 "<in4 i:type=\"d:int\">%d</in4>\n" // Cod moneda cuenta
			 "<in5 i:type=\"d:string\">%@</in5>\n" // importe
			 "<in6 i:type=\"d:int\">%d</in6>\n" // Cod moneda a convertir
			 "</n0:consultarCotizacion>\n"
			 "</v:Body>\n"
			 "</v:Envelope>\n", userToken, [WSRequest securityToken], numeroCuenta, codigoTipoCuenta, codMonedaOrigen, importe, codMonedaDest
			 ];
	
}

-(id)parseResponse:(NSData *)data {
#if WSDEBUG
    return [self getResponseDebug];
#endif
	NSError *error = [[NSError alloc]init];
	
	NSString *msj = [CommonFunctions returnXMLMasterTagFromText:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] withTag:@"out"];
	
	NSData *rdata = [NSData dataWithBytes:[msj UTF8String] length:[msj lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
	
	GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:rdata options:0 error:&error];
	GDataXMLElement *movSoap = doc.rootElement;
	
	Cotizacion *response = [Cotizacion parseSoapObject:movSoap];
	
	return response;
	
}

- (id)getResponseDebug {
    Cotizacion *cot = [[Cotizacion alloc] init];
    
	cot.codigoMoneda = 1;
    
	cot.cotizacion = @"2";
    
	cot.importe = @"123";
    
	cot.importeConvertido = @"3434";
    
	cot.simboloMoneda = @"$";
    
	cot.unidad = 1;
    
	cot.valorCompra = @"34";
    
	cot.valorVenta = @"35";
	
	cot.fecha = @"23/10/2013";
    
	return cot;
}


@end
