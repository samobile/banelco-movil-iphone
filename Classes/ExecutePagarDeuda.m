//
//  ExecutePagarDeuda.m
//  BanelcoMovilIphone
//
//  Created by German Levy on 9/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ExecutePagarDeuda.h"
#import "Context.h"
#import "Deuda.h"
#import "WS_RealizarPago.h"
#import "WSUtil.h"
#import "CommonUIFunctions.h"
#import "DetalleDeudaController.h"
#import "MenuBanelcoController.h"
#import "TicketController.h"

@implementation ExecutePagarDeuda


- (void)execute {

	Context *context = [Context sharedContext];
	Deuda *deuda = context.selectedDeuda;
	Cuenta *cuenta = context.selectedCuenta;

	WS_RealizarPago *request = [[WS_RealizarPago alloc] init];
	request.userToken = [[Context sharedContext] getToken];
	request.deuda = deuda;
	request.codCuenta = cuenta.codigo;

	id result = [WSUtil execute:request];
	
	if ([result isKindOfClass:[NSError class]]) {
        NSString *errorCode = [[(NSError *)result userInfo] valueForKey:@"faultCode"];
        if ([errorCode isEqualToString:@"ss"]) {
            return;
        }
		NSString *errorDesc = [[(NSError *)result userInfo] valueForKey:@"description"];
		context.selectedDeuda.error = errorDesc;
		context.selectedDeuda.otroImporte = @"0.0";
		[CommonUIFunctions showAlert:@"Pago de Deuda" withMessage:errorDesc andCancelButton:@"Cerrar"];
		return;
	}
	
	[self performSelectorOnMainThread:@selector(completarDeudaPaga:) withObject:result waitUntilDone:YES];
	
}

// Se completa el resto en el hilo principal para
// evitar problemas con el refresco de la UI
-(void) completarDeudaPaga:(id)result {
	
	Context *context = [Context sharedContext];
	Cuenta *cuenta = context.selectedCuenta;
	Deuda *deuda = context.selectedDeuda;
	if (context.deudas) {
		context.deudas = [Deuda borrarDeuda:deuda en:context.deudas];
	}
	
	//String ticket = formatTicket
	
	context.selectedCuenta = nil;
	context.selectedDeuda = nil;
	
//	DetalleDeudaController *detalle = [[DetalleDeudaController alloc] 
//									   initWithDeuda:deuda cuenta:cuenta andTicket:result];
	//	[[MenuBanelcoController sharedMenuController] pushScreen:detalle];
	
	
	TicketController* tcontroller = [[TicketController alloc]  initWithDeuda:deuda cuenta:cuenta andTicket:result];
	
	[[MenuBanelcoController sharedMenuController] pushScreen:tcontroller];

	
}


@end
