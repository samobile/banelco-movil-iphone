//
//  ConsultasController.m
//  BanelcoMovilIphone
//
//  Created by Demian on 8/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ConsultasController.h"


@implementation ConsultasController
@synthesize bancoTitulo;

- (id) init {
	if ((self = [super init])) {
		
		self.title = @"Consultas";
		
	}
	return self;
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.bancoTitulo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 48)];
	self.bancoTitulo.image = [UIImage imageNamed:@"fnd_titulos.png"];
	UILabel* l = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, 320, 30)];
	l.text = @"Consultas";
	l.backgroundColor = [UIColor clearColor];
	l.textAlignment = UITextAlignmentCenter;
	l.textColor = [UIColor whiteColor];
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
