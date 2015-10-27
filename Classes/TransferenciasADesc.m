//
//  TransferenciasADesc.m
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 26/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TransferenciasADesc.h"
#import "CommonFunctions.h"
#import "CommonUIFunctions.h"
#import "WS_ModificarCBU.h"
#import "WSUtil.h"
#import "Context.h"
#import "MenuBanelcoController.h"
#import "CuentasList.h"
#import "WaitingAlert.h"

@implementation TransferenciasADesc

@synthesize descripcionText, botonAceptar, cuentaCBU;
@synthesize lDescripcion;

WaitingAlert *w;

- (id) initWithCuenta:(Cuenta *)cta {
	if ((self = [super init])) {
		
		self.cuentaCBU = cta;
		self.title = @"Agenda";
		
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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	CGRect r =  CGRectMake(20, 40, 300, 21);
	UILabel *lcbu = [[UILabel alloc] initWithFrame:r];
	lcbu.backgroundColor = [UIColor clearColor];
	if (![Context sharedContext].personalizado) {
        lcbu.font = [UIFont fontWithName:@"BanelcoBeau-Italic" size:17];
    }
    else {
        lcbu.font = [UIFont fontWithName:@"Helvetica-Oblique" size:17];
    }
	lcbu.text = [NSString stringWithFormat:@"CBU %@",cuentaCBU.codigo];
	lcbu.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	[self.view addSubview:lcbu];
	[lcbu release];
	
    if (![Context sharedContext].personalizado) {
        lDescripcion.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:17];
        descripcionText.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:17];
    }
	lDescripcion.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	
	if (cuentaCBU.nombre && ![cuentaCBU.nombre isEqualToString:@""]) {
		descripcionText.text = [cuentaCBU.nombre stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	}
	
	w = [[WaitingAlert alloc] init];
	[self.view addSubview:w];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (IBAction) aceptar {
	if ([descripcionText.text isEqualToString:@""]) {
		[CommonUIFunctions showAlert:@"Agenda" withMessage:@"Debes completar la descripción" andCancelButton:@"Cerrar"];
		return;
	}
	
	[w startWithSelector:@"modificarCBU" fromTarget:self];
	
}

- (void)modificarCBU {
	self.cuentaCBU.nombre = [descripcionText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	WS_ModificarCBU *request = [[WS_ModificarCBU alloc] init];
	request.userToken = [[Context sharedContext] getToken];
	request.cuentaCBU = self.cuentaCBU;

	id result = [WSUtil execute:request];
	
	[w detener];
	
	if ([result isKindOfClass:[NSError class]]) {
        
        NSString *errorCode = [[(NSError *)result userInfo] valueForKey:@"faultCode"];
        if ([errorCode isEqualToString:@"ss"]) {
            return;
        }
        
		NSString *errorDesc = [[(NSError *)result userInfo] valueForKey:@"description"];
		[CommonUIFunctions showAlert:self.title withMessage:errorDesc andCancelButton:@"Cerrar"];
		return;
	}
	
	//[[MenuBanelcoController sharedMenuController] volver];
	[CommonUIFunctions showAlert:self.title withMessage:@"La operación se realizó correctamente." cancelButton:@"Volver" andDelegate:self];
	
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
	//Validacion de caracteres
	//if (![CommonFunctions hasAlphabetAndNumbers:string]) {
	//	return NO;
	//}
	if ([textField.text length] + [string length] > 22) {
		return NO;
	}
	
	return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	[textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField*) textField {
	[textField resignFirstResponder];
	
	[self aceptar];
	
    return YES;
}

- (void)dismissAll {
	if ([descripcionText isFirstResponder]) {
		[descripcionText resignFirstResponder];
	}
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[lDescripcion release];
    [super dealloc];
}


@end
