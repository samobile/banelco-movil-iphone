//
//  UpdateManager.m
//  BanelcoMovilIphone
//
//  Created by German Levy on 9/25/10.
//  Copyright 2010 -. All rights reserved.
//

#import "UpdatesManager.h"
#import "Context.h"
#import "CommonUIFunctions.h"
#import "MenuOptionsHelper.h"
#import "CommonFunctions.h"

@implementation UpdatesManager

int const NIVELES_VERSION = 3;

int const NEW_VERSION = 1;

int const SAME_VERSION = 2;

int const CONN_ERROR = 3;


- (id)init {
    if ((self = [super init])) {
		obtenerMenues = FALSE;
    }
    return self;
}


/**
 * Controla si existe una nueva version de la aplicacion. Se conecta a la
 * url, descarga el numero de version del servidor y lo controla con la
 * version actual.
 * 
 * @return <code>True</code> si el nuevo numero de version es mayor que el
 *         actual. <code>False</code> en caso contrario.
 * @throws IOException
 * 
 */
- (int) existNewVersion {
	
	int state = SAME_VERSION;
	
	@try {
		
		NSString *env = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"Environment"];
		
		NSString *urlVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:
										[NSString stringWithFormat:@"urlVersion_%@",env]];
		
		
		NSString *newVersionStr = [self procesarRespuesta:urlVersion];
		
		if (newVersionStr) {
			
			NSString *actualVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
			
			if ([self newVersion:newVersionStr withActualVersion:actualVersion]) {
				state = NEW_VERSION;
			}
		}
		else {
			[CommonUIFunctions showAlert:@"Reintentar" withMessage:@"La aplicación requiere de una validación de versión para continuar con su funcionamiento" andCancelButton:@"Cerrar"];
			state = CONN_ERROR;
		}

		
	} @catch (NSException *e) {
		[CommonUIFunctions showAlert:@"Reintentar" withMessage:@"La aplicación requiere de una validación de versión para continuar con su funcionamiento" andCancelButton:@"Cerrar"];
		state = CONN_ERROR;
		
	}
	
	// Request de personalizacion de menues para BanelcoMovil
	if(obtenerMenues) {
		[self obtenerMenues];
	}
	
	return state;
}


- (NSString *)procesarRespuesta:(NSString *)url {

	NSString *response = [self procesarRequestHTTP:url];
//    NSString *txtFilePath = [[NSBundle mainBundle] pathForResource:@"updateiphoneBSTN" ofType:@"txt"];
//    NSString *response = [NSString stringWithContentsOfFile:txtFilePath encoding:NSUTF8StringEncoding error:NULL];
	return [self procesarUpdate:response];

}




- (NSString *)procesarRequestHTTP:(NSString *)urlString {

    NSString *urlString2 = [NSString stringWithFormat:@"%@?%@", urlString, [CommonFunctions dateToNSStringCache:[NSDate date]]];
	NSURL *url = [NSURL URLWithString:urlString2];
	
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:60.0] ;
	
	NSURLResponse *response = [[[NSURLResponse alloc] init] autorelease];
	NSError *error = [[NSError alloc] init];
	NSData *data = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error]; 
	
	return [[NSString alloc] initWithBytes: [data mutableBytes] length:[data length] encoding:NSUTF8StringEncoding];

}

- (BOOL) newVersion:(NSString *)newVersionStr withActualVersion:(NSString *)actualVersion {
	
	BOOL result = FALSE;

	NSArray *valNewVersion = [newVersionStr componentsSeparatedByString:@"."];
	NSArray *valActualVersion = [actualVersion componentsSeparatedByString:@"."];
	
	for (int i = 0; i < NIVELES_VERSION; i++) {
		
		int valorNew = [(NSString *)[valNewVersion objectAtIndex:i] intValue];
		int valorActual = [(NSString *)[valActualVersion objectAtIndex:i] intValue];
		
		BOOL dist = valorNew != valorActual;
		
		if (dist) {
			// Si los valores no son iguales termino la comparacion
			result = valorNew > valorActual;
			break;
		}
		
		// Si los valores son iguales comparo el siguiente valor.
	}
	
	return result;
}

