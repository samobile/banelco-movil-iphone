//
//  StackableScreen.h
//  BanelcoMovilIphone
//
//  Created by German Levy on 10/2/10.
//  Copyright 2010 -. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface StackableScreen : UIViewController <UIAlertViewDelegate> {

	BOOL nav_volver;	

}

@property BOOL nav_volver;


- (void)screenWillBeBack;


@end
