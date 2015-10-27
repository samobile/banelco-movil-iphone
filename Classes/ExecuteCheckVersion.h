//
//  ExecuteCheckVersion.h
//  BanelcoMovilIphone
//
//  Created by German Levy on 9/26/10.
//  Copyright 2010 -. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ExecuteCheckVersion : NSObject <UIAlertViewDelegate> {

	UIViewController *viewController;
	
}

@property (nonatomic, retain) UIViewController *viewController;

- (void)execute;
- (BOOL)executeAndWait;
- (void)configureMenuPrincipal;

@end