/**
 * Procesa el archivo Update.txt
 * Linea 0: Versión de la aplicación
 * Linea 1: Códigos de bancos
 * Linea 2: Nombre de Imagenes, se relaciona la imagen con el codigo por la posición
 * Linea 3: Tiempo maximo de sesión
 * Linea 4: Tiempo máximo de inactividad
 * Linea 5: Mascaras de cuentas de cada banco.
 * Linea 6: Nombres de bancos
 * Linea 7: AppOrigen
 * Linea 8: Opciones deshabilitadas por banco
 * Linea 9: Códigos de telefónicas
 * Linea 10: Nombres código de telefónicas
 * Linea 11: Indica si la versión es mandatoria
 * Linea 12: Url desde donde descargar la nueva version de la aplicacion
 *
 * Linea 13: Fecha expiracion aplicacion (ICBC Movil)
 * Linea 14: Habilita funcionalidad del parametro anterior (1 - 0)
 *
 * Linea 15: Codigos de bancos habilitados para recarga de celular no registrado
 * Linea 16: Nombre de operadoras recarga (necesario si se usa linea anterior y segun los codigos de recarga de linea 10)
 * Linea 17: Habilita escaneo
 * @param String
 *            datosStr,
 * @author gpolonsky
 * @return String
 * 			version de la aplicación
 */
