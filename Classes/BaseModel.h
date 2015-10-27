#import "Util.h"
#import "GDataXMLNode.h"

@interface BaseModel : NSObject {

  NSString * nombre;
  NSString * codigo;
	
}

@property (nonatomic, retain) NSString * nombre;
@property (nonatomic, retain) NSString * codigo;

//- (GDataXMLElement *) toSoapObject;
- (NSString *) toSoapObject;
+ (BaseModel *) parse:(GDataXMLElement *)soapObject;

@end
