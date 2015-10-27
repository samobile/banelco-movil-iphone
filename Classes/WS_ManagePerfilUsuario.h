//
//  WS_CambiarPin.h
//  BanelcoMovilIphone
//
//  Created by German Levy on 9/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSRequest.h"

@interface WS_ManagePerfilUsuario : WSRequest {

	NSString *userToken;
	NSString *email;
	NSString *nickName;
    BOOL vencimientos;
    BOOL novedades;
    BOOL retornarLogueoDNI;
	
}

@property (nonatomic, retain) NSString *userToken;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *nickName;
@property BOOL vencimientos;
@property BOOL novedades;
@property BOOL retornarLogueoDNI;

@end
