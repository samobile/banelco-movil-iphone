//
//  TransferenciasRes.m
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 10/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TransferenciasResult.h"
#import "WS_RealizarTransferenciaCBU.h"
#import "WSUtil.h"
#import "CommonUIFunctions.h"
#import "WS_RealizarTransferenciaPropia.h"
#import "MenuBanelcoController.h"

@implementation TransferenciasResult

@synthesize transfer, ticket, importeConvertido;


@synthesize lFecha, lTransNum, lDe, lImporte,lA,lImporteDescCruz,lImporteCruz, lImporteDesc, lADesc, lTransInmediata;
@synthesize leyendaFecha, leyendaTransNum, leyendaTitulo, leyendaDe, leyendaSeuo, enviarMailBtn;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (id) initWithTitle:(NSString *)t transfer:(Transfer *)tr ticket:(Ticket *)tck {
	if ((self = [super init])) {
		self.title = t;
		self.transfer = tr;
		self.ticket = tck;
		if (!tr) {
			self.nav_volver = YES;
		}
		else {
			self.nav_volver = NO;
		}

	}
	return self;
}

- (void)setFontTypes {
    if ([Context sharedContext].personalizado) {
        return;
    }
    lFecha.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:16];
	lTransNum.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:16];
	lDe.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:14];
	lImporte.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:14];
	lA.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:14];
	lImporteDescCruz.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:14];
	lImporteCruz.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:14];
	lImporteDesc.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:14];
	lADesc.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:14];
	lTransInmediata.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:12];
	leyendaFecha.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:16];
	leyendaTransNum.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:16];
	leyendaTitulo.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:16];
	leyendaDe.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:14];
	leyendaSeuo.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:12];
}

- (void)setTxtColor {
	
	UIColor *color = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	
	lFecha.textColor = color;
	lTransNum.textColor = color;
	lDe.textColor = color;
	lImporte.textColor = color;
	lA.textColor = color;
	lImporteDescCruz.textColor = color;
	lImporteCruz.textColor = color;
	lImporteDesc.textColor = color;
	lADesc.textColor = color;
	lTransInmediata.textColor = color;
	
	leyendaFecha.textColor = color;
	leyendaTransNum.textColor = color;
	leyendaTitulo.textColor = color;
	leyendaDe.textColor = color;
	leyendaSeuo.textColor = color;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [(UIScrollView *)self.view setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 50)];
	
	Ticket *t = ticket;
	
    [self setFontTypes];
	[self setTxtColor];
	
//	int y = 20;
//	int x = 20;
//	int space = 10;
	//NSString *str;
	
//	str = [NSString stringWithFormat:@"De %@",[transfer.cuentaOrigen getDescripcion]];
//	y = space + [CommonUIFunctions addTextToView:self.view boldText:str normalText:nil xPos:x yPos:y];
	
	if (!transfer) {
		
		leyendaTitulo.text = @"Transferencia";
		
		if (t.cuenta) {
			lDe.text = [Util aplicarMascara:t.cuenta yMascara:[Cuenta getMascara]];
		}
	}
	else {
		lDe.text = [transfer.cuentaOrigen getDescripcion];
	}
	//lDe.text = [transfer.cuentaOrigen getDescripcion];
	
	
	//CRUZADA!!!
//	if (transfer.cruzada) {
		
//		str = [NSString stringWithFormat:@"Importe %@ %@",transfer.cuentaOrigen.simboloMoneda, [Util formatSaldo:t.importe]];
//		y = space + [CommonUIFunctions addTextToView:self.view boldText:str normalText:nil xPos:x yPos:y];
//	}
	
	
	
//	str = [NSString stringWithFormat:@"A %@",[transfer.cuentaOrigen getDescripcion]];
//	y = space + [CommonUIFunctions addTextToView:self.view boldText:str normalText:nil xPos:x yPos:y];


	if (!transfer) {
		if (t.cbuDestino && ![t.cbuDestino isEqualToString:@""]) {
			lA.text = [Util aplicarMascara:t.cbuDestino yMascara:[Cuenta getMascara]];
		}
		else {
			if (t.cuentaDestino) {
				lA.text = [Util aplicarMascara:t.cuentaDestino yMascara:[Cuenta getMascara]];
			}
		}
	}
	else {
		lA.text = [transfer.cuentaDestino getDescripcion];
	}
	//lA.text = [transfer.cuentaDestino getDescripcion];

	
	
