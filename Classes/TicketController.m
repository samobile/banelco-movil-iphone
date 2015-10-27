

#import "TicketController.h"
#import "Util.h"
#import "Context.h"
#import "ExecutePagarDeuda.h"
#import "WaitingAlert.h"
#import "DetalleDeudaController.h"
#import "MenuBanelcoController.h"
#import "CommonFunctions.h"

@implementation TicketController

@synthesize lFecha;
@synthesize lNroTrans;
@synthesize lFooter;
@synthesize lTitulo;
@synthesize cuenta, deuda, ticket;
@synthesize leyendFecha, leyendNroTrans;



- (id)initTipo:(int)tipo withDeuda:(Deuda *)deuda {
    if ((self = [super init])) {
        self.deuda = deuda;
		[self iniciar:tipo];
    }
    return self;
}


- (id)initWithDeuda:(Deuda *)deuda cuenta:(Cuenta *)cuenta andTicket:(Ticket *)ticket {
    if ((self = [super init])) {
        self.deuda = deuda;
		self.cuenta = cuenta;
		self.ticket = ticket;
		[self iniciar:DD_PAGADO];
    }
    return self;
}

- (id)initWithTicket:(Ticket *)ticket {
    if ((self = [super init])) {
        self.deuda = nil;
		self.cuenta = nil;
		self.ticket = ticket;
		[self iniciarComprobante];
    }
    return self;
}

- (id)initSubeWithTicket:(Ticket *)ticket {
    if ((self = [self initWithNibName:@"TicketSUBEController" bundle:nil])) {
        self.deuda = nil;
		self.cuenta = nil;
		self.ticket = ticket;
		[self iniciarComprobanteSUBE];
    }
    return self;
}


