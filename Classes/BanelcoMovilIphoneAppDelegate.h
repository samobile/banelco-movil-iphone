//
//  BanelcoMovilIphoneAppDelegate.h
//  BanelcoMovilIphone
//
//  Created by Demian on 8/23/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SeleccionBancoController;

@interface BanelcoMovilIphoneAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    UIViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UIViewController *viewController;

@end

