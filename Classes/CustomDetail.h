//
//  CustomDetail.h
//  BanelcoMovilIphone
//
//  Created by German Levy on 11/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StackableScreen.h"
#import "WheelAnimationController.h"


@interface CustomDetail : WheelAnimationController <UITableViewDelegate> {

	NSMutableArray *titulos;
		
	NSMutableArray *datos;
	
	IBOutlet UITableView *tableView;
	
}

@property (nonatomic, retain) NSMutableArray *titulos;

@property (nonatomic, retain) NSMutableArray *datos;

@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end