- (void)iniciar:(int)t {
	
	tipo = t;
	
	if (tipo == DD_PAGADO) {
		
		self.title = @"Pago Realizado";
		self.nav_volver = NO;
		
	}
	
	float yInicial = 119;
		NSString *codigoidCliente = @"";
	if ([self.deuda.codigoRubro isEqualToString:@"TCIN"] || [self.deuda.codigoRubro isEqualToString:@"TCRE"]) {
		codigoidCliente = [Util formatDigits:self.deuda.idCliente];
	} else {
		codigoidCliente = self.deuda.idCliente;
	}

	
	if (deuda.descripcionUsuario && ![deuda.descripcionUsuario isEqualToString:@""]) {
		
		UILabel* labelDesc = [[UILabel alloc] initWithFrame:CGRectMake(28, yInicial, 70, 25)];
		labelDesc.text =  @"Desc.:";
		if (![Context sharedContext].personalizado) {
            labelDesc.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:14];
        }
        else {
            labelDesc.font = [UIFont systemFontOfSize:14];
        }
        labelDesc.backgroundColor = [UIColor clearColor];
		labelDesc.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
		[self.view addSubview:labelDesc];
		[labelDesc release];

		
		
		UILabel* labelDesc2 = [[UILabel alloc] initWithFrame:CGRectMake(100, yInicial+1, 200, 25)];
		labelDesc2.text =  deuda.descripcionUsuario;
        labelDesc2.accessibilityLabel = [CommonFunctions replaceSymbolVoice:labelDesc2.text];
		labelDesc2.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
		[self.view addSubview:labelDesc2];
		if (![Context sharedContext].personalizado) {
            labelDesc2.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:14];
        }
        else {
            labelDesc2.font = [UIFont boldSystemFontOfSize:14];
        }
        labelDesc2.backgroundColor = [UIColor clearColor];
		[labelDesc2 release];
		//[items addObject:[NSString stringWithFormat:@"<b>Desc. %@", deuda.descripcionUsuario]];
		
		
		yInicial += 24;
	}
	
	
	
	NSString *importe = ![deuda.otroImporte isEqualToString:@"0.0"]? deuda.otroImporte : deuda.importe;
	
	
	UILabel* labelImport = [[UILabel alloc] initWithFrame:CGRectMake(28, yInicial, 70, 25)];
	labelImport.text =  @"Importe:";
	if (![Context sharedContext].personalizado) {
        labelImport.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:14];
    }
    else {
        labelImport.font = [UIFont systemFontOfSize:14];
    }
    labelImport.backgroundColor = [UIColor clearColor];
	labelImport.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	[self.view addSubview:labelImport];
	[labelImport release];
	
	
	
	UILabel* labelImport2 = [[UILabel alloc] initWithFrame:CGRectMake(100, yInicial, 200, 25)];
	labelImport2.text =  [NSString stringWithFormat:@"%@ %@",deuda.monedaSimbolo, [Util formatSaldo:importe] ];
    labelImport2.accessibilityLabel = [CommonFunctions replaceSymbolVoice:labelImport2.text];
	labelImport2.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	[self.view addSubview:labelImport2];
	if (![Context sharedContext].personalizado) {
        labelImport2.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:14];
    }
    else {
        labelImport2.font = [UIFont boldSystemFontOfSize:14];
    }
    labelImport2.backgroundColor = [UIColor clearColor];
	[labelImport2 release];

	
	yInicial += 24;
	
	
	UILabel* labelId = [[UILabel alloc] initWithFrame:CGRectMake(28, yInicial, 70, 25)];
	labelId.text =  @"ID:";
	labelId.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	[self.view addSubview:labelId];
	if (![Context sharedContext].personalizado) {
        labelId.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:14];
    }
    else {
        labelId.font = [UIFont systemFontOfSize:14];
    }
    labelId.backgroundColor = [UIColor clearColor];
	[labelId release];
	
	
	
	UILabel* labelId2 = [[UILabel alloc] initWithFrame:CGRectMake(100, yInicial, 200, 25)];
	labelId2.text =  codigoidCliente;
    labelId2.accessibilityLabel = [CommonFunctions replaceSymbolVoice:labelId2.text];
	labelId2.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	[self.view addSubview:labelId2];
	if (![Context sharedContext].personalizado) {
        labelId2.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:14];
    }
    else {
        labelId2.font = [UIFont boldSystemFontOfSize:14];
    }
    labelId2.backgroundColor = [UIColor clearColor];
	[labelId2 release];
	
	yInicial += 24;
	
	
	Context *context = [Context sharedContext];
	if (context.selectedDeuda.datoAdicional && (![context.selectedDeuda.datoAdicional isEqualToString:@""])) {
		
		
		UILabel* labelAdi = [[UILabel alloc] initWithFrame:CGRectMake(28, yInicial, 70, 25)];
		labelAdi.text = context.selectedDeuda.datoAdicional;
        labelAdi.accessibilityLabel =  [CommonFunctions replaceSymbolVoice:labelAdi.text];
		labelAdi.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
		[self.view addSubview:labelAdi];
		if (![Context sharedContext].personalizado) {
            labelAdi.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:14];
        }
        else {
            labelAdi.font = [UIFont systemFontOfSize:14];
        }
        labelAdi.backgroundColor = [UIColor clearColor];
		[labelAdi release];

		UILabel* labelAdi2 = [[UILabel alloc] initWithFrame:CGRectMake(100, yInicial+1, 200, 25)];
		labelAdi2.text =  context.selectedDeuda.leyenda;
        labelAdi2.accessibilityLabel = [CommonFunctions replaceSymbolVoice:labelAdi2.text];
		labelAdi2.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
		[self.view addSubview:labelAdi2];
        if (![Context sharedContext].personalizado) {
            labelAdi2.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:14];
        }
        else {
            labelAdi2.font = [UIFont boldSystemFontOfSize:14];
        }
        labelAdi2.backgroundColor = [UIColor clearColor];
		[labelAdi2 release];
		
		yInicial += 24;
		
	}
	
	if (deuda.vencimiento && [deuda.vencimiento length] > 0) {
		
		UILabel* labelVto = [[UILabel alloc] initWithFrame:CGRectMake(28, yInicial, 70, 25)];
		labelVto.text = @"F. Vto.:";
		labelVto.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
		[self.view addSubview:labelVto];
        if (![Context sharedContext].personalizado) {
            labelVto.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:14];
        }
        else {
            labelVto.font = [UIFont systemFontOfSize:14];
        }
        labelVto.backgroundColor = [UIColor clearColor];
		[labelVto release];
		
		UILabel* labelVto2 = [[UILabel alloc] initWithFrame:CGRectMake(100, yInicial+1, 200, 25)];
		labelVto2.text =  deuda.vencimiento;
		labelVto2.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
		[self.view addSubview:labelVto2];
		if (![Context sharedContext].personalizado) {
            labelVto2.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:14];
        }
        else {
            labelVto2.font = [UIFont boldSystemFontOfSize:14];
        }
        labelVto2.backgroundColor = [UIColor clearColor];
		[labelVto2 release];
		
		yInicial += 24;

	}
	
	UILabel* labelDeb = [[UILabel alloc] initWithFrame:CGRectMake(28, yInicial, 70, 25)];
	labelDeb.text = @"Débito:";
	labelDeb.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	[self.view addSubview:labelDeb];
	if (![Context sharedContext].personalizado) {
        labelDeb.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:14];
    }
    else {
        labelDeb.font = [UIFont systemFontOfSize:14];
    }
    labelDeb.backgroundColor = [UIColor clearColor];
	[labelDeb release];
	
	UILabel* labelDeb2 = [[UILabel alloc] initWithFrame:CGRectMake(100, yInicial+1, 200, 25)];
	labelDeb2.text =  [NSString stringWithFormat:@"%@  %@", cuenta.descripcionCortaTipoCuenta, [cuenta descripcionParaCBU]];
    labelDeb2.accessibilityLabel = [CommonFunctions replaceSymbolVoice:labelDeb2.text];
	labelDeb2.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	[self.view addSubview:labelDeb2];
	if (![Context sharedContext].personalizado) {
        labelDeb2.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:14];
    }
    else {
        labelDeb2.font = [UIFont boldSystemFontOfSize:14];
    }
    labelDeb2.backgroundColor = [UIColor clearColor];
    labelDeb2.minimumFontSize = 8;
	[labelDeb2 release];
	
	yInicial += 24;
	
	
	if (tipo == DD_PAGADO) {
	
		
		UILabel* labelDato = [[UILabel alloc] initWithFrame:CGRectMake(28, 245, 70, 25)];
		labelDato.text = @"S.E.U.O.";
		labelDato.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
		[self.view addSubview:labelDato];
		if (![Context sharedContext].personalizado) {
            labelDato.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:12];
        }
        else {
            labelDato.font = [UIFont systemFontOfSize:12];
        }
        labelDato.backgroundColor = [UIColor clearColor];
		[labelDato release];
		
		yInicial += 24;

	}
	
}

