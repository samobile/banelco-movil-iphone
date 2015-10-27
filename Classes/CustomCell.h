//
//  CustomCell.h
//  BanelcoMovilIphone
//
//  Created by German Levy on 9/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CustomCell : UITableViewCell {

	UILabel *itemText;
	
	UIImageView *itemIcon;

	UIImageView *itemBg;
	
	UILabel *itemTextBack;
	
	UIImageView *itemIconBack;
	
	UIImageView *itemBgBack;
	

}

@property(nonatomic,retain) UILabel *itemText;

@property(nonatomic,retain) UIImageView *itemIcon;

@property(nonatomic,retain) UIImageView *itemBg;

@property(nonatomic,retain) UILabel *itemTextBack;

@property(nonatomic,retain) UIImageView *itemIconBack;

@property(nonatomic,retain) UIImageView *itemBgBack;


- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier withText:(NSString *)text bgImage:(UIImage *)bgImage andItemImage:(UIImage *)itemImage;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier withBgImage:(UIImage *)bgImage;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier withText:(NSString *)text;


@end
