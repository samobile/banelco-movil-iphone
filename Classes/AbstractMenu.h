//
//  CustomList.h
//  BanelcoMovilIphone
//
//  Created by German Levy on 9/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StackableScreen.h"


@interface AbstractMenu : StackableScreen <UITableViewDelegate> {

	IBOutlet UITableView *tableView;
	
	@protected NSMutableArray *options;
	
	UIImage *bgImage;
	UIImage *itemImage;
	
	int topMargin;
	int margin;
	int cellHeight;
	
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;

@property (nonatomic, retain) NSMutableArray *options;

@property (nonatomic, retain) UIImage *bgImage;
@property (nonatomic, retain) UIImage *itemImage;

extern int const AM_FUCSIA;
extern int const AM_AZUL;
extern int const AM_VIOLETA;
extern int const AM_VERDE;


- (void)initOptions;

- (int)getSelectedIndex:(int)selectedCellIdx;

- (void)aceptar:(int)cellIdx;

@end
