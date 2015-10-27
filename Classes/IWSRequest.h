//
//  IWSRequest.h
//  MING_iPad
//
//  Created by German Levy on 4/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol IWSRequest

@required

	-(NSString *)getWSURL;

	-(NSString *)getWSHost;

	-(NSString *)getWSName;

	-(NSString *)getSoapMessage;

	-(id)parseResponse:(NSData *)data;

	-(int)parseResponseSessionId:(NSData *)data;

@end
