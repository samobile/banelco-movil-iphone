
#import "DeudaCell.h"
#import "Deuda.h"
#import "Util.h"
#import "Context.h"

@implementation DeudaCell

@synthesize fondo;
@synthesize cuentaDescripcion;
@synthesize cuentaNumero;
@synthesize cuentaSaldo;


- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
	
    if ((self = [super initWithFrame:CGRectZero reuseIdentifier:reuseIdentifier])) {
		
        self.fondo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fnd_lista.png"]];
		self.fondo.frame = CGRectMake(0, 0, 320, 70);
		[self addSubview:self.fondo];
		
    }
    return self;
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier andDeuda:(Deuda *)deuda {
	
    if ((self = [super initWithFrame:CGRectZero reuseIdentifier:reuseIdentifier])) {
		
        self.fondo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fnd_lista.png"]];
		self.fondo.frame = CGRectMake(0, 0, 320, 70);
		[self addSubview:self.fondo];
		
		[self cargarDeuda:deuda];
		
    }
    return self;
}

- (void)cargarDeuda:(Deuda *)deuda {

	[self cargarDescripcion:deuda];
	[self cargarVto:deuda];
	[self cargarImporte:deuda];
	
}

- (void) cargarDescripcion:(Deuda *)deuda {
	
	NSString *codigo = @"";
	if ([deuda.codigoRubro isEqualToString:@"TCIN"] || [deuda.codigoRubro isEqualToString:@"TCRE"]) {
		codigo = [Util formatDigits:deuda.idCliente];
	} else {
		codigo = deuda.idCliente;
	}
	self.cuentaDescripcion.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"ListaTxtColor"];
	NSString *texto = [NSString stringWithFormat:@"%@ - %@", deuda.nombreEmpresa, codigo];
	
	if (self.cuentaDescripcion && [self.cuentaDescripcion isDescendantOfView:self]) {
		
		self.cuentaDescripcion.text = texto;
		
	} else {
		
		self.cuentaDescripcion = [[UILabel alloc]initWithFrame:CGRectMake(10, 6, 265,30 )];
		self.cuentaDescripcion.textAlignment = UITextAlignmentLeft;
		if (![Context sharedContext].personalizado) {
            self.cuentaDescripcion.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:17];
        }
        else {
            self.cuentaDescripcion.font = [UIFont systemFontOfSize:17];
        }
		self.cuentaDescripcion.text = texto;
		self.cuentaDescripcion.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
		
		[self addSubview:self.cuentaDescripcion];
		
	}
    self.cuentaDescripcion.accessibilityLabel = [self.cuentaDescripcion.text stringByReplacingOccurrencesOfString:@"U$S" withString:@"dolares"];
    self.cuentaDescripcion.accessibilityLabel = [self.cuentaDescripcion.text stringByReplacingOccurrencesOfString:@"$" withString:@"pesos"];

}

- (void) cargarVto:(Deuda *)deuda {
	
	self.cuentaNumero.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"ListaTxtColor"];
	NSString *texto = [NSString stringWithFormat:@"Vto. %@", deuda.vencimiento];

	if (self.cuentaNumero && [self.cuentaNumero isDescendantOfView:self]) {
		
		self.cuentaNumero.text = texto;
		
	} else {
		
		self.cuentaNumero = [[UILabel alloc]initWithFrame:CGRectMake(10, 33, 250,25)];
		self.cuentaNumero.textAlignment = UITextAlignmentLeft;
		if (![Context sharedContext].personalizado) {
            self.cuentaDescripcion.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:14];
        }
        else {
            self.cuentaNumero.font = [UIFont systemFontOfSize:14];
        }
		self.cuentaNumero.text = texto;
		
		self.cuentaNumero.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
		
		[self addSubview:self.cuentaNumero];
		
	}
	
}

- (void) cargarImporte:(Deuda *)deuda {
	
	self.cuentaSaldo.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"ListaTxtColor"];
	NSString *texto = [NSString stringWithFormat:@"%@ %@", deuda.monedaSimbolo, [Util formatSaldo:deuda.importe]];
	
	if (self.cuentaSaldo && [self.cuentaSaldo isDescendantOfView:self]) {
		
		self.cuentaSaldo.text = texto;
		
	} else {
		
		self.cuentaSaldo = [[UILabel alloc]initWithFrame:CGRectMake(160, 30, 125, 30)];
		self.cuentaSaldo.textAlignment = UITextAlignmentRight;
		if (![Context sharedContext].personalizado) {
            self.cuentaDescripcion.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:18];
        }
        else {
            self.cuentaSaldo.font = [UIFont boldSystemFontOfSize:18];
        }
		self.cuentaSaldo.text = texto;
		
		self.cuentaSaldo.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
		
		[self addSubview:self.cuentaSaldo];
		
	}
    self.cuentaSaldo.accessibilityLabel = [self.cuentaSaldo.text stringByReplacingOccurrencesOfString:@"U$S" withString:@"dolares"];
    self.cuentaSaldo.accessibilityLabel = [self.cuentaSaldo.text stringByReplacingOccurrencesOfString:@"$" withString:@"pesos"];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
	[cuentaNumero release];
	[fondo release];
	[cuentaDescripcion release];
	[cuentaSaldo release];
    [super dealloc];
}


@end
