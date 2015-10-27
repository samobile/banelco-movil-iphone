#import <UIKit/UIKit.h>
#import "WheelAnimationController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@class Cuenta;

@interface ConsultaCBU : WheelAnimationController <UIActionSheetDelegate,MFMailComposeViewControllerDelegate,
MFMessageComposeViewControllerDelegate> {

	
	IBOutlet UILabel* descripcionCuenta;
	UITextView* cbu;
	Cuenta* cuenta;
    NSString *cbuParaMail;
}

-(id) initWithCuenta:(Cuenta*) cuenta;

@property(nonatomic,retain) UILabel* descripcionCuenta;
@property(nonatomic,retain) UITextView* cbu;
@property(nonatomic,retain) Cuenta* cuenta;

@property (nonatomic, retain) NSString *cbuParaMail;

- (IBAction)enviarPorMail:(id)sender;

@end
