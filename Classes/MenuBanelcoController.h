#import <UIKit/UIKit.h>
#import "ConsultasMenu.h"
#import "PagosListController.h"
#import "Stack.h"

@class ConsultasController;
@class PagoMisCuentasController;
@class CargaCelularMenu;
@class TransferenciasMenu;
@class MCUITabBarViewController;

@interface MenuBanelcoController : UIViewController {

	//ConsultasController* consultasScreen;
	ConsultasMenu* consultasScreen;
	//PagoMisCuentasController* pagoMisCuentasScreen;
	PagosListController* pagoMisCuentasScreen;
	CargaCelularMenu* cargaCelularScreen;
	TransferenciasMenu* transferenciasScreen;
		
	IBOutlet UILabel *titulo;
	
	UIImageView* barra;
	
	IBOutlet UIView* centralScreenSpace; 
	int actualIndiceScreen;
	

	IBOutlet UIButton* btn_volver;
	IBOutlet UIButton *btn_inicio;
	UIImageView* header;
	MCUITabBarViewController* mctabbar;
	
	Stack *pantallas;
    
    BOOL dismissOnly;
	
    IBOutlet UIImageView *smb_bottom;
    IBOutlet UIImageView *fnd_tabbar;
}

@property (nonatomic, retain) UIImageView *smb_bottom;
@property (nonatomic, retain) UIImageView *fnd_tabbar;

@property(nonatomic,retain)  UIImageView* header;
//@property(nonatomic,retain) ConsultasController* consultasScreen;
@property(nonatomic,retain) ConsultasMenu* consultasScreen;
//@property(nonatomic,retain) PagoMisCuentasController* pagoMisCuentasScreen;
@property(nonatomic,retain) PagosListController* pagoMisCuentasScreen;
@property(nonatomic,retain) CargaCelularMenu* cargaCelularScreen;
@property(nonatomic,retain) TransferenciasMenu* transferenciasScreen;
@property(nonatomic,retain) MCUITabBarViewController* mctabbar;
@property(nonatomic,retain) IBOutlet UIView* centralScreenSpace;
@property int actualIndiceScreen;
@property(nonatomic,retain) IBOutlet UILabel *titulo;
@property(nonatomic,retain) UIImageView* barra;
@property(nonatomic,retain) UIButton* btn_volver;
@property(nonatomic,retain) IBOutlet UIButton *btn_inicio;
@property (nonatomic,retain) Stack *pantallas;

@property BOOL dismissOnly;

- (void)pushScreen:(StackableScreen *)screen;
- (void) peekScreen; 
+ (MenuBanelcoController *) sharedMenuController;
- (id) initWithIndiceActual:(int) ind;
- (id) init;

- (UIViewController*) getViewControllerByIndice:(int)indice;
- (void) initScreen:(StackableScreen *)screen;

- (IBAction) volver;
- (IBAction) inicio;

+ (void)resetMenuBanelcoController;

@end
