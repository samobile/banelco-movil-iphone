//
//  TransferenciasSaldosYDisponibles.m
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 8/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TransferenciasSaldosYDisponibles.h"
#import "Cuenta.h"
#import "SaldosTransfMobileDTO.h"
#import "CommonUIFunctions.h"
#import "Transfer.h"
#import "Util.h"
#import "Context.h"

@implementation TransferenciasSaldosYDisponibles

@synthesize cuenta;

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

- (void)accionWithDelegate:(WheelAnimationController *)delegate {
	
	
	if (self.cuenta) {
		
		SaldosTransfMobileDTO *resp = [Transfer getSaldoTransfer:self.cuenta];
		if (!resp || [resp isKindOfClass:[NSError class]]) {
            
            NSString *errorCode = [[(NSError *)resp userInfo] valueForKey:@"faultCode"];
            if ([errorCode isEqualToString:@"ss"]) {
                return;
            }
            
			NSString *errorDesc = [[(NSError *)resp userInfo] valueForKey:@"description"];
			[CommonUIFunctions showAlert:self.title withMessage:errorDesc cancelButton:@"Aceptar" andDelegate:self];
			[delegate accionFinalizada:TRUE];
			return;
		}
		
		int w = 240;
		int h = 25;
		int y = 20;
		int space = 10;
		Context *context = [Context sharedContext];
		
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
		NSString *nro = [Util aplicarMascara:self.cuenta.numero yMascara:[Cuenta getMascara]];
		l.text = [NSString stringWithFormat:@"%@ %@",self.cuenta.descripcionLargaTipoCuenta,nro];
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
		l.text = [NSString stringWithFormat:@"Saldo:"];
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
		l.text = [NSString stringWithFormat:@"%@",self.cuenta.simboloMoneda];
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
		l.text = [NSString stringWithFormat:@"%@",[Util formatSaldo:resp.saldo]];
        l.accessibilityLabel = [l.text stringByReplacingOccurrencesOfString:@"U$S" withString:@"dolares"];
        l.accessibilityLabel = [l.text stringByReplacingOccurrencesOfString:@"$" withString:@"pesos"];
		l.textColor = [context UIColorFromRGBProperty:@"TxtColor"];
		[self.view addSubview:l];
		[l release];
		
		
		y += h + space;
		
		l = [[UILabel alloc] initWithFrame:CGRectMake(15, y, w-60, h+25+10)];
		l.backgroundColor = [UIColor clearColor];
		if (![Context sharedContext].personalizado) {
            l.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:17];
        }
        else {
            l.font = [UIFont systemFontOfSize:17];
        }
		l.textAlignment = UITextAlignmentLeft;
		l.numberOfLines = 2;
		l.text = [NSString stringWithFormat:@"Disponible transferencias:"];
		l.textColor = [context UIColorFromRGBProperty:@"TxtColor"];
		[self.view addSubview:l];
		[l release];
		
		
		l = [[UILabel alloc] initWithFrame:CGRectMake(150, y + 20, 55, h)];
		l.backgroundColor = [UIColor clearColor];
		if (![Context sharedContext].personalizado) {
            l.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:17];
        }
        else {
            l.font = [UIFont boldSystemFontOfSize:17];
        }
		l.textAlignment = UITextAlignmentRight;
		l.text = [NSString stringWithFormat:@"%@",self.cuenta.simboloMoneda];
        l.accessibilityLabel = [l.text stringByReplacingOccurrencesOfString:@"U$S" withString:@"dolares"];
        l.accessibilityLabel = [l.text stringByReplacingOccurrencesOfString:@"$" withString:@"pesos"];
		l.textColor = [context UIColorFromRGBProperty:@"TxtColor"];
		[self.view addSubview:l];
		[l release];
		
		l = [[UILabel alloc] initWithFrame:CGRectMake(200, y + 20, 100, h)];
		l.backgroundColor = [UIColor clearColor];
		if (![Context sharedContext].personalizado) {
            l.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:17];
        }
        else {
            l.font = [UIFont boldSystemFontOfSize:17];
        }
		l.textAlignment = UITextAlignmentRight;
		l.text = [NSString stringWithFormat:@"%@",[Util formatSaldo:resp.disponible]];
        l.accessibilityLabel = [l.text stringByReplacingOccurrencesOfString:@"U$S" withString:@"dolares"];
        l.accessibilityLabel = [l.text stringByReplacingOccurrencesOfString:@"$" withString:@"pesos"];
		l.textColor = [context UIColorFromRGBProperty:@"TxtColor"];
		[self.view addSubview:l];
		[l release];
		
		y += h+50 + space + 10;
		
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
	
	[delegate accionFinalizada:TRUE];
	
	
	
	
	//Cuenta *cuentaSaldo = nil;
