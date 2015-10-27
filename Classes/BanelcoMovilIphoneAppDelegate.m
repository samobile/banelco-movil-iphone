//
//  BanelcoMovilIphoneAppDelegate.m
//  BanelcoMovilIphone
//
//  Created by Demian on 8/23/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "BanelcoMovilIphoneAppDelegate.h"
#import "SeleccionBancoController.h"
#import "WS_Logout.h"
#import "WSUtil.h"
#import "Context.h"
#import "LoginController.h"
#import "MenuInicialRBTS.h"
#import "MenuInicialPatagonia.h"
//bimo
//#import "GlobalVars.h"

#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"

#import "ExecuteCheckVersion.h"

@implementation BanelcoMovilIphoneAppDelegate

@synthesize window;
@synthesize viewController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.

    // Add the view controller's view to the window and display.
	//NSLog(@"Pone la pantalla ");
    
    // Initialize Google Analytics with a 120-second dispatch interval. There is a
    // tradeoff between battery usage and timely dispatch.
    [GAI sharedInstance].dispatchInterval = 120;
    [[GAI sharedInstance].logger setLogLevel:kGAILogLevelVerbose];
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    NSString *env = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"Environment"];
    NSString *trackingId = [[[NSBundle mainBundle] infoDictionary] objectForKey:[NSString stringWithFormat:@"TrackingID_%@",env]];
    NSString *trackingName = [NSString stringWithFormat:@"%@_%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"], env];
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithName:trackingName trackingId:trackingId];
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    [tracker set:kGAIAppVersion value:version];
    
	//personalizacion
	NSDictionary *dict = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"Personalizacion"];
	if (!dict) {
		viewController = [[SeleccionBancoController alloc] init];
	}
	else {
		//viewController = [[LoginController alloc] initPrimerLoginConBanco:FALSE];
		//Personalizacion para HSBC: carga otra pantalla antes de login
		if ([[dict objectForKey:@"idBanco"] isEqualToString:@"RBTS"]) {
			viewController = [[MenuInicialRBTS alloc] initWithNibName:@"MenuInicialRBTS" bundle:nil];
		}
        else if ([[dict objectForKey:@"idBanco"] isEqualToString:@"SDMR"]) {
            viewController = [[MenuInicialPatagonia alloc] initWithNibName:@"MenuInicialPatagonia" bundle:nil];
        }
//        else if ([[dict objectForKey:@"idBanco"] isEqualToString:@"BSTN"]) {
//            //primero ejecuta update.txt
//            ExecuteCheckVersion *checkVersion = [[ExecuteCheckVersion alloc] initFromController:nil];
//            [checkVersion executeAndWait];
//            [checkVersion release];
//            viewController = [[LoginController alloc] initPersonalizado];
//        }
		else {
			viewController = [[LoginController alloc] initPersonalizado];
		}
	}
    
	//viewController.view.frame = CGRectMake(0, 20, 320, 460);
   // [GlobalVars sharedGlobalVars].heightDiff = IPHONE5_HDIFF(self.window.frame.size.height) - self.window.frame.size.height;
    
    viewController.view.frame = CGRectMake(0, 20, 320, IPHONE5_HDIFF(460));
    NSLog(@"%f",viewController.view.frame.size.height);
	viewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    if ([self.window respondsToSelector:@selector(setRootViewController:)]) {
        [self.window setRootViewController:viewController];
    }
    else {
        [self.window addSubview:viewController.view];
    }
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    v.tag = -1000;
    v.backgroundColor = [UIColor whiteColor];
    [self.window addSubview:v];
    [v release];
    
    [window makeKeyAndVisible];
    
    application.accessibilityLanguage = @"es-AR";

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    NSDictionary *dict = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"Personalizacion"];
    if ([[dict objectForKey:@"idBanco"] isEqualToString:@"BSTN"] || [[dict objectForKey:@"idBanco"] isEqualToString:@"SPRE"]) {
        //primero ejecuta update.txt
        ExecuteCheckVersion *checkVersion = [[ExecuteCheckVersion alloc] initFromController:nil];
        [checkVersion executeAndWait];
        [checkVersion release];
        
        UIWindow *win = [[[UIApplication sharedApplication] windows] firstObject];
        UIView *oldv = [win viewWithTag:-909];
        if (oldv) {
            [oldv removeFromSuperview];
        }
        
        Context *context = [Context sharedContext];
        if (context.expirationEnabled) {
            //chequeo de fecha
            NSDate *actual = [NSDate date];
            if (context.expirationDate && [actual compare:context.expirationDate] != NSOrderedAscending) {
                [win endEditing:YES];
                //mostrar mensaje bloqueante
                UIView *v = [[UIView alloc] initWithFrame:win.bounds];
                v.tag = -909;
                v.backgroundColor = [UIColor colorWithRed:85/255 green:85/255 blue:85/255 alpha:0.8];
                UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(30, 30, v.frame.size.width - 60, v.frame.size.height - 60)];
                lbl.numberOfLines = 5;
                lbl.backgroundColor = [UIColor clearColor];
                lbl.text = @"Para poder seguir operando, por favor descargá la aplicación ICBC Mobile Banking desde la tienda de tu Smartphone";
                if ([[dict objectForKey:@"idBanco"] isEqualToString:@"SPRE"]) {
                    lbl.text = @"Esta aplicación ya no está disponible. Para seguir operando descargate la nueva aplicación Supervielle Móvil desde Apple Store.";
                }
                lbl.textColor = [UIColor whiteColor];
                lbl.textAlignment = UITextAlignmentCenter;
                lbl.font = [UIFont boldSystemFontOfSize:16];
                [v addSubview:lbl];
                [lbl release];
                [win addSubview:v];
                [v release];
            }
        }
    }
}


- (void)applicationWillTerminate:(UIApplication *)application {
    
	NSLog(@"Estoy saliendo...");
	if ([[Context sharedContext] usuario]) {
		WS_Logout *request = [[[WS_Logout alloc] init] autorelease];
		[WSUtil execute:request];
		NSLog(@"WSUtil execute...");
	}
}



#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
