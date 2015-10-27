//
//  BanelcoMovilIphoneViewController.h
//  BanelcoMovilIphone
//
//  Created by Demian on 8/23/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
//#import "AppContainerViewController.h"
#import "Stack.h"

@class MCUITabBarViewController;
@class ChangePasswordController;
@class TyCPaginadoController;
@class AyudaController;

@interface BanelcoMovilIphoneViewControllerGenerico : UIViewController <UIActionSheetDelegate,MFMailComposeViewControllerDelegate, 
MFMessageComposeViewControllerDelegate>{

	IBOutlet UIButton *btnConsulta;
	IBOutlet UIButton *btnPmc;
    IBOutlet UIButton *btnRecarga;
    IBOutlet UIButton *btnTransf;
    IBOutlet UIButton *btnBimo;
    
	IBOutlet UIImageView* imagenBancoHome;
	
	UIView* centralScreenSpace;
	int actualIndiceScreen;
	MCUITabBarViewController* mctabbar;
	
	ChangePasswordController* changePass;
	TyCPaginadoController* terminos;
	AyudaController* ayuda;
	
	
	UIImageView* sombra;
	
	UIImageView* barra;
	UIActionSheet* recomendarSheet;
	
	UIButton* inicio;
	
	UIButton* btn_volver;
    
    UIButton *btn_salir;
	
	
	Stack *pantallas;
    
    IBOutlet UIView *opcionesContainer;
    
    //P2P
   // AppContainerViewController *appContainer;
    
    IBOutlet UIImageView *fndImage;
    
    BOOL menuConfigured;
}

@property (nonatomic, retain) UIImageView *fndImage;

//P2P
//@property (nonatomic, retain) AppContainerViewController *appContainer;

@property (nonatomic, retain) UIButton *btnConsulta;
@property (nonatomic, retain) UIButton *btnPmc;
@property (nonatomic, retain) UIButton *btnRecarga;
@property (nonatomic, retain) UIButton *btnTransf;
@property (nonatomic, retain) UIButton *btnBimo;

@property (nonatomic,retain) Stack *pantallas;
@property (nonatomic,retain) UIView* centralScreenSpace;
@property (nonatomic,retain) UIButton* btn_volver;
@property (nonatomic,retain) UIImageView* imagenBancoHome;
@property int actualIndiceScreen;
@property (nonatomic,retain) MCUITabBarViewController* mctabbar;
@property (nonatomic,retain) ChangePasswordController* changePass;
@property (nonatomic,retain) UIImageView* sombra;
@property (nonatomic,retain) UIImageView* barra;
@property (nonatomic,retain) TyCPaginadoController* terminos;
@property (nonatomic,retain) AyudaController* ayuda;
@property (nonatomic,retain) UIButton* inicio;
@property (nonatomic,retain) UIActionSheet* recomendarSheet;

@property (nonatomic, retain) UIView *opcionesContainer;

@property (nonatomic, retain) UIButton *btn_salir;

+(BanelcoMovilIphoneViewControllerGenerico *)sharedMenuController;
-(IBAction) irMenuConsulta;
-(IBAction) irMenuPagoCuentas;
-(IBAction) irMenuCargaCelular;
-(IBAction) irMenuTransferencias;
-(IBAction)irBimo;
-(IBAction) irAlStore;

//CAMBIO agregado
-(id) init;
- (void)viewDidLoad ;

+ (void)resetAll;
//- (void)pushScreen:(StackableScreen *)screen;
//
@end