- (NSString*) procesarUpdate:(NSString *)datosStr {
	
	/**Constantes para identificar las filas**/
	int const idxCodigos = 1;
	int const idxImagenes = 2;
	int const idxTiempoSession = 3;
	int const idxTiempoInactividad = 4;
	int const idxMascaras = 5;
	int const idxNombreBancos = 6;
	int const idxaAppOrigen = 7;
	int const idxPersonalizacion = 8;
	// Agregados version 1.5.0
	int const idxCodigoCarriers = 9;
	int const idxNombreCodCarriers = 10;
	int const idxAppOpcional = 11;
	int const idxUrlVersion = 12;
    //Bimo
    //int const idxTiempoInactividadBimo = 13;
    //int const idxListaBancosBimo = 14;
    
    int const idxFechaExpiracion = 13;
    int const idxExpiracionHabilitada = 14;
    
    int const idxBancosNuevaRecarga = 15;
    int const idxNombreCarriers = 16;
    
    int const idxScan = 17;

	
	Context *context = [Context sharedContext];
	NSString *version = nil;
	NSArray *param = [datosStr componentsSeparatedByString:@"\n"];
	
	version = [param objectAtIndex:0]; 
	
	context.bankCodes = [[param objectAtIndex:idxCodigos] componentsSeparatedByString:@","];
	context.bankNames = [[param objectAtIndex:idxNombreBancos] componentsSeparatedByString:@","];
	context.bankCount = [context.bankCodes count];
	
	@try {
        
		context.carrierCodes = [[[param objectAtIndex:idxCodigoCarriers] stringByReplacingOccurrencesOfString:@"\r" withString:@""] componentsSeparatedByString:@","];
		context.carrierCodeNames = [[[param objectAtIndex:idxNombreCodCarriers] stringByReplacingOccurrencesOfString:@"\r" withString:@""] componentsSeparatedByString:@","];
	} @catch (NSException *e) {
		context.carrierCodes = nil;
		context.carrierCodeNames = nil;
	}
	
	context.nombreImagenBancos = [[param objectAtIndex:idxImagenes] componentsSeparatedByString:@","];
	
	@try {
		//En el update.txt estan los tiempos de sesion e inactividad maximos, en minutos.
		//Si no estan se declaran por default en el Context 30 y 15 min.
        long maxSessionTime = [[param objectAtIndex:idxTiempoSession] longLongValue];
        long maxInactivityTime = [[param objectAtIndex:idxTiempoInactividad] longLongValue];
        
        long maxInactivityTimeBimo = 15;
//        if ([param count] > idxTiempoInactividadBimo) {
//            maxInactivityTimeBimo = [[param objectAtIndex:idxTiempoInactividadBimo] longLongValue];
//        }
        
		//Asigno en el contexto los tiempos en segundos, hago la conversion 
		//correspondiente de minutos a segundos
		context.maxSessionTime = maxSessionTime*60;
		context.maxInactivityTime = maxInactivityTime*60;
        
        context.maxInactivityTimeBimo = maxInactivityTimeBimo*60;
		
	} @catch (NSException *e) {
		context.maxSessionTime = 1800;
		context.maxInactivityTime = 900;
        
        context.maxInactivityTimeBimo = 15*60;
	}
    
    @try {
        if ([param count] > idxFechaExpiracion) {
            NSString *f = [param objectAtIndex:idxFechaExpiracion];
            if (f) {
                f = [f stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                [df setDateFormat:@"dd/MM/yyyy"];
                context.expirationDate = [df dateFromString:f];
                [df release];
            }
        }
        if ([param count] > idxExpiracionHabilitada) {
            NSString *e = [param objectAtIndex:idxExpiracionHabilitada];
            e = [e stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            context.expirationEnabled = [e isEqualToString:@"1"] ? YES : NO;
        }
        
    } @catch (NSException *e) {
        context.expirationDate = nil;
        context.expirationEnabled = NO;
    }
    
    @try {
		//context.listaBancosBimo = [param objectAtIndex:idxListaBancosBimo];
        context.listaBancosBimo = @"";
		
	} @catch (NSException *e) {
		context.listaBancosBimo = @"";
	}
	
	NSArray *mascaras = [[param objectAtIndex:idxMascaras] componentsSeparatedByString:@","];
	context.mascaraCuentas = [[NSMutableDictionary alloc] init];
	for (int i = 0; i < [mascaras count] && i < [context.bankCodes count]; i++) {
		[context.mascaraCuentas setObject:[mascaras objectAtIndex:i] forKey:[context.bankCodes objectAtIndex:i]];
	}
	
	//AppOrigen
	if ([[param objectAtIndex:idxaAppOrigen] hasPrefix:@"appOrigen"]) { 
		context.appOrigen = [[[param objectAtIndex:idxaAppOrigen] componentsSeparatedByString:@"="] objectAtIndex:1];
	}
	
	/* Personalizacion por banco. */
	NSString *currentBanco = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"Personalizacion"] objectForKey:@"idBanco"];
	
	// Se usa el sig. if tambien para modificar el menu de la aplicacion no personalizada.
	
	/* Si existe la propiedad es una personalizacion para un banco en particular. */
	if (currentBanco) {
		[self personalizarMenu:idxPersonalizacion fromParams:param forBanco:currentBanco];
		
		/* Si no, se hace request del listado menues bancos, para personalizar los menues
		 * cuando se haya seleccionado un banco de la lista. */
	} else {
		obtenerMenues = YES;
		context.opcionesDeMenu = [[[param objectAtIndex:idxPersonalizacion] componentsSeparatedByString:@"="] objectAtIndex:1];
	}
	
	@try {
		if ([[param objectAtIndex:idxAppOpcional] hasPrefix:@"appOpcional"]) { 
			context.appOpcional = [[[[param objectAtIndex:idxAppOpcional] componentsSeparatedByString:@"="] objectAtIndex:1] copy];
		}
		if ([[param objectAtIndex:idxUrlVersion] hasPrefix:@"urlVersion"]) { 
			context.urlVersion = [[[[param objectAtIndex:idxUrlVersion] componentsSeparatedByString:@"="] objectAtIndex:1] copy];
		}
	} @catch (NSException *e) {
		context.appOpcional = nil;
		context.urlVersion = nil;
	}
    
    @try {
        
        
        context.carrierNames = [[[param objectAtIndex:idxNombreCarriers] stringByReplacingOccurrencesOfString:@"\r" withString:@""] componentsSeparatedByString:@","];
    } @catch (NSException *e) {
        context.carrierNames = context.carrierCodeNames;
    }
	
    @try {
        context.nuevaRecarga = NO;
        NSArray *codigos = [[[param objectAtIndex:idxBancosNuevaRecarga] stringByReplacingOccurrencesOfString:@"\r" withString:@""] componentsSeparatedByString:@","];
        for (NSString *cod in codigos) {
            if ([[cod uppercaseString] isEqualToString:[context.banco.idBanco uppercaseString]]) {
                context.nuevaRecarga = YES;
                break;
            }
        }
    } @catch (NSException *e) {
        context.nuevaRecarga = NO;
    }
    
    @try {
        context.scanEnabled = ([[param objectAtIndex:idxScan] intValue] == 1);
    } @catch (NSException *e) {
        context.scanEnabled = NO;
    }
    
	return version;
}

