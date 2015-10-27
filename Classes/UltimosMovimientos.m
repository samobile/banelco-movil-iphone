//
//  UltimosMovimientos.m
//  BanelcoMovilIphone
//
//  Created by Demian on 9/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UltimosMovimientos.h"
#import "MovimientoView.h"
#import "Movimiento.h"
#import "WS_ConsultaResumenCuenta.h"
#import "ConsultaResumenResponse.h"
#import "CommonUIFunctions.h"
#import "WSUtil.h"
@implementation UltimosMovimientos

@synthesize account;
@synthesize descripcionCuenta;
@synthesize tituloConFecha;
@synthesize movimientosScroll;
@synthesize movimientos;


- (id) initWithCuenta:(Cuenta*) cuenta {
	
	if(self = [super init]){
		self.account = cuenta;
		self.title = @"Últimos Movimientos";
	}
	return self;
	
}



- (void)viewDidLoad {
    [super viewDidLoad];
    if (![Context sharedContext].personalizado) {
        descripcionCuenta.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:17];
    }
	descripcionCuenta.text = [NSString stringWithFormat:@"%@  %@", account.descripcionLargaTipoCuenta,[account descripcionParaCBU]];
    descripcionCuenta.accessibilityLabel = [descripcionCuenta.text stringByReplacingOccurrencesOfString:@" U$S " withString:@" dolares "];
    descripcionCuenta.accessibilityLabel = [descripcionCuenta.text stringByReplacingOccurrencesOfString:@" $ " withString:@" pesos "];
	descripcionCuenta.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	
	movimientosScroll.delegate = self;
	
	[self.movimientosScroll setBackgroundColor:nil];
	[movimientosScroll setCanCancelContentTouches:NO];
	
	
	[movimientosScroll setContentSize:CGSizeMake(320, 500)];
	movimientosScroll.indicatorStyle = UIScrollViewIndicatorStyleBlack;
	movimientosScroll.clipsToBounds = YES;
	movimientosScroll.scrollEnabled = YES;
	
	
}

- (void)accionWithDelegate:(WheelAnimationController *)delegate {
	ConsultaResumenResponse* result;
	WS_ConsultaResumenCuenta *request = [[WS_ConsultaResumenCuenta alloc] init];
	Context *context = [Context sharedContext];
	request.userToken = [context getToken];	
	request.cuenta = self.account;	
	
	result = [WSUtil execute:request];
	if ([result isKindOfClass:[NSError class]]) {
		[self accionFinalizada:FALSE]; //??
        
        NSString *errorCode = [[(NSError *)result userInfo] valueForKey:@"faultCode"];
        if ([errorCode isEqualToString:@"ss"]) {
            return;
        }
        
		NSString *errorDesc = [[(NSError *)result userInfo] valueForKey:@"description"];
		//[CommonUIFunctions showAlert:@"Error de cambio de clave" withMessage:errorDesc andCancelButton:@"Volver"];
		[CommonUIFunctions showAlert:@"Últimos Movimientos" withMessage:errorDesc cancelButton:@"Volver" andDelegate:self];
		return;
		
	}	else{
		self.movimientos = result.listaDeMovimientos;
		if (![Context sharedContext].personalizado) {
            tituloConFecha.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:14];
        }
		tituloConFecha.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
		tituloConFecha.text = [NSString stringWithFormat:@"Últimos Movimientos hasta %@", result.fecha];
		float xmargin = 0;
		for (int i = 0;i<[self.movimientos count];i++){
			//NSLog(@"Movimiento = ");
			MovimientoView* mView = [[MovimientoView alloc] initWithFrame:CGRectMake(0, xmargin, 320, 20) andMovimiento:[self.movimientos objectAtIndex:i]];
			[self.movimientosScroll addSubview:mView];
			//[mView release];
			xmargin = xmargin+22;
		}
        

        
		[movimientosScroll setContentSize:CGSizeMake(320, xmargin+30)];
		
		[self accionFinalizada:TRUE];
		
	}
	
}




/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
    [account release];
	[descripcionCuenta release];
	[tituloConFecha release];
	[movimientosScroll release];
	[super dealloc];
}


@end
