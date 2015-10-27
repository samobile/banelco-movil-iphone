//
//  WS_CambiarPin.h
//  BanelcoMovilIphone
//
//  Created by German Levy on 9/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSRequest.h"

@interface WS_CambiarPin : WSRequest {

	NSString *userToken;
	NSString *actualPW;
	NSString *newPW;
	
}

@property (nonatomic, retain) NSString *userToken;
@property (nonatomic, retain) NSString *actualPW;
@property (nonatomic, retain) NSString *newPW;

@end
