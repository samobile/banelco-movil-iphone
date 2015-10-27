//
//  CuentasAction.m
//  BanelcoMovilIphone
//
//  Created by German Levy on 9/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CuentasAction.h"
#import "Context.h"
#import "Util.h"
#import "CustomText.h"
#import "MenuBanelcoController.h"
#import "CuentasList.h"
#import "CommonUIFunctions.h"
#import "WSUtil.h"
#import "WS_ListarCuentasPlazo.h"
#import "SaldosForm.h"
#import "Transfer.h"
#import "SaldosTransfMobileDTO.h"
#import "UltimosMovimientos.h"


@implementation CuentasAction

@synthesize action, cuenta, cuentasListType, limitesYDisponibles;

int const GET_CBU = 0;
int const GET_CUENTAS = 1;
int const GET_CUENTAS_CBU_EDIT = 2;
int const GET_CUENTAS_CBU_TRANSFER = 3;
int const GET_SALDO = 4;
int const GET_ULT_MOVIMIENTOS = 5;
//int const GET_CUENTAS_SALDOS_TRANFER = 6;
int const GET_SALDO_TRANSFER = 7;
int const GET_ULT_TRANSFER = 8;
int const GET_CUENTAS_PLAZO = 9;


- (void) execute {

	if (action == GET_CBU) {
		[self executeGetCBU];
	} else if (action == GET_CUENTAS) {
		[self executeGetCuentas];
	} else if (action == GET_CUENTAS_PLAZO) { // Etapa2
		[self executeGetCuentasPlazo];
	} else if ((action == GET_CUENTAS_CBU_EDIT)
			   || (action == GET_CUENTAS_CBU_TRANSFER)) {
		[self executeGetCuentasCBU];
	} else if (action == GET_SALDO) {
		[self executeGetSaldo];
	} else if (action == GET_SALDO_TRANSFER) {
		[self executeGetSaldoTransfer];
	} else if (action == GET_ULT_MOVIMIENTOS) {
		[self executeGetUltMov];
	} else if (action == GET_ULT_TRANSFER) {
		[self executeGetUltTransfer];
	}
}

/**
 * Obtiene el CBU de la cuenta y lo muestra en un formulario.
 */
- (void) executeGetCBU {
	
	// TODO iniciar indicador de proceso
	
	@try {
		
		NSString *cbu = [Cuenta getCBU:[self cuenta]];
		
		NSString *text = [NSString stringWithFormat:@"%@\n%@\nCBU \n%@"
										, self.cuenta.descripcionLargaTipoCuenta
										, [Util aplicarMascara:self.cuenta.numero yMascara:[Cuenta getMascara]]
										, cbu ];
		
		//CustomText *cbuForm = [[CustomText alloc] initWithTitle:@"Consulta de CBU" andText:text];
		//[[MenuBanelcoController sharedMenuController] pushScreen:cbuForm];
		
		
	} @catch (NSException *ex) {
		//Util.handleException(ex, "", "CBU1", previous);
	}
	
}

/**
 * Obtiene y muestra la lista de cuentas.
 */
- (void) executeGetCuentas {
	
	Context *context = [Context sharedContext];
	
	// TODO iniciar indicador de proceso
	
	@try {
		NSMutableArray *cuentas = context.cuentas;
		NSString *noneAccountMessage = @"No tenés cuentas.";
		
		if (CL_PAGAR == self.cuentasListType) {
			
			cuentas = [Cuenta filtrarCuentas:context.cuentas porMoneda:context.selectedDeuda.monedaCodigo];
			noneAccountMessage = @"No tenés cuentas con la misma moneda de la deuda.";
		}
		
		if ([cuentas count] == 0) {
			
			[CommonUIFunctions showAlert:noneAccountMessage withMessage:nil andCancelButton:@"Volver"];
			
		} else if ((self.cuentasListType == CL_TRANS_DESTINO) && ([cuentas count] == 1)) {
			// Si el tipo de lista de cuentas es Cuenta Destino de una
			// transferencia y el usuario tiene una sola cuenta, no tiene
			// sentido que muestre la lista de cuentas.
			[CommonUIFunctions showAlert:@"Solo tenés una Cuenta" 
							 withMessage:@"No podes realizar una transferencia desde/hacia la misma cuenta" 
						 andCancelButton:@"Volver"];
			
		} else {
			
			NSString *cuentasListTitle = @"Elegí Cuenta ";
			// Si es CuentasList.SALDOS_Y_DISPONIBLES_TARJETA queda como
			// tÌtulo "Elija Cuenta "
			
			if (self.cuentasListType == CL_TRANS_ORIGEN) {
				cuentasListTitle = @"Cuenta Origen";
			} else if (self.cuentasListType == CL_TRANS_DESTINO) {
				cuentasListTitle = @"Cuenta Destino";
			}
			
			CuentasList *cuentasList = [[CuentasList alloc] initList:cuentasListTitle ofType:cuentasListType withItems:cuentas];
			
			[[MenuBanelcoController sharedMenuController] pushScreen:cuentasList];
		}
		
	} @catch (NSException *ex) {
		//Util.handleException(ex, "CNT1", "CNT2", previous);
	}
}

/**
 * Obtiene y muestra la lista de cuentas plazo. Etata2
 */
