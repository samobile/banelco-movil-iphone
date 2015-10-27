//
//  WS_ConsultaResumenCuenta.h
//  BanelcoMovilIphone
//
//  Created by Demian on 9/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSRequest.h"
#import "Cuenta.h"

@interface WS_ConsultaResumenCuenta : WSRequest {

	NSString* userToken;
	Cuenta* cuenta;
}

@property(nonatomic,retain) NSString* userToken;
@property(nonatomic,retain) Cuenta* cuenta;
@end
