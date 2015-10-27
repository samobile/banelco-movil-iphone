//
//  CommonUIFunctions.m
//  MING_iPad
//
//  Created by German Levy on 5/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CommonUIFunctions.h"
#import "MenuBanelcoController.h"
#import "BanelcoMovilIphoneViewController.h"
#import "BanelcoMovilIphoneViewControllerGenerico.h"
#import "Configuration.h"
#import "Context.h"
#import "LoginController.h"
#import "CommonFunctions.h"

@implementation CommonUIFunctions

+ (void) showAlert:(NSString *)title withMessage:(NSString *)message andCancelButton:(NSString *)cancelText {
	
	
	
	[self showAlert:title withMessage:[message stringByReplacingOccurrencesOfString:@"i?n" withString:@"ión"]  cancelButton:cancelText andDelegate:nil];
	
}

+ (void)showCustomAlert:(NSString *)title withMessage:(NSString *)message andCancelButton:(NSString *)cancelText andDelegate:(id)del {
    
    UIAlertView *alert = [[[UIAlertView alloc] init] autorelease];
    alert.title = nil;
    alert.message = nil;
    UILabel *lbl = [[[UILabel alloc] init] autorelease];
    lbl.frame = CGRectZero;
    lbl.numberOfLines = 0;
    lbl.text = message;
    lbl.accessibilityLabel = [CommonFunctions replaceSymbolVoice:lbl.text];
    lbl.textAlignment = UITextAlignmentCenter;
    if (![Context sharedContext].personalizado) {
        lbl.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:14];
    }
    else {
        lbl.font = [UIFont systemFontOfSize:14];
    }
    CGSize maximumLabelSize = CGSizeMake(alert.bounds.size.width, 500);
    CGSize expectedLabelSize = [lbl.text sizeWithFont:lbl.font constrainedToSize:maximumLabelSize lineBreakMode:lbl.lineBreakMode];
    //adjust the label the the new height.
    CGRect newFrame = lbl.frame;
    newFrame.size.height = expectedLabelSize.height;
    lbl.frame = newFrame;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")) {
        [alert setValue:lbl forKey:@"accessoryView"];
    }
    else {
        alert.message = message;
        alert.message.accessibilityLabel = [CommonFunctions replaceSymbolVoice:message];
    }
    [alert addButtonWithTitle:cancelText];
    alert.cancelButtonIndex = 0;
    alert.delegate = del;
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
    
}

+ (void)showAlert:(NSString *)title withMessage:(NSString *)message cancelButton:(NSString *)cancelText andDelegate:(id)delegate {

	UIAlertView *alert = [[[UIAlertView alloc] init] autorelease];
	alert.title = title;
	alert.message = message;
	[alert addButtonWithTitle:cancelText];
	alert.cancelButtonIndex = 0;
	alert.delegate = delegate;
	[alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
    //[alert show];
}

+ (void)showConfirmationAlert:(NSString *)title withMessage:(NSString *)message andDelegate:(id)delegate {
	
	UIAlertView *alert = [[UIAlertView alloc] init];
	alert.title = title;
	alert.message = message;
	[alert addButtonWithTitle:@"Cancelar"];
	alert.cancelButtonIndex = 0;
	[alert addButtonWithTitle:@"Aceptar"];
	alert.delegate = delegate;
	//[alert show];
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
	
}

+ (void)showOmitAlert:(NSString *)title withMessage:(NSString *)message andDelegate:(id)delegate {
    
    UIAlertView *alert = [[UIAlertView alloc] init];
    alert.title = title;
    alert.message = message;
    [alert addButtonWithTitle:@"Omitir"];
    alert.cancelButtonIndex = 0;
    [alert addButtonWithTitle:@"Recordar más tarde"];
    alert.delegate = delegate;
    //[alert show];
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
    
}

+ (void)showRestrictedAlert:(NSString *)title withDelegate:(id)delegate {
	
	UIAlertView *alert = [[UIAlertView alloc] init];
	alert.title = title;
	alert.message = @"Habilite esta operación en un cajero Banelco al final de su próxima extracción o consulta de saldo. Más información: 5556-9556.";
	[alert addButtonWithTitle:@"Aceptar"];
	alert.cancelButtonIndex = 0;
	alert.delegate = delegate;
	//[alert show];
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
	
}

+ (UIAlertView *)showWatingAlert:(NSString *)message {

	UIAlertView *alert = [[UIAlertView alloc] init];
	alert.title = nil;
	alert.message = message;
	//[alert addButtonWithTitle:@""];
	alert.cancelButtonIndex = 0;
	//[alert show];
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
	
	
	return alert;
	
}

+ (UIColor *)uiColorFromRed:(float)r green:(float)g blue:(float)b alpha:(float)a {
	
	return [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a/255.f];
	
}

+ (int)addTextToView:(UIView *)v boldText:(NSString *)bText normalText:(NSString *)nText xPos:(int)xP yPos:(int)yP {

	CGSize s1 = CGSizeZero;
	CGSize s2 = CGSizeZero;
	
	if (bText) {
		s1 = [bText sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
		UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(xP, yP, s1.width, s1.height)];
		l.text = [NSString stringWithFormat:@"%@",bText];
		l.backgroundColor = [UIColor clearColor];
		l.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
		l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
		[v addSubview:l];
		[l release];
	}
	if (nText) {
		s2 = [nText sizeWithFont:[UIFont fontWithName:@"Helvetica" size:17]];
		UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(xP + s1.width, yP, s2.width, s2.height)];
		l.text = [NSString stringWithFormat:@"%@",nText];
		l.backgroundColor = [UIColor clearColor];
		l.font = [UIFont fontWithName:@"Helvetica" size:17];
		l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
		[v addSubview:l];
		[l release];
		
	}
	return (yP + ((s1.height!=0)?s1.height:s2.height));
}


