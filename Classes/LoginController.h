//
//  LoginController.h
//  BanelcoMovilIphone
//
//  Created by Demian on 8/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaitingAlert.h"
#import "GAITrackedViewController.h"


@interface LoginController : UIViewController <UIAlertViewDelegate,UITextFieldDelegate,UIActionSheetDelegate>{
	
	WaitingAlert *alert;
	
	int tipoSeleccionado;
	
	IBOutlet UILabel* lTipoDocumento;
	
	IBOutlet UITextField* userField;
	IBOutlet UITextField* passField;
	bool ingreso;
	UILabel* label;
	IBOutlet UIButton* link;
	
	UIButton* volverB;
	UIButton* blankButton;
	UIActionSheet *subMenu;
	bool ocultarLink;
	
	UIActionSheet *subMenuGeneracion;
	UIImageView* barTeclado;
	UIButton* barTecladoButton;
	
	IBOutlet UILabel *ltdoc;
	
	BOOL mostrarMsgClave;
	
	// Datos para login desde actividad de generacion de clave
	NSString *doc;
	NSString *docType;
	NSString *password;
    
    IBOutlet UIImageView *fndImage;
    
    BOOL forceLogin;
    BOOL removeTerm;
}

@property BOOL forceLogin;
@property (nonatomic, retain) UIImageView *fndImage;

@property(nonatomic,retain) UIButton* barTecladoButton;

@property(nonatomic,retain) UIImageView* barTeclado;

//@property(nonatomic,retain) NSString* tipoSeleccionado;
@property bool ocultarLink;

@property(nonatomic,retain) WaitingAlert *alert;
@property(nonatomic,retain) UILabel* label;
@property(nonatomic,retain) IBOutlet UILabel* lTipoDocumento;
@property(nonatomic,retain) UIButton* blankButton;
@property(nonatomic,retain) UIButton* volverB;
@property(nonatomic,retain) UITextField* userField;
@property(nonatomic,retain) UITextField* passField;
@property(nonatomic,retain) UIActionSheet *subMenu;
@property(nonatomic,retain) UIActionSheet *subMenuGeneracion;
@property(nonatomic,retain) UIButton* link;
@property bool ingreso;
@property (nonatomic, retain) IBOutlet UILabel *ltdoc;

@property(nonatomic,retain) NSString *doc;
@property(nonatomic,retain) NSString *docType;
@property(nonatomic,retain) NSString *password;

-(void) volver;
//-(void) deseleccionarTodosLosBotones;
-(IBAction) cambiarTipoDocumento;

-(IBAction) activarBoton;
-(void) hideKeyboard;

-(IBAction) generarClave;

-(void) irACambioDeClave;

-(void) ingresarAction:(id) sender;
-(void) loginOfDoc:(NSString *)doc ofType:(NSString *)docType andPW:(NSString *)pw;

-(IBAction) dismissKeyboard: (id)sender;
-(void) cambioTipoDocumento;
-(IBAction) ingresar:(id) sender;

- (IBAction)pressDoneKey:(id)sender;

-(void) finishAlert;

-(id) initPersonalizado;



-(IBAction) mostrarAyuda;

- (IBAction)irAOlvideUsuario:(id)sender;

-(void)doLoginOfDoc:(NSString *)pDoc ofType:(NSString *)pDocType andPW:(NSString *)pPw;
-(void)doLoginOfUser;

- (void)forzarLogin;
- (void)removeTerminos;

- (void)resetKeyboard;

@end
