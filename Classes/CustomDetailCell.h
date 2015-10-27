//
//  CustomDetailCell.h
//  BanelcoMovilIphone
//
//  Created by German Levy on 11/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CustomDetailCell : UITableViewCell {

	UILabel* titulo;
	
	UILabel* dato;
	
}

@property(nonatomic,retain) UILabel* titulo;

@property(nonatomic,retain) UILabel* dato;

- (void)esTitulo;

@end
