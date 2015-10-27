#import "CreditCardCell.h"
#import "Context.h"

@implementation CreditCardCell
@synthesize tarjeta;
@synthesize fondo;
@synthesize tarjDesc;
@synthesize tarjDescNum;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
       self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


-(id) initWithCreditCard:(CreditCard*) cc{
	
	if ((self = [super initWithFrame:CGRectZero reuseIdentifier:@"card"])) {
        self.backgroundColor = [UIColor clearColor];
		self.tarjeta = cc;
		self.fondo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fnd_lista.png"]];
		self.fondo.frame = CGRectMake(0, 0, 320, 50);
		[self addSubview:self.fondo];
		
		
		NSMutableString *num = [[NSMutableString alloc] init];
		
		for (int i = 0; i < 4; i++) {
			[num appendFormat:@"."];
		}
		
		for (int i = [cc.numero length]-4; i < [cc.numero length]; i++) {
			[num appendFormat:@"%c",[cc.numero characterAtIndex:i]];
		}
		self.tarjDesc = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 265,30 )];
		self.tarjDesc.textAlignment = UITextAlignmentLeft;
		if (![Context sharedContext].personalizado) {
            self.tarjDesc.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:17];
        }
        else {
            self.tarjDesc.font = [UIFont systemFontOfSize:17];
        }
		self.tarjDesc.text = [NSString stringWithFormat:@"%@",cc.nombre];
		self.tarjDesc.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
		self.tarjDesc.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
		
		
		self.tarjDescNum = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 265,30 )];
		self.tarjDescNum.textAlignment = UITextAlignmentRight;
		if (![Context sharedContext].personalizado) {
            self.tarjDescNum.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:17];
        }
        else {
            self.tarjDescNum.font = [UIFont boldSystemFontOfSize:17];
        }
		self.tarjDescNum.text = [NSString stringWithFormat:@"%@",num];
		self.tarjDescNum.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
		self.tarjDescNum.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
		
		
		[self addSubview:self.tarjDesc];
		[self addSubview:self.tarjDescNum];
	
  }
	return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
	[fondo release];
	[tarjDesc release];
	[tarjDescNum release];
	[tarjeta release];
    [super dealloc];
}


@end
