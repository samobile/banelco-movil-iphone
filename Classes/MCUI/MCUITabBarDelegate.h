#import <UIKit/UIKit.h>
#import "MCUITabBarViewController.h"

@protocol MCUITabBarDelegate

-(void) onMCUITabBar:(MCUITabBarViewController*) mcUITabBar andItemAction:(int) itemId ;

@end