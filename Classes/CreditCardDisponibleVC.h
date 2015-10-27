//
//  CreditCardDisponibleVC.h
//  BanelcoMovilIphone
//
//  Created by Ezequiel Aceto on 29/09/10.
//  Copyright 2010 Mobile Computing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WheelAnimationController.h"
#import "CreditCard.h"

@interface CreditCardDisponibleVC : WheelAnimationController {

	NSString *numeroTarjeta;
    CreditCard * tarjeta;
	//IBOutlet UITextView *info;
}

@property (nonatomic, retain) NSString *numeroTarjeta;
@property (nonatomic, retain) CreditCard * tarjeta;
//@property (nonatomic, retain) IBOutlet UITextView *info;
- (id) initWithNumeroTarjeta:(CreditCard *)tarjetaCred;
@end
