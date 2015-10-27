//
//  CreditCardSaldoVC.m
//  BanelcoMovilIphone
//
//  Created by Ezequiel Aceto on 29/09/10.
//  Copyright 2010 Mobile Computing. All rights reserved.
//

#import "CreditCardSaldoVC.h"
#import "WS_ConsultarTarjetas.h"
#import "Context.h"
#import "WSUtil.h"
#import "CommonUIFunctions.h"
#import "MenuBanelcoController.h"
#import "MenuOptionsHelper.h"
#import "Util.h"
#import "WS_ConsultarTarjetasVisa.h"

@implementation CreditCardSaldoVC

//@synthesize saldoTextView;
@synthesize saldoScrollView;

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex { 
//	switch(buttonIndex) {
//		case 0:
//			[[MenuBanelcoController sharedMenuController] peekScreen];
//			break;
//	}
//}

//- (void)updateSaldos:(id)object {
//	saldoTextView.text = object;
//}

- (void)accionWithDelegate:(WheelAnimationController *)delegate {
	NSLog(@"accion en creditCardSaldoVC");
	
    id result = nil;
	WS_ConsultarTarjetas *request = [[WS_ConsultarTarjetas alloc] init];
	Context *context = [Context sharedContext];
	request.userToken = [context getToken];
	result = [WSUtil execute:request];
    [request release];
    
    id resultDA = nil;
    WS_ConsultarTarjetasVisa *request2 = [[WS_ConsultarTarjetasVisa alloc] init];
    request2.userToken = [context getToken];
    request2.codBanco = context.banco.idBanco;
    request2.tipoDoc = context.usuario.tipoDocumento;
    request2.nroDoc = context.usuario.nroDocumento;
    resultDA = [WSUtil execute:request2];
    [request2 release];
    
	/////
	
	if ([result isKindOfClass:[NSError class]]) {
		[self accionFinalizada:TRUE]; //??
        
        NSString *errorCode = [[(NSError *)result userInfo] valueForKey:@"faultCode"];
        if ([errorCode isEqualToString:@"ss"]) {
            return;
        }

		NSString *errorDesc = [[(NSError *)result userInfo] valueForKey:@"description"];
		//[CommonUIFunctions showAlert:@"Error de cambio de clave" withMessage:errorDesc andCancelButton:@"Volver"];
		[CommonUIFunctions showAlert:@"Consulta Saldo" withMessage:errorDesc cancelButton:@"Volver" andDelegate:self];
		
		return;
		
    } else if ([result isKindOfClass:[NSMutableArray class]]){
		[self accionFinalizada:TRUE];
		
		NSMutableArray *cards = (NSMutableArray*) result;
        NSMutableArray *datosDA = nil;
        if ([resultDA isKindOfClass:[NSMutableArray class]]) {
            datosDA = (NSMutableArray*) resultDA;
        }
		
		if ([cards count] == 0) {
			[CommonUIFunctions showAlert:@"Consulta Saldo" withMessage:@"No hay información sobre tus tarjetas de crédito por el momento." cancelButton:@"Volver" andDelegate:self];
			return;
		}
		
		int y = 20;
		int x = 20;
		int space = 5;
		//NSString *str;
		int w = 240;
		int h = 25;
		
		//BOOL showSeparator = [cards count]>1?YES:NO;
		
		//for (CreditCard *aCard in cards) {
		for (int i = 0; i < [cards count]; i++) {
		
			CreditCard *aCard = [cards objectAtIndex:i];
            
            CreditCard *cardDA = nil;
            if (datosDA) {
                for (int j = 0; j < [datosDA count]; j++) {
                    CreditCard *c = [datosDA objectAtIndex:j];
                    NSString *s = [c.numero stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    NSString *s2 = [aCard.numero stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    if ([[s uppercaseString] isEqualToString:[s2 uppercaseString]]) {
                        cardDA = [c retain];
                        break;
                    }
                }
            }
			
			UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, y, 320, h)];
			l.textAlignment = UITextAlignmentCenter;
			l.backgroundColor = [UIColor clearColor];
			if (![Context sharedContext].personalizado) {
                l.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:19];
            }
            else {
                l.font = [UIFont boldSystemFontOfSize:19];
            }
			l.text = [NSString stringWithFormat:@"%@",aCard.codigo];
			l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
			[self.saldoScrollView addSubview:l];
			[l release];
		
			y += h + space;
		
			l = [[UILabel alloc] initWithFrame:CGRectMake(20, y, 160, h)];
			l.backgroundColor = [UIColor clearColor];
			if (![Context sharedContext].personalizado) {
                l.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:15];
            }
            else {
                l.font = [UIFont boldSystemFontOfSize:15];
            }
			l.textAlignment = UITextAlignmentLeft;
			l.text = @"Nro. de Tarjeta ";
			l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
			[self.saldoScrollView addSubview:l];
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
			l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
			l.text = [NSString stringWithFormat:@"%@",[Util formatCreditCardNumber:aCard.numero]];
			[self.saldoScrollView addSubview:l];
			[l release];
			
		
			y += h + space;
		
			l = [[UILabel alloc] initWithFrame:CGRectMake(20, y, 160, h)];
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
			[self.saldoScrollView addSubview:l];
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
			l.text = [NSString stringWithFormat:@"%@",aCard.fechaVencimiento];
			l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
			[self.saldoScrollView addSubview:l];
			[l release];
		
			y += h + space;
            
            if([[MenuOptionsHelper sharedMenuHelper ] mostrarDatosAdicionales])
            {
                //////////////////CierreActual
                l = [[UILabel alloc] initWithFrame:CGRectMake(20, y, 160, h)];
                l.backgroundColor = [UIColor clearColor];
                if (![Context sharedContext].personalizado) {
                    l.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:15];
                }
                else {
                    l.font = [UIFont boldSystemFontOfSize:15];
                }
                l.text = @"Cierre actual";
                l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
                [self.saldoScrollView addSubview:l];
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
                l.text = cardDA && [cardDA.fechaCierreActual length] > 0 ? cardDA.fechaCierreActual : @"**/**/****";
                l.textAlignment = UITextAlignmentRight;
                [self.saldoScrollView addSubview:l];
                [l release];
                
               y += h + space;
                //////////////////////////////////
            }

		
			l = [[UILabel alloc] initWithFrame:CGRectMake(20, y, 160, h)];
			l.backgroundColor = [UIColor clearColor];
			if (![Context sharedContext].personalizado) {
                l.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:15];
            }
            else {
                l.font = [UIFont boldSystemFontOfSize:15];
            }
			l.textAlignment = UITextAlignmentLeft;
			l.text = [NSString stringWithFormat:@"Saldo"];
			l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
			[self.saldoScrollView addSubview:l];
			[l release];
		
