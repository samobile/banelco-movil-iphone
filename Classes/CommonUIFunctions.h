//
//  CommonUIFunctions.h
//  MING_iPad
//
//  Created by German Levy on 5/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CommonUIFunctions : NSObject {
	
}

+ (void)showAlert:(NSString *)title withMessage:(NSString *)message andCancelButton:(NSString *)cancelText;

+ (void)showAlert:(NSString *)title withMessage:(NSString *)message cancelButton:(NSString *)cancelText andDelegate:(id)delegate;

+ (void)showConfirmationAlert:(NSString *)title withMessage:(NSString *)message andDelegate:(id)delegate;

+ (void)showRestrictedAlert:(NSString *)title withDelegate:(id)delegate;

+ (UIAlertView *)showWatingAlert:(NSString *)message;

+ (UIColor *)uiColorFromRed:(float)r green:(float)g blue:(float)b alpha:(float)a;

+ (int)addTextToView:(UIView *)v boldText:(NSString *)bText normalText:(NSString *)nText xPos:(int)xP yPos:(int)yP;

+ (void)showOmitAlert:(NSString *)title withMessage:(NSString *)message andDelegate:(id)delegate;

+ (void)showCustomAlert:(NSString *)title withMessage:(NSString *)message andCancelButton:(NSString *)cancelText andDelegate:(id)del;

@end
