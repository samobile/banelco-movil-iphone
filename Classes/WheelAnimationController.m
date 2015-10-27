
#import "WheelAnimationController.h"
#import "CommonUIFunctions.h"
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"


@implementation WheelAnimationController

@synthesize activityConexion, alerta;
@synthesize alertView;
@synthesize label;

- (id) init {
	
	if (self = [super init]) {
		[self iniciarValores];
	}
	return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		[self iniciarValores];
	}
	return self;
}

- (void) iniciarValores {
	
	//contentBackView = [[UIView alloc] initWithFrame:self.view.frame];
	//[self.view addSubview:contentBackView];
	
//	activityConexion = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//	activityConexion.frame = CGRectMake(71, 71, 37, 37);
//	activityConexion.hidden = NO;
//	[activityConexion startAnimating];
//	//[self.view addSubview:activityConexion];
//	UIImageView* imagen = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alert.png"]];
//	imagen.frame = CGRectMake(0, 0, 180, 180);
//	
//	
//	[alertView addSubview:imagen];
//	label = [[UILabel alloc] initWithFrame:CGRectMake(16, 139, 138, 21)];
//	label.backgroundColor = [UIColor clearColor];
//	label.font = [UIFont systemFontOfSize:12.0];
//	label.textColor = [UIColor whiteColor];
//	
//	UIImageView* iv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 160, 22)];
//	iv.image =[UIImage imageNamed:@"lgo_appheader.png"];
//	
//	alertView = [[UIView alloc] initWithFrame:CGRectMake(70, 65, 180, 180)];
//	
////	[alertView addSubview:iv];
//	[alertView addSubview:imagen];
//	[alertView addSubview:activityConexion];
//	[alertView addSubview:label];
//	[imagen release];
//	[iv release];
	
}

- (void) iniciarValoresPos:(int)y {
	
	//contentBackView = [[UIView alloc] initWithFrame:self.view.frame];
	//[self.view addSubview:contentBackView];
	
//	activityConexion = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//	activityConexion.frame = CGRectMake(71, 71, 37, 37);
//	activityConexion.hidden = NO;
//	[activityConexion startAnimating];
//	//[self.view addSubview:activityConexion];
//	UIImageView* imagen = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alert.png"]];
//	imagen.frame = CGRectMake(0, 0, 180, 180);
//	
//	
//	[alertView addSubview:imagen];
//	label = [[UILabel alloc] initWithFrame:CGRectMake(16, 139, 138, 21)];
//	label.backgroundColor = [UIColor clearColor];
//	label.font = [UIFont systemFontOfSize:12.0];
//	label.textColor = [UIColor whiteColor];
//	
//	UIImageView* iv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 160, 22)];
//	iv.image =[UIImage imageNamed:@"lgo_appheader.png"];
//	
//	alertView = [[UIView alloc] initWithFrame:CGRectMake(70, y/*65*/, 180, 180)];
//	
//	//	[alertView addSubview:iv];
//	[alertView addSubview:imagen];
//	[alertView addSubview:activityConexion];
//	[alertView addSubview:label];
//	[imagen release];
//	[iv release];
	
}



/*
-(void) addContentView:(UIView*) v{
	[self.contentBackView addSubview:v];
}
*/
- (void)viewDidLoad {
	NSLog(@"Estoy en viewDidLoad");
    [super viewDidLoad];
	
}


-(void) inicializar{
	NSLog(@"i1");
	//[self accionConBloqueo];
	[self iniciarAccion];
}


-(void) encenderRueda{
//	[self.view addSubview:alertView];
//    alertView.backgroundColor = [UIColor clearColor];
//  //  alertView.center = self.view.superview.center;
//
//    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
//
//	
//	
//    CALayer *viewLayer = self.alertView.layer;
//    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
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



-(void) apagarRueda{
	[self performSelector:@selector(finalUpdate) withObject:nil afterDelay:0];
}


-(BOOL)accion {
	NSLog(@"Accion del padre");
	return YES;
}

- (void)accionWithDelegate:(WheelAnimationController *)delegate {
	NSLog(@"AccionWithDelegate del padre");
	[delegate accionFinalizada:TRUE];
}


-(BOOL) accionConBloqueo {

	//[self encenderRueda];

	
	BOOL res = [self accion];

//	if (res) {
//		[self apagarRueda];
//	} else {
//		[self apagarRueda];
//	}

	return res;
}


// Accion en hilo y con Alerta como indicador de proceso /////////// 

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

- (void)iniciarAccionConCorrimientoEnY:(int) defY {
	
//	[self iniciarValoresPos:defY];
//	[self encenderRueda];
//	[NSThread detachNewThreadSelector:@selector(executeAccion) toTarget:self withObject:nil];
    [self iniciarAccion];
	
}

- (void)executeAccion {
	//NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	[self accionWithDelegate:self];
	
	//[pool release];
}

- (void)accionFinalizada:(BOOL)resultado {
	[self finalUpdate];
}

//////////////////////////////////////////////////////////////////////


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)updateText:(NSString *)newText
{
    [self.label performSelectorOnMainThread:@selector(setText:) withObject:newText waitUntilDone:YES];
    //self.label.text = newText;
}

- (void)finalUpdate
{
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
//	[alertView release];
//	[label release];
//	//	[contentBackView release];
//	[activityConexion release];
    [super dealloc];
}


@end
