//
//  SelectGuestWSRequest.h
//  MING_iPad
//
//  Created by German Levy on 7/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSRequest.h"


@interface WS_Login : WSRequest {

	NSString *tipoDoc;
	NSString *nroDoc;
	NSString *codBanco;
	NSString *clave;
	NSString *codApp;
	NSString *appOrigen;
	NSString *userToken;
    NSString *datosApp;
}

@property (nonatomic, retain) NSString *tipoDoc;
@property (nonatomic, retain) NSString *nroDoc;
@property (nonatomic, retain) NSString *codBanco;
@property (nonatomic, retain) NSString *clave;
@property (nonatomic, retain) NSString *codApp;
@property (nonatomic, retain) NSString *appOrigen;
@property (nonatomic, retain) NSString *userToken;
@property (nonatomic, retain) NSString *datosApp;

@end
