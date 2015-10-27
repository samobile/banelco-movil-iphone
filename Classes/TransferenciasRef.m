//
//  TransferenciasRef.m
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 24/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TransferenciasRef.h"
#import "CommonFunctions.h"
#import "TransferenciasEjecutar.h"
#import "MenuBanelcoController.h"

@implementation TransferenciasRef

@synthesize refText, botonContinuar, transfer;
@synthesize barTeclado,barTecladoButton;
@synthesize lRef;

- (id) init {
	if ((self = [super init])) {
		
		self.title = @"A Otras Ctas. Agendadas";
		
	}
	return self;
}


/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
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

-(void) viewDidLoad{
	[super viewDidLoad];
	
    if (![Context sharedContext].personalizado) {
        lRef.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:15];
        refText.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:17];
    }
    
	barTeclado = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"barra_teclado.png"]];
	barTeclado.alpha = 0;
	
	barTecladoButton = [UIButton buttonWithType:UIButtonTypeCustom];
	barTecladoButton.frame = CGRectMake(222, IPHONE5_HDIFF(488), 88, 29);
	barTecladoButton.alpha =1;
	//	barTecladoButton.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"barra_boton.png"]];
	
	[barTecladoButton setImage:[UIImage imageNamed:@"btn_TecContinuar.png"] forState:UIControlStateNormal];
	[barTecladoButton setTitle:@"" forState:UIControlStateNormal];
	[barTecladoButton addTarget:self action:@selector(continuar) forControlEvents:UIControlEventTouchUpInside];
	
	
	[self.view addSubview:barTeclado];
	[self.view addSubview:barTecladoButton];
	
	lRef.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
	
}

- (IBAction) continuar {
	[self dismissAll];
	TransferenciasEjecutar *t = [[TransferenciasEjecutar alloc] initWithTitle:self.title];
	t.cotizacion = nil;
	self.transfer.referencia = [NSString stringWithFormat:@"%@",refText.text];
	t.transfer = self.transfer;
	//t.tInmediata = self.tInmediata;
	[[MenuBanelcoController sharedMenuController] pushScreen:t];
}

- (void)screenDidAppear {
	[botonContinuar setUserInteractionEnabled:YES];
}

- (void)dismissAll {
	//if ([refText isFirstResponder]) {
		[refText resignFirstResponder];
	//}
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
	//Validacion de nros
	if (![CommonFunctions hasNumbers:string]) {
		return NO;
	}
	if ([textField.text length] + [string length] > 12) {
		return NO;
	}
	return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	[textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField*) textField {
	[textField resignFirstResponder]; 
	
	[self continuar];
	
    return YES;
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void) keyboardWillShow: (NSNotification*) aNotification {	
	
	
	barTeclado.frame = CGRectMake(0, IPHONE5_HDIFF(480), 320, 45);
	barTeclado.alpha = 1;
	
	barTecladoButton.frame = CGRectMake(222, IPHONE5_HDIFF(488), 88, 29);
	barTecladoButton.alpha =1;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	barTeclado.frame = CGRectMake(0, IPHONE5_HDIFF(114), 320, 45);
	barTecladoButton.frame = CGRectMake(222, IPHONE5_HDIFF(122), 88, 29);
	[UIView commitAnimations];
	
	
	
	
	
}

- (void) keyboardWillHide: (NSNotification*) aNotification {
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	barTeclado.frame = CGRectMake(0, IPHONE5_HDIFF(480), 320, 50);
	barTeclado.alpha =0;
	barTecladoButton.frame = CGRectMake(222, IPHONE5_HDIFF(488), 88, 29);
	barTecladoButton.alpha =1;
	
	
	
	[UIView commitAnimations];
}


- (void)dealloc {
	
	[barTeclado release];
	[barTecladoButton release];
	//[tInmediata release];
	
	[lRef release];
	
    [super dealloc];
}


@end
