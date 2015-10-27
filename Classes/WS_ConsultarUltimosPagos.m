//
//  ConsultarUltimosPagos_WSRequest.m
//  BanelcoMovil
//
//  Created by German Levy on 8/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WS_ConsultarUltimosPagos.h"
#import "WSUtil.h"
#import "Ticket.h"


@implementation WS_ConsultarUltimosPagos

@synthesize userToken, codigo, secuencia;


-(NSString *)getWSName {
	return @"consultarUltimosPagos";
}

-(NSMutableArray *)getSoapParams {
	return [NSArray arrayWithObjects:userToken, codigo, secuencia, nil];
}

// ORIGINAL
//-(NSString *)getSoapMessage {
//	
//	return  [NSString stringWithFormat:
//			 @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
//			 "<v:Header />\n"
//			 "<v:Body>\n"
//			 "<n0:consultarUltimosPagos id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
//			 "<in0 i:type=\"d:string\">%@</in0>\n"	// Token
//			 "<in1 i:type=\"d:string\">%@</in1>\n"	// Codigo empresa
//			 "<in2 i:type=\"d:int\">%d</in2>\n"	// Nro pagina
//			 "</n0:consultarUltimosPagos>\n"
//			 "</v:Body>\n"
//			 "</v:Envelope>\n", userToken, codigo, [secuencia intValue]
//			 ];
//	
//}

// SERVICIOS 2.0
-(NSString *)getSoapMessage {
	
	return  [NSString stringWithFormat:
			 @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
			 "<v:Header />\n"
			 "<v:Body>\n"
			 "<n0:consultarUltimosPagos id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
			 "<in0 i:type=\"d:string\">%@</in0>\n"	// Token
			 "<in1 i:type=\"d:string\">%@</in1>\n" // Security Token
			 "<in2 i:type=\"d:string\">%@</in2>\n"	// Codigo empresa
			 "<in3 i:type=\"d:int\">%d</in3>\n"	// Nro pagina
			 "</n0:consultarUltimosPagos>\n"
			 "</v:Body>\n"
			 "</v:Envelope>\n", userToken, [WSRequest securityToken], codigo, [secuencia intValue]
			 ];
	
}

-(id)parseResponse:(NSData *)data {
	
	NSMutableArray *tickets = [[NSMutableArray alloc] init];
	
	GDataXMLElement *rootSoap = [WSUtil getRootElement:@"out" inData:data];
	
	int nroSecuencia = [WSUtil getIntegerProperty:@"nroSecuencia" ofSoap:rootSoap];
	
	NSArray *ticketsSoap = [(GDataXMLElement *)[[rootSoap elementsForName:@"tickets"] objectAtIndex:0] elementsForName:@"TicketMobileDTO"];
	
	for (GDataXMLElement *ticketSoap in ticketsSoap) {
		
		Ticket *t = [[Ticket alloc] init];
		
		t.canal = [WSUtil getStringProperty:@"canal" ofSoap:ticketSoap];
		t.clienteId = [WSUtil getStringProperty:@"clientId" ofSoap:ticketSoap];
		t.cuenta = [WSUtil getStringProperty:@"cuenta" ofSoap:ticketSoap];
		t.empresa = [WSUtil getStringProperty:@"empresa" ofSoap:ticketSoap];
		t.fechaPago = [WSUtil getStringProperty:@"fechaPago" ofSoap:ticketSoap];
		t.fiid = [WSUtil getStringProperty:@"fiid" ofSoap:ticketSoap];
		t.importe = [WSUtil getStringProperty:@"importe" ofSoap:ticketSoap];
		t.moneda = [WSUtil getStringProperty:@"moneda" ofSoap:ticketSoap];
		t.nroControl = [WSUtil getStringProperty:@"nroControl" ofSoap:ticketSoap];
		t.nroTransaccion = [WSUtil getStringProperty:@"nroTransaccion" ofSoap:ticketSoap];
		t.nroSecuencia = nroSecuencia;
		
		[tickets addObject:t];
		[t release];
		
	}
	
	return tickets;
	
}

@end
