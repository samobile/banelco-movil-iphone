//
//  ConsultarUltimosPagos_WSRequest.h
//  BanelcoMovil
//
//  Created by German Levy on 8/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSRequest.h"


@interface WS_ConsultarUltimosPagos : WSRequest {

	NSString *userToken;
	NSString *codigo;
	NSNumber *secuencia;
	
}

@property (nonatomic, retain) NSString *userToken;
@property (nonatomic, retain) NSString *codigo;
@property (nonatomic, retain) NSNumber *secuencia;

@end
