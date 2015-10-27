//
//  LoginResponse.h
//  BanelcoMovilIphone
//
//  Created by German Levy on 9/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Usuario.h"


@interface LoginResponse : NSObject {

	Usuario *usuario;
	
	NSMutableArray *cuentas;
	
	NSString *tokenSeguridad;
	
}

@property (nonatomic, retain) Usuario *usuario;

@property (nonatomic, retain) NSMutableArray *cuentas;

@property (nonatomic, retain) NSString *tokenSeguridad;


@end