- (void)iniciarComprobante {
	
	tipo = DD_COMPROBANTE;
	
	self.title = @"Detalle de Pago";
		

	NSString *importe =ticket.importe;
	
	float yInicial = 119;
	
	UILabel* labelImport = [[UILabel alloc] initWithFrame:CGRectMake(28, yInicial, 70, 25)];
	labelImport.text =  @"Importe:";
	labelImport.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	[self.view addSubview:labelImport];
	if (![Context sharedContext].personalizado) {
        labelImport.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:14];
    }
    else {
        labelImport.font = [UIFont systemFontOfSize:14];
    }
    labelImport.backgroundColor = [UIColor clearColor];
	[labelImport release];
	
	
	UILabel* labelImport2 = [[UILabel alloc] initWithFrame:CGRectMake(100, yInicial+1, 200, 25)];
	labelImport2.text =  [NSString stringWithFormat:@"%@ %@",ticket.moneda, [Util formatSaldo:importe] ];
    labelImport2.accessibilityLabel = [CommonFunctions replaceSymbolVoice:labelImport2.text];
	labelImport2.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	[self.view addSubview:labelImport2];
	if (![Context sharedContext].personalizado) {
        labelImport2.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:14];
    }
    else {
        labelImport2.font = [UIFont boldSystemFontOfSize:14];
    }
    labelImport2.backgroundColor = [UIColor clearColor];
	[labelImport2 release];
	
	
	yInicial += 24;
	
	
	UILabel* labelId = [[UILabel alloc] initWithFrame:CGRectMake(28, yInicial, 70, 25)];
	labelId.text =  @"ID:";
	labelId.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	[self.view addSubview:labelId];
	if (![Context sharedContext].personalizado) {
        labelId.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:14];
    }
    else {
        labelId.font = [UIFont systemFontOfSize:14];
    }
    labelId.backgroundColor = [UIColor clearColor];
	[labelId release];
	
	UILabel* labelId2 = [[UILabel alloc] initWithFrame:CGRectMake(100, yInicial+1, 200, 25)];
	labelId2.text =  ticket.clienteId;
    labelId2.accessibilityLabel = [CommonFunctions replaceSymbolVoice:labelId2.text];
	labelId2.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	[self.view addSubview:labelId2];
	if (![Context sharedContext].personalizado) {
        labelId2.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:14];
    }
    else {
        labelId2.font = [UIFont boldSystemFontOfSize:14];
    }
    labelId2.backgroundColor = [UIColor clearColor];
	[labelId2 release];
	
	yInicial += 24;
	
	UILabel* labelDeb = [[UILabel alloc] initWithFrame:CGRectMake(28, yInicial, 70, 25)];
	labelDeb.text = @"Débito:";
	labelDeb.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	[self.view addSubview:labelDeb];
	if (![Context sharedContext].personalizado) {
        labelDeb.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:14];
    }
    else {
        labelDeb.font = [UIFont systemFontOfSize:14];
    }
    labelDeb.backgroundColor = [UIColor clearColor];
	[labelDeb release];
	
	UILabel* labelDeb2 = [[UILabel alloc] initWithFrame:CGRectMake(100, yInicial+1, 200, 25)];
	labelDeb2.text = [Util aplicarMascara:ticket.cuenta yMascara:[Cuenta getMascara]];
    labelDeb2.accessibilityLabel = [CommonFunctions replaceSymbolVoice:labelDeb2.text];
	labelDeb2.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	[self.view addSubview:labelDeb2];
	if (![Context sharedContext].personalizado) {
        labelDeb2.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:14];
    }
    else {
        labelDeb2.font = [UIFont boldSystemFontOfSize:14];
    }
    labelDeb2.backgroundColor = [UIColor clearColor];
	[labelDeb2 release];

	
	yInicial += 24;
	

	if (deuda.vencimiento && [deuda.vencimiento length] > 0) {
		
		UILabel* labelVto = [[UILabel alloc] initWithFrame:CGRectMake(28, yInicial, 70, 25)];
		labelVto.text = @"F. Vto.:";
		labelVto.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
		[self.view addSubview:labelVto];
		if (![Context sharedContext].personalizado) {
            labelVto.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:14];
        }
        else {
            labelVto.font = [UIFont systemFontOfSize:14];
        }
        labelVto.backgroundColor = [UIColor clearColor];
		[labelVto release];
		
		UILabel* labelVto2 = [[UILabel alloc] initWithFrame:CGRectMake(100, yInicial+1, 200, 25)];
		labelVto2.text =  deuda.vencimiento;
		labelVto2.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
		[self.view addSubview:labelVto2];
		if (![Context sharedContext].personalizado) {
            labelVto2.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:14];
        }
        else {
            labelVto2.font = [UIFont boldSystemFontOfSize:14];
        }
        labelVto2.backgroundColor = [UIColor clearColor];
		[labelVto2 release];
		
		yInicial += 24;
		
	}
	
	UILabel* labelDato = [[UILabel alloc] initWithFrame:CGRectMake(28, 245, 70, 25)];
	labelDato.text = @"S.E.U.O.";
	labelDato.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	[self.view addSubview:labelDato];
	if (![Context sharedContext].personalizado) {
        labelDato.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:12];
    }
    else {
        labelDato.font = [UIFont systemFontOfSize:12];
    }
    labelDato.backgroundColor = [UIColor clearColor];
	[labelDato release];

}

