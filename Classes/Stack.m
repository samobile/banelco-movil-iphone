//
//  Stack.m
//  BanelcoMovilIphone
//
//  Created by German Levy on 9/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Stack.h"

@implementation Stack

@synthesize array;


-(id) init {
	if (self = [super init]){
		
		array = [[NSMutableArray alloc] init];
		
	}
	return self;
}

- (void)push:(NSObject *)object {

	[array addObject:object];
	
}

- (NSObject *)pop {

	NSObject *object = nil;
	
	if ([array count] > 0) {
		
		object = [array objectAtIndex: [array count] -1];
		
		[array removeLastObject];
		
	}
	
	return object;
	
}

- (NSObject *)getLastObject {
	
	NSObject *object = nil;
	
	if ([array count] > 0) {
		
		object = [array objectAtIndex: [array count] -1];
				
	}
	
	return object;
	
}

- (void)resetStackWith:(NSObject *)object {

	[array removeAllObjects];
	
	if (object) {
		[self push:object];
	}
	
}

@end
