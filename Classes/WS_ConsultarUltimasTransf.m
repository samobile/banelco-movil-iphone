//
//  ConsultarUltimasTransf_WSRequest.m
//  BanelcoMovil
//
//  Created by German Levy on 9/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WS_ConsultarUltimasTransf.h"
#import "WSUtil.h"
#import "Ticket.h"


@implementation WS_ConsultarUltimasTransf

@synthesize userToken;

-(NSString *)getWSName {
	return @"consultarUltimasTransf";
}

-(NSMutableArray *)getSoapParams {
	return [NSArray arrayWithObjects:userToken, nil];
}

// ORIGINAL
//-(NSString *)getSoapMessage {
//	return  [NSString stringWithFormat:
//			 @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
//			 "<v:Header />\n"
//			 "<v:Body>\n"
//			 "<n0:consultarUltimasTransf id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
//			 "<in0 i:type=\"d:string\">%@</in0>\n" // User Token	 
//			 "</n0:consultarUltimasTransf>\n"
//			 "</v:Body>\n"
//			 "</v:Envelope>\n", userToken
//			 ];
//}

// SERVICIOS 2.0
-(NSString *)getSoapMessage {
	return  [NSString stringWithFormat:
			 @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
			 "<v:Header />\n"
			 "<v:Body>\n"
			 "<n0:consultarUltimasTransf id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
			 "<in0 i:type=\"d:string\">%@</in0>\n" // User Token	 
			 "<in1 i:type=\"d:string\">%@</in1>\n" // Security Token
			 "</n0:consultarUltimasTransf>\n"
			 "</v:Body>\n"
			 "</v:Envelope>\n", userToken, [WSRequest securityToken]
			 ];
}


-(id)parseResponse:(NSData *)data {
	
	NSMutableArray *tickets = [[NSMutableArray alloc] init];
	
	GDataXMLElement *rootSoap = [WSUtil getRootElement:@"out" inData:data];
	
	//int nroSecuencia = [WSUtil getIntegerProperty:@"nroSecuencia" ofSoap:rootSoap];
	
	NSArray *ticketsSoap = [(GDataXMLElement *)[[rootSoap elementsForName:@"elementos"] objectAtIndex:0] elementsForName:@"TicketTransfMobileDTO"];
	
	//NSArray *ticketsSoap = [rootSoap elementsForName:@"TicketTransfMobileDTO"];
	
	for (GDataXMLElement *ticketSoap in ticketsSoap) {
		
		Ticket *t = [[Ticket alloc] init];
		
		t.canal = [WSUtil getStringProperty:@"canal" ofSoap:ticketSoap];
		t.cuentaDestino = [WSUtil getStringProperty:@"cuentaDestino" ofSoap:ticketSoap];
		t.cbuDestino = [WSUtil getStringProperty:@"cbuDestino" ofSoap:ticketSoap];
		t.clienteId = [WSUtil getStringProperty:@"clientId" ofSoap:ticketSoap];
		t.cuenta = [WSUtil getStringProperty:@"cuenta" ofSoap:ticketSoap];
		t.empresa = [WSUtil getStringProperty:@"empresa" ofSoap:ticketSoap];
		t.fechaPago = [WSUtil getStringProperty:@"fechaPago" ofSoap:ticketSoap];
		t.fiid = [WSUtil getStringProperty:@"fiid" ofSoap:ticketSoap];
		t.importe = [WSUtil getStringProperty:@"importe" ofSoap:ticketSoap];
		t.moneda = [WSUtil getStringProperty:@"moneda" ofSoap:ticketSoap];
		t.nroControl = [WSUtil getStringProperty:@"nroControl" ofSoap:ticketSoap];
		t.nroTransaccion = [WSUtil getStringProperty:@"nroTransaccion" ofSoap:ticketSoap];
		//t.nroSecuencia = nroSecuencia;
		
		[tickets addObject:t];
		[t release];
		
	}
	
	return tickets;
	
}

@end
