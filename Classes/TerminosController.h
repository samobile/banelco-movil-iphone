//
//  TerminosController.h
//  BanelcoMovilIphone
//
//  Created by Demian on 9/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TerminosController : UIViewController {
	IBOutlet UILabel *lTerm;
    
    IBOutlet UIImageView *fndImage;
}

@property (nonatomic, retain) UIImageView *fndImage;

@property (nonatomic, retain) IBOutlet UILabel *lTerm;

@end
