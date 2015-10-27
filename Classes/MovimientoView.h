//
//  MovimientoView.h
//  BanelcoMovilIphone
//
//  Created by Demian on 9/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movimiento.h"
#import "CreditCardCompra.h"

@class Ticket;

@interface MovimientoView : UIView {

		
	
}

-(id) initWithMovimiento:(Movimiento*) movimiento;
- (id)initWithFrame:(CGRect)frame andMovimiento:(Movimiento*) movimiento;
- (id)initWithFrame:(CGRect)frame andCreditCardCompra:(CreditCardCompra*) movimiento;

- (id)initWithFrame:(CGRect)frame andTicket:(Ticket*) ticket;
- (id)initWithFrame:(CGRect)frame andTexto:(NSString*) texto;
@end
