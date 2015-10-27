//
//  BuscarEmpresa_WSRequest.h
//  BanelcoMovil
//
//  Created by German Levy on 9/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSRequest.h"

@interface WS_BuscarEmpresa : WSRequest {

	NSString *userToken;
	NSString *empresaId;
	
}

@property (nonatomic, retain) NSString *userToken;
@property (nonatomic, retain) NSString *empresaId;


@end
