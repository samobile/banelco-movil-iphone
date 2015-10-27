//
//  CargaSUBEOtroController.h
//  BanelcoMovilIphone
//
//  Created by German Levy on 10/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WheelAnimationController.h"


@interface CargaSUBEOtroController : WheelAnimationController <UITableViewDelegate> {
	
	IBOutlet UITableView* listaTarjetas;
	
	NSMutableArray *tarjetas;
	
}

@property (nonatomic, retain) IBOutlet UITableView *listaTarjetas;

@property (nonatomic, retain) NSMutableArray *tarjetas;

-(void)setActivityIndicator:(BOOL)enable;

@end
