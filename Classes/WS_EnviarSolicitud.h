//
//  EnviarSolicitud_WSRequest.h
//  BanelcoMovil
//
//  Created by German Levy on 8/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSRequest.h"


@interface WS_EnviarSolicitud : WSRequest {

	NSString *userToken;
	NSString *codBanco;
	NSString *body;
	NSString *email;
	
}

@property (nonatomic, retain) NSString *userToken;
@property (nonatomic, retain) NSString *codBanco;
@property (nonatomic, retain) NSString *body;
@property (nonatomic, retain) NSString *email;

@end
