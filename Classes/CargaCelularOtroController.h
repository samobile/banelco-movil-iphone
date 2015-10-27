//
//  CargaCelularOtroController.h
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 9/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WheelAnimationController.h"


@interface CargaCelularOtroController : WheelAnimationController <UITableViewDelegate> {
	IBOutlet UITableView* listaCelular;

    IBOutlet UIScrollView *tableContainer;
	NSMutableArray *celulares;
}

@property (nonatomic, retain) IBOutlet UITableView *listaCelular;
@property (nonatomic, retain) IBOutlet UIScrollView *tableContainer;

@property (nonatomic, retain) NSMutableArray *celulares;

//-(void)setActivityIndicator:(BOOL)enable;

@end
