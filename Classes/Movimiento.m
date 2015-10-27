
#import "Movimiento.h"
#import "Context.h"
#import "WSUtil.h"

@implementation Movimiento

@synthesize fechaMovimiento, importe, canal, nombre;


static NSString *fechaConsulta;

static NSString *saldo;


- (NSString *) getDescripcion {
	
  Context *context = [Context sharedContext];

  return [NSString stringWithFormat:@"%@ %@ %@%@", self.fechaMovimiento, self.nombre, context.selectedCuenta.simboloMoneda, self.importe];
	
}

+ (NSArray *) parseMovimientos:(GDataXMLElement *)arraySoap {
	
	NSArray *movimientosSoap = [arraySoap elementsForName:@"MovimientoCuentaMobileDTO"];

	NSMutableArray *movimientos = [[NSMutableArray alloc] init];

	for (GDataXMLElement * soap in movimientosSoap) {
		
		[movimientos addObject:[self parseMovimiento:soap]];
		
	}

	return movimientos;
	
}

+ (Movimiento *) parseMovimiento:(GDataXMLElement *)movimiento {
	
	Movimiento *mov = [[Movimiento alloc] init];

	mov.canal = [WSUtil getStringProperty:@"canal" ofSoap:movimiento];

	mov.fechaMovimiento = [WSUtil getStringProperty:@"fecha" ofSoap:movimiento];

	mov.importe = [[WSUtil getDecimalProperty:@"importe" ofSoap:movimiento] stringValue];

	mov.nombre = [WSUtil getStringProperty:@"nombre" ofSoap:movimiento];

	return mov;
	
}


- (NSComparisonResult)comparePorFecha:(Movimiento *)otroMovimiento
{
	NSString* fechaUno = [self.fechaMovimiento stringByReplacingOccurrencesOfString:@"/" withString:@""];
	NSString* fechaDos = [otroMovimiento.fechaMovimiento stringByReplacingOccurrencesOfString:@"/" withString:@""];

	NSString* anioUno = [fechaUno substringWithRange:NSMakeRange(4, 2)];
	NSString* anioDos = [fechaDos substringWithRange:NSMakeRange(4, 2)]; 
	NSString* mesUno = [fechaUno substringWithRange:NSMakeRange(2, 2)];
	NSString* mesDos = [fechaDos substringWithRange:NSMakeRange(2, 2)]; 
	NSString* diaUno = [fechaUno substringWithRange:NSMakeRange(0, 2)];
	NSString* diaDos = [fechaDos substringWithRange:NSMakeRange(0, 2)]; 
	
	
		
	long numeroUno = strtoull([[NSString stringWithFormat:@"%@%@%@",anioUno,mesUno,diaUno] UTF8String], NULL, 0);

	long numeroDos = strtoull([[NSString stringWithFormat:@"%@%@%@",anioDos,mesDos,diaDos] UTF8String], NULL, 0);

	NSLog(@"Comparo %n , %n", numeroUno,numeroDos);

	
	if (numeroDos>numeroUno){
				return NSOrderedDescending;
	}else if (numeroUno>numeroDos) {

		return NSOrderedAscending;
	}else{
		return NSOrderedSame;
	}
//	if (diff>0)
//	{
//		return NSOrderedDescending;
//	}
//	
//	if (diff<0)
//	{
//		return NSOrderedAscending;
//	}
//	
	
}





+ (NSString *)getFechaConsulta {
	return fechaConsulta;
}

+ (void)setFechaConsulta:(NSString *)fecha {
	fechaConsulta = fecha;
}

+ (NSString *)getSaldo {
	return saldo;
}

+ (void)setSaldo:(NSString *)s {
	saldo = s;
}

@end
