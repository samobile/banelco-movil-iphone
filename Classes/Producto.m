
#import "Producto.h"
#import "Context.h"
#import "WS_ListarProductos.h"
#import "WS_EnviarSolicitud.h"
#import "WSUtil.h"

@implementation Producto

@synthesize nombre, codigo, tipo;

+ (NSMutableArray *)parseProductos:(GDataXMLElement *)cuentasSoap {
	
	NSMutableArray *cuentasPlazo = [[NSMutableArray alloc] init];
	
	NSArray *cuentasSoaps = [cuentasSoap elementsForName:@"ProductoMobileDTO"];
	
	for (GDataXMLElement *cuentaSoap in cuentasSoaps) {
		[cuentasPlazo addObject:[Producto parseProducto:cuentaSoap]];
	}
	
	return cuentasPlazo;
}	

+ (Producto *)parseProducto:(GDataXMLElement *)cuentaSoap {
	
	Producto *c = [[Producto alloc] init];
	
	c.codigo = [[[cuentaSoap elementsForName:@"codigo"] objectAtIndex:0] stringValue];
	c.nombre = [[[cuentaSoap elementsForName:@"nombre"] objectAtIndex:0] stringValue];
	
	return c;
	
}

+ (NSMutableArray *) getProductos {

	WS_ListarProductos * request = [[WS_ListarProductos alloc] init];
	request.userToken = [[Context sharedContext] getToken];

	id response = [WSUtil execute:request];
	
	[request release];

	return response;
		
}


+ (id)enviarSolicitud:(NSString *)nombreProd telContacto:(NSString *)tel1 telAlter:(NSString *)tel2 email:(NSString *)email {
	
	Context *context = [Context sharedContext];

	NSString *body = @"producto:";
	body = [body stringByAppendingString: nombreProd];
	body = [body stringByAppendingString: @"\n\r"];
	body = [body stringByAppendingString: @"tipo documento:"];
	body = [body stringByAppendingString: context.tipoDoc];
	body = [body stringByAppendingString: @"\n\r"];
	body = [body stringByAppendingString: @"nro documento:"];
	body = [body stringByAppendingString: context.dni];
	body = [body stringByAppendingString: @"\n\r"];
	body = [body stringByAppendingString: @"telefono de contacto:"];
	body = [body stringByAppendingString: tel1];
	body = [body stringByAppendingString: @"\n\r"];
	body = [body stringByAppendingString: @"telefono alternativo:"];
	body = [body stringByAppendingString: tel2];
	body = [body stringByAppendingString: @"\n\r"];
    body = [body stringByAppendingString: @"mail usuario:"];
	body = [body stringByAppendingString: email];
	body = [body stringByAppendingString: @"\n\r"];

	WS_EnviarSolicitud * request = [[WS_EnviarSolicitud alloc] init];
	
	request.userToken = [context getToken];
	request.codBanco = context.banco.idBanco;
	request.body = body;
	//request.email = email;
    request.email = @"comentarios@banelco.com.ar";
	
	return [WSUtil execute:request];
	
}

@end
