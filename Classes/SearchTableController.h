//
//  SearchTable.h
//  BanelcoMovilIphone
//
//  Created by German Levy on 9/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WheelAnimationController.h"


@interface SearchTableController : WheelAnimationController <UISearchBarDelegate, UITableViewDelegate> {

	NSArray *sourceKeys;

	NSArray *filteredKeys;
	
	NSDictionary *sourceDictionary;

	IBOutlet UISearchBar *searchBar;
	
	IBOutlet UITableView *tableView;
	
}

@property (nonatomic, retain) NSArray *sourceKeys;

@property (nonatomic, retain) NSArray *filteredKeys;

@property (nonatomic, retain) NSDictionary *sourceDictionary;

@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;

@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end
