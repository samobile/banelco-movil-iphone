//
//  CuentasAction.h
//  BanelcoMovilIphone
//
//  Created by German Levy on 9/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cuenta.h"


@interface CuentasAction : NSObject {

	int action;
	
	Cuenta *cuenta;
	
	int cuentasListType;
	
	BOOL limitesYDisponibles;
	
}

@property int action;

@property (nonatomic, retain) Cuenta *cuenta;

@property int cuentasListType;

@property BOOL limitesYDisponibles;


/** Se obtiene el cbu de la cuenta */
extern int const GET_CBU;

/** Se obtiene la lista de cuentas */
extern int const GET_CUENTAS;

/** Se obtiene la lista de cbu agendadas para editarlas */
extern int const GET_CUENTAS_CBU_EDIT;

/** Se obtiene la lista de cbu agendadas para realizar una transferencia */
extern int const GET_CUENTAS_CBU_TRANSFER;

/** Se obtiene el saldo o limite_y_disponible de la cuenta */
extern int const GET_SALDO;

/** Se obtienen los ultimos movimientos de la cuenta */
extern int const GET_ULT_MOVIMIENTOS;

/** Se obtienen los ultimos movimientos de la cuenta */
//extern int const GET_CUENTAS_SALDOS_TRANFER;

/** Se obtiene el saldo o limite_y_disponible para transferencias de la cuenta */
extern int const GET_SALDO_TRANSFER;

/** Se obtienen los ultimas tranferencias de la cuenta */
extern int const GET_ULT_TRANSFER;

/** Se obtienen los ultimas tranferencias de la cuenta */
extern int const GET_CUENTAS_PLAZO;

- (void) executeGetCBU;
- (void) executeGetCuentas;
- (void) executeGetCuentasPlazo;
- (void) executeGetCuentasCBU;
- (void) executeGetSaldo;
- (void) executeGetSaldoTransfer;
- (void) executeGetUltMov;
- (void) executeGetUltTransfer;


@end