//			l = [[UILabel alloc] initWithFrame:CGRectMake(180, y, 40, h)];
//			l.backgroundColor = [UIColor clearColor];	
//			if (![Context sharedContext].personalizado) {
//                l.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:15];
//            }
//            else {
//                l.font = [UIFont boldSystemFontOfSize:15];
//            }
//			l.textAlignment = UITextAlignmentRight;
//			l.text = [NSString stringWithFormat:@"$"];
//			l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
//			[self.saldoScrollView addSubview:l];
//			[l release];
			
			l = [[UILabel alloc] initWithFrame:CGRectMake(175, y, 125, h)];
			l.backgroundColor = [UIColor clearColor];	
			if (![Context sharedContext].personalizado) {
                l.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:15];
            }
            else {
                l.font = [UIFont boldSystemFontOfSize:15];
            }
			l.textAlignment = UITextAlignmentRight;
			l.text = [NSString stringWithFormat:@"$ %@",[Util formatSaldoB:aCard.saldoPesos]];
            l.accessibilityLabel = [l.text stringByReplacingOccurrencesOfString:@"$" withString:@"pesos"];
			l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
			[self.saldoScrollView addSubview:l];
			[l release];
			
		
			y += h + space;
//		
//			l = [[UILabel alloc] initWithFrame:CGRectMake(180, y, 40, h)];
//			l.backgroundColor = [UIColor clearColor];
//			if (![Context sharedContext].personalizado) {
//                l.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:15];
//            }
//            else {
//                l.font = [UIFont boldSystemFontOfSize:15];
//            }
//			l.textAlignment = UITextAlignmentRight;
//			l.text = [NSString stringWithFormat:@"U$S"];
//			l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
//			[self.saldoScrollView addSubview:l];
//			[l release];
			
			l = [[UILabel alloc] initWithFrame:CGRectMake(175, y, 125, h)];
			l.backgroundColor = [UIColor clearColor];
			if (![Context sharedContext].personalizado) {
                l.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:15];
            }
            else {
                l.font = [UIFont boldSystemFontOfSize:15];
            }
			l.textAlignment = UITextAlignmentRight;
			l.text = [NSString stringWithFormat:@"U$S %@",[Util formatSaldoB:aCard.saldoDolares]];
            l.accessibilityLabel = [l.text stringByReplacingOccurrencesOfString:@"U$S" withString:@"dolares"];
			l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
			[self.saldoScrollView addSubview:l];
			[l release];
			
		
			y += h + space;
		
			l = [[UILabel alloc] initWithFrame:CGRectMake(20, y, 160, h)];
			l.backgroundColor = [UIColor clearColor];
			if (![Context sharedContext].personalizado) {
                l.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:15];
            }
            else {
                l.font = [UIFont systemFontOfSize:15];
            }
			l.textAlignment = UITextAlignmentLeft;
			l.text = [NSString stringWithFormat:@"Pago Mínimo"];
			l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
			[self.saldoScrollView addSubview:l];
			[l release];
		
		
