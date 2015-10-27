#import "CuentaCell.h"
#import "Cuenta.h"
#import "Util.h"
#import "Context.h"
@implementation CuentaCell
@synthesize fondo;
@synthesize cuentaDescripcion;
@synthesize cuentaNumero;
@synthesize cuentaSaldo;




- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier andCuenta:(Cuenta*) cuenta conSaldo:(BOOL) conSaldo{
    if ((self = [super initWithFrame:CGRectZero reuseIdentifier:reuseIdentifier])) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.fondo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fnd_lista.png"]];
		self.fondo.frame = CGRectMake(0, 0, 320, 78);
		[self addSubview:self.fondo];
		if (cuenta.accountType == C_CBU) {
			[self cargarDescripcionAgenda:[cuenta getDescripcion]];
		}
		else {
			[self cargarDescripcion:[cuenta getDescripcionLinea1]];
			[self cargarNumero:[cuenta getDescripcionLinea2]];
		}

		
		if(conSaldo){
			[self cargarSaldo:cuenta.saldo];
		}

    }
    return self;
}

- (id)initSmallWithReuseIdentifier:(NSString *)reuseIdentifier andCuenta:(Cuenta*)cuenta inWidth:(CGFloat)width {

    if ((self = [super initWithFrame:CGRectZero reuseIdentifier:reuseIdentifier])) {
		
        self.backgroundColor = [UIColor clearColor];
        
        self.fondo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fnd_lista.png"]];
		self.fondo.frame = CGRectMake(0, 0, width, 50);
		[self addSubview:self.fondo];		
		[self cargarDescripcionCorta:[cuenta getDescripcion]];
		
    }
    return self;
}


-(void) cargarDescripcion:(NSString*) texto{
	self.cuentaDescripcion = [[UILabel alloc]initWithFrame:CGRectMake(10, 12, 265,30 )];
	self.cuentaDescripcion.textAlignment = UITextAlignmentLeft;
	if (![Context sharedContext].personalizado) {
        self.cuentaDescripcion.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:17];
    }
    else {
        self.cuentaDescripcion.font = [UIFont systemFontOfSize:17];
    }
	self.cuentaDescripcion.text = texto;
    self.cuentaDescripcion.accessibilityLabel = [self.cuentaDescripcion.text stringByReplacingOccurrencesOfString:@"U$S" withString:@"dolares"];
    self.cuentaDescripcion.accessibilityLabel = [self.cuentaDescripcion.text stringByReplacingOccurrencesOfString:@"$" withString:@"pesos"];
	self.cuentaDescripcion.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
	
	[self addSubview:self.cuentaDescripcion];
}

-(void) cargarDescripcionCorta:(NSString*) texto{
	self.cuentaDescripcion = [[UILabel alloc]initWithFrame:CGRectMake(10, 9, 265,30 )];
	self.cuentaDescripcion.textAlignment = UITextAlignmentLeft;
	if (![Context sharedContext].personalizado) {
        self.cuentaDescripcion.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:17];
    }
    else {
        self.cuentaDescripcion.font = [UIFont systemFontOfSize:17];
    }
	self.cuentaDescripcion.text = texto;
    self.cuentaDescripcion.accessibilityLabel = [self.cuentaDescripcion.text stringByReplacingOccurrencesOfString:@"U$S" withString:@"dolares"];
    self.cuentaDescripcion.accessibilityLabel = [self.cuentaDescripcion.text stringByReplacingOccurrencesOfString:@"$" withString:@"pesos"];
	self.cuentaDescripcion.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
	
	[self addSubview:self.cuentaDescripcion];
}

-(void) cargarSaldo:(NSString*) texto{
	self.cuentaSaldo = [[UILabel alloc]initWithFrame:CGRectMake(20, 24, 265,30)];
	self.cuentaSaldo.textAlignment = UITextAlignmentRight;
	if (![Context sharedContext].personalizado) {
        self.cuentaSaldo.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:18];
    }
    else {
        self.cuentaSaldo.font = [UIFont boldSystemFontOfSize:18];
    }
	self.cuentaSaldo.text = texto;
    self.cuentaSaldo.accessibilityLabel = [self.cuentaSaldo.text stringByReplacingOccurrencesOfString:@"U$S" withString:@"dolares"];
    self.cuentaSaldo.accessibilityLabel = [self.cuentaSaldo.text stringByReplacingOccurrencesOfString:@"$" withString:@"pesos"];
	self.cuentaSaldo.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
	
	[self addSubview:self.cuentaSaldo];
}

-(void) cargarDescripcionAgenda:(NSString*) texto{
	self.cuentaDescripcion = [[UILabel alloc]initWithFrame:CGRectMake(10, 18, 265,30 )];
	self.cuentaDescripcion.textAlignment = UITextAlignmentLeft;
	if (![Context sharedContext].personalizado) {
        self.cuentaDescripcion.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:17];
    }
    else {
        self.cuentaDescripcion.font = [UIFont systemFontOfSize:17];
    }
	self.cuentaDescripcion.text = texto;
    self.cuentaDescripcion.accessibilityLabel = [self.cuentaDescripcion.text stringByReplacingOccurrencesOfString:@"U$S" withString:@"dolares"];
    self.cuentaDescripcion.accessibilityLabel = [self.cuentaDescripcion.text stringByReplacingOccurrencesOfString:@"$" withString:@"pesos"];
	self.cuentaDescripcion.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
	
	[self addSubview:self.cuentaDescripcion];
}


-(void) cargarNumero:(NSString*) texto{
	self.cuentaNumero = [[UILabel alloc]initWithFrame:CGRectMake(10, 42, 250,25)];
	self.cuentaNumero.textAlignment = UITextAlignmentLeft;
	if (![Context sharedContext].personalizado) {
        self.cuentaNumero.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:14];
    }
    else {
        self.cuentaNumero.font = [UIFont systemFontOfSize:14];
    }
	self.cuentaNumero.text = texto;
    self.cuentaNumero.accessibilityLabel = [self.cuentaNumero.text stringByReplacingOccurrencesOfString:@"U$S" withString:@"dolares"];
    self.cuentaNumero.accessibilityLabel = [self.cuentaNumero.text stringByReplacingOccurrencesOfString:@"$" withString:@"pesos"];
	self.cuentaNumero.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
	
	[self addSubview:self.cuentaNumero];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
	
	//Agregado para poner texto en blanco al seleccionar celda
	if (selected) {
		self.cuentaDescripcion.textColor = [UIColor colorWithRed:((float)((0x8B092E & 0xFF0000) >> 16))/255.0 
														   green:((float)((0x8B092E & 0xFF00) >> 8))/255.0 
															blue:((float)(0x8B092E & 0xFF))/255.0 
														   alpha:1.0];
		if (![Context sharedContext].personalizado) {
            self.cuentaDescripcion.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:19];
        }
        else {
            self.cuentaDescripcion.font = [UIFont boldSystemFontOfSize:19];
        }
	}
	else {
		self.cuentaDescripcion.textColor = [UIColor blackColor];
		if (![Context sharedContext].personalizado) {
            self.cuentaDescripcion.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:17];
        }
        else {
            self.cuentaDescripcion.font = [UIFont systemFontOfSize:17];
        }
	}

	 
}


- (void)dealloc {
	[cuentaNumero release];
	[fondo release];
	[cuentaDescripcion release];
	[cuentaSaldo release];
    [super dealloc];
}


@end
