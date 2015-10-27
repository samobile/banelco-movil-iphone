//
//  StackableScreen.m
//  BanelcoMovilIphone
//
//  Created by German Levy on 10/2/10.
//  Copyright 2010 -. All rights reserved.
//

#import "StackableScreen.h"
#import "MenuBanelcoController.h"
#import "ExtraccionesMandato.h"


@implementation StackableScreen

@synthesize nav_volver, nav_inicio;



- (id)init {
    if ((self = [super init])) {
		self.nav_volver = YES;
        self.nav_inicio = YES;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		self.nav_volver = YES;
        self.nav_inicio = YES;
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
	
    if (![self isKindOfClass:[ExtraccionesMandato class]]) {
        [[MenuBanelcoController sharedMenuController] volver];
    }
	
	
}

- (void)screenWillBeBack {}
- (void)screenDidBack {}


- (void)dealloc {
    [super dealloc];
}


@end
