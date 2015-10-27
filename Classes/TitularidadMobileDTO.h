//
//  TitularidadMobileDTO.h
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 2/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cuenta.h"

@interface TitularidadMobileDTO : NSObject {

	NSString *nombreTitular;
	NSMutableArray *cuits;
	NSString *fiidBanco;
	NSString *nombreBanco;
	Cuenta *cuentaDestino;
}

@property (nonatomic, retain) NSString *nombreTitular;
@property (nonatomic, retain) NSMutableArray *cuits;
@property (nonatomic, retain) NSString *fiidBanco;
@property (nonatomic, retain) NSString *nombreBanco;
@property (nonatomic, retain) Cuenta *cuentaDestino;

@end
