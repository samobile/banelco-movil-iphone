//
//  WS_CambiarPin.m
//  BanelcoMovilIphone
//
//  Created by German Levy on 9/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WS_ManagePerfilUsuario.h"
#import "CommonFunctions.h"
#import "ManagePerfilUsuarioResponse.h"

@implementation WS_ManagePerfilUsuario

@synthesize userToken, email, nickName, novedades, vencimientos, retornarLogueoDNI;

-(NSString *)getWSName {
	return @"managePerfilUsuario";
}

/*-(NSString *)paramsToXml {
	return [super paramsToXml];
}

-(NSString *)getSoapMessage:(NSMutableArray *)params {
	return [super getSoapMessage:params];	
}*/

-(NSMutableArray *)getSoapParams {
	return [NSMutableArray arrayWithObjects:userToken, email, nickName, nil];
}

// ORIGINAL
//-(NSString *)getSoapMessage {
// 
//	 return  [NSString stringWithFormat:
//	 @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
//	 "<v:Header />\n"
//	 "<v:Body>\n"
//	 "<n0:cambiarPin id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
//	 "<in0 i:type=\"d:string\">%@</in0>\n" // Token
//	 "<in1 i:type=\"d:string\">%@</in1>\n" // PW actual
//	 "<in2 i:type=\"d:string\">%@</in2>\n" // PW nuevo
//	 "</n0:cambiarPin>\n"
//	 "</v:Body>\n"
//	 "</v:Envelope>\n", userToken, actualPW, newPW
//	 ];
// 
// }

// SERVICIOS 2.0
-(NSString *)getSoapMessage {
	
	return  [NSString stringWithFormat:
			 @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
			 "<v:Header />\n"
			 "<v:Body>\n"
			 "<n0:managePerfilUsuario id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
			 "<in0 i:type=\"d:string\">%@</in0>\n" // Token
			 "<in1 i:type=\"d:string\">%@</in1>\n" // Security Token
			 "<in2 i:type=\"d:string\">%@</in2>\n" // email
             "<in3 i:type=\"d:boolean\">%@</in3>\n" //venc
			 "<in4 i:type=\"d:boolean\">%@</in4>\n" //novedades
			 "<in5 i:type=\"d:string\">%@</in5>\n" // nickname
             "<in6 i:type=\"d:boolean\">%@</in6>\n" //retorno logueo
			 "</n0:managePerfilUsuario>\n"
			 "</v:Body>\n"
			 "</v:Envelope>\n", self.userToken, [WSRequest securityToken], self.email, self.vencimientos ? @"true" : @"false", self.novedades ? @"true" : @"false", self.nickName, self.retornarLogueoDNI ? @"true" : @"false"
			 ];
	
}


-(id)parseResponse:(NSData *)data {
    
//    ManagePerfilUsuarioResponse *response = [[ManagePerfilUsuarioResponse alloc] init];
//	
//	NSError *error = [[NSError alloc]init];
//	
//	NSString *msj = [CommonFunctions returnXMLMasterTagFromText:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] withTag:@"out"];
//	//NSLog([NSString stringWithFormat:@"Login Response: %@", msj]);
//    if (!msj) {
//        return nil;
//    }
//	NSData *rdata = [NSData dataWithBytes:[msj UTF8String] length:[msj lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
//	
//	GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:rdata options:0 error:&error];
//	GDataXMLElement *loginSoap = doc.rootElement;
//	
//	response.tokenSeguridad = [[[loginSoap elementsForName:@"tokenSeguridad"] objectAtIndex:0] stringValue];
//	
//    [error release];
//    
//	return response;
    
    return nil;
	
}

- (void)dealloc {
	
	self.userToken = nil;
    self.email = nil;
    self.nickName = nil;
    [super dealloc];
}


@end
