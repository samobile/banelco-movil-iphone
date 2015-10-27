#import "Banco.h"
#import "Cuenta.h"


@implementation Banco

@synthesize selected;
@synthesize imagenRedonda;
@synthesize imagenTitulo;
@synthesize imagenHome;
@synthesize nombre;
@synthesize idBanco;
@synthesize url;

-(id) initWithDictionary:(NSDictionary*) valoresBanco{
	//self.selected = [(NSString*)[valoresBanco valueForKey:@"Seleccionado"] compare:@"Activo"];
	self.imagenRedonda=(NSString*)[valoresBanco valueForKey:@"ImagenRedonda"];
	self.imagenTitulo=(NSString*)[valoresBanco valueForKey:@"ImagenTitulo"];
	self.imagenHome=(NSString*)[valoresBanco valueForKey:@"ImagenHome"];
	self.nombre=(NSString*)[valoresBanco valueForKey:@"Nombre"];
	self.idBanco=(NSString*)[valoresBanco valueForKey:@"idBanco"];
	self.url=(NSString*)[valoresBanco valueForKey:@"url"];
	[Cuenta setMascara:(NSString*)[valoresBanco valueForKey:@"mascara"]];
	
	return self;
}

- (void)dealloc {
	[url release];
	[imagenRedonda release];
	[imagenTitulo release];
	[imagenHome release];
	[nombre release];
	[idBanco release];
    [super dealloc];
}





@end
