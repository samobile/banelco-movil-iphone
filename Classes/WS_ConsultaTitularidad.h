//
//  WS_ConsultaTitularidad.h
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 2/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSRequest.h"
#import "Cuenta.h"

@interface WS_ConsultaTitularidad : WSRequest {
	
	NSString *userToken;
	NSString *cbu;
	Cuenta *cuentaOrigen;
}

@property (nonatomic, retain) NSString *userToken;
@property (nonatomic, retain) NSString *cbu;
@property (nonatomic, retain) Cuenta *cuentaOrigen;

@end
