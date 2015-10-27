//
//  UltimoPagoController.m
//  BanelcoMovilIphone
//
//  Created by German Levy on 9/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UltimoPagoController.h"


@implementation UltimoPagoController

@synthesize lbFecha, lbValor;


- (id)initWithFecha:(NSString *)fecha yValor:(NSString *)valor {
    if ((self = [super initWithNibName:@"UltimoPago" bundle:nil])) {
        lbFecha.text = fecha;
		lbValor.text = valor;
        lbValor.accessibilityLabel = [lbValor.text stringByReplacingOccurrencesOfString:@"U$S" withString:@"dolares"];
        lbValor.accessibilityLabel = [lbValor.text stringByReplacingOccurrencesOfString:@"$" withString:@"pesos"];
    }
    return self;
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