- (void) executeGetCuentasPlazo {
	
	Context *context = [Context sharedContext];
	
	// TODO iniciar indicador de proceso
	
	@try {
		
		WS_ListarCuentasPlazo * request = [[WS_ListarCuentasPlazo alloc] init];
		
		Context *context = [Context sharedContext];
		
		request.token = [context getToken];
				
		NSMutableArray *cuentasPlazo = [WSUtil execute:request];
		
		CuentasList *cuentasList = [[CuentasList alloc] initList:@"Elegí Cuenta Plazo" ofType:cuentasListType withItems:cuentasPlazo];
		
		[[MenuBanelcoController sharedMenuController] pushScreen:cuentasList];
		
	} @catch (NSException *ex) {
		//Util.handleException(ex, "CNT1", "CNT2", previous);
	}
}

/**
 * Obtiene la lista de cbu agendados
 */
- (void) executeGetCuentasCBU {
	Context *context = [Context sharedContext];
	
	// TODO iniciar indicador de proceso
	
	@try {
		NSMutableArray *cuentasCBU = [Cuenta getCuentasCBU];
		
		if ([cuentasCBU count] == 0) {
			
			[CommonUIFunctions showAlert:@"Momentaneamente no posees cuentas con CBU agendada" 
							 withMessage:@"Para mas información comunicate con tu Banco" 
						 andCancelButton:@"Volver"];
			
		} else {
			CuentasList *cuentasList = nil;
			if (action == GET_CUENTAS_CBU_TRANSFER) {
				// Busco las cuentas CBU agendadas para realizar una
				// transferencia
				cuentasList = [[CuentasList alloc] initList:@"Cuenta Destino" ofType:CL_TRANS_DESTINO withItems:cuentasCBU];
				
			} else if (action == GET_CUENTAS_CBU_EDIT) {
				// Busco las cuentas CBU agendadas para mostrar y/o
				// modificar los datos
				cuentasList = [[CuentasList alloc] initList:@"Agenda" ofType:CL_AGENDA withItems:cuentasCBU];
				//cuentasList = new CuentasList("Agenda", List.IMPLICIT, accounts, previous, CuentasList.AGENDA, "Modificar");
				
			}
			
			[[MenuBanelcoController sharedMenuController] pushScreen:cuentasList];
		}
		
	} @catch (NSException *ex) {
		//Util.handleException(ex, "CBU1", "CBU2", previous);
	}
}

/**
 * Obtiene y muestra el saldo o limiteYDisponible de una cuenta
 */
- (void) executeGetSaldo {
	
	// TODO iniciar indicador de proceso
	//context.getMidlet().getWaitingAlert("Cargando el saldo de la cuenta " + account.descripcionCortaTipoCuenta + ", un momento por favor...");
	
	@try {
		Cuenta *cuenta = [Cuenta getSaldo:self.cuenta withLyD:limitesYDisponibles];
		if (limitesYDisponibles) {
			// TODO: ver como resolver parche por como esta hecho lo de cubika
			self.cuenta.codigo = cuenta.codigo;
		}

		SaldosForm *saldo = [[SaldosForm alloc] init];
		//SaldosForm saldo = new SaldosForm("Saldo", account, self.previous, limitesYDisponibles);
		
		[[MenuBanelcoController sharedMenuController] pushScreen:saldo];
		
	} @catch (NSException *ex) {
		//Util.handleException(ex, "", "SLD1", previous);
	}
}

/**
 * Obtiene y muestra el saldo o limiteYDisponible para una transferencia de una cuenta
 */
- (void) executeGetSaldoTransfer {
	
	// TODO iniciar indicador de proceso
	//context.getMidlet().getWaitingAlert("Cargando el saldo de la cuenta " + account.descripcionCortaTipoCuenta + ", un momento por favor...");
	
	@try {
		
		SaldosTransfMobileDTO *stm = [Transfer getSaldoTransfer:self.cuenta];
		
		SaldosForm *saldo = [[SaldosForm alloc] init];
		//SaldosForm *saldo = new SaldosForm("Saldo", stm, self.previous,true);
		
		[[MenuBanelcoController sharedMenuController] pushScreen:saldo];
		
	} @catch (NSException *ex) {
		//Util.handleException(ex, "", "SDT1", previous);
	}
}

/**
 * Obtiene los ultimos movimientos de una cuenta.
 */
- (void) executeGetUltMov {
	
	// TODO iniciar indicador de proceso
	//context.getMidlet().getWaitingAlert("Cargando los últimos movimientos de la cuenta " + account.descripcionCortaTipoCuenta + ", un momento por favor...");
	
	@try {
		
		NSMutableArray *transacciones = [Cuenta getUltimosMovimientos:self.cuenta];
									  
		UltimosMovimientos *ultMovimientosForm = [[UltimosMovimientos alloc] initWithItems:transacciones];
										 
		[[MenuBanelcoController sharedMenuController] pushScreen:ultMovimientosForm];
									  
	} @catch (NSException *ex) {
		//Util.handleException(ex, "", "ULM1", previous);
	}
}

/**
 * Obtiene las ultimas tranferencias de una cuenta.
 */
- (void) executeGetUltTransfer {
	
	Context *context = [Context sharedContext];
	
	// TODO iniciar indicador de proceso
	//context.getMidlet().getWaitingAlert("Cargando las últimas transferencias " + ", un momento por favor...");
	
	//Runnable action = new UltimosPagosAction(previous, 0);
	//Util.fireAndForget(action);
}



@end
