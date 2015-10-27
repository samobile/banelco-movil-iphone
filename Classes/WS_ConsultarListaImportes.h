//
//  ConsultarUltimoResumenTC.h
//  BanelcoMovil
//
//  Created by German Levy on 9/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSRequest.h"


@interface WS_ConsultarListaImportes : WSRequest {

	NSString *userToken;
    NSString *rCel;
	
}

@property (nonatomic, retain) NSString *userToken;
@property (nonatomic, retain) NSString *rCel;

@end
