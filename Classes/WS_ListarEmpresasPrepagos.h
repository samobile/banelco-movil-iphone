//
//  ListarEmpresasPrepago_WSRequest.h
//  BanelcoMovil
//
//  Created by German Levy on 8/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSRequest.h"


@interface WS_ListarEmpresasPrepagos : WSRequest {

	NSString *userToken;
	NSString *rubro;
	NSString *codBanco;
	
}

@property (nonatomic, retain) NSString *userToken;
@property (nonatomic, retain) NSString *rubro;
@property (nonatomic, retain) NSString *codBanco;

@end
