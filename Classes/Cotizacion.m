
#import "Cotizacion.h"
#import "GDataXMLNode.h"
#import "WSUtil.h"
#import "WS_ConsultarCotizacion.h"
#import "Context.h"

@implementation Cotizacion

@synthesize cotizacion, valorCompra, valorVenta, importe, codigoMoneda, simboloMoneda, unidad, importeConvertido, fecha;


+ (Cotizacion *) parseSoapObject:(GDataXMLElement *)cotiSoap {
	
	Cotizacion *cot = [[Cotizacion alloc] init];

	cot.codigoMoneda = [WSUtil getIntegerProperty:@"codigoMoneda" ofSoap:cotiSoap];

	cot.cotizacion = [WSUtil getStringProperty:@"cotizacion" ofSoap:cotiSoap];

	cot.importe = [WSUtil getStringProperty:@"importe" ofSoap:cotiSoap];

	cot.importeConvertido = [WSUtil getStringProperty:@"importeConvertido" ofSoap:cotiSoap];

	cot.simboloMoneda = [WSUtil getStringProperty:@"simboloMoneda" ofSoap:cotiSoap];

	cot.unidad = [WSUtil getIntegerProperty:@"unidad" ofSoap:cotiSoap];

	cot.valorCompra = [WSUtil getStringProperty:@"valorCompra" ofSoap:cotiSoap];

	cot.valorVenta = [WSUtil getStringProperty:@"valorVenta" ofSoap:cotiSoap];
	
	cot.fecha = [WSUtil getStringProperty:@"fecha" ofSoap:cotiSoap];

	return cot;
}

+ (id) getCotizacion:(NSString *)numeroCta codCuenta:(NSString *)codTipoCta codMonedaOrigen:(int)codMonO importe:(NSString *)importeValue codMonedaDest:(int)codMonD {
	
	WS_ConsultarCotizacion * request = [[WS_ConsultarCotizacion alloc] init];
	
	Context *context = [Context sharedContext];
	
	request.userToken = [context getToken];
	request.numeroCuenta = numeroCta;
	request.codigoTipoCuenta = [codTipoCta intValue];
	request.codMonedaOrigen = codMonO;
	request.importe = importeValue;
	request.codMonedaDest = codMonD;
	
	id coti = [WSUtil execute:request];
	
	//if ([coti isKindOfClass:[NSError class]]) {
//		return nil;
//	}
	
	return coti;
	
}

@end
