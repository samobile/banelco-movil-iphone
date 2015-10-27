//
//  DetalleDeudaController.m
//  BanelcoMovilIphone
//
//  Created by German Levy on 9/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DetalleDeudaController.h"
#import "Util.h"
#import "Context.h"
#import "ExecutePagarDeuda.h"
#import "WaitingAlert.h"

@implementation DetalleDeudaController

@synthesize cuenta, deuda, ticket, lblEmpresa;

int const DD_APAGAR = 0;
int const DD_PAGADO = 1;
int const DD_COMPROBANTE = 2;
int const DD_COMPROBANTE_SUBE = 3;


- (id)initTipo:(int)_tipo withDeuda:(Deuda *)_deuda {
    //if ((self = [super initWithNibName:@"DetalleDeudaAPagar" bundle:nil])) {
	if ((self = [super init])) {
        self.deuda = _deuda;
		[self iniciar:_tipo];
    }
    return self;
}

- (id)initWithDeuda:(Deuda *)_deuda andCuenta:(Cuenta *)_cuenta {
    //if ((self = [super initWithNibName:@"DetalleDeudaAPagar" bundle:nil])) {
	if ((self = [super init])) {
        self.deuda = _deuda;
		self.cuenta = _cuenta;
		[self iniciar:DD_APAGAR];
		//[self iniciarAPagar];
    }
    return self;
}

- (id)initWithDeuda:(Deuda *)_deuda cuenta:(Cuenta *)_cuenta andTicket:(Ticket *)_ticket {
    //if ((self = [super initWithNibName:@"DetalleDeudaAPagar" bundle:nil])) {
	if ((self = [super init])) {
        self.deuda = _deuda;
		self.cuenta = _cuenta;
		self.ticket = _ticket;
		[self iniciar:DD_PAGADO];
    }
    return self;
}

- (id)initWithTicket:(Ticket *)_ticket {
    //if ((self = [super initWithNibName:@"DetalleDeudaAPagar" bundle:nil])) {
	if ((self = [super init])) {
        self.deuda = nil;
		self.cuenta = nil;
		self.ticket = _ticket;
		[self iniciarComprobante];
    }
    return self;
}


- (void)iniciar:(int)t {
	
	tipo = t;
	
	if (tipo == DD_APAGAR) {
		
		self.title = @"Estás pagando";
		
	} else if (tipo == DD_PAGADO) {
		
		self.title = @"Pago Realizado";
		self.nav_volver = NO;
		
	}
	
	// Nombre Empresa
	[titulos addObject: @"Empresa"];
	[datos addObject: deuda.nombreEmpresa];
	
	// Descripcion usuario
	if (deuda.descripcionUsuario && ![deuda.descripcionUsuario isEqualToString:@""]) {
		[titulos addObject: @"Desc."];
		[datos addObject: deuda.descripcionUsuario];
	}
	
	// Fecha pago
	if (tipo == DD_PAGADO) {
		[titulos addObject: @"Fecha Pago"];
		[datos addObject: ticket.fechaPago];
	}
	
	// Importe
	NSString *importe = ![deuda.otroImporte isEqualToString:@"0.0"]? deuda.otroImporte : deuda.importe;
	[titulos addObject:@"Importe"];
	[datos addObject:[NSString stringWithFormat:@"%@ %@", deuda.monedaSimbolo, [Util formatSaldo:importe]]];
	
	// ID Cliente
	NSString *codigoidCliente = @"";
	if ([self.deuda.codigoRubro isEqualToString:@"TCIN"] || [self.deuda.codigoRubro isEqualToString:@"TCRE"]) {
		codigoidCliente = [Util formatDigits:self.deuda.idCliente];
	} else {
		codigoidCliente = self.deuda.idCliente;
	}
	[titulos addObject:@"ID"];
	[datos addObject:codigoidCliente];
	
	Context *context = [Context sharedContext];
	
	// Dato adicional
	if (context.selectedDeuda.datoAdicional && (![context.selectedDeuda.datoAdicional isEqualToString:@""])) {
		[titulos addObject: context.selectedDeuda.datoAdicional];
		[datos addObject: context.selectedDeuda.leyenda];
	}
	
	// Fecha Vto.
	if (deuda.vencimiento && [deuda.vencimiento length] > 0) {
		
		if (tipo == DD_APAGAR) {
			[titulos addObject:@"Fecha Vto."];
		} else if (tipo == DD_PAGADO) {
			[titulos addObject:@"F. Vto."];
		}
		
		[datos addObject:deuda.vencimiento];
	}
	
	// Cta Debito
	[titulos addObject:@"Débito"];
	[datos addObject:[NSString stringWithFormat:@"%@ %@", cuenta.descripcionCortaTipoCuenta, [cuenta descripcionParaCBU]]];
	
	if (tipo == DD_PAGADO) {
		
		[titulos addObject: @"Nro. Transacción"];
		[datos addObject: ticket.nroTransaccion];
		
		[titulos addObject:@"S.E.U.O."];
		[datos addObject:@""];
	}
	
}