+ (void)goToLogin {
	
	//[NSThread detachNewThreadSelector:@selector(executeGoToLogin) toTarget:self withObject:nil];
    [self executeGoToLogin];
	
}

+ (void)dismissLater:(UIViewController *)vc {
    [vc dismissModalViewControllerAnimated:NO];
}

//+ (void)executeGoToLogin {
//	//NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//	
//	//[NSThread sleepForTimeInterval:1.0];
//	
//	MenuBanelcoController *stack = [MenuBanelcoController sharedMenuController];
//	[stack performSelectorOnMainThread:@selector(inicio) withObject:nil waitUntilDone:YES];
//	
//	//[NSThread sleepForTimeInterval:1.0];
//    id menu = nil;
//    menu = [BanelcoMovilIphoneViewController sharedMenuController];
//    
//    UIViewController *vc = nil;
//    if ([menu respondsToSelector:@selector(presentingViewController)]) {
//      vc = ((BanelcoMovilIphoneViewController*)menu).presentingViewController;
//    }
//	[menu performSelectorOnMainThread:@selector(dismiss) withObject:nil waitUntilDone:NO];
//    
//    [NSThread sleepForTimeInterval:0.5];
//    
//    while (vc && ![vc isKindOfClass:[LoginController class]]) {
//        UIViewController *vc2 = vc.presentingViewController;
//        //[vc dismissModalViewControllerAnimated:NO];
//        [self performSelector:@selector(dismissLater:) withObject:vc afterDelay:0.5];
//        //[NSThread sleepForTimeInterval:1.0];
//        vc = vc2;
//    }
//    
//    [MenuBanelcoController resetMenuBanelcoController];
//    [BanelcoMovilIphoneViewController resetAll];
//    [[Context sharedContext] resetContext];
//    
//    [[[UIApplication sharedApplication] delegate] applicationDidBecomeActive:nil];
//	
//	//[pool release];
//}

+ (void)executeGoToLogin {
    //NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    [NSThread sleepForTimeInterval:1.0];
    
    MenuBanelcoController *stack = [MenuBanelcoController sharedMenuController];
    [stack performSelectorOnMainThread:@selector(inicio) withObject:nil waitUntilDone:YES];
    
    [NSThread sleepForTimeInterval:1.0];
    NSObject *menu;
    menu = [BanelcoMovilIphoneViewController sharedMenuController];
    
    UIViewController *vc = nil;
    if ([menu respondsToSelector:@selector(presentingViewController)]) {
        vc = ((BanelcoMovilIphoneViewController*)menu).presentingViewController;
    }
    [menu performSelectorOnMainThread:@selector(dismiss) withObject:nil waitUntilDone:YES];
    
    [NSThread sleepForTimeInterval:1.0];
    
    while (vc && ![vc isKindOfClass:[LoginController class]]) {
        UIViewController *vc2 = vc.presentingViewController;
        //[vc dismissModalViewControllerAnimated:NO];
        [vc performSelectorOnMainThread:@selector(dismissModalViewControllerAnimated:) withObject:NULL waitUntilDone:YES];
        [NSThread sleepForTimeInterval:1.0];
        vc = vc2;
    }
    
    [MenuBanelcoController resetMenuBanelcoController];
    [BanelcoMovilIphoneViewController resetAll];
    [[Context sharedContext] resetContext];
    
    //[[[UIApplication sharedApplication] delegate] applicationDidBecomeActive:nil];
    
    //[pool release];
}

@end
