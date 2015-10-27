//
//  CustomCell.m
//  BanelcoMovilIphone
//
//  Created by German Levy on 9/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CustomCell.h"
#import "Context.h"
#import "CommonFunctions.h"


@implementation CustomCell

@synthesize itemText, itemIcon, itemBg,itemTextBack,itemIconBack,itemBgBack;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier withText:(NSString *)text bgImage:(UIImage *)bgImage andItemImage:(UIImage *)itemImage {
	
	if (self = [super initWithFrame:frame ]) {
		
        self.backgroundColor = [UIColor clearColor];
		self.backgroundView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 57)] autorelease];
		self.selectedBackgroundView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 57)] autorelease];
		
		// Background image
		self.itemBg = [[UIImageView alloc]initWithFrame:CGRectMake(17, 3, 280, 57)];
		self.itemBg.image = bgImage;
		[self.backgroundView addSubview:self.itemBg];
		
		self.itemBgBack = [[UIImageView alloc]initWithFrame:CGRectMake(17, 3, 280, 57)];
		self.itemBgBack.image = [UIImage imageNamed:@"btn_barramenuselec.png"];
		[self.selectedBackgroundView addSubview:self.itemBgBack ];
		
	//	((UIImageView *)self.backgroundView).image = itemBg.image;
	//	((UIImageView *)self.selectedBackgroundView).image = itemBgBack.image;
		
		
		// Item image
		self.itemIcon = [[UIImageView alloc]initWithFrame:CGRectMake(17, 3, 57, 57)];
		self.itemIcon.image = itemImage;
		[self addSubview:self.itemIcon];	
		
		// Item text
		self.itemText = [[UILabel alloc]initWithFrame:CGRectMake(80, 12, 265,30 )];
		self.itemText.textAlignment = UITextAlignmentLeft;
		self.itemText.font = [UIFont systemFontOfSize:17];
		self.itemText.text = text;
        self.itemText.accessibilityLabel = [self.itemText.text stringByReplacingOccurrencesOfString:@"U$S" withString:@"dolares"];
        self.itemText.accessibilityLabel = [self.itemText.text stringByReplacingOccurrencesOfString:@"$" withString:@"pesos"];
		self.itemText.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
		//personalizacion
		self.itemText.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"ListaTxtColor"];
		
		[self addSubview:self.itemText];		

	
		
		
	}
	
	return self;
	
}


- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier withBgImage:(UIImage *)bgImage {
	
	if (self = [super initWithFrame:frame ]) {
		
        self.backgroundColor = [UIColor clearColor];
		self.backgroundView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 57)] autorelease];
		self.selectedBackgroundView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 57)] autorelease];
		
		// Background image
		self.itemBg = [[UIImageView alloc]initWithFrame:CGRectMake(17, 3, 280, 57)];
		self.itemBg.image = bgImage;
		[self.backgroundView addSubview:self.itemBg];
		
		self.itemBgBack = [[UIImageView alloc]initWithFrame:CGRectMake(17, 3, 280, 57)];
		self.itemBgBack.image = [UIImage imageNamed:@"btn_barramenuselec.png"];
		[self.selectedBackgroundView addSubview:self.itemBgBack ];
		
		
	
		// Item image
		self.itemIcon = [[UIImageView alloc]initWithFrame:CGRectMake(17, 3, 57, 57)];
		[self addSubview:self.itemIcon];	
		
		// Item text
		self.itemText = [[UILabel alloc]initWithFrame:CGRectMake(80, 15, 265,30 )];
		self.itemText.textAlignment = UITextAlignmentLeft;
		if (![Context sharedContext].personalizado) {
            self.itemText.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:16];
        }
        else {
            self.itemText.font = [UIFont systemFontOfSize:16];
        }
		self.itemText.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
		
		//personalizacion
		self.itemText.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"ListaTxtColor"];
		
		[self addSubview:self.itemText];		
		
	}
	
	return self;
	
}

- (void) dealloc {
	[itemTextBack release];
	[itemIconBack release];
	[itemBgBack release];
	[itemText release];
    [itemIcon release];
	[super dealloc];
}

@end
