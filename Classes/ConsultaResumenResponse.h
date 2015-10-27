//
//  ConsultaResumenResponse.h
//  BanelcoMovilIphone
//
//  Created by Demian on 9/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ConsultaResumenResponse : NSObject {

	NSString* fecha;
	NSString* saldo;
	NSArray* listaDeMovimientos;
}

@property(nonatomic,retain) NSString* fecha;
@property(nonatomic,retain) NSString* saldo;
@property(nonatomic,retain) NSArray* listaDeMovimientos;

@end
