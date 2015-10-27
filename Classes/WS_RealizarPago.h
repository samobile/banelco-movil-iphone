//
//  WS_RealizarPago.h
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 9/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSRequest.h"
#import "Deuda.h"

@interface WS_RealizarPago : WSRequest {

	NSString *userToken;
	NSString *codCuenta;
	Deuda *deuda;
}

@property (nonatomic, retain) NSString *userToken;
@property (nonatomic, retain) NSString *codCuenta;
@property (nonatomic, retain) Deuda *deuda;

@end
