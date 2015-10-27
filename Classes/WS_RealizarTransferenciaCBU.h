//
//  WS_RealizarTransferenciaCBU.h
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 9/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Transfer.h"
#import "WSRequest.h"

@interface WS_RealizarTransferenciaCBU : WSRequest {
	
	NSString *userToken;
	Transfer *transfer;
}

@property (nonatomic, retain) NSString *userToken;
@property (nonatomic, retain) Transfer *transfer;

@end
