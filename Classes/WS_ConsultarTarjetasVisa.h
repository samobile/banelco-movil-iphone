//
//  ConsultarTarjetasVisa_WSRequest.h
//  BanelcoMovil
//
//  Created by German Levy on 8/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSRequest.h"


@interface WS_ConsultarTarjetasVisa : WSRequest {

	NSString *userToken;
	NSString *codBanco;
	NSString *tipoDoc;
	NSString *nroDoc;
	
}

@property (nonatomic, retain) NSString *userToken;
@property (nonatomic, retain) NSString *codBanco;
@property (nonatomic, retain) NSString *tipoDoc;
@property (nonatomic, retain) NSString *nroDoc;

@end
