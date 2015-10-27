//
//  Util.h
//  BanelcoMovilIphone
//
//  Created by German Levy on 9/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Util : NSObject {

}

+ (NSString *) getSecurityToken:(NSString *)codigoBanco forDni:(NSString *)dni;

+ (void) setSecurityToken:(NSString *)token forBank:(NSString *)codigoBanco andDni:(NSString *)dni;

@end
