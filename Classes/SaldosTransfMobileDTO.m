
#import "SaldosTransfMobileDTO.h"
#import "Cuenta.h"
#import "Util.h"
#import "GDataXMLNode.h"
#import "WSUtil.h"

@implementation SaldosTransfMobileDTO

@synthesize saldo, disponible;

+ (SaldosTransfMobileDTO *) parseSaldosTransfMobileDTO:(GDataXMLElement *)dataSoap {
	
	SaldosTransfMobileDTO *res = [[SaldosTransfMobileDTO alloc] init];
	
	res.disponible = [[WSUtil getDecimalProperty:@"disponible" ofSoap:dataSoap] stringValue];
	
	res.saldo = [[WSUtil getDecimalProperty:@"saldo" ofSoap:dataSoap] stringValue];
	
	return res;
}

- (NSString *) getDescripcionSaldoTransf:(Cuenta *)cuenta {
	
	NSMutableString * desc = [[NSMutableString alloc] init];
	
	//se agrega el nro de cuenta al mesaje
	[desc appendFormat:@"%@", [cuenta getDescripcion]];
	
	[desc appendFormat:@"\n\nSaldo\n%@ %@", cuenta.simboloMoneda,[Util formatSaldo:self.saldo]];
	
	[desc appendFormat:@"\n\nDisponible para transferencias\n%@ %@", cuenta.simboloMoneda, [Util formatSaldo:self.disponible]];

	[desc appendString:@"\n\nS.E.U.O."];
	
	return desc;
}


@end
