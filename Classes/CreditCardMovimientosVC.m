//
//  CreditCardMovimientosVC.m
//  BanelcoMovilIphone
//
//  Created by Ezequiel Aceto on 29/09/10.
//  Copyright 2010 Mobile Computing. All rights reserved.
//

#import "CreditCardMovimientosVC.h"
#import "Context.h"
#import "Context.h"
#import "WSUtil.h"
#import "CommonUIFunctions.h"
#import "CreditCard.h"
#import "CreditCardCompra.h"
#import "MenuBanelcoController.h"
#import "MovimientoView.h"

@implementation CreditCardMovimientosVC
@synthesize numeroTarjeta;
@synthesize movimientosScroll;

- (id) initWithNumeroTarjeta:(NSString *)numero
{
	self = [super init];
	if (self != nil) {
		self.numeroTarjeta = [NSString stringWithFormat:@"%@",numero];
		NSLog(@"%@",self.numeroTarjeta);
	}
	return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Tarjetas de Crédito - Últimos Movimientos";
}


//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex { 
//	switch(buttonIndex) {
//		case 0:
//			[[MenuBanelcoController sharedMenuController] peekScreen];
//			break;
//	}
//}

- (void)accionWithDelegate:(WheelAnimationController *)delegate {
	NSLog(@"accion en CreditCardDisponibleVC");
	id result;
	
	Context *context = [Context sharedContext];	
	
	NSLog(@"%@",self.numeroTarjeta);
	
	result = [CreditCardCompra getUltimasCompras:[context getToken] withNumber:numeroTarjeta];
	
	if ([result isKindOfClass:[NSError class]]) {
		[self accionFinalizada:TRUE]; //??
        
        NSString *errorCode = [[(NSError *)result userInfo] valueForKey:@"faultCode"];
        if ([errorCode isEqualToString:@"ss"]) {
            return;
        }
		
		NSString *errorDesc = [[(NSError *)result userInfo] valueForKey:@"description"];
		//[CommonUIFunctions showAlert:@"Error de cambio de clave" withMessage:errorDesc andCancelButton:@"Volver"];
		[CommonUIFunctions showAlert:@"Consulta Movimientos" withMessage:errorDesc cancelButton:@"Volver" andDelegate:self];
		return;
		
	}	else if ([result isKindOfClass:[NSMutableArray class]]){
		
		UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 320, 30)];
		l.textAlignment = UITextAlignmentCenter;
		l.backgroundColor = [UIColor clearColor];
		if (![Context sharedContext].personalizado) {
            l.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:19];
        }
        else {
            l.font = [UIFont boldSystemFontOfSize:19];
        }
		l.text = [NSString stringWithFormat:@"%@",@"VISA"];
		l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
		[self.view addSubview:l];
		[l release];
        
        //leyenda
        l = [[UILabel alloc] initWithFrame:CGRectMake(5, 40, 150, 30)];
		l.textAlignment = UITextAlignmentLeft;
		l.backgroundColor = [UIColor clearColor];
		if (![Context sharedContext].personalizado) {
            l.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:15];
        }
        else {
            l.font = [UIFont boldSystemFontOfSize:15];
        }
		l.text = [NSString stringWithFormat:@"Nro. de Tarjeta"];
		l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
		[self.view addSubview:l];
		[l release];
        
        //nro
        l = [[UILabel alloc] initWithFrame:CGRectMake(155, 40, 160, 30)];
        l.backgroundColor = [UIColor clearColor];
        if (![Context sharedContext].personalizado) {
            l.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:15];
        }
        else {
            l.font = [UIFont boldSystemFontOfSize:15];
        }
        l.text = [NSString stringWithFormat:@"%@",[Util formatCreditCardNumber:self.numeroTarjeta]];
        l.textAlignment = UITextAlignmentRight;
        l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
        [self.view addSubview:l];
        [l release];
		
//		NSString *str = [NSString stringWithFormat:@"Nro. de Tarjeta %@",[Util formatCreditCardNumber:self.numeroTarjeta]];
//		[CommonUIFunctions addTextToView:self.view boldText:str normalText:nil xPos:5 yPos:50];
		
		result = (NSMutableArray *) result;
		float xmargin = 0;
		for (int i = 0;i<[result count];i++){
			MovimientoView* mView = [[MovimientoView alloc] initWithFrame:CGRectMake(0, xmargin, 320, 45) andCreditCardCompra:[result objectAtIndex:i]];
			[self.movimientosScroll addSubview:mView];
			[mView release];
			xmargin = xmargin+52;
		}
        
        //Texto al final de la lista
        l = [[UILabel alloc] initWithFrame:CGRectMake(5, xmargin, 310, 60)];
        l.textAlignment = UITextAlignmentCenter;
        l.numberOfLines = 2;
        l.backgroundColor = [UIColor clearColor];
        if (![Context sharedContext].personalizado) {
            l.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:15];
        }
        else {
            l.font = [UIFont boldSystemFontOfSize:15];
        }
        l.text = @"Información obtenida de Visa@Home\n(S.E.U.O.)";
        l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
        [self.movimientosScroll addSubview:l];
        [l release];
        xmargin = xmargin+52;

        /////////////
		
		[self accionFinalizada:TRUE];		
		
		[self performSelectorOnMainThread:@selector(setContentSizeMovimiento:) withObject:[NSNumber numberWithFloat:xmargin] waitUntilDone:YES];
		
	}	else {
		NSLog(@"Error: No se recibio un array de tarjetas");
		[self accionFinalizada:FALSE];
		[CommonUIFunctions showAlert:@"Consulta Movimientos" withMessage:@"No hay información sobre tus tarjetas de crédito por el momento." cancelButton:@"Volver" andDelegate:self];
	}
	
}

- (void)setContentSizeMovimiento:(NSNumber *)n {
    [self.movimientosScroll setContentSize:CGSizeMake(self.movimientosScroll.frame.size.width, [n floatValue])];
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