/**
* Filtra las opciones de menu que se excluyen, según personalicación
* de banco o de Banelco.
* 
* @param idPers
*            int con el indice del parametro con la personalización.
* @param param
*            NSArray * con los parametros obtenidos del correspondiente update.txt.
* @param nombrePers
*            NSString * con el nombre código de la personalización.
* 
* @return
* 	 void.	
* 
*/
- (void) personalizarMenu:(int)idPers fromParams:(NSArray *)param forBanco:(NSString *)nombrePers {
	
   NSString *opcionesDeMenu = nil;
	
   for (int i = idPers; (i < [param count]) && (opcionesDeMenu == nil); i++) {
	   
	   if ([[param objectAtIndex:i] hasPrefix:nombrePers]) { 
		   opcionesDeMenu = [[[param objectAtIndex:i] componentsSeparatedByString:@"="] objectAtIndex:1];
	   }
	   
   }
   
   /*if (opcionesDeMenu == nil) {
	   if (nombrePers.equals("BANE"))
		   throw new IllegalArgumentException("No existe la configuraciÛn para Banelco.");
	   else
		   throw new IllegalArgumentException("No existe la configuraciÛn para el banco que intenta operar.");
   }*/
   
	/* Si encontro la personalizacion para el banco requerido. */
	NSArray *desabilitados = [opcionesDeMenu componentsSeparatedByString:@","];
	
	NSMutableArray *options = [[NSMutableArray alloc] init];
	/*
	* Creo una coleccion que contiene los menus desabilitados e
	* instancio un filtro de menu.
	*/
	for (int i = 0; i < [desabilitados count]; i++) {
		if (![[desabilitados objectAtIndex:i] isEqualToString:@""]) {
			[options addObject:[desabilitados objectAtIndex:i]];
		}
	}
	
	[[MenuOptionsHelper sharedMenuHelper] initOptions:options];
}


- (void) obtenerMenues {
	
	NSString *env = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"Environment"];
	
	Context *context = [Context sharedContext];
	NSString *urlMenues = [[NSBundle mainBundle] objectForInfoDictionaryKey:
								[NSString stringWithFormat:@"urlMenues_%@",env]];
	
	@try {
		NSString *menuesStr = [self procesarRequestHTTP:urlMenues];
		context.menuesBancos = [menuesStr componentsSeparatedByString:@"\n"];
		
		if (context.menuesBancos) {
			[self personalizarMenu:context.menuesBancos forBanco:context.banco.idBanco];
		}
		
		
	} @catch (NSException *e) {
		//System.out.println("--------obtenerMenues():IOException");
		// Wrap al problema de los menues 28/01/2010 //////////////////////////////
		//context.menuesBancos = new String[] {Context.opcionesDeMenu};
		//////////////////////////////////////////////////////////////////////////
		
	}
	
}
							   
/**
* Filtra las opciones de menu que se excluyen, según banco elegido manualmente.
* 
* @param param
*            NSArray * con los parametros obtenidos del listado de todos los bancos.
* @param nombrePers
*            NSString * con el nombre código del banco seleccionado.
* 
* @return
* 	 void.	
* 
*/
- (void) personalizarMenu:(NSArray *)param forBanco:(NSString *)nombrePers {
   
	NSString *pers = @"BANE";
				
	for (int i = 0; i < [param count]; i++) {
		   
		if ([[param objectAtIndex:i] hasPrefix:nombrePers]) {
			pers = nombrePers;
			break;
		}
	   
	}
		
	[self personalizarMenu:0 fromParams:param forBanco:pers];
   
}


// NUEVA REGISTRACION

- (BOOL) obtenerRegistracion {

	NSString *env = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"Environment"];
	
	Context *context = [Context sharedContext];
	NSString *urlRegis = [[NSBundle mainBundle] objectForInfoDictionaryKey:
						   [NSString stringWithFormat:@"urlRegis_%@",env]];
	
	@try {
		NSString *regisStr = [self procesarRequestHTTP:urlRegis];
		context.condRegistracion = [NSString stringWithString:regisStr];
		
		return true;
		
	} @catch (NSException *e) {
		return false;
	}
	
}

- (BOOL) usaNuevaRegistracion:(NSString *) codBanco {

	if([[Context sharedContext] condRegistracion]) {
	
		NSArray *condiciones = [[[Context sharedContext] condRegistracion] componentsSeparatedByString:@"\n"];
		
		for (int i=0; i < [condiciones count]; i++) {
			NSString *linea = [condiciones objectAtIndex:i];
			if([linea hasPrefix:codBanco]) {
				NSString *cond = [[linea componentsSeparatedByString:@"="] objectAtIndex:1];
				return [cond hasPrefix:@"true"];
			}
		}
		
	}
	return false;
	
}

@end
