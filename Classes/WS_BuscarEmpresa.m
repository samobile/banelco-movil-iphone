//
//  BuscarEmpresa_WSRequest.m
//  BanelcoMovil
//
//  Created by German Levy on 9/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WS_BuscarEmpresa.h"
#import "Empresa.h"
#import "CommonFunctions.h"
#import "WSUtil.h"


@implementation WS_BuscarEmpresa

@synthesize userToken, empresaId;

-(NSString *)getWSName {
	return @"buscarEmpresa";
}

-(NSMutableArray *)getSoapParams {
	return [NSArray arrayWithObjects:userToken, empresaId, nil];
}

// ORIGINAL
//-(NSString *)getSoapMessage {
//	
//	return [NSString stringWithFormat:
//			@"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
//			"<v:Header />\n"
//			"<v:Body>\n"
//			"<n0:%@ id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
//			"<in0 i:type=\"d:string\">%@</in0>\n" // Token
//			"<in1 i:type=\"d:string\">%@</in1>\n" // empresa id
//			"</n0:%@>\n"
//			"</v:Body>\n"
//			"</v:Envelope>\n", [self getWSName], userToken, empresaId, [self getWSName]
//			];
//	
//}

// SERVICIOS 2.0
-(NSString *)getSoapMessage {
	
	return [NSString stringWithFormat:
			@"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
			"<v:Header />\n"
			"<v:Body>\n"
			"<n0:%@ id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
			"<in0 i:type=\"d:string\">%@</in0>\n" // Token
			"<in1 i:type=\"d:string\">%@</in1>\n" // Security Token
			"<in2 i:type=\"d:string\">%@</in2>\n" // empresa id
			"</n0:%@>\n"
			"</v:Body>\n"
			"</v:Envelope>\n", [self getWSName], userToken, [WSRequest securityToken], empresaId, [self getWSName]
			];
	
}

-(id)parseResponse:(NSData *)data {
	
	NSError *error = [[NSError alloc]init];
	
	NSString *msj = [CommonFunctions returnXMLMasterTagFromText:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] withTag:@"out"];

	NSData *rdata = [NSData dataWithBytes:[msj UTF8String] length:[msj lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
	
	GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:rdata options:0 error:&error];
	GDataXMLElement *rootSoap = doc.rootElement;
	
	//caso en que la respuesta no haya devuelto ninguna empresa
	//Suponiendo que todas las empresas tienen codigo
	if ([rootSoap elementsForName:@"codigo"] == nil) {
		return nil;
	}
	
	Empresa *e = [[Empresa alloc] init];
	e.codMoneda = [[(GDataXMLElement *)[[rootSoap elementsForName:@"codMoneda"] objectAtIndex:0] stringValue] intValue];
	e.codigo = [(GDataXMLElement *)[[rootSoap elementsForName:@"codigo"] objectAtIndex:0] stringValue];
	e.datoAdicional = [(GDataXMLElement *)[[rootSoap elementsForName:@"datoAdicional"] objectAtIndex:0] stringValue];
	e.datosPrePago = [[(GDataXMLElement *)[[rootSoap elementsForName:@"datosPrePago"] objectAtIndex:0] stringValue] intValue];
	e.Id = [(GDataXMLElement *)[[rootSoap elementsForName:@"id"] objectAtIndex:0] stringValue];
	e.importePermitido = [[(GDataXMLElement *)[[rootSoap elementsForName:@"importePermitido"] objectAtIndex:0] stringValue] intValue];
	e.nombre = [(GDataXMLElement *)[[rootSoap elementsForName:@"nombre"] objectAtIndex:0] stringValue];
	e.nroLeyenda = [[(GDataXMLElement *)[[rootSoap elementsForName:@"nroLeyenda"] objectAtIndex:0] stringValue] intValue];
	e.rubro = [(GDataXMLElement *)[[rootSoap elementsForName:@"rubro"] objectAtIndex:0] stringValue];
	e.simboloMoneda = [(GDataXMLElement *)[[rootSoap elementsForName:@"simboloMoneda"] objectAtIndex:0] stringValue];
	e.soloConsulta = [[(GDataXMLElement *)[[rootSoap elementsForName:@"soloConsulta"] objectAtIndex:0] stringValue] boolValue];
	e.tipoEmpresa = [(GDataXMLElement *)[[rootSoap elementsForName:@"tipoEmpresa"] objectAtIndex:0] stringValue];
	e.tipoPago = [[(GDataXMLElement *)[[rootSoap elementsForName:@"tipoPago"] objectAtIndex:0] stringValue] intValue];
	e.tituloIdentificacion = [(GDataXMLElement *)[[rootSoap elementsForName:@"tituloIdentificacion"] objectAtIndex:0] stringValue];
	
	return e;
	
}

@end
