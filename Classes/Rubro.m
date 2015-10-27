
#import "Rubro.h"
#import "WSUtil.h"
#import "WS_ListarRubros.h"
#import "WS_ListarSubRubros.h"

@implementation Rubro

@synthesize tipo, codigo, nombre;


+ (NSArray *) getRubros {
	
	Context *context = [Context sharedContext];
	
	NSMutableArray *rubros = context.rubros;
	
	if (rubros) {
		return rubros;
	}
	
	WS_ListarRubros * request = [[WS_ListarRubros alloc] init];
	
	request.userToken = [context getToken];
	
	context.rubros = rubros = [WSUtil execute:request];
	
	return rubros;
	
}

+ (NSMutableArray *) getSubRubros:(NSString *)rubro {
	
	Context *context = [Context sharedContext];

	WS_ListarSubRubros * request = [[WS_ListarSubRubros alloc] init];
	
	request.userToken = [context getToken];
	request.rubro = rubro;
	
	NSMutableArray *subRubros = [WSUtil execute:request];
	
	return subRubros;

}


+ (NSMutableArray *) parseRubros:(GDataXMLElement *)rootSoap {
	
	NSMutableArray *rubros = [[NSMutableArray alloc] init];
	
	NSArray *rubrosSoap = [rootSoap elementsForName:@"RubroMobileDTO"];
	
	for (GDataXMLElement *rubroSoap in rubrosSoap) {
		
		Rubro *r = [[Rubro alloc] init];
		
		r.codigo = [WSUtil getStringProperty:@"codigo" ofSoap:rubroSoap];
		r.nombre = [WSUtil getStringProperty:@"nombre" ofSoap:rubroSoap];
		r.tipo = [WSUtil getStringProperty:@"tipo" ofSoap:rubroSoap];
		
		[rubros addObject:r];
		[r release];
		
	}
	
	return rubros;
	
}

@end
