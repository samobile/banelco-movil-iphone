//
//  ListarRubros_WSRequest.h
//  BanelcoMovil
//
//  Created by German Levy on 8/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSRequest.h"


@interface WS_ListarRubros : WSRequest {

	NSString *userToken;
	
}

@property (nonatomic, retain) NSString *userToken;

@end
