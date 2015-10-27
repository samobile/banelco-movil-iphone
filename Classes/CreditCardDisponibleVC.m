#import "CreditCardDisponibleVC.h"
#import "Context.h"
#import "Context.h"
#import "WSUtil.h"
#import "CommonUIFunctions.h"
#import "CreditCard.h"
#import "CreditCardDisponibles.h"
#import "MenuBanelcoController.h"
#import "MenuOptionsHelper.h"
#import "Util.h"

@implementation CreditCardDisponibleVC

@synthesize numeroTarjeta, tarjeta;
//@synthesize info;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (id) initWithNumeroTarjeta:(CreditCard *)tarjetaCred
{
	self = [super init];
	if (self != nil) {
		//self.numeroTarjeta = [NSString stringWithFormat:@"Nro. %@",numero];
		self.numeroTarjeta = [NSString stringWithFormat:@"%@",tarjetaCred.numero];
		NSLog(@"%@",self.numeroTarjeta);
        self.tarjeta = tarjetaCred;
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Tarjetas de Crédito - Disponible";
	//info.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
}

- (void) updateDisponible:(id) text {
	
//	UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 320, 25)];
//	l.textAlignment = UITextAlignmentCenter;
//	l.backgroundColor = [UIColor clearColor];
//	l.font = [UIFont boldSystemFontOfSize:19];
//	l.text = [NSString stringWithFormat:@"%@",@"VISA"];
//	l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
//	[self.view addSubview:l];
//	[l release];
//	
//	info.text = text;
}


- (void)accionWithDelegate:(WheelAnimationController *)delegate {
	NSLog(@"accion en CreditCardDisponibleVC");
	
    id result;
		
	Context *context = [Context sharedContext];
	
	NSLog(@"%@",self.numeroTarjeta);
	
	result = [CreditCard getDisponibles:[context getToken] withNumber:self.numeroTarjeta];

	if ([result isKindOfClass:[NSError class]]) {
		[self accionFinalizada:FALSE]; //??
        
        NSString *errorCode = [[(NSError *)result userInfo] valueForKey:@"faultCode"];
        if ([errorCode isEqualToString:@"ss"]) {
            return;
        }
		
		NSString *errorDesc = [[(NSError *)result userInfo] valueForKey:@"description"];
		//[CommonUIFunctions showAlert:@"Error de cambio de clave" withMessage:errorDesc andCancelButton:@"Volver"];
		[CommonUIFunctions showAlert:@"Consulta Disponible" withMessage:errorDesc cancelButton:@"Volver" andDelegate:self];
		return;
		
	}	
	else if ([result isKindOfClass:[CreditCardDisponibles class]]) {
		
		[self accionFinalizada:TRUE]; //??
		
		CreditCardDisponibles *dispo = (CreditCardDisponibles*) result;
		
//		NSMutableDictionary *disponibles = dispo.disponibles;
//
//		NSMutableString *theInfo = [[NSMutableString alloc] init];
//
//		[theInfo appendFormat:@"Tarjeta %@\n",[Util formatCreditCardNumber:numeroTarjeta]];
//		
//		for (NSString* key in [disponibles allKeys]) {
//			NSString* desc = [disponibles valueForKey:key];
//			
//			[theInfo appendFormat:@"%@ %@\n\n",key,desc];
//		}
		
		[self performSelectorOnMainThread:@selector(agregarDescripcion:) withObject:dispo waitUntilDone:YES];
	
	}
	else {
		[self accionFinalizada:FALSE]; //??		
	}
}

- (void)agregarDescripcion:(CreditCardDisponibles *)resumen {
	
	int y = 15;
	int x = 20;
	int space = 15;
	NSString *str;
	int w = 240;
	int h = 25;
	
	NSMutableDictionary *disponibles = resumen.disponibles;
	NSArray *keys = [disponibles allKeys];
	
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
	[self.view addSubview:l];
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
	[self.view addSubview:l];
	[l release];
	
	l = [[UILabel alloc] initWithFrame:CGRectMake(175, y, 125, h)];
	l.backgroundColor = [UIColor clearColor];
	if (![Context sharedContext].personalizado) {
        l.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:15];
    }
    else {
        l.font = [UIFont boldSystemFontOfSize:15];
    }
	l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	l.text = [NSString stringWithFormat:@"%@",[Util formatCreditCardNumber:numeroTarjeta]];
    l.textAlignment = UITextAlignmentRight;
	[self.view addSubview:l];
	[l release];
	
	y += h + 10;
    
   /* ///////////////////////////////// Vencimiento
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
    [self.view addSubview:l];
    [l release];
    
    l = [[UILabel alloc] initWithFrame:CGRectMake(175, y, 125, h)];
    l.backgroundColor = [UIColor clearColor];
    if (![Context sharedContext].personalizado) {
        l.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:15];
    }
    else {
        l.font = [UIFont boldSystemFontOfSize:15];
    }
    l.textAlignment = UITextAlignmentRight;
    l.text = [NSString stringWithFormat:@"%@", tarjeta.fechaVencimiento];
    l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
    [self.view addSubview:l];
    [l release];
    
    y += h + 10;
    ////////////////////////////////////////////////////
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
        [self.view addSubview:l];
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
        [self.view addSubview:l];
        [l release];
        
        y += h + 10;

        //////////////////////////////////
    }
    */
	
	@try {
		
		//for (NSString *key in keys) {
        NSArray *disp = [disponibles allKeys];
        for (int i = (int)[disp count] - 1; i >= 0; i--) {
            NSString *key = [disp objectAtIndex:i];
		
			l = [[UILabel alloc] initWithFrame:CGRectMake(20, y, w, h)];
			l.backgroundColor = [UIColor clearColor];
			if (![Context sharedContext].personalizado) {
                l.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:15];
            }
            else {
                l.font = [UIFont systemFontOfSize:15];
            }
			l.textAlignment = UITextAlignmentLeft;
			l.text = key;
            l.accessibilityLabel = [l.text stringByReplacingOccurrencesOfString:@"U$S" withString:@"dolares"];
            l.accessibilityLabel = [l.text stringByReplacingOccurrencesOfString:@"$" withString:@"pesos"];
			l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
			[self.view addSubview:l];
			[l release];
		
			l = [[UILabel alloc] initWithFrame:CGRectMake(175, y, 125, h)];
			l.backgroundColor = [UIColor clearColor];
			if (![Context sharedContext].personalizado) {
                l.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:15];
            }
            else {
                l.font = [UIFont boldSystemFontOfSize:15];
            }
			l.textAlignment = UITextAlignmentRight;
			l.text = [NSString stringWithFormat:@"$ %@", [disponibles valueForKey:key]];
            l.accessibilityLabel = [l.text stringByReplacingOccurrencesOfString:@"U$S" withString:@"dolares"];
            l.accessibilityLabel = [l.text stringByReplacingOccurrencesOfString:@"$" withString:@"pesos"];
			l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
			[self.view addSubview:l];
			[l release];
		
			y += h  + 10;
		}
       /* if([[MenuOptionsHelper sharedMenuHelper] mostrarDatosAdicionales])
        {
        ///////////////////////////////// Próximo cierre
        l = [[UILabel alloc] initWithFrame:CGRectMake(20, y, w, h)];
        l.backgroundColor = [UIColor clearColor];
        if (![Context sharedContext].personalizado) {
            l.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:15];
        }
        else {
            l.font = [UIFont boldSystemFontOfSize:15];
        }
        l.textAlignment = UITextAlignmentLeft;
        l.text = @"Próximo cierre";
        l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
        [self.view addSubview:l];
        [l release];
        
        l = [[UILabel alloc] initWithFrame:CGRectMake(175, y, 125, h)];
        l.backgroundColor = [UIColor clearColor];
        if (![Context sharedContext].personalizado) {
            l.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:15];
        }
        else {
            l.font = [UIFont boldSystemFontOfSize:15];
        }
        l.textAlignment = UITextAlignmentRight;
        l.text = [NSString stringWithFormat:@"%@", tarjeta.fechaProxCierre];
        l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
        [self.view addSubview:l];
        [l release];
        
        y += h  + 10;
////////////////////////////////////////////////////
        //////////////////////////////// Proximo vencimiento
        l = [[UILabel alloc] initWithFrame:CGRectMake(20, y, w, h)];
        l.backgroundColor = [UIColor clearColor];
        if (![Context sharedContext].personalizado) {
            l.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:15];
        }
        else {
            l.font = [UIFont boldSystemFontOfSize:15];
        }
        l.textAlignment = UITextAlignmentLeft;
        l.text = @"Próximo vencimiento";
        l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
        [self.view addSubview:l];
        [l release];
        
        l = [[UILabel alloc] initWithFrame:CGRectMake(175, y, 125, h)];
        l.backgroundColor = [UIColor clearColor];
        if (![Context sharedContext].personalizado) {
            l.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:15];
        }
        else {
            l.font = [UIFont boldSystemFontOfSize:15];
        }
        l.textAlignment = UITextAlignmentRight;
        l.text = [NSString stringWithFormat:@"%@", tarjeta.fechaProxVenc];
        l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
        [self.view addSubview:l];
        [l release];
        
        y += h  + 10;
//////////////////////////////////////////
        }
        */
            y += h  + 10;
        if (!IS_IPHONE_5) {
            [(UIScrollView *)self.view setContentSize:CGSizeMake(self.view.bounds.size.width, y + 10)];
        }
	}
	@catch (NSException * e) {
		
	}
	@finally {
		
	}
	
	
	
