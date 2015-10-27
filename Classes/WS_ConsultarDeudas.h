//
//  WS_ConsultarDeudas.h
//  BanelcoMovilIphone
//
//  Created by German Levy on 9/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSRequest.h"


@interface WS_ConsultarDeudas : WSRequest {

	NSString *userToken;
	
}

@property (nonatomic, retain) NSString *userToken;

@end
