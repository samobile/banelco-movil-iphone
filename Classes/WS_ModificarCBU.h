//
//  WS_ModificarCBU.h
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 30/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSRequest.h"
#import "Cuenta.h"

@interface WS_ModificarCBU : WSRequest {
	NSString *userToken;
	Cuenta *cuentaCBU;
}

@property (nonatomic, retain) NSString *userToken;
@property (nonatomic, retain) Cuenta *cuentaCBU;

@end
