//
//  UltimosMovimientos.h
//  BanelcoMovilIphone
//
//  Created by Demian on 9/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cuenta.h"
#import "WheelAnimationController.h"

@interface UltimosMovimientos : WheelAnimationController {

	
	IBOutlet UILabel* descripcionCuenta;
	IBOutlet UILabel* tituloConFecha;
	
	IBOutlet UIScrollView* movimientosScroll;
	
	Cuenta* account;
	
	NSMutableArray *movimientos;
	
}

@property(nonatomic,retain) UILabel* descripcionCuenta;
@property(nonatomic,retain) UILabel* tituloConFecha;
@property(nonatomic,retain) Cuenta* account;
@property(nonatomic,retain) UIScrollView* movimientosScroll;
@property(nonatomic,retain) NSMutableArray *movimientos;

- (id) initWithCuenta:(Cuenta*) cuenta;


@end
