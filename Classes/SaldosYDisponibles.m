//
//  SaldosYDisponibles.m
//  BanelcoMovilIphone
//
//  Created by Demian on 9/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SaldosYDisponibles.h"
#import "UltimosMovimientos.h"
#import "MenuBanelcoController.h"
#import "Util.h"
#import "WS_ConsultarLimitesyDisponibles.h"
#import "CommonUIFunctions.h"
#import "Context.h"
#import "WSUtil.h"

@implementation SaldosYDisponibles

@synthesize cuenta, botonUltMov;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

- (id)initWithCuenta:(Cuenta *)c {
    if ((self = [super init])) {
        // Custom initialization
		self.title = @"Saldos y Disponibles";
		self.cuenta = c;
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}

//- (void)addTextToView:(NSMutableArray *)texts yPos:(int)yP space:(int)space {
//	
//	int y = yP;
//	int x = 15;
//	int w = 290;
//	int h = 20;
//	
//	for (NSString *txt in texts) {
//		
//		UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
//		l.adjustsFontSizeToFitWidth = YES;
//		
//		
//		NSRange aRange = [txt rangeOfString:@"<b>"];
//		if (aRange.location != NSNotFound) {
//			l.font = [UIFont boldSystemFontOfSize:l.font.pointSize];
//			txt=[txt stringByReplacingOccurrencesOfString:@"<b>" withString:@""]; 
//		}
//		l.text = [NSString stringWithFormat:@"%@",txt];
//		l.backgroundColor = [UIColor clearColor];
//		[self.view addSubview:l];
//		[l release];
//		
//		y += h + space;
//	}
//}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (IBAction)ultimosMov {
	if (cuenta) {
		UltimosMovimientos* uMovimientos = [[UltimosMovimientos alloc] initWithCuenta:cuenta];
		[[MenuBanelcoController sharedMenuController] pushScreen:uMovimientos];
	}
}

