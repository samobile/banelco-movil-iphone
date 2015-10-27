//
//  SaldosForm.h
//  BanelcoMovilIphone
//
//  Created by German Levy on 9/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StackableScreen.h"
#import "Cuenta.h"


@interface SaldosForm : StackableScreen {
	
	Cuenta *cuenta;

}

@property (nonatomic, retain) Cuenta *cuenta;

@end
