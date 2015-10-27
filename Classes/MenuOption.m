//
//  MenuOption.m
//  BanelcoMovilIphone
//
//  Created by German Levy on 9/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MenuOption.h"


@implementation MenuOption

@synthesize option, title;


- (id) initWithOption:(int)_option andTitle:(NSString *)_title {
	
	if (self = [super init]) {
		self.option = _option;
		self.title = _title;
	}
	
	return self;
	
}

- (NSString *)toString {

	return title;
	
}

@end
