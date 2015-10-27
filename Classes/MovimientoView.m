//
//  MovimientoView.m
//  BanelcoMovilIphone
//
//  Created by Demian on 9/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MovimientoView.h"
#import "Util.h"
#import "Ticket.h"
 
@implementation MovimientoView




-(id) initWithMovimiento:(Movimiento*) movimiento{
	if ((self = [super init])) {
	}
	return self;
	
}


- (id)initWithFrame:(CGRect)frame andMovimiento:(Movimiento*) movimiento{
    if ((self = [super initWithFrame:frame])) {
		UILabel* l = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, 60, 20)];

		l.text = movimiento.fechaMovimiento;
		l.backgroundColor = [UIColor clearColor];
		if (![Context sharedContext].personalizado) {
            l.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:12];
        }
        else {
            l.font = [UIFont fontWithName:@"Helvetica" size:12];
        }
		l.textAlignment = UITextAlignmentLeft;
		//l.textColor = [UIColor blackColor];
		l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];

		UILabel* l2 = [[UILabel alloc] initWithFrame:CGRectMake(57, 2, 180, 20)];
		l2.text = [NSString stringWithFormat:@"  %@",movimiento.nombre];
		if (![Context sharedContext].personalizado) {
            l2.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:12];
        }
        else {
            l2.font = [UIFont boldSystemFontOfSize:12];
        }
		l2.lineBreakMode = UILineBreakModeWordWrap;

		l2.backgroundColor = [UIColor clearColor];
		l2.textAlignment = UITextAlignmentLeft;
		//l2.textColor = [UIColor blackColor];
		l2.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];

		
		UILabel* l3 = [[UILabel alloc] initWithFrame:CGRectMake(240, 2, 75, 20)];
		l3.text = [Util formatSaldo:movimiento.importe];
        l3.accessibilityLabel = [l3.text stringByReplacingOccurrencesOfString:@"U$S" withString:@"dolares"];
        l3.accessibilityLabel = [l3.text stringByReplacingOccurrencesOfString:@"$" withString:@"pesos"];
		l3.backgroundColor = [UIColor clearColor];
		if (![Context sharedContext].personalizado) {
            l3.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:14];
        }
        else {
            l3.font = [UIFont boldSystemFontOfSize:14];
        }
		l3.textAlignment = UITextAlignmentRight;
		//l3.textColor = [UIColor blackColor];
		l3.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
		
		[self addSubview:l];
		[self addSubview:l2];
		[self addSubview:l3];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andTicket:(Ticket*) ticket{
    if ((self = [super initWithFrame:frame])) {
		UILabel* l = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, 60, 20)];
		
		l.text = ticket.fechaPago;
		l.backgroundColor = [UIColor clearColor];
		if (![Context sharedContext].personalizado) {
            l.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:14];
        }
        else {
            l.font = [UIFont fontWithName:@"Helvetica" size:14];
        }
		l.textAlignment = UITextAlignmentLeft;
		//l.textColor = [UIColor blackColor];
		l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
		
		UILabel* l2 = [[UILabel alloc] initWithFrame:CGRectMake(57, 2, 180, 20)];
		l2.text = [NSString stringWithFormat:@"  %@",ticket.moneda];
        l2.accessibilityLabel = [l2.text stringByReplacingOccurrencesOfString:@"U$S" withString:@"dolares"];
        l2.accessibilityLabel = [l2.text stringByReplacingOccurrencesOfString:@"$" withString:@"pesos"];
		if (![Context sharedContext].personalizado) {
            l2.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:14];
        }
        else {
            l2.font = [UIFont boldSystemFontOfSize:14];
        }
		l2.lineBreakMode = UILineBreakModeWordWrap;
		
		l2.backgroundColor = [UIColor clearColor];
		l2.textAlignment = UITextAlignmentLeft;
		//l2.textColor = [UIColor blackColor];
		l2.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
		
		
		UILabel* l3 = [[UILabel alloc] initWithFrame:CGRectMake(240, 2, 75, 20)];
		l3.text = [Util formatSaldo:ticket.importe];
        l3.accessibilityLabel = [l3.text stringByReplacingOccurrencesOfString:@"U$S" withString:@"dolares"];
        l3.accessibilityLabel = [l3.text stringByReplacingOccurrencesOfString:@"$" withString:@"pesos"];
		l3.backgroundColor = [UIColor clearColor];
		if (![Context sharedContext].personalizado) {
            l3.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:15];
        }
        else {
            l3.font = [UIFont boldSystemFontOfSize:15];
        }
		l3.textAlignment = UITextAlignmentRight;
		//l3.textColor = [UIColor blackColor];
		l3.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
		
		[self addSubview:l];
		[self addSubview:l2];
		[self addSubview:l3];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andCreditCardCompra:(CreditCardCompra*) movimiento{
    if ((self = [super initWithFrame:frame])) {
		UILabel* l = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, 85, 43)];
		
		l.text = movimiento.fechaCompra;
		l.backgroundColor = [UIColor colorWithRed:212.0/255 green:212.0/255 blue:212.0/255 alpha:0.5];
		l.textAlignment = UITextAlignmentLeft;
		if (![Context sharedContext].personalizado) {
            l.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:12];
        }
        else {
            l.font = [UIFont fontWithName:@"Helvetica" size:14];
        }
		//l.textColor = [UIColor blackColor];
		l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
		
		UILabel* l2 = [[UILabel alloc] initWithFrame:CGRectMake(90, 2, 150, 43)];
		l2.text = [NSString stringWithFormat:@"%@",movimiento.concepto];
        l2.accessibilityLabel = [l2.text stringByReplacingOccurrencesOfString:@"U$S" withString:@"dolares"];
        l2.accessibilityLabel = [l2.text stringByReplacingOccurrencesOfString:@"$" withString:@"pesos"];
        l2.numberOfLines = 3;
		l2.backgroundColor = [UIColor colorWithRed:212.0/255 green:212.0/255 blue:212.0/255 alpha:0.5];
		l2.textAlignment = UITextAlignmentLeft;
		if (![Context sharedContext].personalizado) {
            l2.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:12];
        }
        else {
            l2.font = [UIFont systemFontOfSize:14];
        }
		//l2.textColor = [UIColor blackColor];
		l2.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
		//l2.lineBreakMode = UILineBreakModeWordWrap;
		
		UILabel* l3 = [[UILabel alloc] initWithFrame:CGRectMake(240, 2, 76, 43)];
		
		//No se formatea Saldo para importes que vienen de Tarjetas, por diferencias con formato utilizado por Banelco
		//l3.text = [Util formatSaldo:movimiento.valor];
        NSString *val = movimiento.valor;//[movimiento.dolares length] > 0 ? movimiento.dolares : movimiento.valor;
        if ([val rangeOfString:@"-"].location != NSNotFound) {
            val = [NSString stringWithFormat:@"(%@)", [val stringByReplacingOccurrencesOfString:@"-" withString:@""]];
        }
		l3.text = [NSString stringWithFormat:@"%@", val];
        l3.accessibilityLabel = [l3.text stringByReplacingOccurrencesOfString:@"U$S" withString:@"dolares"];
        l3.accessibilityLabel = [l3.text stringByReplacingOccurrencesOfString:@"$" withString:@"pesos"];
		l3.numberOfLines = 2;
		l3.backgroundColor = [UIColor colorWithRed:212.0/255 green:212.0/255 blue:212.0/255 alpha:0.5];
		l3.textAlignment = UITextAlignmentRight;
		//l3.textColor = [UIColor blackColor];
		l3.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
		if (![Context sharedContext].personalizado) {
            l3.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:12];
        }
        else {
            l3.font = [UIFont systemFontOfSize:14];
        }
		
		[self addSubview:l];
		[self addSubview:l2];
		[self addSubview:l3];
		
		[l release];
		[l2 release];
		[l3 release];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame andTexto:(NSString*) texto{
    if ((self = [super initWithFrame:frame])) {
        UILabel* l = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, 60, 20)];
        
        l.text = texto;
        l.accessibilityLabel = [l.text stringByReplacingOccurrencesOfString:@"U$S" withString:@"dolares"];
        l.accessibilityLabel = [l.text stringByReplacingOccurrencesOfString:@"$" withString:@"pesos"];
        l.backgroundColor = [UIColor clearColor];
        if (![Context sharedContext].personalizado) {
            l.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:12];
        }
        else {
            l.font = [UIFont fontWithName:@"Helvetica" size:12];
        }
        l.textAlignment = UITextAlignmentCenter;
        //l.textColor = [UIColor blackColor];
        l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];

        
        
        
        [self addSubview:l];
 
    }
    return self;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    [super dealloc];
}


@end
