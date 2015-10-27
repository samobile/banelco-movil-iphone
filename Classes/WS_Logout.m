

#import "WS_Logout.h"
#import "Context.h"
#import "Util.h"

@implementation WS_Logout



-(NSString *)getWSName {
	return @"logout";
}

-(NSMutableArray *)getSoapParams {
	return nil;
}

// ORIGINAL
//-(NSString *)getSoapMessageOriginal {
//	Context *context = [Context sharedContext];
//	
//	return  [NSString stringWithFormat:
//			 @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
//			 "<v:Header />\n"
//			 "<v:Body>\n"
//			 "<n0:logout id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
//			 "<in0 i:type=\"d:string\">%@</in0>\n" // User Token
//			 "</n0:logout>\n"
//			 "</v:Body>\n"
//			 "</v:Envelope>\n", [context getToken]
//			 ];
//	
//}

// SERVICIOS 2.0
-(NSString *)getSoapMessage {
	Context *context = [Context sharedContext];
	
	return  [NSString stringWithFormat:
			 @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
			 "<v:Header />\n"
			 "<v:Body>\n"
			 "<n0:logout id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
			 "<in0 i:type=\"d:string\">%@</in0>\n" // User Token
			 "<in1 i:type=\"d:string\">%@</in1>\n" // Security Token
			 "</n0:logout>\n"
			 "</v:Body>\n"
			 "</v:Envelope>\n", [context getToken], [WSRequest securityToken]
			 ];
	
}

-(id)parseResponse:(NSData *)data {
	
	return nil;
	
}






@end
