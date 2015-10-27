//
//  CreditCardResumenVC.m
//  BanelcoMovilIphone
//
//  Created by Ezequiel Aceto on 29/09/10.
//  Copyright 2010 Mobile Computing. All rights reserved.
//

#import "CreditCardResumenVC.h"
#import "CommonUIFunctions.h"
#import "Context.h"
#import "CreditCardResumen.h"
#import "MenuBanelcoController.h"
#import "MenuOptionsHelper.h"
#import "Util.h"

@implementation CreditCardResumenVC

@synthesize numeroTarjeta, tarjeta;

- (id) initWithNumeroTarjeta:(CreditCard *)tarjetaCred
{
	self = [super init];
	if (self != nil) {
		self.numeroTarjeta = [NSString stringWithFormat:@"%@",tarjetaCred.numero];
		NSLog(@"%@",self.numeroTarjeta);
        self.tarjeta = tarjetaCred;
	}
	return self;
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
	
	result = [CreditCardResumen getResumenWithNumber:numeroTarjeta];
    
  
	
	if ([result isKindOfClass:[NSError class]]) {
		[self accionFinalizada:TRUE]; //??
        
        NSString *errorCode = [[(NSError *)result userInfo] valueForKey:@"faultCode"];
        if ([errorCode isEqualToString:@"ss"]) {
            return;
        }
		
		NSString *errorDesc = [[(NSError *)result userInfo] valueForKey:@"description"];
		//[CommonUIFunctions showAlert:@"Error de cambio de clave" withMessage:errorDesc andCancelButton:@"Volver"];
		[CommonUIFunctions showAlert:@"Último Resumen" withMessage:errorDesc cancelButton:@"Volver" andDelegate:self];
		return;
		
	}	else if ([result isKindOfClass:[CreditCardResumen class]]){
		[self accionFinalizada:TRUE];		
		
		[self agregarDescripcion:result];
		
	}	else {
		NSLog(@"Error: No se recibio un array de tarjetas");
		[self accionFinalizada:TRUE];
		[CommonUIFunctions showAlert:@"Último Resumen" withMessage:@"No hay información sobre tus tarjetas de crédito por el momento." cancelButton:@"Volver" andDelegate:self];
	}
	
}

- (void)agregarDescripcion:(CreditCardResumen *)resumen {
	
	int y = 15;
	int x = 20;
	int space = 15;
	NSString *str;
	int w = 240;
	int h = 25;


    
    UIScrollView *scrV = [[UIScrollView alloc]initWithFrame:self.view.frame];
    scrV.showsVerticalScrollIndicator=YES;
    scrV.scrollEnabled=YES;
    scrV.userInteractionEnabled=YES;
   
    [self.view addSubview:scrV];
    
	UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, y, 320, h)];
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
	[scrV addSubview:l];
	[l release];
	
	y += h + 10;
	
	l = [[UILabel alloc] initWithFrame:CGRectMake(20, y, w, h)];
	l.backgroundColor = [UIColor clearColor];
	if (![Context sharedContext].personalizado) {
        l.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:15];
    }
    else {
        l.font = [UIFont boldSystemFontOfSize:15];
    }
	l.text = @"Nro. de Tarjeta ";
	l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	[scrV addSubview:l];
	[l release];
	
	l = [[UILabel alloc] initWithFrame:CGRectMake(200, y, 100, h)];
	l.backgroundColor = [UIColor clearColor];
	if (![Context sharedContext].personalizado) {
        l.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:15];
    }
    else {
        l.font = [UIFont boldSystemFontOfSize:15];
    }
	l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	l.text = [NSString stringWithFormat:@"%@",[Util formatCreditCardNumber:resumen.nroTarjeta]];
    l.textAlignment = UITextAlignmentRight;
	[scrV addSubview:l];
	[l release];
	
	y += h + 10;
	
	l = [[UILabel alloc] initWithFrame:CGRectMake(20, y, w, h)];
	l.backgroundColor = [UIColor clearColor];
	if (![Context sharedContext].personalizado) {
        l.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:15];
    }
    else {
        l.font = [UIFont boldSystemFontOfSize:15];
    }
	l.textAlignment = UITextAlignmentLeft;
	l.text = @"Vencimiento";
	l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	[scrV addSubview:l];
	[l release];
	
	l = [[UILabel alloc] initWithFrame:CGRectMake(180, y, 120, h)];
	l.backgroundColor = [UIColor clearColor];
	if (![Context sharedContext].personalizado) {
        l.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:15];
    }
    else {
        l.font = [UIFont boldSystemFontOfSize:15];
    }
	l.textAlignment = UITextAlignmentRight;
	l.text = [NSString stringWithFormat:@"%@",resumen.fechaVencimiento];
	l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	[scrV addSubview:l];
	[l release];
	
	
	y += h + 10;
    
    if([[MenuOptionsHelper sharedMenuHelper ] mostrarDatosAdicionales])
    {
    //////////////////CierreActual
    l = [[UILabel alloc] initWithFrame:CGRectMake(20, y, w, h)];
    l.backgroundColor = [UIColor clearColor];
    if (![Context sharedContext].personalizado) {
        l.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:15];
    }
    else {
        l.font = [UIFont boldSystemFontOfSize:15];
    }
    l.text = @"Cierre actual";
    l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
    [scrV addSubview:l];
    [l release];
    
    l = [[UILabel alloc] initWithFrame:CGRectMake(180, y, 120, h)];
    l.backgroundColor = [UIColor clearColor];
    if (![Context sharedContext].personalizado) {
        l.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:15];
    }
    else {
        l.font = [UIFont boldSystemFontOfSize:15];
    }
    l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
    l.text = tarjeta.fechaCierreActual;
    l.textAlignment = UITextAlignmentRight;
    [scrV addSubview:l];
    [l release];
    
    y += h + 10;
    //////////////////////////////////
    }
	
	l = [[UILabel alloc] initWithFrame:CGRectMake(20, y, w, h)];
	l.backgroundColor = [UIColor clearColor];
	if (![Context sharedContext].personalizado) {
        l.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:15];
    }
    else {
        l.font = [UIFont systemFontOfSize:15];
    }
	l.textAlignment = UITextAlignmentLeft;
	l.text = @"Total a pagar";
	l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	[scrV addSubview:l];
    [l release];
	
