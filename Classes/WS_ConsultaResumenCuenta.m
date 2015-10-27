//
//  WS_ConsultaResumenCuenta.m
//  BanelcoMovilIphone
//
//  Created by Demian on 9/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WS_ConsultaResumenCuenta.h"
#import "ConsultaResumenResponse.h"
#import "CommonFunctions.h"
#import "Movimiento.h"

@implementation WS_ConsultaResumenCuenta
@synthesize userToken,cuenta;





-(NSString *)getWSName {
	return @"consultaResumenCuenta";
}

-(NSMutableArray *)getSoapParams {
	return [NSArray arrayWithObjects:userToken, cuenta,nil];
}

// ORIGINAL
//-(NSString *)getSoapMessage {
//	NSLog(@"voy a loggear");
//	NSLog(@"%@", [NSString stringWithFormat:
//				  @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
//				  "<v:Header />\n"
//				  "<v:Body>\n"
//				  "<n0:consultaResumenCuenta id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
//				  "<in0 i:type=\"d:string\">%@</in0>\n" // User Token
//				  "<in1 i:type=\":\">"
//				  "%@"
//				  "</in1>"
//				  "</n0:consultaResumenCuenta>\n"
//				  "</v:Body>\n"
//				  "</v:Envelope>\n",userToken, [cuenta toSoapObject]]);
//	
//	return  [NSString stringWithFormat:
//			 @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
//			 "<v:Header />\n"
//			 "<v:Body>\n"
//			 "<n0:consultaResumenCuenta id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
//			 "<in0 i:type=\"d:string\">%@</in0>\n" // User Token
//			 "<in1 i:type=\":\">"
//			 "%@"
//			 "</in1>"
//			 "</n0:consultaResumenCuenta>\n"
//			 "</v:Body>\n"
//			 "</v:Envelope>\n",userToken, [cuenta toSoapObject]];
//	
//}

// SERVICIOS 2.0
-(NSString *)getSoapMessage {
	
	return  [NSString stringWithFormat:
			 @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
			 "<v:Header />\n"
			 "<v:Body>\n"
			 "<n0:consultaResumenCuenta id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
			 "<in0 i:type=\"d:string\">%@</in0>\n" // User Token
			 "<in1 i:type=\"d:string\">%@</in1>\n" // Security Token
			 "<in2 i:type=\":\">"
			 "%@"
			 "</in2>"
			 "</n0:consultaResumenCuenta>\n"
			 "</v:Body>\n"
			 "</v:Envelope>\n",userToken, [WSRequest securityToken], [cuenta toSoapObject]];
	
}


-(id)parseResponse:(NSData *)data {
#if WSDEBUG
    [self getDebugResponse];
#endif
	ConsultaResumenResponse *response = [[ConsultaResumenResponse alloc] init];
	
	NSError *error = [[NSError alloc]init];
	
	NSString *msj = [CommonFunctions returnXMLMasterTagFromText:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] withTag:@"out"];
	//NSLog([NSString stringWithFormat:@"Login Response: %@", msj]);	
	NSData *rdata = [NSData dataWithBytes:[msj UTF8String] length:[msj lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
	
	GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:rdata options:0 error:&error];
	GDataXMLElement *movSoap = doc.rootElement;
	
	response.fecha = [[[movSoap elementsForName:@"fecha"] objectAtIndex:0] stringValue];
	response.listaDeMovimientos = [Movimiento parseMovimientos:[[movSoap elementsForName:@"movimientos"] objectAtIndex:0]];
	response.saldo = [[[movSoap elementsForName:@"saldo"] objectAtIndex:0] stringValue];
	
//	response.listaDeMovimientos = [response.listaDeMovimientos sortedArrayUsingSelector:@selector(comparePorFecha:)];
	
	
	
	return response;

}

- (id)getDebugResponse {
    ConsultaResumenResponse *response = [[ConsultaResumenResponse alloc] init];
	
	response.fecha = @"18/10/2013";
    NSMutableArray *movimientos = [[NSMutableArray alloc] init];
	for (int i = 0; i<10; i++) {
		Movimiento *mov = [[Movimiento alloc] init];
        mov.canal = @"123";
        mov.fechaMovimiento = @"21/11/2013";
        mov.importe = @"432";
        mov.nombre = @"Movim.";
        [movimientos addObject:mov];
        [mov release];
		
	}
	response.listaDeMovimientos = movimientos;
	response.saldo = @"646";
	return response;
}


- (void)dealloc {
	
	[userToken release];
	[cuenta release];
	[super dealloc];
}


@end
