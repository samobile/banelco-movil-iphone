//
//  CargaCelularResultado.m
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 9/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CargaCelularResultado.h"
#import "MenuBanelcoController.h"
#import "WS_RealizarPago.h"
#import "WSUtil.h"
#import "Ticket.h"
#import "CommonUIFunctions.h"
#import "Deuda.h"

@implementation CargaCelularResultado

@synthesize cuenta, ticket, empresa, importe, idCliente, descCliente,lEmpresa,lCliente,lFecha,lTransNum,lImporte, lDebito;
@synthesize leyendaFecha, leyendaTransNum, leyendaImporte, leyendaDebito, leyendaCliente, leyendaSeuo, leyenda, enviarMailBtn;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

- (id) initWithTitle:(NSString *)t andTicket:(Ticket *)tck {
	if ((self = [super init])) {
		
		self.title = t;
		self.ticket = tck;
		self.nav_volver = NO;
	}
	return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
		
	//CGRect r = CGRectMake(20, 250, 280, 61);
//	UILabel *l = [[UILabel alloc] initWithFrame:r];
//	l.text = [NSString stringWithFormat:@"Puede consultar e imprimir sus comprobantes en pagomiscuentas.com o en los cajeros de la red Banelco."];
//	l.font = [UIFont fontWithName:@"Helvetica-Oblique" size:14];
//	l.textAlignment = UITextAlignmentLeft;
//	l.backgroundColor = [UIColor clearColor];
//	l.numberOfLines = 3;
//	[self.view addSubview:l];
//	[l release];
	
	[self performSelectorOnMainThread:@selector(crearTextView) withObject:nil waitUntilDone:YES];
    
    [(UIScrollView *)self.view setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 50)];

}

- (void) setFontTypes {

    if ([Context sharedContext].personalizado) {
        return;
    }
    
	lEmpresa.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:16];
	lCliente.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:14];
	lFecha.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:16];
	lImporte.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:14];
	lDebito.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:14];
	lTransNum.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:16];
	
	leyendaFecha.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:16];
	leyendaTransNum.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:16];
	leyendaImporte.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:14];
	leyendaDebito.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:14];
	leyendaCliente.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:14];
	leyendaSeuo.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:12];
	leyenda.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:9];
	
}

- (void) setTxtColor {

	UIColor *color = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	lEmpresa.textColor = color;
	lCliente.textColor = color;
	lFecha.textColor = color;
	lImporte.textColor = color;
	lDebito.textColor = color;
	lTransNum.textColor = color;
	
	leyendaFecha.textColor = color;
	leyendaTransNum.textColor = color;
	leyendaImporte.textColor = color;
	leyendaDebito.textColor = color;
	leyendaCliente.textColor = color;
	leyendaSeuo.textColor = color;
	leyenda.textColor = color;
	
}

