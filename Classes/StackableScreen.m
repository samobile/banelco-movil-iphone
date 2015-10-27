//
//  StackableScreen.m
//  BanelcoMovilIphone
//
//  Created by German Levy on 10/2/10.
//  Copyright 2010 -. All rights reserved.
//

#import "StackableScreen.h"
#import "MenuBanelcoController.h"


@implementation StackableScreen

@synthesize nav_volver;



- (id)init {
    if ((self = [super init])) {
		nav_volver = YES;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		nav_volver = YES;
    }
    return self;
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
}
*/

// Si del pre-proceso de la pantalla no surgen datos el cancel del alerta vuelve
// a la pantalla anterior
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
	
	[[MenuBanelcoController sharedMenuController] volver];
	
}

- (void)screenWillBeBack {}


- (void)dealloc {
    [super dealloc];
}


@end