//CRUZADA	
	//if (transfer.cruzada) {
	if (transfer && transfer.cruzada) {
	
		lImporteDescCruz.text = @"Importe:";
		lImporteCruz.text = [NSString stringWithFormat:@"%@ %@",transfer.cuentaDestino.simboloMoneda, [Util formatSaldo:self.importeConvertido]];
		//str = [NSString stringWithFormat:@"Importe %@ %@",transfer.cuentaDestino.simboloMoneda, [Util formatSaldo:self.importeConvertido]];
	//	y = space + [CommonUIFunctions addTextToView:self.view boldText:str normalText:nil xPos:x yPos:y];
	}
	else {
		//Si no es cruzada acomodo la visualizacion en pantalla
		CGFloat yDesc = lImporteDesc.frame.origin.y;
		CGFloat y = lImporte.frame.origin.y;
		
		CGRect f = lImporteDesc.frame;
		f.origin.y = lADesc.frame.origin.y;
		lImporteDesc.frame = f;
		
		f = lADesc.frame;
		f.origin.y = yDesc;
		lADesc.frame = f;
		
		f = lImporte.frame;
		f.origin.y = lA.frame.origin.y;
		lImporte.frame = f;
		
		f = lA.frame;
		f.origin.y = y;
		lA.frame = f;
	}

	
	//if (!transfer.cruzada) {
		
//		str = [NSString stringWithFormat:@"Importe %@ %@",transfer.cuentaOrigen.simboloMoneda, [Util formatSaldo:t.importe]];
//		y = space + [CommonUIFunctions addTextToView:self.view boldText:str normalText:nil xPos:x yPos:y];
		
	if (!transfer) {
		lImporte.text = [NSString stringWithFormat:@"%@ %@",t.moneda, [Util formatSaldo:t.importe]];
	}
	else {
		lImporte.text = [NSString stringWithFormat:@"%@ %@",transfer.cuentaOrigen.simboloMoneda, [Util formatSaldo:t.importe]];
	}
	//lImporte.text = [NSString stringWithFormat:@"%@ %@",transfer.cuentaOrigen.simboloMoneda, [Util formatSaldo:t.importe]];
//	}

	
	
//	str = [NSString stringWithFormat:@"Fecha %@",t.fechaPago];
//	y = space + [CommonUIFunctions addTextToView:self.view boldText:nil normalText:str xPos:x yPos:y];

	lFecha.text = t.fechaPago;
	
	
	//CRUZADA
	//if (transfer.cruzada) {
	if (transfer && transfer.cruzada) {
		UILabel *lab;
		lab = [[UILabel alloc] initWithFrame:CGRectMake(30, 237, 280, 40)];
		lab.text = [NSString stringWithFormat:@"%@",transfer.cotizacion];
		lab.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
		lab.font = [UIFont systemFontOfSize:14];
		lab.backgroundColor = [UIColor clearColor];
		lab.numberOfLines = 2;
		[self.view addSubview:lab];
		[lab release];
		
//		y += 40 + 10;
	}

	
	
//	str = [NSString stringWithFormat:@"Nro. Transacción %@",t.nroControl];
//	y = space + [CommonUIFunctions addTextToView:self.view boldText:nil normalText:str xPos:x yPos:y];

	
	lTransNum.text = t.nroControl;
	
//	y = space + [CommonUIFunctions addTextToView:self.view boldText:nil normalText:@"S.E.U.O." xPos:x yPos:y];
	
	//En caso de ser transferencia inmediata muestra texto informativo
	if (!transfer) {
		lTransInmediata.hidden = YES;
	}
	else {
		lTransInmediata.hidden = (transfer.tInmediata == nil);
	}
	//lTransInmediata.hidden = (transfer.tInmediata == nil);
}

- (IBAction)enviarPorMail:(id)sender {
    [self sendMail];
}

