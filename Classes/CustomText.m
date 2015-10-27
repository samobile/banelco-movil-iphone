//
//  CustomText.m
//  BanelcoMovilIphone
//
//  Created by German Levy on 9/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CustomText.h"
#import "Context.h"

@implementation CustomText

@synthesize scrollView, items;


- (id)init {
    if ((self = [super initWithNibName:@"CustomText" bundle:nil])) {

    }
    return self;
}

- (id)initWithItems:(NSMutableArray *)items {
    if ((self = [super initWithNibName:@"CustomText" bundle:nil])) {
		self.items = items;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	//Carga Info
	int y = 20;
	int space = 10;
	UILabel *l;
	
	for (NSObject *obj in self.items) {
		
		
		
		CGRect r = CGRectMake(20, y, 280, 20);
		
		if ([obj isKindOfClass:[UILabel class]]){  // Si el objeto en el array de items es un label lo escribo como viene
			l = (UILabel*) obj;
			l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
			r = CGRectMake(20, y, 280, l.frame.size.height);
			l.frame = r;
			[self.scrollView addSubview:l];
			y += l.frame.size.height + space;
			[l release];
		}else{ // si es un texto, busco por tags y lo escribo como sea 
			
			NSString* item = (NSString*) obj;
			l = [[UILabel alloc] initWithFrame:r];
			
			
			l.backgroundColor = [UIColor clearColor];
			
			NSRange aRange = [item rangeOfString:@"<b>"];
			if (aRange.location != NSNotFound) {
				l.font = [UIFont boldSystemFontOfSize:l.font.pointSize+1];
				item=[item stringByReplacingOccurrencesOfString:@"<b>" withString:@""]; 
				
				
			}
			
			NSRange bRange = [item rangeOfString:@"<i>"];
			if (bRange.location != NSNotFound) {
				l.font = [UIFont italicSystemFontOfSize:l.font.pointSize];
				item=[item stringByReplacingOccurrencesOfString:@"<i>" withString:@""]; 
				
			}
			
			
			l.text = [NSString stringWithFormat:item];
			l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
			[self.scrollView addSubview:l];
			[l release];
			y += r.size.height + space;
		}
		
				
		
		
	}

}


-(void) addText:(NSString*)txt withSize:(int) fontSize{
	UILabel* l = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, fontSize + 2)];
	l.text = txt;
    l.accessibilityLabel = [l.text stringByReplacingOccurrencesOfString:@"U$S" withString:@"dolares"];
    l.accessibilityLabel = [l.text stringByReplacingOccurrencesOfString:@"$" withString:@"pesos"];
	l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	l.font = [UIFont systemFontOfSize:fontSize];
	[items addObject:l];
	[l release];
}


- (void)dealloc {
	[scrollView release];
	[items release];
    [super dealloc];
}


@end
