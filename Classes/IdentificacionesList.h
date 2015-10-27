//
//  IdentificacionesList.h
//  BanelcoMovilIphone
//
//  Created by German Levy on 9/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WheelAnimationController.h"
#import "Empresa.h"


@interface IdentificacionesList : StackableScreen <UITableViewDelegate> {

	NSMutableArray *items;
	UITableView* tabla;
	Empresa *empresa;
}

@property(nonatomic,retain) NSMutableArray *items;
@property(nonatomic,retain) Empresa *empresa;
@property(nonatomic,retain) UITableView* tabla;


@end
