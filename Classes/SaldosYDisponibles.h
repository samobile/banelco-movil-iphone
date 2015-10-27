//
//  SaldosYDisponibles.h
//  BanelcoMovilIphone
//
//  Created by Demian on 9/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WheelAnimationController.h"
#import "Cuenta.h"

@interface SaldosYDisponibles : WheelAnimationController {
	IBOutlet UIButton *botonUltMov;
	
	Cuenta *cuenta;
}

@property (nonatomic, retain) Cuenta *cuenta;
@property (nonatomic, retain) IBOutlet UIButton *botonUltMov;

- (IBAction)ultimosMov;

@end
