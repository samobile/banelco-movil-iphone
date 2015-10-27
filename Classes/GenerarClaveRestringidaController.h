//
//  GenerarClaveRestringidaController.h
//  BanelcoMovilIphone
//
//  Created by German Levy on 5/15/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaitingAlert.h"


@interface GenerarClaveRestringidaController : UIViewController <UIAlertViewDelegate, UIActionSheetDelegate, UITextFieldDelegate> {

	WaitingAlert *alert;
	UIViewController *controllerLogin;

	int tipoSeleccionado;
	IBOutlet UILabel *ltdoc;
	IBOutlet UILabel *lTipoDocumento;
	
	IBOutlet UITextField *dniField;
	IBOutlet UITextField *fechaNacField;
	IBOutlet UITextField *areaField, *celField;
	
	int carrierSeleccionado;
	IBOutlet UILabel *lCarrier;

	IBOutlet UITextField *nroTarjetaField;
	IBOutlet UITextField *fechaTarjetaField;
	IBOutlet UITextField *passField;	
	IBOutlet UITextField *pass2Field;
    
    IBOutlet UILabel *lblTipoDoc;
    IBOutlet UILabel *lbl0;
    IBOutlet UILabel *lbl15;
    IBOutlet UILabel *lblSelOper;
	
	UIView *contenedorFecha;
	UIView *contenedorFechaVenc;
	NSString *fechaSeleccionada;
	
	UIActionSheet *subMenuDNI;
	UIActionSheet *subMenuCarrier;
	
	UIButton *blankButton;
	UIImageView *barTeclado;
	UIButton *barTecladoButton;
	
	CGFloat	animatedDistance;
	
    IBOutlet UIImageView *fndImage;
    
    BOOL mustBack;
}

@property (nonatomic, retain) UIImageView *fndImage;

@property(nonatomic,retain) WaitingAlert *alert;
@property (nonatomic, retain) UIViewController *controllerLogin;

@property(nonatomic, retain) UILabel *ltdoc;
@property(nonatomic,retain) UILabel *lTipoDocumento;

@property(nonatomic,retain) UITextField *dniField;
@property(nonatomic,retain) UITextField *fechaNacField;
@property(nonatomic,retain) UITextField *areaField, *celField;

@property(nonatomic,retain) UILabel *lCarrier;

@property(nonatomic,retain) UITextField *nroTarjetaField;
@property(nonatomic,retain) UITextField *fechaTarjetaField;
@property(nonatomic,retain) UITextField *passField;	
@property(nonatomic,retain) UITextField *pass2Field;

@property(nonatomic,retain) UIView *contenedorFecha;
@property(nonatomic,retain) UIView *contenedorFechaVenc;
@property(nonatomic,retain) NSString *fechaSeleccionada;

@property(nonatomic,retain) UIActionSheet *subMenuDNI;
@property(nonatomic,retain) UIActionSheet *subMenuCarrier;

@property(nonatomic,retain) UIButton *blankButton;
@property(nonatomic,retain) UIButton *barTecladoButton;
@property(nonatomic,retain) UIImageView *barTeclado;

@property (nonatomic, retain) UILabel *lblTipoDoc;
@property (nonatomic, retain) UILabel *lbl0;
@property (nonatomic, retain) UILabel *lbl15;
@property (nonatomic, retain) UILabel *lblSelOper;

@property BOOL mustBack;

-(IBAction)cambiarTipoDocumento;

-(IBAction)cambiarCarrier;

-(IBAction)abrirSelectorFechaNac;

-(IBAction)abrirSelectorFechaVenc;

-(IBAction)cerrarSelectorFecha;

-(IBAction)aceptarSelectorFecha;

-(IBAction)generarClave;

-(IBAction)volver;

- (void)keyboardButtonAction;

-(IBAction) mostrarAyuda;

- (void)resetKeyboard;

@end
