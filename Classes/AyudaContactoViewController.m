//
//  AyudaContactoViewController.m
//  BanelcoMovilIphone
//
//  Created by German Levy on 2/20/14.
//
//

#import "AyudaContactoViewController.h"
#import "Context.h"

@interface AyudaContactoViewController ()
-(id) init;
@end

@implementation AyudaContactoViewController

@synthesize fndApp;

-(id) init{
	
	if (self = [super init]){
	self.nav_volver = YES;	
	}
    
	return self;
	
}




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       self.nav_volver = YES;
    
    }
    return self;
}


- (void)iniciarAccion {
	
    //	alerta = [CommonUIFunctions showWatingAlert:@"Alerta de prueba"];
    
    //	[self iniciarValores];
    //	[self encenderRueda];
    //	[NSThread detachNewThreadSelector:@selector(executeAccion) toTarget:self withObject:nil];
    
    MBProgressHUD *prog = [[MBProgressHUD alloc] initWithView:[[[UIApplication sharedApplication] delegate] window]];
	[[[[UIApplication sharedApplication] delegate] window] addSubview:prog];
	prog.delegate = nil;
	prog.labelText = @"Aguardá un momento, por favor...";
	[prog showWhileExecuting:@selector(executeAccion) onTarget:self withObject:nil animated:YES];
	[prog release];
	
}

-(IBAction)llamar:(id)sender
{
    NSString *phoneNumber =  @"telprompt://5556-9556";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (![Context sharedContext].personalizado) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    
     self.fndApp.frame = CGRectMake(self.fndApp.frame.origin.x, self.fndApp.frame.origin.y, self.fndApp.frame.size.width, IPHONE5_HDIFF(self.fndApp.frame.size.height + 128));
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) volver{
	
	[self dismissModalViewControllerAnimated:YES];
}

@end
