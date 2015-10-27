//
//  WSRequest.m
//  MING_iPad
//
//  Created by German Levy on 4/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WSRequest.h"
#import "CommonFunctions.h"
#import "Configuration.h"

static NSString *securityToken;

@implementation WSRequest

@synthesize token, sessionId, url, host, xml;

-(id)initWithToken:(NSString *)aToken andSessionId:(NSString *)aSessionId {

	if ( self = [super init] )
    {
		self.token = aToken;
		self.sessionId = aSessionId;
    }
    return self;
}

+(NSString *)securityToken {
	return securityToken;
}

+(void)setSecurityToken:(NSString *)secToken {
	//securityToken = [secToken copy];
    securityToken = [[NSString alloc] initWithString:secToken];
}

-(NSString *)getWSURL{
//	return @"https://wssrvcert.banelcoservices.com.ar/services/PMCSoapMobileClient";
	//return @"https://wssrv2.banelcoservices.com.ar/services/PMCSoapMobileClient";
	return [Configuration getConsultaWebServiceURL];	
}

-(NSString *)getWSHost{
	//return @"wssrvcert.banelcoservices.com.ar";
	return [Configuration getHostBaseURL];
}

-(NSString *)getWSName { return nil; }

-(NSMutableArray *)getSoapParams { return nil; }

-(NSString *)paramsToXml {

	NSMutableArray *soapParams = [self getSoapParams];
	NSMutableString *paramsString = [[NSMutableString alloc] init];
	NSString *paramString;
	
	for (int i=0; i<[soapParams count]; i++) {
		
		if ([[soapParams objectAtIndex:i] isKindOfClass:[NSString class]]) {
			
			paramString = [NSString stringWithFormat:@"<in%d i:type=\"d:string\">%@</in%d>\n", i, [soapParams objectAtIndex:i], i];
			
		} else if ([[soapParams objectAtIndex:i] isKindOfClass:[[NSNumber numberWithInt:1] class]]) {
			
			paramString = [NSString stringWithFormat:@"<in%d i:type=\"d:int\">%d</in%d>\n", i, [[soapParams objectAtIndex:i] intValue], i];
		
		} else if ([[soapParams objectAtIndex:i] isKindOfClass:[[NSNumber numberWithBool:YES] class]]) {
			
			paramString = [NSString stringWithFormat:@"<in%d i:type=\"d:bool\">%d</in%d>\n", i, [[soapParams objectAtIndex:i] boolValue], i];
			
		}

		[paramsString appendString:paramString];
		
		[paramString release];
		
	}
	
	return paramsString;
	
}

-(NSString *)getSoapMessage {
	
	return [NSString stringWithFormat:
			 @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
			 "<v:Header />\n"
			 "<v:Body>\n"
			 "<n0:%@ id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
			 "%@"
			 "</n0:%@>\n"
			 "</v:Body>\n"
			 "</v:Envelope>\n", [self getWSName], [self paramsToXml], [self getWSName]
			 ];
	
}

-(id)parseResponse:(NSData *)data { return nil; }



@end
