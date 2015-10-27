//
//  MenuOption.h
//  BanelcoMovilIphone
//
//  Created by German Levy on 9/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MenuOption : NSObject {

	int option;
	
	NSString *title;
	
}

@property int option;

@property (nonatomic, retain) NSString *title;


- (id) initWithOption:(int)_option andTitle:(NSString *)_title;

- (NSString *)toString;
	

@end
