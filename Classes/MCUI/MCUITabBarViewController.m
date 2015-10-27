#import "MCUITabBarViewController.h"

@implementation MCUITabBarViewController
@synthesize delegate;
@synthesize listaDeItems;
@synthesize anchoBotones;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.listaDeItems = [[NSMutableArray alloc] init];
		self.anchoBotones = self.frame.size.width;
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame andListaDeItems:(NSMutableArray*) items{

	if ((self = [super initWithFrame:frame])) {
        self.listaDeItems = items;
    }
	
	[self calcularAnchoBotones];
	[self setearAnchoBotones];
	
	for (int i=0; i<[self.listaDeItems count]; i++) {
		[(MCUITabBarItem*)[self.listaDeItems objectAtIndex:i] delete:self];
		[self addSubview:(MCUITabBarItem*)[self.listaDeItems objectAtIndex:i]];
	}
    return self;
	
}

-(void) calcularAnchoBotones{
	
	self.anchoBotones = self.frame.size.width / [self.listaDeItems count];
	
}

-(void) setearAnchoBotones{
	
	int x=0;
	for (int i=0; i<[self.listaDeItems count]; i++) {
		
		MCUITabBarItem* item = (MCUITabBarItem*)[self.listaDeItems objectAtIndex:i];
		item.frame = CGRectMake(x, 0, self.anchoBotones, self.frame.size.height);
		x = x+self.anchoBotones;
		
	}
	
	
}

-(void) addItem:(MCUITabBarItem*) item withAnimation:(BOOL) animated{
	item.delegate = self;
	[self.listaDeItems addObject:item];
	[self calcularAnchoBotones];
	[self setearAnchoBotones];
	
	if (animated){
		item.alpha = 0;
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
		[UIView setAnimationDuration:1];
		item.alpha = 1;
		[UIView commitAnimations];
	}
	
	[self addSubview:item];

}

-(void) removeAllItems{
	[self removeAllSubViews];
	[self.listaDeItems removeAllObjects];
	

}

-(void) removeAllSubViews{
	
	for (int i=0;i<[self.listaDeItems count]; i++) {
		[(MCUITabBarItem*) [self.listaDeItems objectAtIndex:i] removeFromSuperview];
	}
	
}

-(void) removeItemAtIndex:(int) indice{

	[(MCUITabBarItem*)[self.listaDeItems objectAtIndex:indice] removeFromSuperview];
	[self.listaDeItems removeObjectAtIndex:indice];
	
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



-(void) mcUITabBarItemPressed:(id) mcUIItem{
	
	[self resetSelection];
	
	[mcUIItem cambiarEstadoASeleccion];
	int indice = [self.listaDeItems indexOfObject:mcUIItem];
	[delegate onMCUITabBar:self andItemAction:indice];
	
}

- (void)resetSelection {

	for (int i=0; i<[self.listaDeItems count]; i++) {
		[(MCUITabBarItem*)[self.listaDeItems objectAtIndex:i] cambiarEstadoASimple];
	}	

}

- (void)dealloc {
	[listaDeItems release];
	[delegate release];
    [super dealloc];
}


@end
