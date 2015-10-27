#import <UIKit/UIKit.h>
#import "StackableScreen.h"


@interface WheelAnimationController : StackableScreen {
	UIView  *alertView;
	UILabel* label;
	UIActivityIndicatorView* activityConexion;
	//UIView* contentBackView;
	
	UIAlertView *alerta;
	
}

@property(nonatomic,retain) UIActivityIndicatorView* activityConexion;
@property(nonatomic,retain) UIView  *alertView;
@property(nonatomic,retain) UILabel* label;

//@property(nonatomic,retain) UIView* contentBackView;
- (void)updateText:(NSString *)newText;
- (void)finalUpdate;
- (void)removeAlert;

@property (nonatomic,retain) UIAlertView *alerta;

-(void)accionFinalizada:(BOOL)resultado;
-(BOOL) accionConBloqueo;
-(void) encenderRueda;
-(void) apagarRueda;
-(BOOL) accion;
-(void) inicializar;
- (void)iniciarAccionConCorrimientoEnY:(int) defY;
//-(void) addContentView:(UIView*) v;

@end
