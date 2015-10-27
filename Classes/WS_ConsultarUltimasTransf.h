//
//  ConsultarUltimasTransf_WSRequest.h
//  BanelcoMovil
//
//  Created by German Levy on 9/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSRequest.h"


@interface WS_ConsultarUltimasTransf : WSRequest {

	NSString *userToken;
	
}

@property (nonatomic, retain) NSString *userToken;

@end
