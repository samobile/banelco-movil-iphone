
#import <UIKit/UIKit.h>
#import "CreditCard.h"

@interface CreditCardCell : UITableViewCell {

	
	CreditCard* tarjeta;
	
	UIImageView* fondo;
	UILabel* tarjDesc;
	UILabel* tarjDescNum;
}
@property (nonatomic,retain) CreditCard* tarjeta;
@property (nonatomic,retain) UILabel* tarjDescNum;
@property(nonatomic,retain) UIImageView* fondo;
@property(nonatomic,retain) UILabel* tarjDesc;
@end