//	
//	WS_ConsultarLimitesyDisponibles *request = [[WS_ConsultarLimitesyDisponibles alloc] init];
//	
//	Context *context = [Context sharedContext];
//	
//	request.userToken = [context getToken];
//	request.codigoCuenta = self.cuenta.codigo;
//	
//	cuentaSaldo = [WSUtil execute:request];
//	
//	if (cuentaSaldo && ![cuentaSaldo isKindOfClass:[NSError class]]) {
//		
//		self.cuenta.codigo = cuentaSaldo.codigo; // TODO revisar que esto funcione
//		
//		int w = 240;
//		int h = 25;
//		int y = 20;
//		int space = 10;
//		
//		UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(15, y, 290, h)];
//		l.textAlignment = UITextAlignmentLeft;
//		l.backgroundColor = [UIColor clearColor];
//		l.font = [UIFont boldSystemFontOfSize:17];
//		l.adjustsFontSizeToFitWidth = YES;
//		NSString *nro = [Util aplicarMascara:cuentaSaldo.numero yMascara:[Cuenta getMascara]];
//		l.text = [NSString stringWithFormat:@"%@ %@",cuentaSaldo.descripcionLargaTipoCuenta,nro];
//		l.textColor = [context UIColorFromRGBProperty:@"TxtColor"];
//		[self.view addSubview:l];
//		[l release];
//		
//		y += h + space + 10;
//		
//		l = [[UILabel alloc] initWithFrame:CGRectMake(15, y, w, h)];
//		l.backgroundColor = [UIColor clearColor];
//		l.font = [UIFont systemFontOfSize:17];
//		l.textAlignment = UITextAlignmentLeft;
//		l.text = [NSString stringWithFormat:@"Saldo"];
//		l.textColor = [context UIColorFromRGBProperty:@"TxtColor"];
//		[self.view addSubview:l];
//		[l release];
//		
//		l = [[UILabel alloc] initWithFrame:CGRectMake(150, y, 55, h)];
//		l.backgroundColor = [UIColor clearColor];	
//		l.font = [UIFont boldSystemFontOfSize:17];
//		l.textAlignment = UITextAlignmentRight;
//		l.text = [NSString stringWithFormat:@"%@",cuentaSaldo.simboloMoneda];
//		l.textColor = [context UIColorFromRGBProperty:@"TxtColor"];
//		[self.view addSubview:l];
//		[l release];
//		
//		l = [[UILabel alloc] initWithFrame:CGRectMake(200, y, 100, h)];
//		l.backgroundColor = [UIColor clearColor];	
//		l.font = [UIFont boldSystemFontOfSize:17];
//		l.textAlignment = UITextAlignmentRight;
//		l.text = [NSString stringWithFormat:@"%@",[Util formatSaldo:cuentaSaldo.saldo]];
//		l.textColor = [context UIColorFromRGBProperty:@"TxtColor"];
//		[self.view addSubview:l];
//		[l release];
//		
//		
//		y += h + space;
//		
//		l = [[UILabel alloc] initWithFrame:CGRectMake(15, y, w, h)];
//		l.backgroundColor = [UIColor clearColor];
//		l.font = [UIFont systemFontOfSize:17];
//		l.textAlignment = UITextAlignmentLeft;
//		l.text = [NSString stringWithFormat:@"Disponible Pagos"];
//		l.textColor = [context UIColorFromRGBProperty:@"TxtColor"];
//		[self.view addSubview:l];
//		[l release];
//		
//		
//		l = [[UILabel alloc] initWithFrame:CGRectMake(150, y, 55, h)];
//		l.backgroundColor = [UIColor clearColor];
//		l.font = [UIFont boldSystemFontOfSize:17];
//		l.textAlignment = UITextAlignmentRight;
//		l.text = [NSString stringWithFormat:@"%@",cuentaSaldo.simboloMoneda];
//		l.textColor = [context UIColorFromRGBProperty:@"TxtColor"];
//		[self.view addSubview:l];
//		[l release];
//		
//		l = [[UILabel alloc] initWithFrame:CGRectMake(200, y, 100, h)];
//		l.backgroundColor = [UIColor clearColor];
//		l.font = [UIFont boldSystemFontOfSize:17];
//		l.textAlignment = UITextAlignmentRight;
//		l.text = [NSString stringWithFormat:@"%@",[Util formatSaldo:cuentaSaldo.disponible]];
//		l.textColor = [context UIColorFromRGBProperty:@"TxtColor"];
//		[self.view addSubview:l];
//		[l release];
//		
//		y += h + space;
//		
//		l = [[UILabel alloc] initWithFrame:CGRectMake(15, y, w, h)];
//		l.backgroundColor = [UIColor clearColor];
//		l.font = [UIFont systemFontOfSize:17];
//		l.textAlignment = UITextAlignmentLeft;
//		l.text = [NSString stringWithFormat:@"Límite Pagos"];
//		l.textColor = [context UIColorFromRGBProperty:@"TxtColor"];
//		[self.view addSubview:l];
//		[l release];
//		
//		
//		l = [[UILabel alloc] initWithFrame:CGRectMake(150, y, 55, h)];
//		l.backgroundColor = [UIColor clearColor];
//		l.font = [UIFont boldSystemFontOfSize:17];
//		l.textAlignment = UITextAlignmentRight;
//		l.text = [NSString stringWithFormat:@"%@",cuentaSaldo.simboloMoneda];
//		l.textColor = [context UIColorFromRGBProperty:@"TxtColor"];
//		[self.view addSubview:l];
//		[l release];
//		
//		l = [[UILabel alloc] initWithFrame:CGRectMake(200, y, 100, h)];
//		l.backgroundColor = [UIColor clearColor];
//		l.font = [UIFont boldSystemFontOfSize:17];
//		l.textAlignment = UITextAlignmentRight;
//		l.text = [NSString stringWithFormat:@"%@",[Util formatSaldo:cuentaSaldo.limite]];
//		l.textColor = [context UIColorFromRGBProperty:@"TxtColor"];
//		[self.view addSubview:l];
//		[l release];
//		
//		y += h + space + 10;
//		
//		l = [[UILabel alloc] initWithFrame:CGRectMake(15, y, w, h)];
//		l.backgroundColor = [UIColor clearColor];
//		l.font = [UIFont systemFontOfSize:17];
//		l.textAlignment = UITextAlignmentLeft;
//		l.text = [NSString stringWithFormat:@"S.E.U.O."];
//		l.textColor = [context UIColorFromRGBProperty:@"TxtColor"];
//		[self.view addSubview:l];
//		[l release];
//		
//		
//	}
//	else {
//		NSString *errorDesc = [[(NSError *)cuentaSaldo userInfo] valueForKey:@"description"];
//		[CommonUIFunctions showAlert:@"Saldo" withMessage:errorDesc cancelButton:@"Volver" andDelegate:self];
//	}
//	
//	[delegate accionFinalizada:TRUE];
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
