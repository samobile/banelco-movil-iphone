//
//  ForzarCambioDeClaveController.h
//  BanelcoMovilIphone
//
//  Created by Demian on 9/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaitingAlert.h"

@class LoginController;

@interface CambioClaveController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate> {
	
	IBOutlet UITextField* oldPassField;
	IBOutlet UITextField* newPassField;
	IBOutlet UITextField* newPassConfirmField;
    

	
	UIButton* blankButton;
	
	WaitingAlert *alert;
	UIView  *alertView;
	UILabel* label;
	UIActivityIndicatorView* activityConexion;

	IBOutlet UILabel* tituloDePantalla;
    

	
	
	UIImageView* barTeclado;
	UIButton* barTecladoButton;
	
	IBOutlet UIImageView *fndImage;
    
    LoginController *loginController;
}

@property (nonatomic, assign) LoginController *loginController;

@property (nonatomic, retain) UIImageView *fndImage;

@property(nonatomic,retain) UIButton* barTecladoButton;

@property(nonatomic,retain) UIImageView* barTeclado;


@property(nonatomic,retain)  UILabel* tituloDePantalla;


@property(nonatomic,retain) WaitingAlert *alert;

@property(nonatomic,retain) UIView  *alertView;
@property(nonatomic,retain) UILabel* label;
@property(nonatomic,retain) UIActivityIndicatorView* activityConexion;


@property(nonatomic,retain) IBOutlet UITextField* oldPassField;
@property(nonatomic,retain) IBOutlet UITextField* newPassField;
@property(nonatomic,retain) IBOutlet UITextField* newPassConfirmField;



@property(nonatomic,retain) UIButton* blankButton;

-(IBAction) aceptar;
-(IBAction) activarBoton;
-(void) hideKeyboard;

-(BOOL)doChangeOfPW;

- (IBAction)dismissKeyboard: (id)sender;

- (void)clearFields;


@end