    //
//  WaitingAlert.m
//  BanelcoMovilIphone
//
//  Created by German Levy on 10/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WaitingAlert.h"
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"

@implementation WaitingAlert

@synthesize alertView, label, activityConexion;
@synthesize finishSelector;
@synthesize theFinishTarget,hPos;

id theTarget = nil;

id paramObject = nil;


- (id)initWithH:(int)h {
    if ((self = [super init])) {
       
		self.hPos = h;
    }
    return self;
}

- (void) initValues {
	
//	activityConexion = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//	activityConexion.frame = CGRectMake(71, 71+hPos, 37, 37);
//	activityConexion.hidden = NO;
//	[activityConexion startAnimating];
//	
//
//	alertView = [[UIView alloc] initWithFrame:CGRectMake(70, 65+hPos, 180, 180)];
//	UIImageView* imagen = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alert.png"]];
//	
//	label = [[UILabel alloc] initWithFrame:CGRectMake(16, 139+hPos, 138, 21)];
//	label.backgroundColor = [UIColor clearColor];
//	label.font = [UIFont systemFontOfSize:12.0];
//	label.textColor = [UIColor whiteColor];
//	
//	UIImageView* iv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5+hPos, 160, 22)];
//	iv.image =[UIImage imageNamed:@"lgo_appheader.png"];
//	
//	imagen.frame = CGRectMake(0, 0+hPos, 180, 180);
//	[alertView addSubview:imagen];
////	[alertView addSubview:imagen];
////	[alertView addSubview:iv];
//	[alertView addSubview:activityConexion];
//	[alertView addSubview:label];
//	[imagen release];
//	[iv release];
	
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

-(void)processExecute:(NSString *)selector {
	//NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	//[NSThread sleepForTimeInterval:0.1];
	if (theTarget) {
		if ([theTarget respondsToSelector:NSSelectorFromString(selector)]) {
			if (paramObject) {
				[theTarget performSelector:NSSelectorFromString(selector) withObject:paramObject];
			} else {
				[theTarget performSelector:NSSelectorFromString(selector)];
			}
		}
	}
	
	if(self.finishSelector){
		if ([self.theFinishTarget respondsToSelector:NSSelectorFromString(finishSelector)]) {
			[self.theFinishTarget performSelector:NSSelectorFromString(finishSelector)];
		}
	}else{
		[self detener];
	}
	//[pool release];
	
	
}

-(void) iniciar {
//	[self addSubview:alertView];
//    alertView.backgroundColor = [UIColor clearColor];
//	
//    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
//	
//	
//    CALayer *viewLayer = self.alertView.layer;
//    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
//    
//    animation.duration = 0.35555555;
//    animation.values = [NSArray arrayWithObjects:
//                        [NSNumber numberWithFloat:0.6],
//                        [NSNumber numberWithFloat:1.1],
//                        [NSNumber numberWithFloat:.9],
//                        [NSNumber numberWithFloat:1],
//                        nil];
//    animation.keyTimes = [NSArray arrayWithObjects:
//                          [NSNumber numberWithFloat:0.0],
//                          [NSNumber numberWithFloat:0.6],
//                          [NSNumber numberWithFloat:0.8],
//                          [NSNumber numberWithFloat:1.0], 
//                          nil];    
//    
//    [viewLayer addAnimation:animation forKey:@"transform.scale"];
//    
//    [self performSelector:@selector(updateText:) withObject:@"Aguardá un momento, por favor" afterDelay:1.0];
//    [self performSelector:@selector(updateText:) withObject:@"Aguardá un momento, por favor." afterDelay:2.0];
//    [self performSelector:@selector(updateText:) withObject:@"Aguardá un momento, por favor.." afterDelay:3.0];
//    [self performSelector:@selector(updateText:) withObject:@"Aguardá un momento, por favor..." afterDelay:4.5];
	
}

-(void) startWithSelector:(NSString *)selector fromTarget:(id)t {
	
	//Inicializa si todavia no lo hizo
//	if (!alertView || !activityConexion || !label) {
//		[self initValues];
//	}
//	else {
//		//Hace visible el alertView en caso de que ya este creado
//		self.alertView.alpha = 1.0;
//	}
//
//	
//	[self iniciar];
	
	//Lanza un nuevo thread en el que ejecuta el selector para el target pasado
	if (t && selector) {
		theTarget = t;
		//[NSThread detachNewThreadSelector:@selector(processExecute:) toTarget:self withObject:selector];
        MBProgressHUD *prog = [[MBProgressHUD alloc] initWithView:[[[UIApplication sharedApplication] delegate] window]];
        [[[[UIApplication sharedApplication] delegate] window] addSubview:prog];
        prog.delegate = nil;
        prog.labelText = @"Aguardá un momento, por favor...";
        [prog showWhileExecuting:@selector(processExecute:) onTarget:self withObject:selector animated:YES];
        [prog release];
	}
	
}

-(void) startWithSelector:(NSString *)selector fromTarget:(id)t withObject:(id)object {
	
	//Inicializa si todavia no lo hizo
//	if (!alertView || !activityConexion || !label) {
//		[self initValues];
//	}
//	else {
//		//Hace visible el alertView en caso de que ya este creado
//		self.alertView.alpha = 1.0;
//	}
//	
//	
//	[self iniciar];
	
	paramObject = object;
	
	//Lanza un nuevo thread en el que ejecuta el selector para el target pasado
	if (t && selector) {
		theTarget = t;
		//[NSThread detachNewThreadSelector:@selector(processExecute:) toTarget:self withObject:selector];
        MBProgressHUD *prog = [[MBProgressHUD alloc] initWithView:[[[UIApplication sharedApplication] delegate] window]];
        [[[[UIApplication sharedApplication] delegate] window] addSubview:prog];
        prog.delegate = nil;
        prog.labelText = @"Aguardá un momento, por favor...";
        [prog showWhileExecuting:@selector(processExecute:) onTarget:self withObject:selector animated:YES];
        [prog release];
	}
	
}


-(void) startWithSelector:(NSString *)selector fromTarget:(id)t andFinishSelector:(NSString*)finishSel formTarget:(id) t2{
	
	//Inicializa si todavia no lo hizo
//	if (!alertView || !activityConexion || !label) {
//		[self initValues];
//	}
//	
//	[self iniciar];
	self.finishSelector = finishSel;
	self.theFinishTarget = t2;
	//Lanza un nuevo thread en el que ejecuta el selector para el target pasado
	if (t && selector) {
		theTarget = t;
		//[NSThread detachNewThreadSelector:@selector(processExecute:) toTarget:self withObject:selector];
        MBProgressHUD *prog = [[MBProgressHUD alloc] initWithView:[[[UIApplication sharedApplication] delegate] window]];
        [[[[UIApplication sharedApplication] delegate] window] addSubview:prog];
        prog.delegate = nil;
        prog.labelText = @"Aguardá un momento, por favor...";
        [prog showWhileExecuting:@selector(processExecute:) onTarget:self withObject:selector animated:YES];
        [prog release];
	}
	
}



- (void)updateText:(NSString *)newText
{
    [self.label performSelectorOnMainThread:@selector(setText:) withObject:newText waitUntilDone:YES];
    //self.label.text = newText;
}


-(void) detenerRueda {
//	[self performSelector:@selector(finalUpdate) withObject:nil afterDelay:0];
}

- (void)detener {
//    [UIView beginAnimations:@"" context:nil];
//    self.alertView.alpha = 0.0;
//    [UIView commitAnimations];
//    [UIView setAnimationDuration:0.35];
//    [self performSelector:@selector(removeAlert) withObject:nil afterDelay:0.5];
//	[[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

- (void)removeAlert
{
//    [self.alertView removeFromSuperview];
//    self.alertView.alpha = 1.0;
}


- (void)dealloc {
//	[hPos release];	
	[finishSelector release];
	[theFinishTarget release];
//	[alertView release];
//	[label release];
//	[activityConexion release];
	
    [super dealloc];
}


@end
