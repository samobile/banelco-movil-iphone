#import "MCUITabBarItem.h"
#import "MenuBanelcoController.h"
#import "BanelcoMovilIphoneViewController.h"

@implementation MCUITabBarItem
@synthesize delegate;
@synthesize imageSimple;
@synthesize imageSeleccion;
@synthesize estadoSeleccion;


- (id)initNombreImagenSimple:(NSString*) name1 andNombreImagenSeleccion:(NSString*) name2 {
	
	self = [super init];
	self.estadoSeleccion = NO;
	self.frame = CGRectZero;
	[self setTitle:@"" forState:UIControlStateNormal];
	self.backgroundColor = [UIColor clearColor];
	[self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
	self.imageSimple = [UIImage imageNamed:name1];
	[self setBackgroundImage:self.imageSimple forState:UIControlStateNormal];
	self.imageSeleccion = [UIImage imageNamed:name2];
	[self setBackgroundImage:self.imageSeleccion forState:UIControlStateHighlighted];
	[self addTarget:self action:@selector(mcUITabBarItemPressed2) forControlEvents:UIControlEventTouchUpInside];
    return self;
}

- (void)mcUITabBarItemPressed2 {
    [self.delegate performSelector:@selector(mcUITabBarItemPressed:) withObject:self];
}

-(void) cambiarEstadoASeleccion{

	[self setBackgroundImage:self.imageSeleccion forState:UIControlStateNormal];
	self.estadoSeleccion = YES;
	
}


-(void) cambiarEstadoASimple{

	[self setBackgroundImage:self.imageSimple forState:UIControlStateNormal];
	self.estadoSeleccion = NO;
	
}



-(void) cambiarEstado{

	if(self.estadoSeleccion){
		[self cambiarEstadoASimple];
	}else {
		[self cambiarEstadoASeleccion];
	}

}


- (void)dealloc { 
	[imageSimple release];
	[imageSeleccion release];
	[delegate release];
    [super dealloc];
	
}

//- (void)accessibilityElementDidLoseFocus {
//    if ([self.accessibilityLabel rangeOfString:@","].location == NSNotFound) {
//        return;
//    }
//    self.accessibilityLabel = [[self.accessibilityLabel componentsSeparatedByString:@";"] objectAtIndex:0];
//}

- (void)accessibilityElementDidBecomeFocused {
    
    if ([self.accessibilityLabel rangeOfString:@","].location != NSNotFound) {
        int act = [MenuBanelcoController sharedMenuController].actualIndiceScreen;
        if (act == self.tag) {
            UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, [NSString stringWithFormat:@"%@, seleccionado",self.accessibilityLabel]);
        }
    }
    else if ([self.accessibilityLabel rangeOfString:@";"].location != NSNotFound) {
        int act = [BanelcoMovilIphoneViewController sharedMenuController].actualIndiceScreen;
        if (act == self.tag) {
            UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, [NSString stringWithFormat:@"%@, seleccionado",self.accessibilityLabel]);
        }
    }
    
    
    
}


@end
