//
//  Stack.h
//  BanelcoMovilIphone
//
//  Created by German Levy on 9/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Stack : NSMutableArray {
	
	NSMutableArray *array;
	
}

@property (nonatomic, retain) NSMutableArray *array;

- (void)push:(NSObject *)object;

- (NSObject *)pop;

- (NSObject *)getLastObject;

- (void)resetStackWith:(NSObject *)object;

@end
