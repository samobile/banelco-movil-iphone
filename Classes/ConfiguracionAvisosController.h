#import <UIKit/UIKit.h>
#import "WheelAnimationController.h"

@interface ConfiguracionAvisosController : WheelAnimationController {	
	BOOL generalActiva;
	BOOL vencimientosActiva;
	IBOutlet UIButton* opcionGeneral;
	IBOutlet UIButton* opcionVencimientos;
	
	
	IBOutlet UILabel* labelGeneral;
	IBOutlet UILabel* labelVencimientos;
	
	
	IBOutlet UILabel* labelTitulo;
	IBOutlet UIButton* btnAceptar;
	
	

}

@property(nonatomic,retain) UILabel* labelTitulo;
@property(nonatomic,retain) UIButton* btnAceptar;

@property BOOL generalActiva;
@property BOOL vencimientosActiva;
@property(nonatomic,retain) UIButton* opcionGeneral;
@property(nonatomic,retain) UIButton* opcionVencimientos;
@property(nonatomic,retain)  UILabel* labelGeneral;
@property(nonatomic,retain)  UILabel* labelVencimientos;
-(IBAction) aceptar;
-(IBAction) activarVencimientos;
-(IBAction) activarGeneral;

@end
