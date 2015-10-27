//
//  ListarEmpresas_WSRequest.m
//  BanelcoMovil
//
//  Created by German Levy on 8/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WS_ListarEmpresas.h"
#import "Context.h"
#import "Usuario.h"
#import "CommonFunctions.h"
#import "Cuenta.h"
#import "WSUtil.h"
#import "Empresa.h"


@implementation WS_ListarEmpresas

@synthesize userToken, rubro, busqueda, codBanco, pagina, soloConsulta;

-(NSString *)getWSName {
	return @"listarEmpresasFiltradas";
}

-(NSMutableArray *)getSoapParams {
	return [NSArray arrayWithObjects:userToken, rubro, busqueda, codBanco, pagina, soloConsulta, nil];
}

// ORIGINAL
//-(NSString *)getSoapMessage {
//	
//	return  [NSString stringWithFormat:
//			 @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
//			 "<v:Header />\n"
//			 "<v:Body>\n"
//			 "<n0:listarEmpresasFiltradas id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
//			 "<in0 i:type=\"d:string\">%@</in0>\n"	// Token
//			 "<in1 i:type=\"d:string\">%@</in1>\n"	// Rubro
//			 "<in2 i:type=\"d:string\">%@</in2>\n"	// Cadena busqueda
//			 "<in3 i:type=\"d:string\">%@</in3>\n"	// Codigo banco
//			 "<in4 i:type=\"d:int\">%d</in4>\n"		// Pagina
//			 "<in5 i:type=\"d:boolean\">%@</in5>\n" // Solo Consulta
//			 "</n0:listarEmpresasFiltradas>\n"
//			 "</v:Body>\n"
//			 "</v:Envelope>\n", userToken, rubro, busqueda, codBanco, [pagina intValue], [soloConsulta boolValue]?@"true":@"false"
//			 ];
//	
//}

// SERVICIOS 2.0
-(NSString *)getSoapMessage {
	
	return  [NSString stringWithFormat:
			 @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
			 "<v:Header />\n"
			 "<v:Body>\n"
			 "<n0:listarEmpresasFiltradas id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
			 "<in0 i:type=\"d:string\">%@</in0>\n"	// Token
			 "<in1 i:type=\"d:string\">%@</in1>\n"  // Security Token
			 "<in2 i:type=\"d:string\">%@</in2>\n"	// Rubro
			 "<in3 i:type=\"d:string\">%@</in3>\n"	// Cadena busqueda
			 "<in4 i:type=\"d:string\">%@</in4>\n"	// Codigo banco
			 "<in5 i:type=\"d:int\">%d</in5>\n"		// Pagina
			 "<in6 i:type=\"d:boolean\">%@</in6>\n" // Solo Consulta
			 "</n0:listarEmpresasFiltradas>\n"
			 "</v:Body>\n"
			 "</v:Envelope>\n", userToken, [WSRequest securityToken], rubro, busqueda, codBanco, [pagina intValue], [soloConsulta boolValue]?@"true":@"false"
			 ];
	
}

-(id)parseResponse:(NSData *)data {
	
	NSMutableArray *empresas = [[NSMutableArray alloc] init];
	
	GDataXMLElement *rootSoap = [WSUtil getRootElement:@"out" inData:data];
	
	GDataXMLElement *empresasSoap = [[rootSoap elementsForName:@"empresas"] objectAtIndex:0];
	
	int nroSecuencia = [[[[rootSoap elementsForName:@"nroSecuencia"] objectAtIndex:0] stringValue] intValue];
	
	NSArray *elementosEmpresa = [empresasSoap elementsForName:@"EmpresaMobileDTO"];
	
	for (GDataXMLElement *soap in elementosEmpresa) {
		
		[empresas addObject:[Empresa parse:soap forSecuencia:nroSecuencia]];
		
	}
	
	return empresas;
	
}

@end
