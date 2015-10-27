//
//  DetalleDeudaController.h
//  BanelcoMovilIphone
//
//  Created by German Levy on 9/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StackableScreen.h"
#import "Cuenta.h"
#import "Deuda.h"
#import "Ticket.h"
#import "CustomDetail.h"


@interface DetalleDeudaController : CustomDetail {

	Cuenta *cuenta;
	
	Deuda *deuda;
	
	Ticket *ticket;
	
	int tipo;
	
	IBOutlet UILabel *lblEmpresa;
	
}

@property (nonatomic, retain) Cuenta *cuenta;

@property (nonatomic, retain) Deuda *deuda;

@property (nonatomic, retain) Ticket *ticket;

@property (nonatomic, retain) IBOutlet UILabel *lblEmpresa;

extern int const DD_APAGAR;
extern int const DD_PAGADO;
extern int const DD_COMPROBANTE;
extern int const DD_COMPROBANTE_SUBE;

- (id)initWithDeuda:(Deuda *)deuda andCuenta:(Cuenta *)cuenta;

- (id)initWithDeuda:(Deuda *)deuda cuenta:(Cuenta *)cuenta andTicket:(Ticket *)ticket;

- (void)iniciar:(int)t;

- (void)iniciarAPagar;

- (void)iniciarComprobante;

- (IBAction)pagar;


@end
