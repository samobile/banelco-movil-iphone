#import <UIKit/UIKit.h>

@protocol MCUITabBarItemDelegate

-(void) mcUITabBarItemPressed:(id) mcItem;

@end


@interface MCUITabBarItem : UIButton {

	UIImage* imageSimple;
	UIImage* imageSeleccion;
	BOOL estadoSeleccion;
	id delegate;
	
}

// 

-(id) initNombreImagenSimple:(NSString*) name1 andNombreImagenSeleccion:(NSString*) name2 ;
@property(nonatomic,retain) UIImage* imageSimple;
@property(nonatomic,retain) UIImage* imageSeleccion;
@property(nonatomic,retain) id delegate;
@property BOOL estadoSeleccion;

-(void) cambiarEstadoASeleccion;
-(void) cambiarEstadoASimple;
-(void) cambiarEstado;

@end
