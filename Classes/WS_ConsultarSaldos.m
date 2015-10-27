#import "WS_ConsultarSaldos.h"
#import "Cuenta.h"
#import "CommonFunctions.h"

@implementation WS_ConsultarSaldos
	
@synthesize userToken,numeroCuenta, codigoTipoCuenta, codigoMonedaCuenta;


-(NSString *)getWSName {
	return @"consultarSaldos";
}

-(NSMutableArray *)getSoapParams {
	return [NSArray arrayWithObjects:userToken, numeroCuenta,codigoTipoCuenta,codigoMonedaCuenta,nil];
}

// ORIGINAL
//-(NSString *)getSoapMessage {
//	
//	NSLog(@"getSoapMessage");
//	NSLog(@"%@ , %@ , %d , %d",userToken, numeroCuenta,codigoTipoCuenta,codigoMonedaCuenta);
//	NSString * respuesta = [NSString stringWithFormat:
//							@"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
//							"<v:Header />\n"
//							"<v:Body>\n"
//							"<n0:consultarSaldos id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
//							"<in0 i:type=\"d:string\">%@</in0>\n" // User Token
//							"<in1 i:type=\"d:string\">%@</in1>\n" // Numero de Cuenta
//							"<in2 i:type=\"d:int\">%d</in2>\n" // Tipo de Cuenta
//							"<in3 i:type=\"d:int\">%d</in3>\n" // Moneda
//							"</n0:consultarSaldos>\n"
//							"</v:Body>\n"
//							"</v:Envelope>\n",userToken, numeroCuenta,codigoTipoCuenta,codigoMonedaCuenta];
//	NSLog(@"%@",respuesta);
//	return  respuesta;
//	
//}

// SERVICIOS 2.0
-(NSString *)getSoapMessage {
	
	NSString * respuesta = [NSString stringWithFormat:
							@"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
							"<v:Header />\n"
							"<v:Body>\n"
							"<n0:consultarSaldos id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
							"<in0 i:type=\"d:string\">%@</in0>\n" // User Token
							"<in1 i:type=\"d:string\">%@</in1>\n" // Security Token
							"<in2 i:type=\"d:string\">%@</in2>\n" // Numero de Cuenta
							"<in3 i:type=\"d:int\">%d</in3>\n" // Tipo de Cuenta
							"<in4 i:type=\"d:int\">%d</in4>\n" // Moneda
							"</n0:consultarSaldos>\n"
							"</v:Body>\n"
							"</v:Envelope>\n",userToken, [WSRequest securityToken], numeroCuenta,codigoTipoCuenta,codigoMonedaCuenta];
	return  respuesta;
	
}


-(id)parseResponse:(NSData *)data {
#if WSDEBUG
    [Cuenta getDebugCuenta];
#endif
	NSLog(@"c1");
	Cuenta *cuenta = [[Cuenta alloc] init];
	NSLog(@"c2");
	NSError *error = [[NSError alloc]init];
	NSLog(@"c3");
	NSString *msj = [CommonFunctions returnXMLMasterTagFromText:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] withTag:@"out"];
	NSLog(@"c4");
	//NSLog([NSString stringWithFormat:@"Login Response: %@", msj]);	
	NSData *rdata = [NSData dataWithBytes:[msj UTF8String] length:[msj lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
	NSLog(@"c5");
	GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:rdata options:0 error:&error];
	NSLog(@"c6");
	GDataXMLElement *dispSoap = doc.rootElement;
	NSLog(@"c7");
	
	cuenta = [Cuenta parseCuenta:dispSoap];
	NSLog(@"c8");
	return cuenta;
	
	
}



- (void)dealloc {
	
	[userToken release];
	[numeroCuenta release];


	[super dealloc];
}
	

@end
