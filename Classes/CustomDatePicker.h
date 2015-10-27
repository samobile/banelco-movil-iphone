//
//  CustomDatePicker.h
//  BanelcoMovilIphone
//
//  Created by German Levy on 6/8/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CustomDatePicker : UIPickerView <UIPickerViewDelegate, UIPickerViewDataSource> {

	NSArray *meses;
	NSMutableArray *anios;
	
	NSInteger anioActual;
	
}

@property(nonatomic,retain) NSArray *meses;
@property(nonatomic,retain) NSMutableArray *anios;

@property(nonatomic) NSInteger anioActual;

-(void)iniciar;

-(NSString *)getDateString;

@end