-(void)sendMail {
    
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"El dispositivo no está configurado para enviar mails." delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
    
	if (mailClass != nil) {
		//[self displayMailComposerSheet];
		// We must always check whether the current device is configured for sending emails
		if ([mailClass canSendMail]) {
			[self displayMailComposerSheet];
		}
        else {
            [alert show];
		}
	}
	else	{
		[alert show];
	}
	
    
	[alert release];
    
}

// Displays an email composition interface inside the application. Populates all the Mail fields.
-(void)displayMailComposerSheet
{
	
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
    if (self.transfer && self.transfer.cuentaDestino.accountType != C_CBU) {
        [picker setSubject:@"Cuentas Propias - Información de Transferencia"];
    }
    else {
        [picker setSubject:@"A Otras Ctas. Agendadas - Información de Transferencia"];
    }
	
    Ticket *t = ticket;
    NSString *importe = nil;
    NSString *de = nil;
    NSString *a = nil;
//    if (transfer && transfer.cruzada) {
//        importe = [NSString stringWithFormat:@"%@ %@",transfer.cuentaDestino.simboloMoneda, [Util formatSaldo:self.importeConvertido]];
//    }
    if (!transfer) {
		importe = [NSString stringWithFormat:@"%@ %@",t.moneda, [Util formatSaldo:t.importe]];
        if (t.cbuDestino && ![t.cbuDestino isEqualToString:@""]) {
			a = [Util aplicarMascara:t.cbuDestino yMascara:[Cuenta getMascara]];
		}
		else {
			if (t.cuentaDestino) {
				a = [Util aplicarMascara:t.cuentaDestino yMascara:[Cuenta getMascara]];
			}
		}
        if (t.cuenta) {
			de = [Util aplicarMascara:t.cuenta yMascara:[Cuenta getMascara]];
		}
	}
	else {
		importe = [NSString stringWithFormat:@"%@ %@",transfer.cuentaOrigen.simboloMoneda, [Util formatSaldo:t.importe]];
        a = [transfer.cuentaDestino getDescripcion];
        de = [transfer.cuentaOrigen getDescripcion];
	}
    
    NSString *strName = nil;
	if ([Context sharedContext].personalizado) {
		strName = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"Personalizacion"] objectForKey:@"AppName"];
	}
	else {
		strName = @"Banelco MÓVIL";
	}
    
    NSString *ltransIn = transfer.tInmediata ? lTransInmediata.text : @"";
    
	NSString *emailBody = [NSString stringWithFormat:@"Fecha Transf.: %@\nNro. Trans.: %@\nImporte: %@\nDe: %@\nA: %@\nS.E.U.O\n\n%@\n\nTransferencia realizada a través de %@.",
						   t.fechaPago,
						   t.nroControl,
                           importe,
                           de,
                           a,
                           ltransIn,
                           strName
                           ];
    
	[picker setMessageBody:emailBody isHTML:NO];
	[MenuBanelcoController sharedMenuController].dismissOnly = YES;
	[[MenuBanelcoController sharedMenuController] presentModalViewController:picker animated:YES];
	[picker release];
}

// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the
// message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller
		  didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	
	// Notifies users about errors associated with the interface
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Mail" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
	
	switch (result)
	{
		case MFMailComposeResultCancelled:
			alert.message =@"Se cancelo el envio del comprobante.";
			break;
		case MFMailComposeResultSaved:
			alert.message =@"Se grabo el envio del comprobante.";
			break;
		case MFMailComposeResultSent:
			alert.message =@"El comprobante fue enviado con exito!";
			break;
		case MFMailComposeResultFailed:
			alert.message =@"Fallo el envio del comprobante.";
			break;
		default:
			alert.message =@"El comprobante no ha sido enviado.";
			break;
	}
	[alert show];
	[alert release];
	[controller dismissModalViewControllerAnimated:YES];
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
	[lImporteDescCruz release];
	[lImporteCruz release];
	[lFecha release];
	[lTransNum release];
	[lDe release];
	[lImporte release];
	[lA release];
	
	[leyendaFecha release];
	[leyendaTransNum release];
	[leyendaTitulo release];
	[leyendaDe release];
	[leyendaSeuo release];
	
    self.enviarMailBtn = nil;
    
    [super dealloc];
}


@end
