//
//  CreditCardSaldoVC.h
//  BanelcoMovilIphone
//
//  Created by Ezequiel Aceto on 29/09/10.
//  Copyright 2010 Mobile Computing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WheelAnimationController.h"

@interface CreditCardSaldoVC : WheelAnimationController <UIScrollViewDelegate>{

	//IBOutlet UITextView *saldoTextView;
	IBOutlet UIScrollView *saldoScrollView;
	
}

//@property (nonatomic, retain) IBOutlet UITextView *saldoTextView;
@property (nonatomic, retain) IBOutlet UIScrollView *saldoScrollView;

@end
