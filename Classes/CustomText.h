//
//  CustomText.h
//  BanelcoMovilIphone
//
//  Created by German Levy on 9/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StackableScreen.h"


@interface CustomText : StackableScreen {

 	IBOutlet UIScrollView *scrollView;
	
	NSMutableArray *items;
	
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

@property (nonatomic, retain) NSMutableArray *items;

- (id)initWithTitle:(NSString *)title andItems:(NSMutableArray *)items;

@end
