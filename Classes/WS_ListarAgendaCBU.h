//
//  WS_ListarAgendaCBU.h
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 9/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSRequest.h"

@interface WS_ListarAgendaCBU : WSRequest {

	NSString *userToken;
}

@property (nonatomic, retain) NSString *userToken;

@end
