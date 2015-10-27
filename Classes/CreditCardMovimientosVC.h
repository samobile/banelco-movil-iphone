//
//  CreditCardMovimientosVC.h
//  BanelcoMovilIphone
//
//  Created by Ezequiel Aceto on 29/09/10.
//  Copyright 2010 Mobile Computing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WheelAnimationController.h"

@interface CreditCardMovimientosVC : WheelAnimationController {
	NSString *numeroTarjeta;
	
	IBOutlet UIScrollView *movimientosScroll;
}

@property (nonatomic, retain) NSString *numeroTarjeta;

@property (nonatomic, retain) IBOutlet UIScrollView *movimientosScroll;

- (id) initWithNumeroTarjeta:(NSString *)numero;

@end
