//
//  Rubro.h
//  BanelcoMovil
//
//  Created by German Levy on 8/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Context.h"
#import "Util.h"


@interface Rubro : NSObject {

	NSString * tipo;

	NSString * codigo;

	NSString * nombre;
	
}

@property (nonatomic, retain) NSString * tipo;

@property (nonatomic, retain) NSString * codigo;

@property (nonatomic, retain) NSString * nombre;

+ (NSMutableArray *) getRubros;

+ (NSMutableArray *) getSubRubros:(NSString *)rubro;

+ (NSMutableArray *) parseRubros:(GDataXMLElement *)rootSoap;

@end
