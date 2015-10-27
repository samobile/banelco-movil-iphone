#import <UIKit/UIKit.h>
#import "MCUITabBarItem.h"

@interface MCUITabBarViewController : UIView <MCUITabBarItemDelegate>{

	NSMutableArray* listaDeItems;
	id delegate;
	int anchoBotones;
	
}

@property(nonatomic,retain) NSMutableArray* listaDeItems;
@property(nonatomic,retain) id delegate;
@property int anchoBotones;

- (id) initWithFrame:(CGRect)frame andListaDeItems:(NSMutableArray*) items;
- (void) addItem:(MCUITabBarItem*) item withAnimation:(BOOL) animated;
- (void) removeAllItems;
- (void) removeItemAtIndex:(int) indice;
- (void) removeAllSubViews;
- (void) calcularAnchoBotones;
- (void) setearAnchoBotones;
- (void) resetSelection;

@end
