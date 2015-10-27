//
//  AceptarTerminosController.m
//  BanelcoMovilIphone
//
//  Created by Demian on 9/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AceptarTerminosController.h"
#import "TerminosYCondicionesPaginado.h"
#import "WS_AceptarTerminosYCondiciones.h"
#import "BanelcoMovilIphoneViewController.h"
#import "BanelcoMovilIphoneViewControllerGenerico.h"
#import "Context.h"
#import "CommonUIFunctions.h"
#import "WSUtil.h"
#import "WaitingAlert.h"
#import "Configuration.h"
#import "CommonFunctions.h"


@implementation AceptarTerminosController
@synthesize terminosAceptados;
@synthesize aceptarTerminosBoton;
@synthesize continuarBoton;
@synthesize activityConexion;
@synthesize ltyc, fndApp, contr;

- (id)initWithController:(id)controller {
    self = [super init];
    if (self) {
        self.contr = controller;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    yInicial = -1;
    if (![Context sharedContext].personalizado) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    
	self.terminosAceptados = NO;
	self.continuarBoton.enabled = NO;
	
	self.activityConexion.hidden = YES;
	
	ltyc.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
    if (![Context sharedContext].personalizado) {
        ltyc.font = [UIFont fontWithName:@"BanelcoBeau-BoldItalic" size:20];
    }
    
    CGRect r = self.fndApp.frame;
    r.size.height = IPHONE5_HDIFF(r.size.height);
    self.fndApp.frame = r;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    if (yInicial == -1) {
//        yInicial = self.view.superview.frame.origin.y;
//    }
//    else {
//        CGRect r2 = self.view.frame;
//        r2.origin.y = 20;
//        self.view.superview.frame = r2;
//    }
//    
//    NSLog(@"aaaaa: %f",self.view.frame.origin.y);
}

-(IBAction) verTerminos{
	NSLog(@"Ver Terminos y Condiciones");
	TerminosYCondicionesPaginado* atycc = [[TerminosYCondicionesPaginado alloc] initWithNibName:@"TerminosYCondicionesPaginado" bundle:nil];
	atycc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	[self.contr presentModalViewController:atycc animated:YES];
	
	//[atycc autorelease];
}

-(IBAction) aceptarTerminos{
	NSLog(@"Aceptar Terminos y condiciones");
	if(self.terminosAceptados){
		self.terminosAceptados = NO;
		self.continuarBoton.enabled = NO;
		[self.aceptarTerminosBoton setImage:[UIImage imageNamed:@"btn_check.png"] forState:UIControlStateNormal];
        self.aceptarTerminosBoton.accessibilityLabel = @"Aceptar términos y condiciones desactivado";
	}else {
		self.terminosAceptados = YES;
		self.continuarBoton.enabled = YES;
		[self.aceptarTerminosBoton setImage:[UIImage imageNamed:@"btn_checkselec.png"] forState:UIControlStateNormal];
        self.aceptarTerminosBoton.accessibilityLabel = @"Aceptar términos y condiciones activado";
	}

}


-(BOOL) doAceptarTerminosYCondiciones{
	
	Context *context = [Context sharedContext];
	
	WS_AceptarTerminosYCondiciones *request = [[[WS_AceptarTerminosYCondiciones alloc] init] autorelease]; 
	
	request.userToken = [context getToken];
	

	id result = [WSUtil execute:request];
	
	if (![result isKindOfClass:[NSError class]]) {
		NSLog(@"Acepto bien!");		
	} else {
		NSString *errorCode = [[(NSError *)result userInfo] valueForKey:@"faultCode"];
        if ([errorCode isEqualToString:@"ss"]) {
            return NO;
        }
		NSString *errorDesc = [[(NSError *)result userInfo] valueForKey:@"description"];
		[CommonUIFunctions showAlert:@"Error Terminos y Condiciones" withMessage:errorDesc andCancelButton:@"Volver"];
		
		return NO;
		
	}
	
	return YES;
}

-(IBAction) continuar{

	WaitingAlert* wa = [[WaitingAlert alloc] init];
	[self.view addSubview:wa];
	[wa startWithSelector:@"aceptar" fromTarget:self];
		
	
}

-(void) aceptar{
	//[self enableControls:NO];
	if ([self doAceptarTerminosYCondiciones]){
		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
		[prefs setBool:YES forKey:@"yaAceptoTerminosYCondiciones"];
		[prefs synchronize];
		//[self enableControls:YES];
//		BanelcoMovilIphoneViewController* p1 = [[BanelcoMovilIphoneViewController alloc] init];
//		p1.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//		[self presentModalViewController:p1 animated:YES];
//		[p1 autorelease];
        
        [self.contr performSelector:@selector(removeTerminos) withObject:nil];
        
        // Menu Principal
        BanelcoMovilIphoneViewController* p1 = [BanelcoMovilIphoneViewController sharedMenuController];
        p1.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        //[self presentModalViewController:p1 animated:YES];
        [self.contr presentModalViewController:p1 animated:YES];
        //[p1 viewDidLoad];
        
        //[self dismissViewControllerAnimated:NO completion:nil];
        
        
	}else{
		//[self enableControls:YES];
	}
	
}


- (void)enableControls:(BOOL)enable {
	if (enable) {
		activityConexion.hidden = YES;
		[activityConexion stopAnimating];		
	} else {
		activityConexion.hidden = NO;
		[activityConexion startAnimating];
	}
}




- (void)dealloc {
	//[activityConexion release];
    //self.activityConexion = nil;
	//[aceptarTerminosBoton release];
    //self.aceptarTerminosBoton = nil;
	//[continuarBoton release];
    //self.continuarBoton = nil;
    //self.fndApp = nil;
    //self.contr = nil;
    [super dealloc];
}


@end
