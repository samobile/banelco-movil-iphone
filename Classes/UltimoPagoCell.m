//
//  UltimoPagoController.m
//  BanelcoMovilIphone
//
//  Created by German Levy on 9/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UltimoPagoCell.h"
#import "Ticket.h"
#import "Context.h"

@implementation UltimoPagoCell

@synthesize lbFecha, lbValor;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier andTicket:(Ticket *)ticket {
	
    if ((self = [super initWithFrame:CGRectZero reuseIdentifier:reuseIdentifier])) {
		
		[self inicializar:ticket];
		
    }
    return self;
}

- (void)inicializar:(Ticket *)ticket {

	lbFecha.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	// FECHA
	if (self.lbFecha && [self.lbFecha isDescendantOfView:self]) {
		
		self.lbFecha.text = ticket.fechaPago;
		
	} else {
		self.lbFecha = [[UILabel alloc]initWithFrame:CGRectMake(25, 12, 133, 21)];
		self.lbFecha.textAlignment = UITextAlignmentLeft;
		if (![Context sharedContext].personalizado) {
            self.lbFecha.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:18];
        }
        else {
            self.lbFecha.font = [UIFont systemFontOfSize:18];
        }
		self.lbFecha.text = ticket.fechaPago;
		self.lbFecha.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
		
		[self addSubview:self.lbFecha];
	}
	
	lbValor.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	// VALOR
	NSString *valor = [NSString stringWithFormat:@"%@ %@", ticket.moneda, [Util formatSaldo:ticket.importe]];
	
	if (self.lbValor && [self.lbValor isDescendantOfView:self]) {
		
		self.lbValor.text = valor;
	
	} else {
		self.lbValor = [[UILabel alloc]initWithFrame:CGRectMake(140, 12, 133, 21)];
		self.lbValor.textAlignment = UITextAlignmentRight;
		if (![Context sharedContext].personalizado) {
            self.lbValor.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:18];
        }
        else {
            self.lbValor.font = [UIFont systemFontOfSize:18];
        }
		self.lbValor.text = valor;
		self.lbValor.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
		
		[self addSubview:self.lbValor];	
	}
    self.lbValor.accessibilityLabel = [self.lbValor.text stringByReplacingOccurrencesOfString:@"U$S" withString:@"dolares"];
    self.lbValor.accessibilityLabel = [self.lbValor.text stringByReplacingOccurrencesOfString:@"$" withString:@"pesos"];

	/*self.fondo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fnd_lista.png"]];
	 self.frame.size.height = CGRectMake(0, 0, 320, 70);
	 [self addSubview:self.fondo];
	 */
	
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


- (void)dealloc {
	[lbFecha release];
	[lbValor release];
    [super dealloc];
}


@end