- (void)accionWithDelegate:(WheelAnimationController *)delegate {
	
	//Cuenta *cuentaSaldo = [Cuenta getSaldo:cuenta withLyD:YES];
	
	Cuenta *cuentaSaldo = nil;
	
	WS_ConsultarLimitesyDisponibles *request = [[WS_ConsultarLimitesyDisponibles alloc] init];
		
	Context *context = [Context sharedContext];
		
	request.userToken = [context getToken];
	request.codigoCuenta = self.cuenta.codigo;
		
	cuentaSaldo = [WSUtil execute:request];
	
	if (cuentaSaldo && ![cuentaSaldo isKindOfClass:[NSError class]]) {
		
		self.cuenta.codigo = cuentaSaldo.codigo; // TODO revisar que esto funcione
		
		//NSMutableArray *text = [[NSMutableArray alloc] init];
//		NSString *nro = [Util aplicarMascara:cuentaSaldo.numero yMascara:[Cuenta getMascara]];
//		NSString *l = [NSString stringWithFormat:@"<b>%@ %@",cuentaSaldo.descripcionLargaTipoCuenta,nro];
//		[text addObject:l];
//		[l release];
//			
//		
//		
//	//	l = [NSString stringWithFormat:@"Nro. %@", nro];
//	//	[text addObject:l];
//	//	[l release];
//		
//		l = [NSString stringWithFormat:@"Saldo %@ %@", cuentaSaldo.simboloMoneda, [Util formatSaldo:cuentaSaldo.saldo]];
//		[text addObject:l];
//		[l release];
//		
//		l = [NSString stringWithFormat:@"Disponible Pagos %@ %@",cuentaSaldo.simboloMoneda, [Util formatSaldo:cuentaSaldo.disponible]];
//		[text addObject:l];
//		[l release];
//		
//		l = [NSString stringWithFormat:@"Límite Pagos %@ %@",cuentaSaldo.simboloMoneda, [Util formatSaldo:cuentaSaldo.limite]];
//		[text addObject:l];
//		[l release];
//		
//		l = [NSString stringWithFormat:@"S.E.U.O."];
//		[text addObject:l];
//		[l release];
//		
//		[self addTextToView:text yPos:20 space:10];
		
		int w = 240;
		int h = 25;
		int y = 20;
		int space = 10;
		
		UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(15, y, 290, h)];
		l.textAlignment = UITextAlignmentLeft;
		l.backgroundColor = [UIColor clearColor];
		if (![Context sharedContext].personalizado) {
            l.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:17];
        }
        else {
            l.font = [UIFont boldSystemFontOfSize:17];
        }
		l.adjustsFontSizeToFitWidth = YES;
		NSString *nro = [Util aplicarMascara:cuentaSaldo.numero yMascara:[Cuenta getMascara]];
		l.text = [NSString stringWithFormat:@"%@   %@",cuentaSaldo.descripcionLargaTipoCuenta,nro];
        l.accessibilityLabel = [l.text stringByReplacingOccurrencesOfString:@"U$S" withString:@"dolares"];
        l.accessibilityLabel = [l.text stringByReplacingOccurrencesOfString:@"$" withString:@"pesos"];
		l.textColor = [context UIColorFromRGBProperty:@"TxtColor"];
		[self.view addSubview:l];
		[l release];
		
		y += h + space + 10;
		
		l = [[UILabel alloc] initWithFrame:CGRectMake(15, y, w, h)];
		l.backgroundColor = [UIColor clearColor];
		if (![Context sharedContext].personalizado) {
            l.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:17];
        }
        else {
            l.font = [UIFont systemFontOfSize:17];
        }
		l.textAlignment = UITextAlignmentLeft;
		l.text = [NSString stringWithFormat:@"Saldo"];
		l.textColor = [context UIColorFromRGBProperty:@"TxtColor"];
		[self.view addSubview:l];
		[l release];
		
		l = [[UILabel alloc] initWithFrame:CGRectMake(150, y, 55, h)];
		l.backgroundColor = [UIColor clearColor];	
		if (![Context sharedContext].personalizado) {
            l.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:17];
        }
        else {
            l.font = [UIFont boldSystemFontOfSize:17];
        }
		l.textAlignment = UITextAlignmentRight;
		l.text = [NSString stringWithFormat:@"%@",cuentaSaldo.simboloMoneda];
        l.accessibilityLabel = [l.text stringByReplacingOccurrencesOfString:@"U$S" withString:@"dolares"];
        l.accessibilityLabel = [l.text stringByReplacingOccurrencesOfString:@"$" withString:@"pesos"];
		l.textColor = [context UIColorFromRGBProperty:@"TxtColor"];
		[self.view addSubview:l];
		[l release];
		
		l = [[UILabel alloc] initWithFrame:CGRectMake(200, y, 100, h)];
		l.backgroundColor = [UIColor clearColor];	
		if (![Context sharedContext].personalizado) {
            l.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:17];
        }
        else {
            l.font = [UIFont boldSystemFontOfSize:17];
        }
		l.textAlignment = UITextAlignmentRight;
		l.text = [NSString stringWithFormat:@"%@",[Util formatSaldo:cuentaSaldo.saldo]];
		l.textColor = [context UIColorFromRGBProperty:@"TxtColor"];
		[self.view addSubview:l];
		[l release];
		
		
		y += h + space;
		
		l = [[UILabel alloc] initWithFrame:CGRectMake(15, y, w, h)];
		l.backgroundColor = [UIColor clearColor];
		if (![Context sharedContext].personalizado) {
            l.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:17];
        }
        else {
            l.font = [UIFont systemFontOfSize:17];
        }
		l.textAlignment = UITextAlignmentLeft;
		l.text = [NSString stringWithFormat:@"Disponible Pagos"];
		l.textColor = [context UIColorFromRGBProperty:@"TxtColor"];
		[self.view addSubview:l];
		[l release];
		
		
		l = [[UILabel alloc] initWithFrame:CGRectMake(150, y, 55, h)];
		l.backgroundColor = [UIColor clearColor];
		if (![Context sharedContext].personalizado) {
            l.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:17];
        }
        else {
            l.font = [UIFont boldSystemFontOfSize:17];
        }
		l.textAlignment = UITextAlignmentRight;
		l.text = [NSString stringWithFormat:@"%@",cuentaSaldo.simboloMoneda];
        l.accessibilityLabel = [l.text stringByReplacingOccurrencesOfString:@"U$S" withString:@"dolares"];
        l.accessibilityLabel = [l.text stringByReplacingOccurrencesOfString:@"$" withString:@"pesos"];
		l.textColor = [context UIColorFromRGBProperty:@"TxtColor"];
		[self.view addSubview:l];
		[l release];
		
		l = [[UILabel alloc] initWithFrame:CGRectMake(200, y, 100, h)];
		l.backgroundColor = [UIColor clearColor];
		if (![Context sharedContext].personalizado) {
            l.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:17];
        }
        else {
            l.font = [UIFont boldSystemFontOfSize:17];
        }
		l.textAlignment = UITextAlignmentRight;
		l.text = [NSString stringWithFormat:@"%@",[Util formatSaldo:cuentaSaldo.disponible]];
		l.textColor = [context UIColorFromRGBProperty:@"TxtColor"];
		[self.view addSubview:l];
		[l release];
		
		y += h + space;
		
		l = [[UILabel alloc] initWithFrame:CGRectMake(15, y, w, h)];
		l.backgroundColor = [UIColor clearColor];
		if (![Context sharedContext].personalizado) {
            l.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:17];
        }
        else {
            l.font = [UIFont systemFontOfSize:17];
        }
		l.textAlignment = UITextAlignmentLeft;
		l.text = [NSString stringWithFormat:@"Límite Pagos"];
		l.textColor = [context UIColorFromRGBProperty:@"TxtColor"];
		[self.view addSubview:l];
		[l release];
		
		
		l = [[UILabel alloc] initWithFrame:CGRectMake(150, y, 55, h)];
		l.backgroundColor = [UIColor clearColor];
		if (![Context sharedContext].personalizado) {
            l.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:17];
        }
        else {
            l.font = [UIFont boldSystemFontOfSize:17];
        }
		l.textAlignment = UITextAlignmentRight;
		l.text = [NSString stringWithFormat:@"%@",cuentaSaldo.simboloMoneda];
        l.accessibilityLabel = [l.text stringByReplacingOccurrencesOfString:@"U$S" withString:@"dolares"];
        l.accessibilityLabel = [l.text stringByReplacingOccurrencesOfString:@"$" withString:@"pesos"];
		l.textColor = [context UIColorFromRGBProperty:@"TxtColor"];
		[self.view addSubview:l];
		[l release];
		
		l = [[UILabel alloc] initWithFrame:CGRectMake(200, y, 100, h)];
		l.backgroundColor = [UIColor clearColor];
		if (![Context sharedContext].personalizado) {
            l.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:17];
        }
        else {
            l.font = [UIFont boldSystemFontOfSize:17];
        }
		l.textAlignment = UITextAlignmentRight;
		l.text = [NSString stringWithFormat:@"%@",[Util formatSaldo:cuentaSaldo.limite]];
		l.textColor = [context UIColorFromRGBProperty:@"TxtColor"];
		[self.view addSubview:l];
		[l release];
		
		y += h + space + 10;
		
		l = [[UILabel alloc] initWithFrame:CGRectMake(15, y, w, h)];
		l.backgroundColor = [UIColor clearColor];
		if (![Context sharedContext].personalizado) {
            l.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:17];
        }
        else {
            l.font = [UIFont systemFontOfSize:17];
        }
		l.textAlignment = UITextAlignmentLeft;
		l.text = [NSString stringWithFormat:@"S.E.U.O."];
		l.textColor = [context UIColorFromRGBProperty:@"TxtColor"];
		[self.view addSubview:l];
		[l release];
		
		
	}
	else {
        
        NSString *errorCode = [[(NSError *)cuentaSaldo userInfo] valueForKey:@"faultCode"];
        if ([errorCode isEqualToString:@"ss"]) {
            return;
        }
        
		NSString *errorDesc = [[(NSError *)cuentaSaldo userInfo] valueForKey:@"description"];
		[CommonUIFunctions showAlert:@"Saldo" withMessage:errorDesc cancelButton:@"Volver" andDelegate:self];
	}

	[delegate accionFinalizada:TRUE];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
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
