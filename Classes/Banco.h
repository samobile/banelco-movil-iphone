//
//  Banco.h
//  BanelcoMovilIphone
//
//  Created by Demian on 8/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Banco : NSObject {

	
	BOOL selected;
	
	NSString* imagenRedonda;
	NSString* imagenHome;
	NSString* imagenTitulo;
	NSString* nombre;
	NSString* idBanco;
	NSString* url;
	
}

-(id) initWithDictionary:(NSDictionary*) valoresBanco;

@property BOOL selected;

@property (nonatomic,retain) NSString* imagenRedonda;
@property (nonatomic,retain) NSString* imagenTitulo;
@property (nonatomic,retain) NSString* imagenHome;
@property (nonatomic,retain) NSString* nombre;
@property (nonatomic,retain) NSString* idBanco;
@property (nonatomic,retain) NSString* url;

@end
