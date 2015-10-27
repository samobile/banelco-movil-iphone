//
//  AyudaContactoViewController.h
//  BanelcoMovilIphone
//
//  Created by German Levy on 2/20/14.
//
//

#import <UIKit/UIKit.h>
#import "StackableScreen.h"
#import "MBProgressHUD.h"

@interface AyudaContactoViewController : StackableScreen{
    IBOutlet UIImageView *fndApp;
}
@property (nonatomic, retain) UIImageView *fndApp;

-(IBAction)llamar:(id)sender;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
@end
