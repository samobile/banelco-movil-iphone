//
//  WSRequest.h
//  MING_iPad
//
//  Created by German Levy on 4/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IWSRequest.h"
#import "GDataXMLNode.h"


@interface WSRequest : NSObject <IWSRequest> {

	NSString *token;
	NSString *sessionId;
	NSString *url;
	NSString *host;
	NSString *xml;
	
}

@property (nonatomic, retain) NSString *token;
@property (nonatomic, retain) NSString *sessionId;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *host;
@property (nonatomic, retain) NSString *xml;

+(NSString *)securityToken;
+(void)setSecurityToken:(NSString *)secToken;

-(id)initWithToken:(NSString *)token andSessionId:(NSString *)sessionId;

-(NSString *)getWSURL;

-(NSString *)getWSHost;

-(NSString *)getWSName;

-(NSMutableArray *)getSoapParams;

-(NSString *)paramsToXml;

-(NSString *)getSoapMessage;

-(NSString *)returnRequestXML:(NSObject *)model;

-(id)parseResponse:(NSData *)data;


@end
