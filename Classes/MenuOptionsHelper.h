//
//  MenuOptionsHelper.h
//  BanelcoMovilIphone
//
//  Created by German Levy on 9/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MenuOptionsHelper : NSObject {

	// Contiene todas las opciones de menu que no se muestran
	NSMutableArray *disabledOptions;
	
}

@property (nonatomic, retain) NSMutableArray *disabledOptions;

// OPCIONES PRINCIPALES (PortalesList)
extern int const BANCA_MOVIL;
extern int const PAGO_MIS_CUENTAS;
extern int const RECARGA_MOVIL;
extern int const CAMBIAR_CLAVE;
extern int const AYUDA;

// DENTRO DE BANCA MOVIL
extern int const CONSULTAS;
extern int const PAGOS;
extern int const TRANSFERENCIAS;
extern int const TASAS_PLAZO_FIJO;
extern int const SOLICITUD_PRODUCTO;

// DENTRO DE CONSULTAS
extern int const SALDOS;
extern int const ULTIMOS_MOVIMIENTOS;
extern int const CONSULTA_CBU;
extern int const TARJETAS_CREDITO;
extern int const DISPONIBLE_EXTRACCION;

// DENTRO DE TRANSFERENCIAS
extern int const CUENTAS_VINCULADAS;
extern int const CUENTAS_CBU_AGENDADA;
extern int const CONSULTAS_TRANSF;

// DENTRO DE CONSULTAS_TRANSF
extern int const AGENDA;
extern int const CONSULTA_ULTIMAS_TRANSF;
extern int const SALDOS_Y_DISP_TRANSF;

// DENTRO DE OTRAS_OPERACIONES
extern int const AVISOS;
extern int const SALDOS_Y_DISPONIBLES;
extern int const OTRAS_CUENTAS;
extern int const OTRAS_TARJETAS;
extern int const MIS_COMPROBANTES;

// DENTRO DE TARJETAS_CREDITO
extern int const SALDOSTC;
extern int const ULTIMO_RESUMEN;
extern int const ULTIMAS_COMPRAS;
extern int const DISPONIBLES;
extern int const PAGO_TARJETA;

//DENTRO DE RECARGA_MOVIL
extern int const MI_CELULAR;
extern int const OTRO_NUMERO;
extern int const TARJETA_SUBE;

// DENTRO DE EXTRACCIONES
extern int const EXTRACCION_PROPIA;
extern int const EXTRACCION_TERCERO;
extern int const EXTRACCION_CONSULTA;

+(MenuOptionsHelper *)sharedMenuHelper;

- (BOOL)isEnabled:(int)option;

-(BOOL)mostrarDatosAdicionales;

@end
