#import "BancoCell.h"
#import "Context.h"

@implementation BancoCell

@synthesize nombreBancoLabel;
@synthesize iconoBanco;



- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier nombreBanco:(NSString*) nombre andImageName:(NSString*)nombreImagen{
	if (self = [super initWithFrame:frame ]) {
		// Initialization code
		[self cargarImagen:nombreImagen];
		[self cargarLabel:nombre];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier andNombreBanco:(NSString*) nombre{
	if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		[self cargarLabel:nombre];
	}
	return self;
}


-(void) cargarImagen:(NSString*) nombreImagen{
	
	self.iconoBanco = [[UIImageView alloc]initWithFrame:CGRectMake(17, 3, 48, 48)];
	self.iconoBanco.image = [UIImage imageNamed:nombreImagen];
	//[self.contentView addSubview:label];
	[self addSubview:self.iconoBanco];
	//[self.contentView addSubview:imageView];
}

-(void) cargarLabel:(NSString*) nombre{
	self.nombreBancoLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 12, 265,30 )];
	self.nombreBancoLabel.textAlignment = UITextAlignmentLeft;
    if (![[Context sharedContext] personalizado]) {
        self.nombreBancoLabel.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:17];
    }
    else {
        self.nombreBancoLabel.font = [UIFont systemFontOfSize:17];
    }
	self.nombreBancoLabel.text = nombre;
	self.nombreBancoLabel.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	self.nombreBancoLabel.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];

	[self addSubview:self.nombreBancoLabel];
	
}

- (void)dealloc {
	[nombreBancoLabel release];
    [iconoBanco release];
	[super dealloc];
}

@end
