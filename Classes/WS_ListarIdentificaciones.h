//
//  ListarIdentificaciones_WSRequest.h
//  BanelcoMovil
//
//  Created by German Levy on 8/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSRequest.h"


@interface WS_ListarIdentificaciones : WSRequest {

	NSString *userToken;
	NSString *codigo;
	
}

@property (nonatomic, retain) NSString *userToken;
@property (nonatomic, retain) NSString *codigo;

@end
