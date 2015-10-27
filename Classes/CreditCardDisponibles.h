//
//  CreditCardDisponibles.h
//  BanelcoMovil
//
//  Created by German Levy on 8/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CreditCardDisponibles : NSObject {

	NSString *codigo;
	NSMutableDictionary *disponibles;

}

@property (nonatomic,retain) NSString *codigo;
@property (nonatomic,retain) NSMutableDictionary *disponibles;

@end