//	l = [[UILabel alloc] initWithFrame:CGRectMake(160, y, 45, h)];
//	l.backgroundColor = [UIColor clearColor];
//	if (![Context sharedContext].personalizado) {
//        l.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:17];
//    }
//    else {
//        l.font = [UIFont systemFontOfSize:17];
//    }
//	l.textAlignment = UITextAlignmentRight;
//	l.text = [NSString stringWithFormat:@"$"];
//	l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
//	[scrV addSubview:l];
//    [l release];
	
	l = [[UILabel alloc] initWithFrame:CGRectMake(200, y, 100, h)];
	l.backgroundColor = [UIColor clearColor];
	if (![Context sharedContext].personalizado) {
        l.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:15];
    }
    else {
        l.font = [UIFont boldSystemFontOfSize:15];
    }
	l.textAlignment = UITextAlignmentRight;
	//No se formatea Saldo para importes que vienen de Tarjetas, por diferencias con formato utilizado por Banelco
	//l.text = [NSString stringWithFormat:@"%@",[Util formatSaldo:resumen.totalAPagarPesos]];
	l.text = [NSString stringWithFormat:@"$ %@",resumen.totalAPagarPesos];
    l.accessibilityLabel = [l.text stringByReplacingOccurrencesOfString:@"$" withString:@"pesos"];
	l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	[scrV addSubview:l];
    [l release];
	
	y += h + space;
	
//	l = [[UILabel alloc] initWithFrame:CGRectMake(160, y, 45, h)];
//	l.backgroundColor = [UIColor clearColor];
//	if (![Context sharedContext].personalizado) {
//        l.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:17];
//    }
//    else {
//        l.font = [UIFont boldSystemFontOfSize:17];
//    }
//	l.textAlignment = UITextAlignmentRight;
//	l.text = [NSString stringWithFormat:@"U$S"];
//	l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
//	[scrV addSubview:l];
//	[l release];
	
	l = [[UILabel alloc] initWithFrame:CGRectMake(200, y, 100, h)];
	l.backgroundColor = [UIColor clearColor];
	if (![Context sharedContext].personalizado) {
        l.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:15];
    }
    else {
        l.font = [UIFont boldSystemFontOfSize:15];
    }
	l.textAlignment = UITextAlignmentRight;
	//No se formatea Saldo para importes que vienen de Tarjetas, por diferencias con formato utilizado por Banelco
	//l.text = [NSString stringWithFormat:@"%@",[Util formatSaldo:resumen.totalAPagarDolares]];
	l.text = [NSString stringWithFormat:@"U$S %@",resumen.totalAPagarDolares];
    l.accessibilityLabel = [l.text stringByReplacingOccurrencesOfString:@"U$S" withString:@"dolares"];
	l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	[scrV addSubview:l];
	[l release];
	
	y += h + space;
	
	l = [[UILabel alloc] initWithFrame:CGRectMake(20, y, w, h)];
	l.backgroundColor = [UIColor clearColor];	
	if (![Context sharedContext].personalizado) {
        l.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:15];
    }
    else {
        l.font = [UIFont systemFontOfSize:15];
    }
	l.textAlignment = UITextAlignmentLeft;
	l.text = @"Mínimo a pagar";
	l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	[scrV addSubview:l];
	[l release];
	
	
