#import <UIKit/UIKit.h>


@interface Opcion : UIView {

	UIButton* boton;
	
	UIImage* imagen;
	UIImage* imagenSeleccionada;
	
	CGRect boundsCorrespondiente;
	
	UIViewController* pantalla;
	
	BOOL activa;
	
}

@property(nonatomic,retain) UIButton* boton;

@property(nonatomic,retain) UIImage* imagen;
@property(nonatomic,retain) UIImage* imagenSeleccionada;
@property CGRect boundsCorrespondiente;
@property(nonatomic,retain) UIViewController* pantalla;
@property BOOL activa;



- (id)initWithFrame:(CGRect)frame imagenNombre:(NSString*)iNombre imagenSeleccionadaNombre:(NSString*)iSeleccionadaNombre andController:(UIViewController*) controller;





@end
