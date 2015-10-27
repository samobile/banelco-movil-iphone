//
//  WS_RealizarTransferenciaInmediata.h
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 2/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSRequest.h"
#import "Transfer.h"

@interface WS_RealizarTransferenciaInmediata : WSRequest {

	NSString *userToken;
	Transfer *transfer;
}

@property (nonatomic, retain) NSString *userToken;
@property (nonatomic, retain) Transfer *transfer;

@end
