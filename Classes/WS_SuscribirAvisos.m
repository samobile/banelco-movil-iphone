#import "WS_SuscribirAvisos.h"
#import "CommonFunctions.h"

@implementation WS_SuscribirAvisos

@synthesize userToken,userMail,showVencimientos,showInfo;

-(NSString *)getWSName {
	return @"suscribirAvisos";
}

-(NSMutableArray *)getSoapParams {
	return [NSArray arrayWithObjects:userToken, userMail, showVencimientos, showInfo, nil];
}

// ORIGINAL
//-(NSString *)getSoapMessage {
//	
//	//Revisar si esta bien armado el XML
//	return  [NSString stringWithFormat:
//			 @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
//			 "<v:Header />\n"
//			 "<v:Body>\n"
//			 "<n0:suscribirAvisos id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com\">\n"
//			 "<in0 i:type=\"d:string\">%@</in0>\n" // Token
//			 "<in1 i:type=\"d:string\">%@</in1>\n" //
//			 "<in2 i:type=\"d:boolean\">%@</in2>\n" // 
//			 "<in3 i:type=\"d:boolean\">%@</in3>\n" // 
//			 "</n0:suscribirAvisos>\n"
//			 "</v:Body>\n"
//			 "</v:Envelope>\n",userToken, userMail, showVencimientos, showInfo
//			 ];
//	
//}

// SERVICIOS 2.0
-(NSString *)getSoapMessage {
	
	return  [NSString stringWithFormat:
			 @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
			 "<v:Header />\n"
			 "<v:Body>\n"
			 "<n0:suscribirAvisos id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com\">\n"
			 "<in0 i:type=\"d:string\">%@</in0>\n" // Token
			 "<in1 i:type=\"d:string\">%@</in1>\n" // Security Token
			 "<in2 i:type=\"d:string\">%@</in2>\n" //
			 "<in3 i:type=\"d:boolean\">%@</in3>\n" // 
			 "<in4 i:type=\"d:boolean\">%@</in4>\n" // 
			 "</n0:suscribirAvisos>\n"
			 "</v:Body>\n"
			 "</v:Envelope>\n",userToken, [WSRequest securityToken], userMail, showVencimientos, showInfo
			 ];
	
}

-(id)parseResponse:(NSData *)data {
#if (WSDEBUG==FALSE)
	NSError *error = [[NSError alloc]init];
	
	NSString *msj = [CommonFunctions returnXMLMasterTagFromText:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] withTag:@"out"];
	
	NSData *rdata = [NSData dataWithBytes:[msj UTF8String] length:[msj lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
	
	GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:rdata options:0 error:&error];
	GDataXMLElement *avSoap = doc.rootElement;
#endif
	// [WSUtil getStringProperty:@"idCliente" ofSoap:avSoap];
	NSString* response = @"hola";
	
	return response;
	
}




@end