- (void) crearTextView {
	
	//Carga Info
	//int y = 20;
	//int x = 20;
	//int space = 10;
	//NSString *str;
	
	//y = space + [CommonUIFunctions addTextToView:self.view boldText:ticket.empresa normalText:nil xPos:x yPos:y];
	[self setFontTypes];
	[self setTxtColor];
	
	lEmpresa.text = ticket.empresa;
	
	//str = [NSString stringWithFormat:@"%@",self.descCliente];
	//y = space + [CommonUIFunctions addTextToView:self.view boldText:str	normalText:nil xPos:x yPos:y];
	
	
	lCliente.text = [NSString stringWithFormat:@"%@",self.descCliente];
	
//	str = [NSString stringWithFormat:@"Fecha Pago %@",ticket.fechaPago];
//	y = space + [CommonUIFunctions addTextToView:self.view boldText:str normalText:nil xPos:x yPos:y];

	lFecha.text =ticket.fechaPago;
	
//	str = [NSString stringWithFormat:@"Importe %@ %@",cuenta.simboloMoneda,[Util formatSaldo:ticket.importe]];
//	y = space + [CommonUIFunctions addTextToView:self.view boldText:str normalText:nil xPos:x yPos:y];
	
	
	lImporte.text =  [NSString stringWithFormat:@"%@ %@",cuenta.simboloMoneda,[Util formatSaldo:ticket.importe]];
	lImporte.accessibilityLabel = [lImporte.text stringByReplacingOccurrencesOfString:@"U$S" withString:@"dolares"];
    lImporte.accessibilityLabel = [lImporte.text stringByReplacingOccurrencesOfString:@"$" withString:@"pesos"];
	
//	str = [NSString stringWithFormat:@"Débito %@",[cuenta getDescripcion]];
//	y = space + [CommonUIFunctions addTextToView:self.view boldText:nil	normalText:str xPos:x yPos:y];
	
	lDebito.text = [cuenta getDescripcion];
	lDebito.accessibilityLabel = [lDebito.text stringByReplacingOccurrencesOfString:@"U$S" withString:@"dolares"];
    lDebito.accessibilityLabel = [lDebito.text stringByReplacingOccurrencesOfString:@"$" withString:@"pesos"];
	
//	str = [NSString stringWithFormat:@"Nro. Transacción %@",ticket.nroControl];
//	y = space + [CommonUIFunctions addTextToView:self.view boldText:nil	normalText:str xPos:x yPos:y];

	
	lTransNum.text = ticket.nroControl;
	
//	y = space + [CommonUIFunctions addTextToView:self.view boldText:nil	normalText:@"S.E.U.O." xPos:x yPos:y];
	
//	CGRect frameText = CGRectMake(12, 260, 296, 317 - 260);
	//UITextView *textView = [[UITextView alloc] initWithFrame:frameText];
	//textView.backgroundColor = [UIColor clearColor];
	//textView.text = @"Puede consultar e imprimir sus comprobantes en pagomiscuentas.com o en los cajeros de la Red BANELCO.";
	//textView.editable = NO;
	//textView.userInteractionEnabled = NO;
	//textView.autocorrectionType = UITextAutocorrectionTypeNo;
	//[self.view addSubview:textView];
	
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
	
    NSString *subject = [NSString stringWithFormat:@"Carga Realizada"];
	[picker setSubject:subject];
    
    NSString *fecha = ticket.fechaPago;
    NSString *importeStr = [NSString stringWithFormat:@"%@ %@",cuenta.simboloMoneda,[Util formatSaldo:ticket.importe]];
    importeStr.accessibilityLabel = [importeStr stringByReplacingOccurrencesOfString:@"U$S" withString:@"dolares"];
    importeStr.accessibilityLabel = [importeStr stringByReplacingOccurrencesOfString:@"$" withString:@"pesos"];
    NSString *clienteID = [NSString stringWithFormat:@"%@",self.descCliente];
    NSString *debito = [cuenta getDescripcion];
    NSString *nroTrans = ticket.nroControl;
    
	NSString *emailBody = [NSString stringWithFormat:@"%@\nFecha Carga: %@\nNro. Trans.: %@\nImporte: %@\nID: %@\nDébito: %@\nS.E.U.O",
						   subject,
						   fecha,
                           nroTrans,
                           importeStr,
                           clienteID,
                           debito
                           ];
    emailBody.accessibilityLabel = [emailBody stringByReplacingOccurrencesOfString:@"U$S" withString:@"dolares"];
    emailBody.accessibilityLabel = [emailBody stringByReplacingOccurrencesOfString:@"$" withString:@"pesos"];
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

- (void)dealloc {
	
	[empresa release];
	[lEmpresa release];
	[lCliente release];
	[lFecha release];
	[lTransNum release];
	[lImporte release];
	[lDebito release];
	
	[leyendaFecha release];
	[leyendaTransNum release];
	[leyendaImporte release];
	[leyendaDebito release];
	[leyendaCliente release];
	[leyendaSeuo release];
	[leyenda release];
	self.enviarMailBtn = nil;
    [super dealloc];
}


@end