- (void)iniciarComprobante {
	
	tipo = DD_COMPROBANTE;
	
	self.title = @"Detalle de Pago";
		
	[titulos addObject: @"Empresa"];
	[datos addObject: ticket.empresa];
	
	[titulos addObject: @"Fecha Pago"];
	[datos addObject: ticket.fechaPago];
	
	[titulos addObject: @"Importe"];
	[datos addObject:[NSString stringWithFormat:@"%@ %@", ticket.moneda, [Util formatSaldo:ticket.importe]]];
	
	[titulos addObject: @"ID"];
	[datos addObject: ticket.clienteId];
	
	[titulos addObject: @"Débito"];
	[datos addObject: [Util aplicarMascara:ticket.cuenta yMascara:[Cuenta getMascara]]];
	
	[titulos addObject: @"Nro. Transacción"];
	[datos addObject: ticket.nroTransaccion];
	
	[titulos addObject:@"S.E.U.O."];
	[datos addObject:@""];
	
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	int limite = 260;
	int max = 317;
	
    if (![Context sharedContext].personalizado) {
        lblEmpresa.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:20];
    }
    
	if (tipo == DD_APAGAR) {
		
		// Nombre Empresa
		//self.lblEmpresa.text = deuda.nombreEmpresa;
		
		self.tableView.frame = CGRectMake(5, -10, 310, limite + 15);
		
		UIButton *btn_pagar = [UIButton buttonWithType:UIButtonTypeCustom];
        btn_pagar.accessibilityLabel = @"Pagar";
		btn_pagar.frame = CGRectMake(160-51, limite+15, 102, 32);
		[btn_pagar setBackgroundImage:[UIImage imageNamed:@"btn_pagar.png"] forState:UIControlStateNormal];
		[btn_pagar setImage:[UIImage imageNamed:@"btn_pagarselec.png"] forState:UIControlStateHighlighted];
		[btn_pagar addTarget:self action:@selector(pagar) forControlEvents:UIControlEventTouchUpInside];
		
		[self.view addSubview:btn_pagar];
		
	} else if (tipo == DD_PAGADO || tipo == DD_COMPROBANTE) {
		
		self.tableView.frame = CGRectMake(5, -10, 310, limite + 15);
		
		CGRect frameText = CGRectMake(12, limite, 296, max - limite + 5);
		UITextView *textView = [[UITextView alloc] initWithFrame:frameText];
		textView.backgroundColor = [UIColor clearColor];
		textView.text = @"Puedes consultar e imprimir sus comprobantes en pagomiscuentas.com o en los cajeros de la Red BANELCO.";
		if (![Context sharedContext].personalizado) {
            textView.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:14];
        }
		[self.view addSubview:textView];
		
	}
	
	self.tableView.backgroundColor = [UIColor clearColor];

}


- (IBAction)pagar {

	
	ExecutePagarDeuda *pagarDeuda = [[ExecutePagarDeuda alloc] init];
	WaitingAlert* alert = [[WaitingAlert alloc] init];
	[self.view addSubview:alert];
	[alert startWithSelector:@"execute" fromTarget:pagarDeuda];

}


- (void)dealloc {
	[deuda release];
	[cuenta release];
    [super dealloc];
}


@end
