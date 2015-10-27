//
//  CustomDetailCell.m
//  BanelcoMovilIphone
//
//  Created by German Levy on 11/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CustomDetailCell.h"
#import "Context.h"
#import "CommonFunctions.h"


@implementation CustomDetailCell

@synthesize titulo, dato;


- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
	
    if ((self = [super initWithFrame:CGRectZero reuseIdentifier:reuseIdentifier])) {
		
		//personalizacion
		self.backgroundColor = [[Context sharedContext] UIColorFromRGBProperty:@"DetalleBkgColor"];
		
		//self.backgroundColor = [UIColor whiteColor];
		
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
        self.titulo = [[UILabel alloc] initWithFrame:CGRectMake(16, 5, 76, 30)];
		if (![Context sharedContext].personalizado) {
            self.titulo.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:14];
        }
        else {
            self.titulo.font = [UIFont systemFontOfSize:14];
        }
		self.titulo.textAlignment = UITextAlignmentRight;
		
		//personalizacion
		self.titulo.backgroundColor = [UIColor clearColor];
		
		self.dato = [[UILabel alloc] initWithFrame:CGRectMake(100, 5, 185, 30)];

		//personalizacion
		self.dato.backgroundColor = [UIColor clearColor];
		
		self.dato.adjustsFontSizeToFitWidth = YES;

		if (![Context sharedContext].personalizado) {
            self.dato.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:14];
        }
        else {
            self.dato.font = [UIFont boldSystemFontOfSize:14];
        }
		
		[self addSubview:self.titulo];
		[self addSubview:self.dato];
		
    }
    return self;
}

- (void)esTitulo {

	[self.titulo removeFromSuperview];
	int cellWidth = 310;
	self.dato.frame = CGRectMake(10, 8, cellWidth - 20, 30);
	//self.dato.backgroundColor = [UIColor redColor];
	self.dato.textAlignment = UITextAlignmentCenter;
	if (![Context sharedContext].personalizado) {
        self.dato.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:16];
    }
    else {
        self.dato.font = [UIFont boldSystemFontOfSize:16];
    }
	
}

- (void)dealloc {
    [super dealloc];
	[titulo release];
	[dato release];
}


@end
