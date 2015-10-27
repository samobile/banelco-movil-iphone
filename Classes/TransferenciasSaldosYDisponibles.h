//
//  TransferenciasSaldosYDisponibles.h
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 8/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WheelAnimationController.h"

@class Cuenta;

@interface TransferenciasSaldosYDisponibles : WheelAnimationController {
	
	Cuenta *cuenta;
}

@property (nonatomic, retain) Cuenta *cuenta;

@end
