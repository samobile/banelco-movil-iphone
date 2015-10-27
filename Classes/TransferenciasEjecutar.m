//
//  TransferenciasEjecutar.m
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 9/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TransferenciasEjecutar.h"
#import "Context.h"
#import "CommonUIFunctions.h"
#import "WS_RealizarTransferenciaPropia.h"
#import "Ticket.h"
#import "WSUtil.h"
#import "CustomText.h"
#import "MenuBanelcoController.h"
#import "WS_RealizarTransferenciaCBU.h"
#import "TransferenciasResult.h"
#import "WS_RealizarTransferenciaInmediata.h"

@implementation TransferenciasEjecutar

@synthesize transfer, cotizacion, botonAceptar, importeOrigen, importeDest;

BOOL ejecutarTransferencia = NO;

- (id) initWithTitle:(NSString *)t {
	if ((self = [super init])) {
		self.title = t;
		
		self.botonAceptar = [[UIButton alloc] init];
        self.botonAceptar.accessibilityLabel = @"Aceptar";
		[self.botonAceptar setBackgroundImage:[UIImage imageNamed:@"btn_aceptar.png"] forState:UIControlStateNormal];
		[self.botonAceptar setBackgroundImage:[UIImage imageNamed:@"btn_aceptarselec.png"] forState:UIControlStateHighlighted];
		[self.botonAceptar addTarget:self action:@selector(aceptar) forControlEvents:UIControlEventTouchUpInside];
		
	}
	return self;
}

/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect r = self.tableView.frame;
    //self.tableView.frame = CGRectMake(r.origin.x, r.origin.y, r.size.width, r.size.height + (IS_IPHONE_5 ? 80 : 0));
    self.tableView.frame = CGRectMake(r.origin.x, r.origin.y, r.size.width, r.size.height + (IS_IPHONE_5 ? 80 : 0));
}

/*
- (void)addTextToView:(NSMutableArray *)texts yPos:(int)yP space:(int)space {
	
	int y = yP;
	int x = 20;
	int w = 300;
	int h = 20;
	
	for (NSString *txt in texts) {
		
		UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
		l.text = [NSString stringWithFormat:@"%@",txt];
		l.backgroundColor = [UIColor clearColor];
		[self.view addSubview:l];
		[l release];
		
		y += h + space;
	}
}

- (int)addTextToView:(NSString *)t andDescription:(NSString *)descText yPos:(int)yP {
	
	//int y = yP;
	int x = 20;
	CGSize s1 = CGSizeZero;
	CGSize s2 = CGSizeZero;
	
	if (t) {
		s1 = [t sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
		UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(x, yP, s1.width, s1.height)];
		l.text = [NSString stringWithFormat:@"%@",t];
		l.backgroundColor = [UIColor clearColor];
		l.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
		[self.view addSubview:l];
		[l release];
	}
	if (descText) {
		s2 = [descText sizeWithFont:[UIFont fontWithName:@"Helvetica" size:17]];
		UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(x + s1.width, yP, s2.width, s2.height)];
		l.text = [NSString stringWithFormat:@"%@",descText];
		l.backgroundColor = [UIColor clearColor];
		l.font = [UIFont fontWithName:@"Helvetica" size:17];
		[self.view addSubview:l];
		[l release];
		
	}
	return (yP + ((s1.height!=0)?s1.height:s2.height));
}



- (int)addSimpleTextToView:(NSString *)t andDescription:(NSString *)descText yPos:(int)yP {
	
	//int y = yP;
	int x = 20;
	CGSize s1 = CGSizeZero;
	CGSize s2 = CGSizeZero;
	
	if (t) {
		s1 = [t sizeWithFont:[UIFont fontWithName:@"Helvetica" size:17]];
		UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(x, yP, s1.width, s1.height)];
		l.text = [NSString stringWithFormat:@"%@",t];
		l.backgroundColor = [UIColor clearColor];
		l.font = [UIFont fontWithName:@"Helvetica" size:17];
		[self.view addSubview:l];
		[l release];
	}
	if (descText) {
		s2 = [descText sizeWithFont:[UIFont fontWithName:@"Helvetica" size:17]];
		UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(x + s1.width, yP, s2.width, s2.height)];
		l.text = [NSString stringWithFormat:@"%@",descText];
		l.backgroundColor = [UIColor clearColor];
		l.font = [UIFont fontWithName:@"Helvetica" size:17];
		[self.view addSubview:l];
		[l release];
		
	}
	return (yP + ((s1.height!=0)?s1.height:s2.height));
}

*/



