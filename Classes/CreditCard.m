
#import "CreditCard.h"
#import "WS_ConsultarDisponiblesTC.h"
#import "WSUtil.h"
#import "Context.h"
#import "GDataXMLNode.h"
#import "WS_ConsultarTarjetas.h"
#import "WS_ConsultarTarjetasVisa.h"

@implementation CreditCard

@synthesize codigo, numero, nombre;

@synthesize disponibleAdelanto, fechaVencimiento;

@synthesize saldoPesos, pagoMinimo, saldoDolares;

@synthesize fechaProxCierre, fechaProxVenc, fechaCierreActual;


+ (CreditCard *) parseCreditCard:(GDataXMLElement *)creditCardSoap {
	
	CreditCard *card = [[CreditCard alloc] init];
	
	card.codigo = [WSUtil getStringProperty:@"codigo" ofSoap:creditCardSoap];
	
	card.disponibleAdelanto = [[WSUtil getDecimalProperty:@"disponibleAdelanto" ofSoap:creditCardSoap] stringValue];
	
	card.fechaVencimiento = [WSUtil getStringProperty:@"fechaVencimiento" ofSoap:creditCardSoap];
	
	card.numero = [WSUtil getStringProperty:@"numero" ofSoap:creditCardSoap];
	
	card.nombre = [WSUtil getStringProperty:@"nombre" ofSoap:creditCardSoap];
	
	card.pagoMinimo = [[WSUtil getDecimalProperty:@"pagoMinimo" ofSoap:creditCardSoap] stringValue];
	
	card.saldoDolares = [[WSUtil getDecimalProperty:@"saldoDolares" ofSoap:creditCardSoap] stringValue];
	
	card.saldoPesos = [[WSUtil getDecimalProperty:@"saldoPesos" ofSoap:creditCardSoap] stringValue];
 	return card;
	
}

+ (NSArray *) parseCreditCards:(GDataXMLElement *)creditCardsSoap {
	
	NSMutableArray *creditCards = [[NSMutableArray alloc] init];
	
	NSArray *soaps = [creditCardsSoap elementsForName:@"TarjetaCreditoMobileDTO"];
	
	for(GDataXMLElement *cc in soaps) {
		
		[creditCards addObject:[self parseCreditCard:cc]];
		
	}
	
	return creditCards;
	
}

+ (CreditCard *) parseCreditCardVisa:(GDataXMLElement *)creditCardSoap {
	
	CreditCard *card = [[CreditCard alloc] init];

	card.numero = [WSUtil getStringProperty:@"numero" ofSoap:creditCardSoap];

	card.nombre = [WSUtil getStringProperty:@"titular" ofSoap:creditCardSoap];
    
    
 


	return card;
	
}

+ (NSMutableArray *) parseCreditCardsVisa:(GDataXMLElement *)creditCardsSoap {
	
	NSMutableArray *creditCards = [[NSMutableArray alloc] init];
	
	NSArray *soaps = [creditCardsSoap elementsForName:@"Tarjeta"];
	
	for(GDataXMLElement *cc in soaps) {
		
		[creditCards addObject:[self parseCreditCardVisa:cc]];
		
	}
	
	return creditCards;
	
}

+ (NSArray *) getSaldo:(NSString *)token {

	WS_ConsultarTarjetas * request = [[WS_ConsultarTarjetas alloc] init];
	
	Context *context = [Context sharedContext];
	
	request.userToken = [context getToken];
	
	NSMutableArray *tarjetas = [WSUtil execute:request];
	
	return tarjetas;
	
}

+ (NSArray *) getVisas:(NSString *)token {
    
	WS_ConsultarTarjetasVisa * request = [[WS_ConsultarTarjetasVisa alloc] init];

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
	
	NSMutableArray *visas = [WSUtil execute:request];

	return visas;
	
}

+ (CreditCardDisponibles *) getDisponibles:(NSString *)token withNumber:(NSString *)number{
	
	WS_ConsultarDisponiblesTC * request = [[WS_ConsultarDisponiblesTC alloc] init];
	
	Context *context = [Context sharedContext];
	
	request.userToken = [context getToken];
	
	request.codBanco = context.banco.idBanco;
	
	//request.tipoDoc = context.tipoDoc;
	
	//request.nroDoc = context.dni;
    
    request.tipoDoc = context.usuario.tipoDocumento;
    
    request.nroDoc = context.usuario.nroDocumento;
	
	request.nroTarjeta = number;
	
	CreditCardDisponibles *disponibles = [WSUtil execute:request];
	
	return disponibles;
}

+ (CreditCardDisponibles *) getDisponibles:(NSString *)token {
	
	WS_ConsultarDisponiblesTC * request = [[WS_ConsultarDisponiblesTC alloc] init];
	
	Context *context = [Context sharedContext];
	
	request.userToken = [context getToken];
	
	request.codBanco = context.banco.idBanco;
	
	request.tipoDoc = context.tipoDoc;
	
	request.nroDoc = context.dni;
	
	request.nroTarjeta = context.visaSeleccionada.numero;
	
	CreditCardDisponibles *disponibles = [WSUtil execute:request];
	
	return disponibles;
}

- (void)dealloc {
    
    self.fechaProxCierre = nil;
    self.fechaProxVenc = nil;
    self.fechaCierreActual = nil;
    [super dealloc];
}

@end
