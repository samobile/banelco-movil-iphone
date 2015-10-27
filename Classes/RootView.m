//
//  RootView.m
//  CETool
//
//  Created by Sebastian on 12/8/13.
//
//

#import "RootView.h"

@implementation RootView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
        
        if (self.tag == -10) {
            if (frame.origin.y == 0) {
                frame = [UIScreen mainScreen].applicationFrame;
            }
            [super setFrame:frame];
            return;
        }
        
        if (self.superview && self.superview != self.window)
        {
            frame = self.superview.bounds;
            frame.origin.y += 20.f;
            frame.size.height -= 20.f;
        }
        else
        {
            frame = [UIScreen mainScreen].applicationFrame;
        }
    }
    
    [super setFrame:frame];
}

- (void)layoutSubviews
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
        self.frame = self.frame;
    }
    
    [super layoutSubviews];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
