//
//  WS_RealizarTransferenciaPropia.m
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 9/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WS_RealizarTransferenciaPropia.h"
#import "CommonFunctions.h"
#import "Ticket.h"

@implementation WS_RealizarTransferenciaPropia

@synthesize userToken, cuentaOrigen, cuentaDestino, importe;

-(NSString *)getWSName {
	return @"realizarTransferenciaPropia";
}

-(NSMutableArray *)getSoapParams {
	return [NSArray arrayWithObjects:userToken, cuentaOrigen, cuentaDestino, importe, nil];
}

-(NSString *)getSoapMessage {
	
	NSMutableString* soapOrigen = [[NSMutableString alloc] init];
	
	if (cuentaOrigen.accountType == C_ACCOUNT) {
		NSString* nameSpace = @"=\"http://impl.cuentas.consultas.mobile.services.pmctas.banelco.com\"";

		[soapOrigen appendFormat:@"<n2:codigo i:type=\"n2:string\" xmlns:n2%@ >%@</n2:codigo>\n",nameSpace,cuentaOrigen.codigo];
		[soapOrigen appendFormat:@"<n3:codigoMoneda i:type=\"n3:int\" xmlns:n3%@ >%d</n3:codigoMoneda>\n",nameSpace,cuentaOrigen.codigoMoneda];
		[soapOrigen appendFormat:@"<n4:codigoTipoCuenta i:type=\"n4:string\" xmlns:n4%@ >%@</n4:codigoTipoCuenta>\n",nameSpace,cuentaOrigen.codigoTipoCuenta];
		if(cuentaOrigen.ctaEspecial){
			[soapOrigen appendFormat:@"<n5:ctaEspecial i:type=\"n5:boolean\" xmlns:n5%@ >%@</n5:ctaEspecial>\n",nameSpace,@"true"];
		}else {
			[soapOrigen appendFormat:@"<n5:ctaEspecial i:type=\"n5:boolean\" xmlns:n5%@ >%@</n5:ctaEspecial>\n",nameSpace,@"false"];
		}
		[soapOrigen appendFormat:@"<n6:descripcionCortaTipoCuenta i:type=\"n6:string\" xmlns:n6%@ >%@</n6:descripcionCortaTipoCuenta>\n",nameSpace,cuentaOrigen.descripcionCortaTipoCuenta];
		[soapOrigen appendFormat:@"<n7:descripcionLargaTipoCuenta i:type=\"n7:string\" xmlns:n7%@ >%@</n7:descripcionLargaTipoCuenta>\n",nameSpace,cuentaOrigen.descripcionLargaTipoCuenta];
		[soapOrigen appendFormat:@"<n8:disponible i:type=\"n8:double\" xmlns:n8%@ >%d</n8:disponible>\n",nameSpace,cuentaOrigen.disponible];
		[soapOrigen appendFormat:@"<n9:limite i:type=\"n9:string\" xmlns:n9%@ >%@</n9:limite>\n",nameSpace,cuentaOrigen.limite];
		[soapOrigen appendFormat:@"<n10:numero i:type=\"n10:string\" xmlns:n10%@ >%@</n10:numero>\n",nameSpace,cuentaOrigen.numero];
		[soapOrigen appendFormat:@"<n11:saldo i:type=\"n11:string\" xmlns:n11%@ >%@</n11:saldo>\n",nameSpace,@"0.0"];
		[soapOrigen appendFormat:@"<n12:simboloMoneda i:type=\"n12:string\" xmlns:n12%@ >%@</n12:simboloMoneda>\n",nameSpace,cuentaOrigen.simboloMoneda];
		
		[soapOrigen appendFormat:@"</n1:cuentaOrigen><n13:cuentaDestino i:type=\":\" xmlns:n13=\"http://homebanking.mobile.services.pmctas.banelco.com\">"];
	} 
//	else {
//		NSString* nameSpace =@"=\"http://transferencias.mobile.services.pmctas.banelco.com\"";
//		[soapOrigen appendFormat:@"<n2:codigo i:type=\"n1:string\" xmlns:n1%@>%@</n2:codigo>\n",nameSpace,cuentaOrigen.codigo];
//		[soapOrigen appendFormat:@"<n3:cuit i:type=\"n2:string\" xmlns:n2%@>%@</n3:cuit>\n",nameSpace,cuentaOrigen.cuit];
//		[soapOrigen appendFormat:@"<n4:nombre i:type=\"n3:string\" xmlns:n3%@>%@</n4:nombre>\n",nameSpace,cuentaOrigen.nombre];
//		[soapOrigen appendFormat:@"<n5:propia i:type=\"n4:string\" xmlns:n4%@>%@</n5:propia>\n",nameSpace,cuentaOrigen.propia];
//		
//		[soapOrigen appendFormat:@"</n1:cuentaOrigen><n6:cuentaDestino i:type=\":\" xmlns:n6=\"http://homebanking.mobile.services.pmctas.banelco.com\">"];
//	}
	
	
	if (cuentaDestino.accountType == C_ACCOUNT) {
		NSString* nameSpace = @"=\"http://impl.cuentas.consultas.mobile.services.pmctas.banelco.com\"";
		//[soap appendFormat:@"<in1 i:type=\":\">"];
		[soapOrigen appendFormat:@"<n14:codigo i:type=\"n14:string\" xmlns:n14%@ >%@</n14:codigo>\n",nameSpace,cuentaDestino.codigo];
		[soapOrigen appendFormat:@"<n15:codigoMoneda i:type=\"n15:int\" xmlns:n15%@ >%d</n15:codigoMoneda>\n",nameSpace,cuentaDestino.codigoMoneda];
		[soapOrigen appendFormat:@"<n16:codigoTipoCuenta i:type=\"n16:string\" xmlns:n16%@ >%@</n16:codigoTipoCuenta>\n",nameSpace,cuentaDestino.codigoTipoCuenta];
		if(cuentaDestino.ctaEspecial){
			[soapOrigen appendFormat:@"<n17:ctaEspecial i:type=\"n17:boolean\" xmlns:n17%@ >%@</n17:ctaEspecial>\n",nameSpace,@"true"];
		}else {
			[soapOrigen appendFormat:@"<n17:ctaEspecial i:type=\"n17:boolean\" xmlns:n17%@ >%@</n17:ctaEspecial>\n",nameSpace,@"false"];
		}
		[soapOrigen appendFormat:@"<n18:descripcionCortaTipoCuenta i:type=\"n18:string\" xmlns:n18%@ >%@</n18:descripcionCortaTipoCuenta>\n",nameSpace,cuentaDestino.descripcionCortaTipoCuenta];
		[soapOrigen appendFormat:@"<n19:descripcionLargaTipoCuenta i:type=\"n19:string\" xmlns:n19%@ >%@</n19:descripcionLargaTipoCuenta>\n",nameSpace,cuentaDestino.descripcionLargaTipoCuenta];
		[soapOrigen appendFormat:@"<n20:disponible i:type=\"n20:double\" xmlns:n20%@ >%d</n20:disponible>\n",nameSpace,cuentaDestino.disponible];
		[soapOrigen appendFormat:@"<n21:limite i:type=\"n21:string\" xmlns:n21%@ >%@</n21:limite>\n",nameSpace,cuentaDestino.limite];
		[soapOrigen appendFormat:@"<n22:numero i:type=\"n22:string\" xmlns:n22%@ >%@</n22:numero>\n",nameSpace,cuentaDestino.numero];
		[soapOrigen appendFormat:@"<n23:saldo i:type=\"n23:string\" xmlns:n23%@ >%@</n23:saldo>\n",nameSpace,@"0.0"];
		[soapOrigen appendFormat:@"<n24:simboloMoneda i:type=\"n24:string\" xmlns:n24%@ >%@</n24:simboloMoneda>\n",nameSpace,cuentaDestino.simboloMoneda];
		
		[soapOrigen appendFormat:@"</n13:cuentaDestino><n25:importe i:type=\"n25:string\" xmlns:n25=\"http://homebanking.mobile.services.pmctas.banelco.com\">%@</n25:importe>",importe];
	} else {
		NSString* nameSpace =@"=\"http://transferencias.mobile.services.pmctas.banelco.com\"";
		[soapOrigen appendFormat:@"<n14:codigo i:type=\"n14:string\" xmlns:n14%@>%@</n14:codigo>\n",nameSpace,cuentaDestino.codigo];
		[soapOrigen appendFormat:@"<n15:cuit i:type=\"n15:string\" xmlns:n15%@>%@</n15:cuit>\n",nameSpace,cuentaDestino.cuit];
		[soapOrigen appendFormat:@"<n16:nombre i:type=\"n16:string\" xmlns:n16%@>%@</n16:nombre>\n",nameSpace,cuentaDestino.nombre];
		[soapOrigen appendFormat:@"<n17:propia i:type=\"n17:string\" xmlns:n17%@>%@</n17:propia>\n",nameSpace,cuentaDestino.propia];
		
		[soapOrigen appendFormat:@"</n13:cuentaDestino><n18:importe i:type=\"n18:string\" xmlns:n18=\"http://homebanking.mobile.services.pmctas.banelco.com\">%@</n18:importe>",importe];
	}
	
// ORIGINAL	
//	return  [NSString stringWithFormat:
//			 @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
//			 "<v:Header />\n"
//			 "<v:Body>\n"
//			 "<n0:realizarTransferenciaPropia id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
//			 "<in0 i:type=\"d:string\">%@</in0>\n" // Token
//			 "<in1 i:type=\":\">\n" // Cuenta Origen, Destino, importe
//			 "<n1:cuentaOrigen i:type=\":\" xmlns:n1=\"http://homebanking.mobile.services.pmctas.banelco.com\">%@"
//			 "</in1>"
//			 "</n0:realizarTransferenciaPropia>\n"
//			 "</v:Body>\n"
//			 "</v:Envelope>\n", userToken, soapOrigen
//			 ];

	// SERVICIOS 2.0
	return  [NSString stringWithFormat:
			 @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
			 "<v:Header />\n"
			 "<v:Body>\n"
			 "<n0:realizarTransferenciaPropia id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
			 "<in0 i:type=\"d:string\">%@</in0>\n" // Token
			 "<in1 i:type=\"d:string\">%@</in1>\n" // Security Token
			 "<in2 i:type=\":\">\n" // Cuenta Origen, Destino, importe
			 "<n1:cuentaOrigen i:type=\":\" xmlns:n1=\"http://homebanking.mobile.services.pmctas.banelco.com\">%@"
			 "</in2>"
			 "</n0:realizarTransferenciaPropia>\n"
			 "</v:Body>\n"
			 "</v:Envelope>\n", userToken, [WSRequest securityToken], soapOrigen
			 ];
	
	}

