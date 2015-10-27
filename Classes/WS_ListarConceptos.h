//
//  WS_ListarConceptos.h
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 9/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSRequest.h"

@interface WS_ListarConceptos : WSRequest {
	NSString *userToken;
}

@property (nonatomic, retain) NSString *userToken;

@end
