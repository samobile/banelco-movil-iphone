//
//  TerminosController.m
//  BanelcoMovilIphone
//
//  Created by Demian on 9/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TerminosController.h"
#import "Context.h"

@implementation TerminosController

@synthesize lTerm, fndImage;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (![Context sharedContext].personalizado) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
	
	lTerm.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
    
    CGRect r = self.fndImage.frame;
    r.size.height = IPHONE5_HDIFF(r.size.height);
    self.fndImage.frame = r;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[lTerm release];
    self.fndImage = nil;
    [super dealloc];
}


@end
