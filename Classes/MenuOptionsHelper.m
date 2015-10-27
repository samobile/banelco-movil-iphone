//
//  MenuOptionsHelper.m
//  BanelcoMovilIphone
//
//  Created by German Levy on 9/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MenuOptionsHelper.h"


@implementation MenuOptionsHelper

@synthesize disabledOptions;


// OPCIONES PRINCIPALES (PortalesList)
int const BANCA_MOVIL = 1;
int const PAGO_MIS_CUENTAS = 2;
int const RECARGA_MOVIL = 3;
int const CAMBIAR_CLAVE = 4;
int const AYUDA = 5;

// DENTRO DE BANCA MOVIL
int const CONSULTAS = 6;
int const PAGOS = 7;
int const TRANSFERENCIAS = 8;
int const TASAS_PLAZO_FIJO = 24;
int const SOLICITUD_PRODUCTO = 25;

// DENTRO DE CONSULTAS
int const SALDOS = 9;
int const ULTIMOS_MOVIMIENTOS = 10;
int const CONSULTA_CBU = 11;
int const TARJETAS_CREDITO = 12;
int const DISPONIBLE_EXTRACCION = 37;

// DENTRO DE TRANSFERENCIAS
int const CUENTAS_VINCULADAS = 13;
int const CUENTAS_CBU_AGENDADA = 14;
int const CONSULTAS_TRANSF = 15;

// DENTRO DE CONSULTAS_TRANSF
int const AGENDA = 16;
int const CONSULTA_ULTIMAS_TRANSF = 17;
int const SALDOS_Y_DISP_TRANSF = 18;

// DENTRO DE OTRAS_OPERACIONES
int const AVISOS = 19;
int const SALDOS_Y_DISPONIBLES = 20;
int const OTRAS_CUENTAS = 21;
int const OTRAS_TARJETAS = 22;
int const MIS_COMPROBANTES = 23;

// DENTRO DE TARJETAS_CREDITO
int const SALDOSTC = 26;
int const ULTIMO_RESUMEN = 27;
int const ULTIMAS_COMPRAS = 28;
int const DISPONIBLES = 29;
int const PAGO_TARJETA = 36;

//DENTRO DE RECARGA_MOVIL
int const MI_CELULAR = 30;
int const OTRO_NUMERO = 31;
int const TARJETA_SUBE = 32;

// DENTRO DE EXTRACCIONES
int const EXTRACCION_PROPIA = 38;
int const EXTRACCION_TERCERO = 39;
int const EXTRACCION_CONSULTA = 40;

static MenuOptionsHelper * _sharedHelper = nil;


+(MenuOptionsHelper *)sharedMenuHelper
{
	@synchronized([MenuOptionsHelper class])
	{
		if (!_sharedHelper)
			_sharedHelper = [[self alloc] init];
		
		return _sharedHelper;
	}
	
	return nil;
}

- (void)initOptions:(NSMutableArray *)options {
	
	self.disabledOptions = options;
	
}

- (BOOL)isEnabled:(int)option {

	if(!self.disabledOptions) {
		//@throw [NSException exceptionWithName:@"RuntimeException" reason:@"No se inicializo la lista de opciones deshabilitadas" userInfo:nil];
		return TRUE;
	}
	
	BOOL enabled = TRUE;
	
	for (NSNumber *o in disabledOptions) {
		if (option == [o intValue]) {
			enabled = FALSE;
			break;
		}
	}
	
	return enabled;
	
}
-(BOOL)mostrarDatosAdicionales
{
    //Combiaron este requerimiento , no borré el código por si dan marcha a atras
    return YES;
   /* if ([self isEnabled:SALDOSTC] && [self isEnabled:ULTIMO_RESUMEN] && [self isEnabled:ULTIMAS_COMPRAS] && [self isEnabled:DISPONIBLES]) {
        return YES;
    }
    else
    {
        return false;
    }*/
}

@end