//			l = [[UILabel alloc] initWithFrame:CGRectMake(180, y, 40, h)];
//			l.backgroundColor = [UIColor clearColor];
//			if (![Context sharedContext].personalizado) {
//                l.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:15];
//            }
//            else {
//                l.font = [UIFont systemFontOfSize:15];
//            }
//			l.textAlignment = UITextAlignmentRight;
//			l.text = [NSString stringWithFormat:@"$"];
//			l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
//			[self.saldoScrollView addSubview:l];
//			[l release];
			
			l = [[UILabel alloc] initWithFrame:CGRectMake(175, y, 125, h)];
			l.backgroundColor = [UIColor clearColor];
			if (![Context sharedContext].personalizado) {
                l.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:15];
            }
            else {
                l.font = [UIFont boldSystemFontOfSize:15];
            }
			l.textAlignment = UITextAlignmentRight;
			l.text = [NSString stringWithFormat:@"$ %@",[Util formatSaldoB:aCard.pagoMinimo]];
            l.accessibilityLabel = [l.text stringByReplacingOccurrencesOfString:@"$" withString:@"pesos"];
			l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
			[self.saldoScrollView addSubview:l];
			[l release];
			
            if([[MenuOptionsHelper sharedMenuHelper]mostrarDatosAdicionales])
            {
                //////////////////////////////Proximo cierre
               
                y += h + space;
                ////Linea de arriba
                UIView *linea = [[UIView alloc] initWithFrame:CGRectMake(x, y, 280, 1)];
                linea.backgroundColor = [UIColor blackColor];
                [self.saldoScrollView addSubview:linea];
                
               
                
                l = [[UILabel alloc] initWithFrame:CGRectMake(20, y, 160, h)];
                l.backgroundColor = [UIColor clearColor];
                if (![Context sharedContext].personalizado) {
                    l.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:15];
                }
                else {
                    l.font = [UIFont systemFontOfSize:15];
                }
                l.textAlignment = UITextAlignmentLeft;
                l.text = @"Próximo cierre";
                l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
                [self.saldoScrollView addSubview:l];
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
                l.text = cardDA && [cardDA.fechaProxCierre length] > 0 ? [NSString stringWithFormat:@"%@",cardDA.fechaProxCierre] : @"**/**/****";
                l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
                [self.saldoScrollView addSubview:l];
                [l release];
                
    /////////////////////////////////////////
                ////////////////////////////////Proximo Vencimiento
                y += h + space;
                
                l = [[UILabel alloc] initWithFrame:CGRectMake(20, y, 160, h)];
                l.backgroundColor = [UIColor clearColor];
                if (![Context sharedContext].personalizado) {
                    l.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:15];
                }
                else {
                    l.font = [UIFont systemFontOfSize:15];
                }
                l.textAlignment = UITextAlignmentLeft;
                l.text = @"Próximo vencimiento";
                l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
                [self.saldoScrollView addSubview:l];
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
                l.text = cardDA && [cardDA.fechaProxVenc length] > 0 ? [NSString stringWithFormat:@"%@",cardDA.fechaProxVenc] : @"**/**/****";
                l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
                [self.saldoScrollView addSubview:l];
                [l release];
                y += h + space;
                linea = [[UIView alloc] initWithFrame:CGRectMake(x, y, 280, 1)];
                linea.backgroundColor = [UIColor blackColor];
                [self.saldoScrollView addSubview:linea];
            }

//////////////////////////////////////////////////////////
            
            if (cardDA) {
                [cardDA release];
            }
            
			y += h + 5;
			
			//if (showSeparator) {
			if (i < [cards count] - 1) {
				UIView *line = [[UIView alloc] initWithFrame:CGRectMake(x, y, 280, 2)];
				//line.backgroundColor = [UIColor blackColor];
				line.backgroundColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
				[self.saldoScrollView addSubview:line];
				[line release];
			}
			
			y += 10;
		
		}
		
		saldoScrollView.contentSize = CGSizeMake(320, y);
		
