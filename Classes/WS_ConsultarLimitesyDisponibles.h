//
//  WS_ConsultarLimitesyDisponibles.h
//  BanelcoMovilIphone
//
//  Created by Demian on 9/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSRequest.h"

@interface WS_ConsultarLimitesyDisponibles : WSRequest {
	
	NSString* codigoCuenta;
	NSString *userToken;
	
}

@property (nonatomic, retain) NSString *userToken;
@property (nonatomic, retain) NSString* codigoCuenta;

@end
