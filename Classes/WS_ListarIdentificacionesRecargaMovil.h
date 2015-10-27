//
//  WS_ListarIdentificacionesRecargaMovil.h
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 9/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSRequest.h"

@interface WS_ListarIdentificacionesRecargaMovil : WSRequest {
	NSString *userToken;
	NSString *codigo;
}

@property (nonatomic, retain) NSString *userToken;
@property (nonatomic, retain) NSString *codigo;


@end
