#import "ConsultaCBU.h"
#import "Cuenta.h"
#import "WS_ConsultarCBUCuenta.h"
#import "WheelAnimationController.h"
#import "Context.h"
#import "CommonUIFunctions.h"
#import "WSUtil.h"
#import "MenuBanelcoController.h"
#import "CommonFunctions.h"

@implementation ConsultaCBU

@synthesize  descripcionCuenta;
@synthesize cbu, cbuParaMail;

@synthesize cuenta;


-(id) initWithCuenta:(Cuenta*) account{
	
	if(self = [super init]){
		self.cuenta = account;
		self.title = @"Consulta de CBU";
//		self.cbu = [[UITextView alloc] initWithFrame:CGRectMake(10, 93, 300, 40)];
//		self.cbu.backgroundColor = [UIColor clearColor];
//		self.cbu.textAlignment = UIBaselineAdjustmentAlignCenters;
//		self.cbu.scrollEnabled = NO;
//		self.cbu.editable = NO;
//		self.cbu.font = [UIFont boldSystemFontOfSize:20.0];
//		// [UIFont systemFontOfSize:17.0];
//		[self.view addSubview:self.cbu];
	}
	
	return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
	if (![Context sharedContext].personalizado) {
        self.descripcionCuenta.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:18];
    }
	self.descripcionCuenta.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	self.descripcionCuenta.text = [NSString stringWithFormat:@"%@  %@",cuenta.descripcionLargaTipoCuenta,[cuenta descripcionParaCBU]];
    self.descripcionCuenta.accessibilityLabel = [CommonFunctions replaceSymbolVoice:self.descripcionCuenta.text];
    
	//self.cbu.text = @"";

}






- (void)accionWithDelegate:(WheelAnimationController *)delegate {
	id result;

	WS_ConsultarCBUCuenta *request = [[WS_ConsultarCBUCuenta alloc] init];

	
	Context *context = [Context sharedContext];
	request.userToken = [context getToken];	
	request.numeroCuenta = cuenta.numero; 
	request.tipoCuenta = [cuenta.codigoTipoCuenta intValue];
	request.codigoMoneda = cuenta.codigoMoneda;
	result = [WSUtil execute:request];

	
	if ([result isKindOfClass:[NSError class]]) {
		[self accionFinalizada:FALSE]; //??
        
        NSString *errorCode = [[(NSError *)result userInfo] valueForKey:@"faultCode"];
        if ([errorCode isEqualToString:@"ss"]) {
            return;
        }
        
		NSString *errorDesc = [[(NSError *)result userInfo] valueForKey:@"description"];
		//[CommonUIFunctions showAlert:@"Error de cambio de clave" withMessage:errorDesc andCancelButton:@"Volver"];
		[CommonUIFunctions showAlert:@"Consulta CBU" withMessage:errorDesc cancelButton:@"Volver" andDelegate:self];
		return;
		
	}	else{
		[self accionFinalizada:TRUE];
		[self performSelectorOnMainThread:@selector(setCBUDelacuenta:) withObject:result waitUntilDone:YES];
		//self.cbu.text = result;
	}
	
}

- (void)addTextToView:(UIView *)v boldText:(NSString *)bText normalText:(NSString *)nText xPos:(int)xP yPos:(int)yP {
	
	CGSize s1 = CGSizeZero;
	CGSize s2 = CGSizeZero;
	
	if (bText) {
//		s1 = [bText sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
//		UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(xP, yP, s1.width, s1.height)];
//		l.text = [NSString stringWithFormat:@"%@",bText];
//		l.backgroundColor = [UIColor clearColor];
//		l.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
//		[v addSubview:l];
//		[l release];
		UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(xP, yP, 300, 90)];
        l.text = [NSString stringWithFormat:@"%@",bText];
		l.accessibilityLabel = [CommonFunctions replaceSymbolVoice:l.text];
		l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
		l.backgroundColor = [UIColor clearColor];
        
        NSLog(@"%@\n%@", l.text, l.accessibilityLabel);
		if (![Context sharedContext].personalizado) {
            l.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:18];
        }
        else {
            l.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
        }
		//l.editable = NO;
		//l.scrollEnabled = NO;
		[v addSubview:l];
		[l release];
	}
	if (nText) {
		s2 = [nText sizeWithFont:[UIFont fontWithName:@"Helvetica" size:18]];
		UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(xP + s1.width, yP, s2.width, s2.height)];
		l.text = [NSString stringWithFormat:@"%@",nText];
        l.accessibilityLabel = [CommonFunctions replaceSymbolVoice:l.text];
		l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
		l.backgroundColor = [UIColor clearColor];
		if (![Context sharedContext].personalizado) {
            l.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:17];
        }
        else {
            l.font = [UIFont fontWithName:@"Helvetica" size:17];
        }
		[v addSubview:l];
		[l release];
		
	}
}


-(void) setCBUDelacuenta:(id) numCbu{
	//self.cbu.text = numCbu;
	
    self.cbuParaMail = [NSString stringWithFormat:@"CBU: %@",numCbu];
	NSString *str = [NSString stringWithFormat:@"CBU %@",numCbu];
	[self addTextToView:self.view boldText:str normalText:nil xPos:10 yPos:80];
	
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
	
	[picker setSubject:@"Número de CBU"];
	
    NSString *cuentaStr = [NSString stringWithFormat:@"%@  %@",cuenta.descripcionLargaTipoCuenta,[cuenta descripcionParaCBU]];
    
	NSString *emailBody = [NSString stringWithFormat:@"%@\n%@",cuentaStr,self.cbuParaMail];
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
	[descripcionCuenta release];
	[cuenta release];
	//[cbu release];
    self.cbuParaMail = nil;
    
    [super dealloc];
}


@end
