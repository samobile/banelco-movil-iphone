//
//  ListarProductos_WSRequest.h
//  BanelcoMovil
//
//  Created by German Levy on 8/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSRequest.h"


@interface WS_ListarProductos : WSRequest {

	NSString *userToken;
	
}

@property (nonatomic, retain) NSString *userToken;

@end