- (IBAction)aceptar {
	
	ejecutarTransferencia = YES;
	[super iniciarValores];
	[super inicializar];
	
}

- (void)ejecutarTransferencia {
	
	id resp;
	//Detecta si es operacion con cta CBU Agendada
	//if (transfer.cuentaDestino.accountType == C_CBU) {
	if (transfer.cuentaDestino.accountType == C_CBU) {
		
		if (transfer.tInmediata) {
			//Realiza Transferencia Inmediata
			WS_RealizarTransferenciaInmediata *request = [[WS_RealizarTransferenciaInmediata alloc] init];
			request.userToken = [[Context sharedContext] getToken];
			request.transfer = self.transfer;
			resp = [WSUtil execute:request];
			
		}
		else {
			//Realiza Transferencia CBU
			WS_RealizarTransferenciaCBU *request = [[WS_RealizarTransferenciaCBU alloc] init];
			request.userToken = [[Context sharedContext] getToken];
			request.transfer = self.transfer;
			resp = [WSUtil execute:request];
		}
		
	}
	else {
		//Realiza Transferencia Propia
		WS_RealizarTransferenciaPropia *request = [[WS_RealizarTransferenciaPropia alloc] init];
		request.userToken = [[Context sharedContext] getToken];
		request.cuentaOrigen = transfer.cuentaOrigen;
		request.cuentaDestino = transfer.cuentaDestino;
		request.importe = transfer.importe;
		resp = [WSUtil execute:request];
	}
	
	if ([resp isKindOfClass:[NSError class]]) {
        NSString *errorCode = [[(NSError *)resp userInfo] valueForKey:@"faultCode"];
        NSString *codigo = [[(NSError *)resp userInfo] valueForKey:@"tipoError"];
        

		NSString *errorDesc = [[(NSError *)resp userInfo] valueForKey:@"description"];
		[CommonUIFunctions showAlert:self.title withMessage:errorDesc cancelButton:@"Cerrar" andDelegate:nil];
        
        if ([errorDesc rangeOfString:@"53"].location  != NSNotFound) {
            //Vuelve 3 pantallas
            for (int i =0 ; i<3; i++) {
                [[MenuBanelcoController sharedMenuController] peekScreen];
                
            }
            
            return;
        }
        else
            if ([errorDesc rangeOfString:@"62"].location  != NSNotFound) {
              
                [[MenuBanelcoController sharedMenuController] inicio];
                return;
            }
            else
            {
                

            }
        
        
	}
	else if (resp) {
		TransferenciasResult *tr = [[TransferenciasResult alloc] initWithTitle:self.title transfer:self.transfer ticket:(Ticket *)resp];
		tr.importeConvertido = self.importeDest;
		[[MenuBanelcoController sharedMenuController] pushScreen:tr];
	}
}

