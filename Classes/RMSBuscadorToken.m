
#import "RMSBuscadorToken.h"

@implementation RMSBuscadorToken

@synthesize codigoBanco, dni;


- (BOOL) matches:(NSString *)registro {
	
/*	String cadena = new String(registro);

	String[] record = Util.split(cadena, 3, '|');

	boolean coincideCodigo = record[0].equals(this.codigoBanco);

	boolean coincideDni = record[1].equals(this.dni);

	boolean buscoPorDni = this.dni != null;

	if (!coincideCodigo) {
		return false;
	}

	if (!buscoPorDni) {
		return true;
	}

	return coincideDni;
	*/
}

- (id *) init:(NSString *)codigoBanco dni:(NSString *)dni {
	
	if (self=[super init]) {
		self.codigoBanco = codigoBanco;

		self.dni = dni;
	}

	return self;
	
}

@end
