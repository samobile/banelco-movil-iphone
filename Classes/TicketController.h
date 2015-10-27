#import <UIKit/UIKit.h>
#import "StackableScreen.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@class Cuenta;
@class Deuda;
@class Ticket;

@interface TicketController : StackableScreen <UIActionSheetDelegate,MFMailComposeViewControllerDelegate,
MFMessageComposeViewControllerDelegate> {

	
	IBOutlet UILabel* lFecha;
	IBOutlet UILabel* lNroTrans;
	IBOutlet UILabel* lFooter;
	IBOutlet UILabel* lTitulo;
	
	IBOutlet UILabel* leyendFecha;
	IBOutlet UILabel* leyendNroTrans;
	
	Cuenta *cuenta;
	Deuda *deuda;
	Ticket *ticket;
	int tipo;
	
}




@property(nonatomic,retain) UILabel* lFecha; 
@property(nonatomic,retain) UILabel* lNroTrans;
@property(nonatomic,retain) UILabel* lFooter;
@property(nonatomic,retain) UILabel* lTitulo;

@property (nonatomic, retain) Cuenta *cuenta;
@property (nonatomic, retain) Deuda *deuda;
@property (nonatomic, retain) Ticket *ticket;

@property (nonatomic, retain) IBOutlet UILabel* leyendFecha;
@property (nonatomic, retain) IBOutlet UILabel* leyendNroTrans;

- (IBAction)enviarPorMail:(id)sender;


@end
