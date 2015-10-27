
#import "CreditCardResumen.h"
#import "Context.h"
#import "WSUtil.h"
#import "WS_ConsultarUltimoResumenTC.h"

@implementation CreditCardResumen

@synthesize minAPagarPesos, totalAPagarPesos, minAPagarDolares, totalAPagarDolares;

@synthesize nroTarjeta, fechaVencimiento;


+ (CreditCardResumen *) getResumenWithNumber:(NSString *)number {
	
 	WS_ConsultarUltimoResumenTC * request = [[WS_ConsultarUltimoResumenTC alloc] init];
#if WSDEBUG
    return [request getDebugResponse];
#endif
	Context *context = [Context sharedContext];
	
	request.userToken = [context getToken];
	
	request.codBanco = context.banco.idBanco;
	
	//request.tipoDoc = context.tipoDoc;
	
	//request.nroDoc = context.dni;
    
    request.tipoDoc = context.usuario.tipoDocumento;
    
    request.nroDoc = context.usuario.nroDocumento;
	
	request.nroTarjeta = number;
	
	CreditCardResumen *res = [WSUtil execute:request];

	return res;
	
}

/*
+ (NSArray *) getResumenes:(NSString *)token {
	
  	ConsultarUltimoResumenTC * request = [[ConsultarUltimoResumenTC alloc] init];
	
	Context *context = [Context sharedContext];
	
	request.token = [context getToken];
	
	request.codBanco = context.codigoBanco;
	
	request.tipoDoc = context.tipoDoc;
	
	request.nroDoc = context.dni;
	
	NSMutableArray *res = [WSUtil execute:request];
	
	return res;
	
}
 */

+ (CreditCardResumen *) parseResumen:(GDataXMLElement *)wsResumen {
	
	CreditCardResumen *res = [[CreditCardResumen alloc] init];

	res.fechaVencimiento = [WSUtil getStringProperty:@"fechaVencimiento" ofSoap:wsResumen];

	res.minAPagarDolares = [WSUtil getStringProperty:@"minDolares" ofSoap:wsResumen];

	res.minAPagarPesos = [WSUtil getStringProperty:@"minPesos" ofSoap:wsResumen];

	res.nroTarjeta = [WSUtil getStringProperty:@"numero" ofSoap:wsResumen];

	res.totalAPagarDolares = [WSUtil getStringProperty:@"totalDolares" ofSoap:wsResumen];

	res.totalAPagarPesos = [WSUtil getStringProperty:@"totalPesos" ofSoap:wsResumen];

	return res;
	
}

/*
+ (NSMutableArray *) parseResumenes:(GDataXMLElement *)resumenSoap {
	
	NSArray *resumenesSoap = [resumenSoap elementsForName:@"ResumenTarjetaMobile"];
	
	NSMutableArray *resumenes = [[NSMutableArray alloc] init];
	
	for (GDataXMLElement *soap in resumenesSoap) {
		
		[resumenes addObject:[self parseResumen:soap]];
		
	}
	
	return resumenes;
	
}
 */

@end
