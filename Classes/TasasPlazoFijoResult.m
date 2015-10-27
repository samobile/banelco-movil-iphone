//
//  TasasPlazoFijoResult.m
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TasasPlazoFijoResult.h"
#import "CommonUIFunctions.h"
#import "Context.h"
#import "WS_ConsultarTasa.h"
#import "WSUtil.h"


@implementation TasasPlazoFijoResult

@synthesize ctaPlazo, importe, plazo, seuo, fecha, hora;

- (id) initWithTitle:(NSString *)t ctaPlazo:(Cuenta *)cPlazo importe:(NSString *)ite plazo:(NSString *)p {
	if ((self = [super init])) {
		self.title = t;
		self.ctaPlazo = cPlazo;
		self.importe = ite;
		self.plazo = p;
	}
	return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	[tableView setFrame:CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, IPHONE5_HDIFF(317))];
}


- (void)accionWithDelegate:(WheelAnimationController *)delegate {
	
	NSMutableArray *cuentasUsuario = [Context getCuentas];
	//Busca una cuenta de usuario con la misma moneda que la cuenta plazo seleccionada
	Cuenta *ctaUsuario = nil;
	for (Cuenta *cta in cuentasUsuario) {
		if (cta.codigoMoneda == ctaPlazo.codigoMoneda) {
			ctaUsuario = [cta retain];
			break;
		}
	}
	if (!ctaUsuario) {
		[CommonUIFunctions showAlert:self.title withMessage:@"No posee cuentas con la moneda seleccionada. Intente eligiendo otra cuenta plazo." cancelButton:@"Volver" andDelegate:self];
		[delegate accionFinalizada:TRUE];
		return;
	}
	
	WS_ConsultarTasa *request = [[WS_ConsultarTasa alloc] init];
	request.userToken = [[Context sharedContext] getToken];
	request.numCuentaPlazo = ctaPlazo.numero;
	request.numCuenta = ctaUsuario.numero;
	request.codTipoCta = ctaUsuario.codigoTipoCuenta;
	request.codMoneda = ctaPlazo.codigoMoneda;
	request.importe = [self.importe stringByReplacingOccurrencesOfString:@"," withString:@"."];
	request.plazo = self.plazo;
	NSString *result = [WSUtil execute:request];
	
	if (!result) {
		[CommonUIFunctions showAlert:self.title withMessage:@"En este momento no se puede realizar el cálculo de la tasa para el plazo fijo." cancelButton:@"Volver" andDelegate:self];
		[delegate accionFinalizada:TRUE];
		return;
	}
	else if ([result isKindOfClass:[NSError class]]) {
        NSString *errorCode = [[(NSError *)result userInfo] valueForKey:@"faultCode"];
        if ([errorCode isEqualToString:@"ss"]) {
            return;
        }
		NSString *errorDesc = [[(NSError *)result userInfo] valueForKey:@"description"];
		[CommonUIFunctions showAlert:self.title withMessage:errorDesc cancelButton:@"Volver" andDelegate:self];
		[delegate accionFinalizada:TRUE];
		return;
	}
	
	self.tableView.frame = CGRectMake(5, 0, 310, IPHONE5_HDIFF(180));
		
	[titulos addObject:@""];
	[datos addObject:@"Consulta de Tasa"];
	
	[titulos addObject:@"TNA"];
	[datos addObject:[NSString stringWithFormat:@"%@ %%",result]];
	
	[titulos addObject:@"Moneda"];
	[datos addObject:ctaPlazo.simboloMoneda];
	
	[titulos addObject:@"Días"];
	[datos addObject:plazo];
	
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"dd/MM/yyyy"];
	
	NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
	[timeFormat setDateFormat:@"HH:mm"];
	
	NSDate *now = [[NSDate alloc] init];
	
	NSString *theDate = [dateFormat stringFromDate:now];
	NSString *theTime = [timeFormat stringFromDate:now];
	
	UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 190, 150, 35)];
	lbl.text = @"S.E.U.O.";
	lbl.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	lbl.backgroundColor = [UIColor clearColor];
	if (![Context sharedContext].personalizado) {
        lbl.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:13];
    }
    else {
        lbl.font = [UIFont fontWithName:@"Helvetica" size:13];
    }
	lbl.numberOfLines = 1;
	[self.view addSubview:lbl];
	[lbl release];
	
	lbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 220, 150, 35)];
	lbl.text = theDate;
	lbl.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	lbl.backgroundColor = [UIColor clearColor];
	if (![Context sharedContext].personalizado) {
        lbl.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:13];
    }
    else {
        lbl.font = [UIFont fontWithName:@"Helvetica" size:13];
    }
	lbl.numberOfLines = 1;
	[self.view addSubview:lbl];
	[lbl release];
	
	lbl = [[UILabel alloc] initWithFrame:CGRectMake(220, 220, 80, 35)];
	lbl.text = [NSString stringWithFormat:@"%@ Horas",theTime];
	lbl.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	lbl.backgroundColor = [UIColor clearColor];
	lbl.textAlignment = UITextAlignmentRight;
	if (![Context sharedContext].personalizado) {
        lbl.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:13];
    }
    else {
        lbl.font = [UIFont fontWithName:@"Helvetica" size:13];
    }
	lbl.numberOfLines = 1;
	[self.view addSubview:lbl];
	[lbl release];
	
	fecha.text = theDate;
	hora.text = [NSString stringWithFormat:@"%@ Horas",theTime];
	
	[dateFormat release];
	[timeFormat release];
	[now release];
	
	[self.tableView reloadData];
	
	[delegate accionFinalizada:TRUE];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
