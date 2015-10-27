//
//  UltimosPagosController.h
//  BanelcoMovilIphone
//
//  Created by German Levy on 9/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WheelAnimationController.h"
#import "Empresa.h"


@interface UltimosPagosController : WheelAnimationController <UITableViewDelegate, UITableViewDataSource> {

	Empresa *empresa;
	
	NSMutableArray *tickets;
	
	IBOutlet UITableView *tableView;
	
}

@property (nonatomic, retain) Empresa *empresa;

@property (nonatomic, retain) NSMutableArray *tickets;

@property (nonatomic, retain) IBOutlet UITableView *tableView;


- (void)executeShowAlert:(id)object;


@end
