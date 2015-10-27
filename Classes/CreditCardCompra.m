
#import "CreditCardCompra.h"
#import "WSUtil.h"
#import "WS_ConsultarUltimasComprasTC.h"

@implementation CreditCardCompra

@synthesize nroTarjeta, valor, fechaCompra, concepto, dolares;


+ (NSMutableArray *) getUltimasCompras:(NSString *)token withNumber:(NSString *)number {

	WS_ConsultarUltimasComprasTC * request = [[WS_ConsultarUltimasComprasTC alloc] init];
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
	
	NSMutableArray *compras = [WSUtil execute:request];
	
	return compras;
	
}

+ (NSMutableArray *) parse:(GDataXMLElement *)soapObject {
	
	NSMutableArray *compras = [[NSMutableArray alloc] init];
	
	NSString *codigo = [WSUtil getStringProperty:@"codigoTarjeta" ofSoap:soapObject];
	
	NSArray *comprasSoap = [[[soapObject elementsForName:@"compras"] objectAtIndex:0] elementsForName:@"CompraTarjetaCreditoDTO"];
	
	for (GDataXMLElement *soap in comprasSoap) {
		
		CreditCardCompra *c = [[CreditCardCompra alloc] init];
		c.nroTarjeta = codigo;
		c.concepto = [WSUtil getStringProperty:@"descripcion" ofSoap:soap];
		c.fechaCompra = [WSUtil getStringProperty:@"fecha" ofSoap:soap];
		c.valor = [WSUtil getStringProperty:@"pesos" ofSoap:soap];
        if (c.valor) {
            c.valor = [c.valor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }
		c.dolares = [WSUtil getStringProperty:@"dolares" ofSoap:soap];
        if (c.dolares) {
            c.dolares = [c.dolares stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }
        
		[compras addObject:c];
		[c release];
	}

	return compras;
	
}


@end