- (void)accionWithDelegate:(WheelAnimationController *)delegate {
	
	if (ejecutarTransferencia) {
		ejecutarTransferencia = NO;
		[self ejecutarTransferencia];
		[delegate accionFinalizada:TRUE];
		return;
	}
	
//	NSMutableArray *text = [[NSMutableArray alloc] init];
	int y = 20;
//	int space = 10;
	
	if (transfer.cruzada) {
		//Consulta WS Cotizaciones
		cotizacion = [Cotizacion getCotizacion:transfer.cuentaOrigen.numero 
							   codCuenta:transfer.cuentaOrigen.codigoTipoCuenta 
						 codMonedaOrigen:transfer.cuentaOrigen.codigoMoneda 
								 importe:transfer.importe
						   codMonedaDest:transfer.moneda];
		if (!cotizacion) {
			[CommonUIFunctions showAlert:self.title withMessage:@"En este momento no se puede obtener cotización" cancelButton:@"Volver" andDelegate:self];
		}
		else if ([cotizacion isKindOfClass:[NSError class]]) {
            NSString *errorCode = [[(NSError *)cotizacion userInfo] valueForKey:@"faultCode"];
            if ([errorCode isEqualToString:@"ss"]) {
                return;
            }
			NSString *errorDesc = [[(NSError *)cotizacion userInfo] valueForKey:@"description"];
			[CommonUIFunctions showAlert:self.title withMessage:errorDesc cancelButton:@"Volver" andDelegate:self];
			
		}
		else {
			
			// Titulo
			//y = space + [self addTextToView:@"Usted está transfiriendo" andDescription:nil yPos:y];
			[titulos addObject:@""];
			[datos addObject:@"Estás transfiriendo"];
			
			if (![cotizacion.importe isEqualToString:@""]) {
				transfer.importe = cotizacion.importe;
			}
			transfer.cotizacion = cotizacion.cotizacion;
			transfer.importeConvertido = cotizacion.importeConvertido;
			importeOrigen = transfer.importe;
			importeDest = transfer.importeConvertido;
			
			
			// Cta. origen
			//y = space + [self addTextToView:[NSString stringWithFormat:@"De %@",[transfer.cuentaOrigen getDescripcion]] andDescription:nil yPos:y];
			[titulos addObject:@"De"];
			[datos addObject:[transfer.cuentaOrigen getDescripcion]];

			// Importe origen
			//NSString *str = [NSString stringWithFormat:@"Importe %@ %@",transfer.cuentaOrigen.simboloMoneda,[Util formatSaldo:importeOrigen]];
			//y = space + [self addTextToView:str andDescription:nil yPos:y];
			[titulos addObject:@"Importe"];
			[datos addObject:[NSString stringWithFormat:@"%@ %@",transfer.cuentaOrigen.simboloMoneda,[Util formatSaldo:importeOrigen]]];

			// Cta. destino
			//y = space + [self addTextToView:[NSString stringWithFormat:@"A %@",[transfer.cuentaDestino getDescripcion]] andDescription:nil yPos:y];
			[titulos addObject:@"A"];
			[datos addObject:[transfer.cuentaDestino getDescripcion]];
			
			// Importe destino
			//str = [NSString stringWithFormat:@"Importe %@ %@",transfer.cuentaDestino.simboloMoneda,[Util formatSaldo:importeDest]];
			//y = space + [self addTextToView:str andDescription:nil yPos:y];
			[titulos addObject:@"Importe"];
			[datos addObject:[NSString stringWithFormat:@"%@ %@",transfer.cuentaDestino.simboloMoneda,[Util formatSaldo:importeDest]]];
			
			self.tableView.frame = CGRectMake(5, 5, 310, IS_IPHONE_5 ? 310 : 215);
			
			y = 218 + 30;// + (IS_IPHONE_5 ? 80 : 0);
			int h = 20;
			UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(20, y, 300, h)];
			lbl.text = [NSString stringWithFormat:@"%@",cotizacion.cotizacion];
            lbl.accessibilityLabel = [lbl.text stringByReplacingOccurrencesOfString:@"U$S" withString:@"dolares"];
            lbl.accessibilityLabel = [lbl.text stringByReplacingOccurrencesOfString:@"$" withString:@"pesos"];
			lbl.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
			lbl.backgroundColor = [UIColor clearColor];
			lbl.font = [UIFont fontWithName:@"Helvetica" size:13];
			lbl.numberOfLines = 1;
			[self.view addSubview:lbl];
			[lbl release];
			
			lbl = [[UILabel alloc] initWithFrame:CGRectMake(20, y+h, 300, 32)];
			lbl.text = [NSString stringWithFormat:@"OP ALCANZ COM A5085/4377 BCRA DECLARO CONOCER LIMITES Y COND"];
			lbl.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
			lbl.backgroundColor = [UIColor clearColor];
			lbl.font = [UIFont fontWithName:@"Helvetica" size:11];
			lbl.numberOfLines = 2;
			[self.view addSubview:lbl];
			[lbl release];
			
		}
		
	}
	else {
		
		// Titulo
		//y = space + [self addTextToView:@"Usted está transfiriendo" andDescription:nil yPos:y];
		[titulos addObject:@""];
		[datos addObject:@"Estás transfiriendo"];
		
		// Importe
		//NSString * str = [NSString stringWithFormat:@"Importe %@ %@",transfer.cuentaOrigen.simboloMoneda,[Util formatSaldo:transfer.importe]];
		//y = space + [self addTextToView:str andDescription:nil yPos:y];
		
		// Cta. origen
		//str = [NSString stringWithFormat:@"De %@",[transfer.cuentaOrigen getDescripcion]];
		//y = space + [self addSimpleTextToView:str andDescription:nil yPos:y];
		[titulos addObject:@"De"];
		[datos addObject:[transfer.cuentaOrigen getDescripcion]];
		
		// Cta. destino
		/*if (transfer.cuentaDestino.accountType == C_CBU) {
			y = space + [self addTextToView:[NSString stringWithFormat:@"A %@",[transfer.cuentaDestino getDescripcion]] andDescription:nil yPos:y];
		}
		else {
			y = space + [self addTextToView:nil andDescription:[NSString stringWithFormat:@"A %@",[transfer.cuentaDestino getDescripcion]] yPos:y];
		}*/
		[titulos addObject:@"A"];
		[datos addObject:[transfer.cuentaDestino getDescripcion]];

		[titulos addObject:@"Importe"];
		[datos addObject:[NSString stringWithFormat:@"%@ %@",transfer.cuentaOrigen.simboloMoneda,[Util formatSaldo:transfer.importe]]];
		
		//Detecta si es una transf. con cta CBU Agendada
		//if (transfer.concepto) {
		if (transfer.cuentaDestino.accountType == C_CBU) {
			
			if (transfer.tInmediata) {
				
				self.tableView.frame = CGRectMake(5, 0, 310, IS_IPHONE_5 ? 290 : 210);
				
				[titulos addObject:@"Titular"];
				NSString *titular = [transfer.tInmediata.nombreTitular capitalizedString];
				int limite = 32;
				if ([titular length] > limite) {
					titular = [NSString stringWithFormat:@"%@...", [titular substringToIndex:limite]];
				}
				[datos addObject:titular];

				for (NSString *c in transfer.tInmediata.cuits) {
					[titulos addObject:[NSString stringWithFormat:@"%@",@"CUIT"]];
					[datos addObject:[NSString stringWithFormat:@"%@",c]];
				}

				[titulos addObject:@"Banco"];
				[datos addObject:[NSString stringWithFormat:@"%@",transfer.tInmediata.nombreBanco]];
				
				UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 185 + (IS_IPHONE_5 ? 80 : 0), 300, 110)];
				//lbl.text = [NSString stringWithFormat:@"La transferencia será cursada al destino en forma inmediata. Operación sujeta a comisiones determinadas por su Banco + imp."];
                lbl.text = [NSString stringWithFormat:@"La transferencia será cursada al destino en forma inmediata. Sujeto a impuestos y comisiones determinadas por tu banco"];
				lbl.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
				lbl.backgroundColor = [UIColor clearColor];
				lbl.numberOfLines = 8;
				if (![Context sharedContext].personalizado) {
                    lbl.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:12];
                }
                else {
                    lbl.font = [UIFont fontWithName:@"Helvetica" size:12];
                }
				[self.view addSubview:lbl];
			}
			else {
				
				self.tableView.frame = CGRectMake(5, 5, 320, IS_IPHONE_5 ? 290 : 200);
				
				//si no es inmediata mostrar plazo 48hs
				UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 185 + (IS_IPHONE_5 ? 80 : 0), 300, 90)];
				lbl.text = [NSString stringWithFormat:@"Plazo mínimo 48 hs. Operación sujeta a comisiones determinadas por su Banco + imp."];
				lbl.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
				lbl.backgroundColor = [UIColor clearColor];
				lbl.numberOfLines = 8;
				if (![Context sharedContext].personalizado) {
                    lbl.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:12];
                }
                else {
                    lbl.font = [UIFont fontWithName:@"Helvetica" size:12];
                }
				[self.view addSubview:lbl];
			}

//			UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 235 + (IS_IPHONE_5 ? 80 : 0), 300, 55)];
//			lbl.text = [NSString stringWithFormat:@"Operación sujeta a comisiones determinadas por su Banco + imp."];
//			lbl.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
//			lbl.backgroundColor = [UIColor clearColor];
//			lbl.numberOfLines = 3;
//			if (![Context sharedContext].personalizado) {
//                lbl.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:12];
//            }
//            else {
//                lbl.font = [UIFont fontWithName:@"Helvetica" size:12];
//            }
//			[self.view addSubview:lbl];
//			[lbl release];
			
		}
		
	}
	
	self.botonAceptar.frame = CGRectMake(109, 274 + (IS_IPHONE_5 ? 80 : 0), 102, 32);
	[self.view addSubview:self.botonAceptar];
	
	[self.tableView reloadData];
		
	[delegate accionFinalizada:TRUE];
}



- (void)dealloc {
	
	//[tInmediata release];
    [super dealloc];
}


@end
