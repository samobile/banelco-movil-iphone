
#import "BaseModel.h"

@implementation BaseModel

@synthesize nombre, codigo;

//- (GDataXMLElement *) toSoapObject {
//	
//	NSString *nameSpace = @"http://mobile.services.pmctas.banelco.com";
//
//	GDataXMLElement *conceptoSoapObject = [GDataXMLNode elementWithName:@""];
//	
//	[conceptoSoapObject addChild:[GDataXMLNode elementWithName:@"codigo" stringValue:codigo]];
//	
//	[conceptoSoapObject addChild:[GDataXMLNode elementWithName:@"nombre" stringValue:nombre]];
//
//	return conceptoSoapObject;
//	
//}

+ (BaseModel *) parse:(GDataXMLElement *)soapObject {
	
	BaseModel *model = [[BaseModel alloc] init];

	model.codigo = [(GDataXMLElement *)[[soapObject elementsForName:@"codigo"] objectAtIndex:0] stringValue];

	model.nombre = [(GDataXMLElement *)[[soapObject elementsForName:@"nombre"] objectAtIndex:0] stringValue];

	return model;
}

-(NSString*) toSoapObject {
	
	NSMutableString* soap = [[NSMutableString alloc] init];
	
	NSString* nameSpace = @"\"http://mobile.services.pmctas.banelco.com\"";
	[soap appendFormat:@"<n1:codigo i:type=\"n1:string\" xmlns:n1=%@>%@</n1:codigo>\n",nameSpace,codigo ];
	[soap appendFormat:@"<n2:nombre i:type=\"n2:boolean\" xmlns:n2=%@>%@</n2:nombre>\n",nameSpace,nombre];
	
	[soap autorelease];
	
	return soap;
	
	
}


@end
