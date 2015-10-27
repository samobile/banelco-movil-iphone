#import "Context.h"

static NSMutableArray *cuentas = nil;

//sea (Transferencias -> Otras Ctas, Agenda)
static NSMutableArray *cuentasCBU = nil;

static Banco *bancoAnt = nil;
static NSString *listaBimo = nil;

@implementation Context

@synthesize bankCount, bankCodes, bankNames, nombreImagenBancos;

@synthesize bancosSeleccionados, bancosNoSeleccionados;

@synthesize specialDigits;

@synthesize maxSessionTime, maxInactivityTime, appOrigen;

@synthesize menuesBancos, opcionesDeMenu, condRegistracion;

@synthesize applicationName;

@synthesize token, tipoDoc, dni, banco, usuario;

@synthesize visaSeleccionada;

@synthesize productos, rubros, cuentas, selectedCuenta;

@synthesize deudas, selectedDeuda;

@synthesize startAppHour, lastActivityHour;

@synthesize mascaraCuentas;

//sea
@synthesize carrierCodes, carrierCodeNames;
@synthesize appOpcional, urlVersion, allowRequest;
@synthesize conceptos;

//personalizacion
@synthesize personalizado;

//Bimo
@synthesize maxInactivityTimeBimo;
@synthesize listaBancosBimo, cuentasCBU;

@synthesize expirationDate, expirationEnabled, carrierNames;


static Context * _sharedContext = nil;

- (void)resetContext {
    if (_sharedContext.usuario) {
        _sharedContext.usuario = nil;
    }
    if (_sharedContext.cuentas) {
        [_sharedContext.cuentas release];
        _sharedContext.cuentas = nil;
    }
    if (_sharedContext.cuentasCBU) {
        [_sharedContext.cuentasCBU release];
        _sharedContext.cuentasCBU = nil;
    }
    if (bancoAnt) {
        [bancoAnt release];
        bancoAnt = nil;
    }
    bancoAnt = [_sharedContext.banco retain];
    if (listaBimo) {
        [listaBimo release];
        listaBimo = nil;
    }
    listaBimo = [_sharedContext.listaBancosBimo retain];
    if (_sharedContext) {
        [_sharedContext release];
        _sharedContext = nil;
    }
    if (_sharedContext.expirationDate) {
        _sharedContext.expirationDate = nil;
    }
}

+ (Context *)sharedContext {
	
	@synchronized([Context class])
	{
		if (!_sharedContext) {
			[[self alloc] init];
		}
		
		return _sharedContext;
	}
	
	return nil;
}

+ (id)alloc {
	
	@synchronized([Context class])
	{
		NSAssert(_sharedContext == nil, @"Attempted to allocate a second instance of a singleton.");
		_sharedContext = [super alloc];
		return _sharedContext;
	}
	
	return nil;
}

-(id) init {
	if (self = [super init]) {
		
        if (bancoAnt) {
            self.banco = bancoAnt;
            [bancoAnt release];
            bancoAnt = nil;
        }
        
		self.bankCount = 0;
		
		self.maxSessionTime = 1800;
		self.maxInactivityTime = 900;
        
        //Bimo
        self.maxInactivityTimeBimo = 1800;
		
		self.specialDigits = @"XXXX";
		
		allowRequest = YES;
        
        self.listaBancosBimo = @"";
        if (listaBimo) {
            self.listaBancosBimo = listaBimo;
            [listaBimo release];
            listaBimo = nil;
        }
		
		//personalizacion
		self.personalizado = ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"Personalizacion"]?YES:NO);
		
		NSString *str;
		if (self.personalizado) {
			applicationName = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"Personalizacion"] objectForKey:@"AppName"];
		}
		else {
			applicationName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
		}
        
        self.expirationDate = nil;
        self.expirationEnabled = NO;
        
        self.scanEnabled = NO;
		
	}
	return self;
}


+(void) initialize {
	[super initialize];
  //  if (!cuentas)
//	    cuentas = [[NSMutableArray alloc] init];
}

+(NSMutableArray *)getCuentas {

		return cuentas;
}

+(NSMutableArray *)getCuentas:(int)codMoneda {
	
	if (!cuentas || codMoneda < 0) {
		return nil;
	}
	
	NSMutableArray *cuentasFiltradas = [[NSMutableArray alloc] init];
	
	for (Cuenta *cuenta in cuentas) {
		if (cuenta.codigoMoneda == codMoneda) {
			[cuentasFiltradas addObject:cuenta];
		}
	}
	return cuentasFiltradas;
}

+(NSMutableArray *)getCuentasCBU {
	
	//TEST!!!
//	if (!cuentasCBU) {
//		cuentasCBU = [[NSMutableArray alloc] init];
//		Cuenta *c = [[Cuenta alloc] init];
//		c.accountType = C_CBU;
//		c.cuit = @"234527714";
//		c.codigo = @"1231231231231";
//		c.nombre = @"Nombre 1";
//		c.propia = @"false";
//		[cuentasCBU addObject:c];
//		
//		c = [[Cuenta alloc] init];
//		c.accountType = C_CBU;
//		c.cuit = @"219863421";
//		c.codigo = @"8971241343566";
//		c.nombre = @"Nombre 2";
//		c.propia = @"false";
//		[cuentasCBU addObject:c];
//		
//	}
	
	return cuentasCBU;
}

+(void)setCuentasCBU:(NSMutableArray *)ctas {
	cuentasCBU = ctas;
}

+(void)setCuentas:(NSMutableArray *)ctas {
	NSLog(@"cantidad de cuentas = %d",[ctas count]);
	cuentas = ctas;
}

- (BOOL)isLogued {

	if (!self.usuario) {
		return FALSE;
	}
	return TRUE;

}

- (NSString *)getToken {

	//          Logged :p
	if ([self isLogued]) {
		return self.usuario.token;
	}
	return nil;

}

//personalizacion
//devuelve valores por defecto para la generica.
- (UIColor *)UIColorFromRGBProperty:(NSString *)prop {
	
	NSString *hexStr;
	if (self.personalizado) {
		hexStr = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"Personalizacion"] objectForKey:prop];
		int rgbValue = 0;
		sscanf([hexStr UTF8String], "%x", &rgbValue);
		return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 
							   green:((float)((rgbValue & 0xFF00) >> 8))/255.0 
								blue:((float)(rgbValue & 0xFF))/255.0 
							   alpha:1.0];
	}
	else {
		if ([prop isEqualToString:@"DetalleBkgColor"]) {
			//return [UIColor whiteColor];
            return [UIColor colorWithRed:243/255 green:243/255 blue:244/255 alpha:0.1];
		}
		else if ([prop isEqualToString:@"DetalleTxtColor"]) {
			return [UIColor blackColor];
		}
		else if ([prop isEqualToString:@"ListaTxtColor"]) {
			return [UIColor blackColor];
		}
		else if ([prop isEqualToString:@"MenuTxtColor"]) {
			return [UIColor blackColor];
		}
		else if ([prop isEqualToString:@"TitleTxtColor"]) {
			return [UIColor whiteColor];
		}
		else if ([prop isEqualToString:@"TxtColor"]) {
			return [UIColor blackColor];
		}
	}

	return [UIColor blackColor];
}


@end
