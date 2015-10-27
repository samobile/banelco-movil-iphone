
#import "Ticket.h"
#import "WSUtil.h"

@implementation Ticket

@synthesize fiid, bancoDestino, empresa, fechaPago, moneda, nroSecuencia;
@synthesize nroTransaccion, cuenta, canal, cuentaDestino;
@synthesize clienteId, cbuDestino, nroControl, importe;


+ (Ticket *) parseTicketTransf:(GDataXMLElement *)soapObject {
	
	Ticket *ticket = [[Ticket alloc] init];

	ticket.bancoDestino = [WSUtil getStringProperty:@"bancoDestino" ofSoap:soapObject];

	ticket.canal = [WSUtil getStringProperty:@"canal" ofSoap:soapObject];

	ticket.cbuDestino = [WSUtil getStringProperty:@"cbuDestino" ofSoap:soapObject];

	ticket.clienteId = [WSUtil getStringProperty:@"clienteId" ofSoap:soapObject];

	ticket.cuenta = [WSUtil getStringProperty:@"cuenta" ofSoap:soapObject];

	ticket.cuentaDestino = [WSUtil getStringProperty:@"cuentaDestino" ofSoap:soapObject];

	ticket.empresa = [WSUtil getStringProperty:@"empresa" ofSoap:soapObject];

	ticket.fechaPago = [WSUtil getStringProperty:@"fechaPago" ofSoap:soapObject];

	ticket.fiid = [WSUtil getStringProperty:@"fiid" ofSoap:soapObject];

	ticket.importe = [WSUtil getStringProperty:@"importe" ofSoap:soapObject];

	ticket.moneda = [WSUtil getStringProperty:@"moneda" ofSoap:soapObject];

	ticket.nroControl = [WSUtil getStringProperty:@"nroControl" ofSoap:soapObject];

	ticket.nroTransaccion = [WSUtil getStringProperty:@"nroTransaccion" ofSoap:soapObject];

	return ticket;
	
}

+ (Ticket *) parseTicketPago:(GDataXMLElement *)soapObject nroSecuencia:(int)nroSecuencia {
	
	Ticket *ticket = [[Ticket alloc] init];

	ticket.canal = [WSUtil getStringProperty:@"canal" ofSoap:soapObject];

	ticket.clienteId = [WSUtil getStringProperty:@"clienteId" ofSoap:soapObject];

	ticket.cuenta = [WSUtil getStringProperty:@"cuenta" ofSoap:soapObject];

	ticket.empresa = [WSUtil getStringProperty:@"empresa" ofSoap:soapObject];

	ticket.fechaPago = [WSUtil getStringProperty:@"fechaPago" ofSoap:soapObject];

	ticket.fiid = [WSUtil getStringProperty:@"fiid" ofSoap:soapObject];

	ticket.importe = [WSUtil getStringProperty:@"importe" ofSoap:soapObject];

	ticket.moneda = [WSUtil getStringProperty:@"moneda" ofSoap:soapObject];
	
	ticket.nroControl = [WSUtil getStringProperty:@"nroControl" ofSoap:soapObject];
	
	ticket.nroTransaccion = [WSUtil getStringProperty:@"nroTransaccion" ofSoap:soapObject];
	
	ticket.nroSecuencia = nroSecuencia;

	return ticket;
	
}

- (NSComparisonResult)compare:(id)otroTicket {
	
	NSString *fechaUno = [self.fechaPago stringByReplacingOccurrencesOfString:@"/" withString:@""];
	NSString *fechaDos = [((Ticket *)otroTicket).fechaPago stringByReplacingOccurrencesOfString:@"/" withString:@""];
	
	NSString *anioUno = [fechaUno substringWithRange:NSMakeRange(4, 4)];
	NSString *anioDos = [fechaDos substringWithRange:NSMakeRange(4, 4)]; 
	NSString *mesUno = [fechaUno substringWithRange:NSMakeRange(2, 2)];
	NSString *mesDos = [fechaDos substringWithRange:NSMakeRange(2, 2)]; 
	NSString *diaUno = [fechaUno substringWithRange:NSMakeRange(0, 2)];
	NSString *diaDos = [fechaDos substringWithRange:NSMakeRange(0, 2)]; 
	
	long numeroUno = strtoull([[NSString stringWithFormat:@"%@%@%@",anioUno,mesUno,diaUno] UTF8String], NULL, 0);
	long numeroDos = strtoull([[NSString stringWithFormat:@"%@%@%@",anioDos,mesDos,diaDos] UTF8String], NULL, 0);
		
	if (numeroDos > numeroUno) {
		
		return NSOrderedDescending;
		
	} else if (numeroUno > numeroDos) {
		
		return NSOrderedAscending;
		
	} else {
		
		return NSOrderedSame;
		
	}
	
}

- (NSString *) toString {
	return [NSString stringWithFormat:@"%@ %@ %@", fechaPago, moneda, importe];
}

@end