- (void)iniciarComprobanteSUBE {
	
	tipo = DD_COMPROBANTE_SUBE;
	
	self.title = @"Detalle de Pago";
	
	NSString *importe =ticket.importe;
	
	float yInicial = 119;
	
	UILabel* labelImport = [[UILabel alloc] initWithFrame:CGRectMake(28, yInicial, 70, 25)];
	labelImport.text =  @"Importe:";
	labelImport.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	[self.view addSubview:labelImport];
	if (![Context sharedContext].personalizado) {
        labelImport.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:14];
    }
    else {
        labelImport.font = [UIFont systemFontOfSize:14];
    }
    labelImport.backgroundColor = [UIColor clearColor];
	[labelImport release];
	
	
	UILabel* labelImport2 = [[UILabel alloc] initWithFrame:CGRectMake(113, yInicial+1, 190, 25)];
	labelImport2.text =  [NSString stringWithFormat:@"%@ %@",ticket.moneda, [Util formatSaldo:importe] ];
	labelImport2.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	[self.view addSubview:labelImport2];
	if (![Context sharedContext].personalizado) {
        labelImport2.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:14];
    }
    else {
        labelImport2.font = [UIFont boldSystemFontOfSize:14];
    }
    labelImport2.backgroundColor = [UIColor clearColor];
	[labelImport2 release];
	
	
	yInicial += 24;
	
	
	UILabel* labelId = [[UILabel alloc] initWithFrame:CGRectMake(28, yInicial, 70, 25)];
	labelId.text =  @"ID:";
	labelId.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	[self.view addSubview:labelId];
	if (![Context sharedContext].personalizado) {
        labelId.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:14];
    }
    else {
        labelId.font = [UIFont systemFontOfSize:14];
    }
    labelId.backgroundColor = [UIColor clearColor];
	[labelId release];
	
	UILabel* labelId2 = [[UILabel alloc] initWithFrame:CGRectMake(113, yInicial+1, 190, 25)];
	labelId2.text =  ticket.clienteId;
	labelId2.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	[self.view addSubview:labelId2];
	if (![Context sharedContext].personalizado) {
        labelId2.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:14];
    }
    else {
        labelId2.font = [UIFont boldSystemFontOfSize:14];
    }
    labelId2.backgroundColor = [UIColor clearColor];
	[labelId2 release];
	
	yInicial += 24;
	
	UILabel* labelDeb = [[UILabel alloc] initWithFrame:CGRectMake(28, yInicial, 70, 25)];
	labelDeb.text = @"Débito:";
	labelDeb.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	[self.view addSubview:labelDeb];
	if (![Context sharedContext].personalizado) {
        labelDeb.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:14];
    }
    else {
        labelDeb.font = [UIFont systemFontOfSize:14];
    }
    labelDeb.backgroundColor = [UIColor clearColor];
	[labelDeb release];
	
	UILabel* labelDeb2 = [[UILabel alloc] initWithFrame:CGRectMake(113, yInicial+1, 190, 25)];
	labelDeb2.text = [Util aplicarMascara:ticket.cuenta yMascara:[Cuenta getMascara]];
	labelDeb2.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	[self.view addSubview:labelDeb2];
	if (![Context sharedContext].personalizado) {
        labelDeb2.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:14];
    }
    else {
        labelDeb2.font = [UIFont boldSystemFontOfSize:14];
    }
    labelDeb2.backgroundColor = [UIColor clearColor];
	[labelDeb2 release];
		
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
    [(UIScrollView *)self.view setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 50)];
    
	lFooter.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	
	leyendFecha.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	
