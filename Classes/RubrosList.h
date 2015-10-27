//
//  RubrosList.h
//  BanelcoMovilIphone
//
//  Created by German Levy on 9/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WheelAnimationController.h"
#import "SearchTableController.h"
#import "WaitingAlert.h"


@interface RubrosList : SearchTableController {

	NSString *codRubro;
	
	int typeList;
	
	int typeAction;
	
	WaitingAlert *waiting;
	
}

@property (nonatomic, retain) NSString *codRubro;


extern int const RUBRO;

extern int const SUB_RUBRO;

extern NSString * const RUBRO_TARJETAS;

extern NSString * const RUBRO_AFIP;

- (void)executeSelectedRubro:(id)rubro;

@end
