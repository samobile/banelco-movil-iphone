//
//  PagosListController.m
//  BanelcoMovilIphone
//
//  Created by German Levy on 9/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PagosListController.h"
#import "OtrasOperacionesMenu.h"
#import "MenuBanelcoController.h"
#import "Context.h"
#import "DetalleDeudaController.h"
#import "TipoDePagoController.h"
#import "DeudaCell.h"
#import "CommonUIFunctions.h"

#import "Rubro.h"
#import "EmpresasList.h"
#import "RubrosList.h"

#import "GAITracker.h"
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

#import "BuscarEmpresa.h"

@implementation PagosListController

@synthesize deudas;
@synthesize tableView, lb_sindeudas, btnOtras, btnNuevoPago;

int const PL_DEUDAS_ADHERIDAS = 0;
int const PL_OTROS_PAGOS = 1;


#pragma mark -
#pragma mark View lifecycle

- (void)GAItrack {
    // May return nil if a tracker has not already been initialized with a
    // property ID.
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    // This screen name value will remain set on the tracker and sent with
    // hits until it is set to a new value or to nil.
    [tracker set:kGAIScreenName value:@"Pantalla PagoMisCuentas"];
    // New SDK versions
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

- (id)init {
	if ((self = [super initWithNibName:@"PagosList" bundle:nil])) {
		self.title = @"Próximos Vencimientos";
		self.deudas = nil;
		self.lb_sindeudas.hidden = YES;
		//self.lb_sindeudas.alpha = 0;
		operacion = PL_DEUDAS_ADHERIDAS;
		
		conOtrasOperaciones = TRUE;
        nuevaTarjeta = NO;
	}
	return self;
}

- (id)initWithDeudas:(NSMutableArray *)_deudas {
	if ((self = [super initWithNibName:@"PagosList" bundle:nil])) {
		self.title = @"Próximos Vencimientos";
		self.deudas = _deudas;
		btnOtras.hidden = YES;
		operacion = PL_OTROS_PAGOS;
		self.lb_sindeudas.hidden = YES;
		//self.lb_sindeudas.alpha = 0;
		conOtrasOperaciones = FALSE;
        nuevaTarjeta = NO;
	}
	return self;
}

- (id)initWithDeudasTarjeta:(NSMutableArray *)_deudas {
    if ((self = [super initWithNibName:@"PagosList" bundle:nil])) {
        self.title = @"Próximos Vencimientos";
        self.deudas = _deudas;
        btnOtras.hidden = YES;
        operacion = PL_OTROS_PAGOS;
        self.lb_sindeudas.hidden = YES;
        //self.lb_sindeudas.alpha = 0;
        conOtrasOperaciones = FALSE;
        nuevaTarjeta = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
    if (![Context sharedContext].personalizado) {
        self.lb_sindeudas.font = [UIFont fontWithName:@"BanelcoBeau-Italic" size:17];
    }
	self.lb_sindeudas.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
    
    if (nuevaTarjeta) {
        self.btnOtras.hidden = YES;
    }
    
    if (operacion != PL_DEUDAS_ADHERIDAS || ![Context sharedContext].scanEnabled) {
        self.btnNuevoPago.hidden = YES;
        CGRect br = self.btnOtras.frame;
        br.origin.x = self.view.frame.size.width/2 - br.size.width/2;
        self.btnOtras.frame = br;
    }
    
    CGRect r = self.view.frame;
    self.view.frame = CGRectMake(r.origin.x, r.origin.y, r.size.width, IPHONE5_HDIFF(r.size.height));
    r = self.tableView.frame;
    self.tableView.frame = CGRectMake(r.origin.x, r.origin.y, r.size.width, IPHONE5_HDIFF(r.size.height));
    r = self.btnOtras.frame;
    self.btnOtras.frame = CGRectMake(r.origin.x, IPHONE5_HDIFF(r.origin.y), r.size.width, r.size.height);
    r = self.btnNuevoPago.frame;
    self.btnNuevoPago.frame = CGRectMake(r.origin.x, IPHONE5_HDIFF(r.origin.y), r.size.width, r.size.height);
}

- (IBAction)nuevoPago:(id)sender {
    if ([Context sharedContext].usuario.esRestringido) {
        [CommonUIFunctions showRestrictedAlert:@"Nuevo Pago" withDelegate:nil];
        return;
    }
    
    BuscarEmpresa *buscarEmpresa = [[BuscarEmpresa alloc] initWithType:BE_INICIAL_COD tipoAccion:EL_OTRAS_CUENTAS andRubro:nil];
    [[MenuBanelcoController sharedMenuController] pushScreen:buscarEmpresa];
}

- (void)nuevaTarjetaAccion {
    Rubro *rubro = [[Rubro alloc] init];
    rubro.codigo = RUBRO_TARJETAS;
    rubro.nombre = @"Tarjetas de Crédito";
    EmpresasList *empresasList = [[EmpresasList alloc] initWithRubro:rubro busqueda:@"" andTipoAccion:EL_PAGOS_TARJETA];
    [[MenuBanelcoController sharedMenuController] pushScreen:empresasList];
}
	
- (void)accionWithDelegate:(WheelAnimationController *)delegate {
	
    if (operacion != PL_DEUDAS_ADHERIDAS && self.deudas) {
        [delegate accionFinalizada:TRUE];
        [self refrescarContenido];
        return;
    }
    
	self.lb_sindeudas.hidden = YES;
	//self.lb_sindeudas.alpha = 0;
	Context *context = [Context sharedContext];
	
	context.selectedDeuda = nil;
	context.selectedCuenta = nil;
	
//	if (!self.deudas || conOtrasOperaciones) {
//		self.deudas = context.deudas;
//	}

//	if (!self.deudas || nuevaTarjeta) {
		self.deudas = [Deuda getDeudas];
//	}
	
	if (![deudas isKindOfClass:[NSError class]]) {
        if (nuevaTarjeta) {
            self.deudas = [self filtrarDeudas];
        }
		
	} else {
		
        NSString *errorCode = [[(NSError *)deudas userInfo] valueForKey:@"faultCode"];
        if ([errorCode isEqualToString:@"ss"]) {
            return;
        }
        
		NSString *errorDesc = [[(NSError *)deudas userInfo] valueForKey:@"description"];
		[CommonUIFunctions showAlert:@"Lista de deudas" withMessage:errorDesc andCancelButton:@"Cerrar"];
		
	}
	
	[delegate accionFinalizada:TRUE];
	
	[self refrescarContenido];
}

- (NSMutableArray *)filtrarDeudas {
    NSMutableArray *deudas2 = self.deudas;
//    if (!deudas2) {
//        deudas2 = [Deuda getDeudas];
//    }
    NSMutableArray *deudasTarjeta = [[[NSMutableArray alloc] init] autorelease];
    for (Deuda *d in deudas2) {
        if ([d.codigoRubro isEqualToString:RUBRO_TARJETAS]) {
            [deudasTarjeta addObject:d];
        }
    }
    return deudasTarjeta;
}

- (void)refrescarContenido {

	if (deudas && ![deudas isKindOfClass:[NSError class]] && [deudas count] > 0) {
		
		self.lb_sindeudas.hidden = YES;
		//self.lb_sindeudas.alpha = 0;
		self.tableView.hidden = NO;
        self.tableView.alpha = 1;
		//context.deudas = deudas;
		
		if (!conOtrasOperaciones) {
			btnOtras.hidden = YES;
		}
		
		[self.tableView reloadData];
		
	} else {
        if ([deudas isKindOfClass:[NSError class]]) {
            NSString *errorCode = [[(NSError *)deudas userInfo] valueForKey:@"faultCode"];
            if ([errorCode isEqualToString:@"ss"]) {
                return;
            }
		}
		self.lb_sindeudas.hidden = NO;
		//self.lb_sindeudas.alpha = 1;
		self.tableView.hidden = YES;
        self.tableView.alpha = 0;
        if (![deudas isKindOfClass:[NSError class]]) {
            [self.tableView reloadData];
        }
		
	}
    
    if (nuevaTarjeta) {
        [self.btnOtras setBackgroundImage:[UIImage imageNamed:@"btn_nuevatarjeta.png"] forState:UIControlStateNormal];
        [self.btnOtras setBackgroundImage:[UIImage imageNamed:@"btn_nuevatarjetaselec.png"] forState:UIControlStateHighlighted];
        [self.btnOtras removeTarget:self action:@selector(otrasOperaciones) forControlEvents:UIControlEventTouchUpInside];
        [self.btnOtras addTarget:self action:@selector(nuevaTarjetaAccion) forControlEvents:UIControlEventTouchUpInside];
        btnOtras.hidden = NO;
    }
	
}

- (IBAction)otrasOperaciones {

	CGRect rect = CGRectMake(0, 59, 320, 345);

	OtrasOperacionesMenu *otras = [[OtrasOperacionesMenu alloc] init];
	
	NSLog(@"Frame %f %f", otras.view.frame.origin.x, otras.view.frame.origin.y);
	
	[[MenuBanelcoController sharedMenuController] pushScreen:otras];
	
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    int cantDeudas = self.deudas? [self.deudas count] : 0;
	
	if (cantDeudas > 0) {
		
	}
	
	return cantDeudas;
	
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    Deuda *deuda = [self.deudas objectAtIndex:indexPath.row];
	
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[DeudaCell alloc] initWithReuseIdentifier:CellIdentifier] autorelease];
		[cell setAccessoryType:UITableViewCellEditingStyleDelete];
		[cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    
	[(DeudaCell *)cell cargarDeuda:deuda];
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	Deuda *deuda = [deudas objectAtIndex:indexPath.row];
	
	Context *context = [Context sharedContext];
	context.selectedDeuda = deuda;

	TipoDePagoController *deudaController = [[TipoDePagoController alloc] initWithDeuda:deuda forImporteTotal:YES];
	 [[MenuBanelcoController sharedMenuController] pushScreen:deudaController];
	 //[deudaController release];
	 
}

// Implemantacion de StackableScreen
- (void)screenWillBeBack {

	if (operacion != PL_DEUDAS_ADHERIDAS) {
//		Context *context = [Context sharedContext];
//		deudas = context.deudas;
//		[self refrescarContenido];
	}
    else {
    
        self.deudas = nil;
        [self.tableView reloadData];
        [self inicializar];
    }

}


- (void)dealloc {
    [super dealloc];
	[deudas release];
	[lb_sindeudas release];
}


@end