//	l = [[UILabel alloc] initWithFrame:CGRectMake(20, y, w, h)];
//	l.backgroundColor = [UIColor clearColor];
//	l.font = [UIFont boldSystemFontOfSize:17];
//	l.textAlignment = UITextAlignmentLeft;
//	l.text = @"Vencimiento";
//	l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
//	[self.view addSubview:l];
//	[l release];
//	
//	l = [[UILabel alloc] initWithFrame:CGRectMake(175, y, 100, h)];
//	l.backgroundColor = [UIColor clearColor];
//	l.font = [UIFont boldSystemFontOfSize:17];
//	l.textAlignment = UITextAlignmentLeft;
//	l.text = [NSString stringWithFormat:@"%@",resumen.fechaVencimiento];
//	l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
//	[self.view addSubview:l];
//	[l release];
//	
//	
//	y += h + space + 10;
//	
//	l = [[UILabel alloc] initWithFrame:CGRectMake(20, y, w, h)];
//	l.backgroundColor = [UIColor clearColor];
//	l.font = [UIFont systemFontOfSize:17];
//	l.textAlignment = UITextAlignmentLeft;
//	l.text = @"Total a pagar";
//	l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
//	[self.view addSubview:l];
//    [l release];
//	
//	l = [[UILabel alloc] initWithFrame:CGRectMake(160, y, 45, h)];
//	l.backgroundColor = [UIColor clearColor];
//	l.font = [UIFont boldSystemFontOfSize:17];
//	l.textAlignment = UITextAlignmentRight;
//	l.text = [NSString stringWithFormat:@"$"];
//	l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
//	[self.view addSubview:l];
//    [l release];
//	
//	l = [[UILabel alloc] initWithFrame:CGRectMake(200, y, 100, h)];
//	l.backgroundColor = [UIColor clearColor];
//	l.font = [UIFont boldSystemFontOfSize:17];
//	l.textAlignment = UITextAlignmentRight;
//	//No se formatea Saldo para importes que vienen de Tarjetas, por diferencias con formato utilizado por Banelco
//	//l.text = [NSString stringWithFormat:@"%@",[Util formatSaldo:resumen.totalAPagarPesos]];
//	l.text = [NSString stringWithFormat:@"%@",resumen.totalAPagarPesos];
//	l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
//	[self.view addSubview:l];
//    [l release];
//	
//	y += h + space;
//	
//	l = [[UILabel alloc] initWithFrame:CGRectMake(160, y, 45, h)];
//	l.backgroundColor = [UIColor clearColor];
//	l.font = [UIFont boldSystemFontOfSize:17];
//	l.textAlignment = UITextAlignmentRight;
//	l.text = [NSString stringWithFormat:@"U$S"];
//	l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
//	[self.view addSubview:l];
//	[l release];
//	
//	l = [[UILabel alloc] initWithFrame:CGRectMake(200, y, 100, h)];
//	l.backgroundColor = [UIColor clearColor];
//	l.font = [UIFont boldSystemFontOfSize:17];
//	l.textAlignment = UITextAlignmentRight;
//	//No se formatea Saldo para importes que vienen de Tarjetas, por diferencias con formato utilizado por Banelco
//	//l.text = [NSString stringWithFormat:@"%@",[Util formatSaldo:resumen.totalAPagarDolares]];
//	l.text = [NSString stringWithFormat:@"%@",resumen.totalAPagarDolares];
//	l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
//	[self.view addSubview:l];
//	[l release];
//	
//	y += h + space;
//	
//	l = [[UILabel alloc] initWithFrame:CGRectMake(20, y, w, h)];
//	l.backgroundColor = [UIColor clearColor];	
//	l.font = [UIFont systemFontOfSize:17];
//	l.textAlignment = UITextAlignmentLeft;
//	l.text = @"Mínimo a pagar";
//	l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
//	[self.view addSubview:l];
//	[l release];
//	
//	
//	l = [[UILabel alloc] initWithFrame:CGRectMake(160, y, 45, h)];
//	l.backgroundColor = [UIColor clearColor];
//	l.font = [UIFont boldSystemFontOfSize:17];
//	l.textAlignment = UITextAlignmentRight;
//	l.text = [NSString stringWithFormat:@"$"];
//	l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
//	[self.view addSubview:l];
//	[l release];
//	
//	l = [[UILabel alloc] initWithFrame:CGRectMake(200, y, 100, h)];
//	l.backgroundColor = [UIColor clearColor];
//	l.font = [UIFont boldSystemFontOfSize:17];
//	l.textAlignment = UITextAlignmentRight;
//	//No se formatea Saldo para importes que vienen de Tarjetas, por diferencias con formato utilizado por Banelco
//	//l.text = [NSString stringWithFormat:@"%@",[Util formatSaldo:resumen.minAPagarPesos]];
//	l.text = [NSString stringWithFormat:@"%@",resumen.minAPagarPesos];
//	l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
//	[self.view addSubview:l];
//	[l release];
//	
//	
//	y += h + space;
//	
//	l = [[UILabel alloc] initWithFrame:CGRectMake(160, y, 45, h)];
//	l.backgroundColor = [UIColor clearColor];
//	l.font = [UIFont boldSystemFontOfSize:17];
//	l.textAlignment = UITextAlignmentRight;
//	l.text = [NSString stringWithFormat:@"U$S"];
//	l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
//	[self.view addSubview:l];
//	[l release];
//	
//	l = [[UILabel alloc] initWithFrame:CGRectMake(200, y, 100, h)];
//	l.backgroundColor = [UIColor clearColor];
//	l.font = [UIFont boldSystemFontOfSize:17];
//	l.textAlignment = UITextAlignmentRight;
//	//No se formatea Saldo para importes que vienen de Tarjetas, por diferencias con formato utilizado por Banelco
//	//l.text = [NSString stringWithFormat:@"%@",[Util formatSaldo:resumen.minAPagarDolares]];
//	l.text = [NSString stringWithFormat:@"%@",resumen.minAPagarDolares];
//	l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
//	[self.view addSubview:l];
//	[l release];
	
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
    [super dealloc];
	//[numeroTarjeta release];
}


@end
