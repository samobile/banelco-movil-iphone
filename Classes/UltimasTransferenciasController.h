//
//  UltimasTransferenciasController.h
//  BanelcoMovilIphone
//
//  Created by German Levy on 9/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WheelAnimationController.h"


@interface UltimasTransferenciasController : WheelAnimationController <UITableViewDelegate, UITableViewDataSource> {
	
	NSMutableArray *tickets;
	
	IBOutlet UITableView *tableView;

}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *tickets;

@end
