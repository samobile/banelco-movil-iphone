//
//  ResumenCuentaResponse.h
//  BanelcoMovilIphone
//
//  Created by German Levy on 9/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ResumenCuentaResponse : NSObject {
	
	NSString *fechaConsulta;
	
	NSString *saldo;
	
	NSArray *movimientos;

}

@property (nonatomic, retain) NSString *fechaConsulta;

@property (nonatomic, retain) NSString *saldo;

@property (nonatomic, retain) NSArray *movimientos;


@end
