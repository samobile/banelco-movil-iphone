//
//  ConsultarSaldosyDisponTransf_WSRequest.h
//  BanelcoMovil
//
//  Created by German Levy on 9/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSRequest.h"


@interface WS_ConsultarSaldosyDisponTransf : WSRequest {

	NSString *userToken;
	NSString *nroCuenta;
	NSNumber *tipoCuenta;
	NSNumber *codMoneda;
	
}

@property (nonatomic, retain) NSString *userToken;
@property (nonatomic, retain) NSString *nroCuenta;
@property (nonatomic, retain) NSNumber *tipoCuenta;
@property (nonatomic, retain) NSNumber *codMoneda;

@end
