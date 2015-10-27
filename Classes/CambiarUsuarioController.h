//
//  ChangePasswordController.h
//  BanelcoMovilIphone
//
//  Created by Demian on 8/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StackableScreen.h"
#import "WaitingAlert.h"
@class BanelcoMovilIphoneViewController;

@interface CambiarUsuarioController : StackableScreen <UITextFieldDelegate,UIAlertViewDelegate> {

	IBOutlet UITextField* oldPassField;
	IBOutlet UITextField* theNewPassField;
    IBOutlet UITextField* theNewPassConfirmField;
    
    IBOutlet UILabel* titDatos;
    IBOutlet UILabel* label;
    
	BanelcoMovilIphoneViewController* contr;
	WaitingAlert *alert;
	UIButton* blankButton;
	UILabel*  tituloDePantalla;
	UIView  *alertView;
	
	UIActivityIndicatorView* activityConexion;
	UIImageView* barTeclado;
	UIButton* barTecladoButton;

	IBOutlet UIImageView *fndImage;
}

@property (nonatomic, retain) UIImageView *fndImage;

@property(nonatomic,retain) UIButton* barTecladoButton;
@property(nonatomic,retain) UIImageView* barTeclado;
@property(nonatomic,retain) WaitingAlert *alert;
@property(nonatomic,retain) UIView  *alertView;
@property(nonatomic,retain) IBOutlet UILabel* tituloDePantalla;

@property(nonatomic,retain) UIActivityIndicatorView* activityConexion;
@property(nonatomic,retain) BanelcoMovilIphoneViewController* contr;
@property(nonatomic,retain) IBOutlet UITextField* oldPassField;
@property(nonatomic,retain) IBOutlet UITextField* theNewPassField;
@property (nonatomic, retain) UITextField* theNewPassConfirmField;

@property(nonatomic,retain) IBOutlet UILabel* titDatos;
@property(nonatomic,retain) UILabel* label;

@property(nonatomic,retain) UIButton* blankButton;

-(id) initWithController:(BanelcoMovilIphoneViewController*)control CargaDatos:(BOOL)cargaDatos;
-(IBAction) aceptar;
-(IBAction) activarBoton;
-(void) hideKeyboard;

-(BOOL)doChangeOfPW;

- (IBAction)dismissKeyboard: (id)sender;

- (void)clearFields;

@end