//		int x = 20;
//		int y = 20;
//		int space = 10;
//		NSString *str;
//		
//		for (CreditCard *aCard in cards) {
//			
//			str = [NSString stringWithFormat:@"%@",aCard.codigo];
//			y = space + [CommonUIFunctions addTextToView:saldoScrollView boldText:str normalText:nil xPos:x yPos:y];
//			
//			str = [NSString stringWithFormat:@"%@",[Util formatCreditCardNumber:aCard.numero]];
//			y = space + [CommonUIFunctions addTextToView:saldoScrollView boldText:str normalText:nil xPos:x yPos:y];
//			
//			str = [NSString stringWithFormat:@"Vencimiento %@",aCard.fechaVencimiento];
//			y = space + [CommonUIFunctions addTextToView:saldoScrollView boldText:str normalText:nil xPos:(x+50) yPos:y];
//			
//			int yAnt = y;
//			
//			str = [NSString stringWithFormat:@"Saldo"];
//			y = space + [CommonUIFunctions addTextToView:saldoScrollView boldText:nil normalText:str xPos:(x+50) yPos:y];
//			
//			str = [NSString stringWithFormat:@"$ %@",[Util formatSaldo:aCard.saldoPesos]];
//			[self addRigthTextToView:saldoScrollView boldText:nil normalText:str xPos:197 yPos:yAnt];
//			
//			str = [NSString stringWithFormat:@"U$S %@",[Util formatSaldo:aCard.saldoDolares]];
//			y = space + [CommonUIFunctions addTextToView:saldoScrollView boldText:nil normalText:str xPos:168 yPos:y];
//			
//			yAnt = y;
//			
//			str = [NSString stringWithFormat:@"Pago Mínimo"];
//			y = space + [CommonUIFunctions addTextToView:saldoScrollView boldText:nil normalText:str xPos:(x+50) yPos:y];
//			
//			str = [NSString stringWithFormat:@"$ %@",[Util formatSaldo:aCard.pagoMinimo]];
//			[self addRigthTextToView:saldoScrollView boldText:nil normalText:str xPos:197 yPos:yAnt];
//			
//			y += 20;
//		
//		}
		
//		NSMutableString *theInfo = [[NSMutableString alloc] init];
//		
//		for (CreditCard *aCard in cards) {
//
//			NSMutableString *num = [[NSMutableString alloc] init];
//			
//			for (int i = 0; i < 4; i++) {
//				[num appendFormat:@"."];
//			}
//			
//			for (int i = [aCard.numero length]-4; i < [aCard.numero length]; i++) {
//				[num appendFormat:@"%c",[aCard.numero characterAtIndex:i]];
//			}			
//			
//			[theInfo appendFormat:@"\t%@: %@\n",aCard.codigo,num];
//			
//			[theInfo appendFormat:@"\tVto. %@\n",aCard.fechaVencimiento];
//			 
//			[theInfo appendFormat:@"\tSaldo\t$ %@\n",aCard.saldoPesos];
//			[theInfo appendFormat:@"\t\t\tU$S %@\n",aCard.saldoDolares];
//			
//	 		[theInfo appendFormat:@"\tPago Mín.: $ %@\n\n",aCard.pagoMinimo];
//						
//		}
//		[self performSelectorOnMainThread:@selector(updateSaldos:) withObject:theInfo waitUntilDone:YES];
		
		
	}
	else {
		[self accionFinalizada:TRUE]; //??
		[CommonUIFunctions showAlert:@"Consulta Saldo" withMessage:@"No hay información sobre tus tarjetas de crédito por el momento." cancelButton:@"Volver" andDelegate:self];
	}
	
}

+ (int)addRigthTextToView:(UIView *)v boldText:(NSString *)bText normalText:(NSString *)nText xPos:(int)xP yPos:(int)yP {
	
	CGSize s1 = CGSizeZero;
	CGSize s2 = CGSizeZero;
	
	if (bText) {
		s1 = [bText sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
		UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(xP, yP, 150, s1.height)];
		l.text = [NSString stringWithFormat:@"%@",bText];
		l.backgroundColor = [UIColor clearColor];
		if (![Context sharedContext].personalizado) {
            l.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:17];
        }
        else {
            l.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
        }
		l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
		[v addSubview:l];
		[l release];
	}
	if (nText) {
		s2 = [nText sizeWithFont:[UIFont fontWithName:@"Helvetica" size:17]];
		UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(xP + s1.width, yP, s2.width, s2.height)];
		l.text = [NSString stringWithFormat:@"%@",nText];
		l.backgroundColor = [UIColor clearColor];
		if (![Context sharedContext].personalizado) {
            l.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:17];
        }
        else {
            l.font = [UIFont fontWithName:@"Helvetica" size:17];
        }
		l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
		[v addSubview:l];
		[l release];
		
	}
	return (yP + ((s1.height!=0)?s1.height:s2.height));
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Tarjetas de Crédito - Saldos";
	
	saldoScrollView.delegate = self;
	saldoScrollView.scrollEnabled = YES;
	saldoScrollView.canCancelContentTouches = NO;
	saldoScrollView.clipsToBounds=YES;
	

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
	
	[saldoScrollView release];
	
    [super dealloc];
}


@end
