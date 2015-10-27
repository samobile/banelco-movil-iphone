//
//  ListarSubRubros_WSRequest.h
//  BanelcoMovil
//
//  Created by German Levy on 8/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSRequest.h"


@interface WS_ListarSubRubros : WSRequest {

	NSString *userToken;
	NSString *rubro;
	
}

@property (nonatomic, retain) NSString *userToken;
@property (nonatomic, retain) NSString *rubro;

@end