-(id)parseResponse:(NSData *)data {
	
	NSError *error = [[NSError alloc]init];
	
	NSString *msj = [CommonFunctions returnXMLMasterTagFromText:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] withTag:@"out"];
	
	NSData *rdata = [NSData dataWithBytes:[msj UTF8String] length:[msj lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
	
	GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:rdata options:0 error:&error];
	GDataXMLElement *movSoap = doc.rootElement;
	
	//La respuesta de realizarTransferenciaPropia es un Ticket
	Ticket *response = [[Ticket alloc] init];
	response.fechaPago = [[[movSoap elementsForName:@"fechaPago"] objectAtIndex:0] stringValue];
	response.empresa = [[[movSoap elementsForName:@"empresa"] objectAtIndex:0] stringValue];
	response.nroTransaccion = [[[movSoap elementsForName:@"nroTransaccion"] objectAtIndex:0] stringValue];
	response.clienteId = [[[movSoap elementsForName:@"clientId"] objectAtIndex:0] stringValue];
	response.cuenta = [[[movSoap elementsForName:@"cuenta"] objectAtIndex:0] stringValue];
	response.fiid = [[[movSoap elementsForName:@"fiid"] objectAtIndex:0] stringValue];
	response.importe = [[[movSoap elementsForName:@"importe"] objectAtIndex:0] stringValue];
	response.moneda = [[[movSoap elementsForName:@"moneda"] objectAtIndex:0] stringValue];
	response.nroControl = [[[movSoap elementsForName:@"nroControl"] objectAtIndex:0] stringValue];
	response.canal = [[[movSoap elementsForName:@"canal"] objectAtIndex:0] stringValue];
	
	return response;
	
}


@end