//	l = [[UILabel alloc] initWithFrame:CGRectMake(160, y, 45, h)];
//	l.backgroundColor = [UIColor clearColor];
//	if (![Context sharedContext].personalizado) {
//        l.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:17];
//    }
//    else {
//        l.font = [UIFont boldSystemFontOfSize:17];
//    }
//	l.textAlignment = UITextAlignmentRight;
//	l.text = [NSString stringWithFormat:@"$"];
//	l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
//	[scrV addSubview:l];
//	[l release];
	
	l = [[UILabel alloc] initWithFrame:CGRectMake(200, y, 100, h)];
	l.backgroundColor = [UIColor clearColor];
	if (![Context sharedContext].personalizado) {
        l.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:15];
    }
    else {
        l.font = [UIFont boldSystemFontOfSize:15];
    }
	l.textAlignment = UITextAlignmentRight;
	//No se formatea Saldo para importes que vienen de Tarjetas, por diferencias con formato utilizado por Banelco
	//l.text = [NSString stringWithFormat:@"%@",[Util formatSaldo:resumen.minAPagarPesos]];
	l.text = [NSString stringWithFormat:@"$ %@",resumen.minAPagarPesos];
    l.accessibilityLabel = [l.text stringByReplacingOccurrencesOfString:@"$" withString:@"pesos"];
	l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	[scrV addSubview:l];
	[l release];
	
	
	y += h + space;
	
//	l = [[UILabel alloc] initWithFrame:CGRectMake(160, y, 45, h)];
//	l.backgroundColor = [UIColor clearColor];
//	if (![Context sharedContext].personalizado) {
//        l.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:17];
//    }
//    else {
//        l.font = [UIFont boldSystemFontOfSize:17];
//    }
//	l.textAlignment = UITextAlignmentRight;
//	l.text = [NSString stringWithFormat:@"U$S"];
//	l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
//	[scrV addSubview:l];
//	[l release];
	
	l = [[UILabel alloc] initWithFrame:CGRectMake(200, y, 100, h)];
	l.backgroundColor = [UIColor clearColor];
	if (![Context sharedContext].personalizado) {
        l.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:15];
    }
    else {
        l.font = [UIFont boldSystemFontOfSize:15];
    }
	l.textAlignment = UITextAlignmentRight;
	//No se formatea Saldo para importes que vienen de Tarjetas, por diferencias con formato utilizado por Banelco
	//l.text = [NSString stringWithFormat:@"%@",[Util formatSaldo:resumen.minAPagarDolares]];
	l.text = [NSString stringWithFormat:@"U$S %@",resumen.minAPagarDolares];
    l.accessibilityLabel = [l.text stringByReplacingOccurrencesOfString:@"U$S" withString:@"dolares"];
	l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	[scrV addSubview:l];
	[l release];
    
    y += h + 10;
    
    if([[MenuOptionsHelper sharedMenuHelper ] mostrarDatosAdicionales])
    {
        ////Linea de arriba
        
        UIView *linea = [[UIView alloc] initWithFrame:CGRectMake(x, y, 280, 1)];
        linea.backgroundColor = [UIColor blackColor];
        [scrV addSubview:linea];
        
        //////////////////Fecha Proximo Cierre
        l = [[UILabel alloc] initWithFrame:CGRectMake(20, y, w, h)];
        l.backgroundColor = [UIColor clearColor];
        if (![Context sharedContext].personalizado) {
            l.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:15];
        }
        else {
            l.font = [UIFont boldSystemFontOfSize:15];
        }
        l.text = @"Próximo cierre";
        l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
        [scrV addSubview:l];
        [l release];
        
        l = [[UILabel alloc] initWithFrame:CGRectMake(180, y, 120, h)];
        l.backgroundColor = [UIColor clearColor];
        if (![Context sharedContext].personalizado) {
            l.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:15];
        }
        else {
            l.font = [UIFont boldSystemFontOfSize:15];
        }
        l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
        l.text = tarjeta.fechaProxCierre;
        l.textAlignment = UITextAlignmentRight;
        [scrV addSubview:l];
        [l release];
        
        y += h + 10;
        //////////////////////////////////
        
        //////////////////Fecha Proximo Vencimiento
        l = [[UILabel alloc] initWithFrame:CGRectMake(20, y, 180, h)];
        l.backgroundColor = [UIColor clearColor];
        if (![Context sharedContext].personalizado) {
            l.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:15];
        }
        else {
            l.font = [UIFont boldSystemFontOfSize:15];
        }
        l.text = @"Próximo vencimiento";
        l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
        [scrV addSubview:l];
        [l release];
        
        l = [[UILabel alloc] initWithFrame:CGRectMake(180, y, 120, h)];
        l.backgroundColor = [UIColor clearColor];
        if (![Context sharedContext].personalizado) {
            l.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:15];
        }
        else {
            l.font = [UIFont boldSystemFontOfSize:15];
        }
        l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
        l.text = tarjeta.fechaProxVenc;
        l.textAlignment = UITextAlignmentRight;
        [scrV addSubview:l];
        [l release];
        y += h + 10;
        
        linea = [[UIView alloc] initWithFrame:CGRectMake(x, y, 280, 1)];
        linea.backgroundColor = [UIColor blackColor];
        [scrV addSubview:linea];
        
        y += h + 10;
        //////////////////////////////////
         scrV.contentSize = CGSizeMake(self.view.frame.size.width, y);
    }
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"Tarjetas de Crédito - Último Resumen";	
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
