//
//  PagoMisCuentasController.m
//  BanelcoMovilIphone
//
//  Created by Demian on 8/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PagoMisCuentasController.h"
#import "Context.h"

@implementation PagoMisCuentasController
@synthesize bancoTitulo;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


- (void)viewDidLoad {
	[super viewDidLoad];
	self.bancoTitulo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 48)];
	self.bancoTitulo.image = [UIImage imageNamed:@"fnd_titulos.png"];
	UILabel* l = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, 320, 30)];
	l.text = @"Pago Mis Cuentas";
	l.backgroundColor = [UIColor clearColor];
	l.textAlignment = UITextAlignmentCenter;
	//l.textColor = [UIColor whiteColor];
	l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TitleTxtColor"];
	[self.bancoTitulo addSubview:l];
	[l release];
	[self.view addSubview:self.bancoTitulo ];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[bancoTitulo release];
    [super dealloc];
}

@end