//	if (tipo == DD_PAGADO) {
	lFecha.text = ticket.fechaPago;
	lFecha.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
//	}
	
	lTitulo.text = ticket.empresa;
	lTitulo.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	
	lNroTrans.text =ticket.nroTransaccion;
	lNroTrans.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	
	//[self iniciarComprobante];
	
//	if (tipo == DD_PAGADO || tipo == DD_COMPROBANTE) {
		
		//CGRect frameScroll = CGRectMake(0, 0, 320, limite);
		//super.scrollView.frame = frameScroll;
		
		//CGRect frameText = CGRectMake(12, limite, 296, max - limite);
	//	UITextView *textView = [[UITextView alloc] initWithFrame:frameText];
	//	textView.backgroundColor = [UIColor clearColor];
	//	textView.text = @"Puede consultar e imprimir sus comprobantes en pagomiscuentas.com o en los cajeros de la Red Banelco.";
		
	//	[self.view addSubview:textView];
		
//	}
	
    if (![Context sharedContext].personalizado) {
        lFecha.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:16];
        lNroTrans.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:16];
        lFooter.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:9];
        lTitulo.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:16];
        leyendFecha.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:16];
        leyendNroTrans.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:16];
    }
	
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
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
	
    NSString *subject = [NSString stringWithFormat:@"%@ – Información de Pago Realizado", lTitulo.text];
	[picker setSubject:subject];

    NSString *fecha = ticket.fechaPago;
    NSString *importe = [NSString stringWithFormat:@"%@ %@",ticket.moneda, [Util formatSaldo:ticket.importe]];
    NSString *clienteID = ticket.clienteId;
    NSString *debito = [Util aplicarMascara:ticket.cuenta yMascara:[Cuenta getMascara]];
    NSString *nroTrans = ticket.nroTransaccion;
    
    NSString *strName = nil;
	if ([Context sharedContext].personalizado) {
		strName = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"Personalizacion"] objectForKey:@"AppName"];
	}
	else {
		strName = @"Banelco MÓVIL";
	}
    
	NSString *emailBody = [NSString stringWithFormat:@"%@\nFecha Pago: %@\nNro. Trans.: %@\nImporte: %@\nID: %@\nDébito: %@\nS.E.U.O",
						   subject,
						   fecha,
                           nroTrans,
                           importe,
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
	[lFecha release];
	[lNroTrans release];
	[lFooter release];
	[lTitulo release];
	[cuenta release];
	[deuda release];
	[ticket release];
	[leyendFecha release];
	[leyendNroTrans release];
    [super dealloc];
}


@end
