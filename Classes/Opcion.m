#import "Opcion.h"


@implementation Opcion

@synthesize imagen;
@synthesize imagenSeleccionada;
@synthesize pantalla;
@synthesize boundsCorrespondiente;
@synthesize boton;
@synthesize activa;


- (id)initWithFrame:(CGRect)frame {
	NSLog(@"Opcion - InitWithFrame");
    if ((self = [super initWithFrame:frame])) {
     
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame imagenNombre:(NSString*)iNombre imagenSeleccionadaNombre:(NSString*)iSeleccionadaNombre 
																andController:(UIViewController*) controller{
	NSLog(@"Opcion - Init con todos los parametros ");
	if((self = [self initWithFrame:frame])){

		[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		self.imagen = [UIImage imageNamed:iNombre];
		self.imagenSeleccionada = [UIImage imageNamed:iSeleccionadaNombre];
		self.pantalla = controller;
		
		
		self.boton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
		self.boton.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
		[self.boton setTitle:@"" forState:UIControlStateNormal];
		self.boton.backgroundColor = [UIColor clearColor];
		[self.boton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
		self.imagen = [self.imagen stretchableImageWithLeftCapWidth:12 topCapHeight:0];
		[self.boton setBackgroundImage:strechableButtonImageNormal forState:UIControlStateNormal];
		
		self.imagenSeleccionada = [self.imagenSeleccionada  stretchableImageWithLeftCapWidth:12 topCapHeight:0];
		[self.boton setBackgroundImage:strechableButtonImagePressed forState:UIControlStateHighlighted];
		
		[self.boton addTarget:self.co action:@selector(presionar:) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:self.boton];
		self.activa = NO;
	}
	return self;
}


-(void) presionar:(id) boton{
	NSLog(@"Opcion - Presionar");
	

}

-(void) cambiarImagenSeleccion{
	NSLog(@"Opcion - cambiarImagenSeleccion");
	[self.boton setBackgroundImage:self.imagenSeleccionada forState:UIControlStateNormal];
	self.activa = YES;
}

-(void) cambiarImagenSinSeleccion{
	NSLog(@"Opcion - cambiarImagenSinSeleccion");
	[self.boton setBackgroundImage:self.imagen forState:UIControlStateNormal];
	self.activa = NO;
}

- (void)dealloc {
	NSLog(@"Opcion - Dealloc");
	[boton release];
	[imagen release];
	[imagenSeleccionada release];
	[pantalla release];
    [super dealloc];
}


@end
