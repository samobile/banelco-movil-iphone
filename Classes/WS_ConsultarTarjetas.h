//
//  ConsultarTarjetas.h
//  BanelcoMovil
//
//  Created by German Levy on 8/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSRequest.h"


@interface WS_ConsultarTarjetas : WSRequest {

	NSString *userToken;
	
}

@property (nonatomic, retain) NSString *userToken;

@end
