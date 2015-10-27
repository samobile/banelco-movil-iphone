#import "CuentasList.h"
#import "Context.h"
#import "CuentaCell.h"
#import "UltimosMovimientos.h"
#import "MenuBanelcoController.h"
#import "ConsultaCBU.h"

#import "WS_ConsultarSaldos.h"
#import "WSUtil.h"
#import "CommonUIFunctions.h"
#import "TransferenciasADesc.h"
#import "Util.h"
#import "SaldosYDisponibles.h"
#import "DisponibleExtraccion.h"

#import "TransferenciasSaldosYDisponibles.h"

@implementation CuentasList

@synthesize pantallaCompleta, conSaldo, seleccionable;
@synthesize cuentasListType, cuentas, idxSelecCuenta, tableView, viewFrame;
@synthesize idxPathSelecCuenta;

int const CL_SALDOS = 0;
int const CL_SALDOS_Y_DISPONIBLES = 1;
int const CL_TRANS_ORIGEN = 2;
int const CL_TRANS_DESTINO = 3;
int const CL_ULT_MOVIMIENTOS = 4;
int const CL_PAGAR = 5;
int const CL_CONSULTA_CBU = 6; 
int const CL_AGENDA = 7;
int const CL_SALDOS_Y_DISPONIBLES_TRANSFER = 8;
int const CL_TASAS_PLAZO_FIJO = 9;
int const CL_DISPONIBLES = 10;



-(id) initConSaldo:(BOOL) saldo andTipoLista:(int) tipoLista{
	
	if(self=[super init]){
		self.conSaldo = saldo;
		self.pantallaCompleta = YES;
		self.cuentasListType = tipoLista;
		//self.tableView.backgroundColor = [UIColor clearColor];
		self.tableView.rowHeight = 78;
		
		if(self.cuentasListType == CL_AGENDA){
			//self.cuentas = [Context getCuentasCBU];
			self.title = @"Agenda";
		}
		if (self.cuentasListType != CL_AGENDA && self.cuentasListType != CL_DISPONIBLES) {
			self.cuentas = [Context getCuentas];
		}

		
		if(self.cuentasListType == CL_SALDOS){
			self.title = @"Saldos"; 
			for (int i=0;i<[cuentas count];i++){
				[[cuentas objectAtIndex:i] setSaldo:@""];
			}
		}else if(self.cuentasListType == CL_SALDOS_Y_DISPONIBLES){
			self.title = @"Saldos y Disponibles";
		}else if(self.cuentasListType == CL_SALDOS_Y_DISPONIBLES_TRANSFER){
			self.title = @"Saldos y Disponibles";
		}else if(self.cuentasListType == CL_CONSULTA_CBU){
			self.title = @"Consulta de CBU";
		}else if(self.cuentasListType == CL_ULT_MOVIMIENTOS){
			self.title = @"Últimos Movimientos";
		}
        else if(self.cuentasListType == CL_DISPONIBLES){
            self.title = @"Disponible de Extracción";
        }
		
		
	}
	return self;
}


-(id) initList:(NSString *)title ofType:(int)type withItems:(NSMutableArray *)items inFrame:(CGRect)frame toFullScreen:(BOOL)fs {
	
	if(self = [super initWithNibName:@"CuentasList" bundle:nil]) {
		
		NSLog(@"init With items");
		
		if (title) {
			self.title = title;
		}
		
		self.cuentasListType = type;
		self.cuentas = items;
		
		self.viewFrame = frame;
		
		self.pantallaCompleta = fs;
		
		//self.view = [[UIView alloc] initWithFrame:frame];
		//self.tableView = [[UITableView alloc] initWithFrame:frame];
		
	}
	return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
	NSLog(@"view Did load");
	self.tableView.frame = self.viewFrame;
	self.tableView.delegate = self;
	//self.tableView.rowHeight = 78;
	//[self.view addSubview:tableView];
	self.tableView.rowHeight = pantallaCompleta? 78 : 50;
	
	//Solucion al fondo blanco en Transferencias - Agenda cuando la cant. de ctas no llega a cubrir toda la pantalla
	//if(self.cuentasListType == CL_AGENDA){
		self.tableView.backgroundColor = [UIColor clearColor];
	//}
	
	idxSelecCuenta = -1;

}


- (void)accionWithDelegate:(WheelAnimationController *)delegate {

	if (self.cuentasListType == CL_AGENDA) {
		self.cuentas = [Cuenta getCuentasCBU];
		if (self.cuentas && [self.cuentas isKindOfClass:[NSError class]]) {
            NSString *errorCode = [[(NSError *)self.cuentas userInfo] valueForKey:@"faultCode"];
            if ([errorCode isEqualToString:@"ss"]) {
                return;
            }
			NSString *errorDesc = [[(NSError *)self.cuentas userInfo] valueForKey:@"description"];
			self.cuentas = nil;
			[CommonUIFunctions showAlert:@"Cuentas con CBU Agendadas" withMessage:errorDesc cancelButton:@"Volver" andDelegate:self];
		}
		else if (!self.cuentas || [self.cuentas count] == 0) {
			[CommonUIFunctions showAlert:@"Transferencias" withMessage:@"Momentáneamente Ud. no posee cuentas con CBU agendada. Para mas información comuníquese con su banco" cancelButton:@"Volver" andDelegate:self];
		}
		else {
			[self.tableView reloadData];
		}
		[delegate accionFinalizada:TRUE];
		return;
	}
    
    if (self.cuentasListType == CL_DISPONIBLES) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (Cuenta *c in [Context getCuentas]) {
            if ([c.simboloMoneda isEqualToString:@"$"]) {
                [array addObject:c];
            }
        }
        self.cuentas = array;
        [self.tableView reloadData];
        [delegate accionFinalizada:TRUE];
        return;
    }
	
	NSLog(@"accion en cuentasList");
	id result;
	WS_ConsultarSaldos *request = nil;
	Context *context = [Context sharedContext];
	NSLog(@"CAntidad de cuentas %d",[cuentas count]);
	
	
	for (int i=0; i<[cuentas count]; i++) {
		
		request = [[WS_ConsultarSaldos alloc] init];
		request.userToken = [context getToken];	
		request.numeroCuenta = [[cuentas objectAtIndex:i] numero];
		request.codigoTipoCuenta = [[[cuentas objectAtIndex:i] codigoTipoCuenta] intValue];
		request.codigoMonedaCuenta = [[cuentas objectAtIndex:i] codigoMoneda];
		result = [WSUtil execute:request];
		
		if (![result isKindOfClass:[NSError class]]) {

			NSLog(@"EL SALDO ES = %@",[result saldo]);
			[[cuentas objectAtIndex:i] setSaldo:[Util formatSaldo:[result saldo]]];
		
		} else {
			NSString *errorCode = [[(NSError *)result userInfo] valueForKey:@"faultCode"];
            if ([errorCode isEqualToString:@"ss"]) {
                return;
            }
            if (self.cuentasListType == CL_SALDOS) {
                [[cuentas objectAtIndex:i] setSaldo:@"***"];
            }
            else {
                NSString *errorDesc = [[(NSError *)result userInfo] valueForKey:@"description"];
                [CommonUIFunctions showAlert:@"Consulta de saldo" withMessage:errorDesc cancelButton:@"Volver" andDelegate:self];

                [delegate accionFinalizada:FALSE];
                return;
            }
			
		}
		
	}
	[self.tableView reloadData];
	
	[delegate accionFinalizada:TRUE];

}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
	return 1;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.cuentas? [self.cuentas count] : 0;

}

- (UITableViewCell *)tableView:(UITableView *)tableV cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	NSLog(@"pido la celda numero %d",indexPath.row);
    //static NSString *CellIdentifier = @"Cell";
	//cambia el identificador para cada celda porque a veces confunde los identificadores
	//para celdas que aun no se habian creado
	NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d",indexPath.row];

	Context *context = [Context sharedContext];
	Cuenta *cuenta = [self.cuentas objectAtIndex:indexPath.row];
	context.selectedCuenta = cuenta;
	
	
    CuentaCell *cell = (CuentaCell *)[tableV dequeueReusableCellWithIdentifier:CellIdentifier];
  
	if (cell == nil) {
		
		if (self.pantallaCompleta) {
			cell = [[CuentaCell alloc] initWithReuseIdentifier:CellIdentifier andCuenta:cuenta conSaldo:self.conSaldo];
			[cell setAccessoryType:UITableViewCellEditingStyleDelete ];
		} else {
			cell = [[CuentaCell alloc] initSmallWithReuseIdentifier:CellIdentifier andCuenta:cuenta inWidth:self.viewFrame.size.width];
		}
		if (self.cuentasListType == CL_PAGAR) {
			[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
		}
		else {
			[cell setSelectionStyle:UITableViewCellSelectionStyleGray];
		}
		

	} else {
		if (cuenta.accountType == C_CBU) {
			cell.cuentaDescripcion.text = [cuenta getDescripcion];
            cell.cuentaDescripcion.accessibilityLabel = [cell.cuentaDescripcion.text stringByReplacingOccurrencesOfString:@"U$S" withString:@"dolares"];
            cell.cuentaDescripcion.accessibilityLabel = [cell.cuentaDescripcion.text stringByReplacingOccurrencesOfString:@"$" withString:@"pesos"];
		}
		else {
			cell.cuentaSaldo.text = [[cuentas objectAtIndex:indexPath.row] saldo];
            cell.cuentaSaldo.accessibilityLabel = [cell.cuentaSaldo.text stringByReplacingOccurrencesOfString:@"U$S" withString:@"dolares"];
            cell.cuentaSaldo.accessibilityLabel = [cell.cuentaSaldo.text stringByReplacingOccurrencesOfString:@"$" withString:@"pesos"];
		}
		
	}

    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	Context *context = [Context sharedContext];
	Cuenta* cuenta = (Cuenta *)[cuentas objectAtIndex:indexPath.row];
	context.selectedCuenta = cuenta;
	
	if(self.cuentasListType == CL_SALDOS) {
		
		UltimosMovimientos* uMovimientos = [[UltimosMovimientos alloc] initWithCuenta:cuenta];
		[[MenuBanelcoController sharedMenuController] pushScreen:uMovimientos];
		
	} else if(self.cuentasListType == CL_SALDOS_Y_DISPONIBLES) {
		
		SaldosYDisponibles *sd = [[SaldosYDisponibles alloc] initWithCuenta:cuenta];
		[[MenuBanelcoController sharedMenuController] pushScreen:sd];
		
	} else if(self.cuentasListType == CL_SALDOS_Y_DISPONIBLES_TRANSFER) {
		
		TransferenciasSaldosYDisponibles *sd = [[TransferenciasSaldosYDisponibles alloc] initWithCuenta:cuenta];
		[[MenuBanelcoController sharedMenuController] pushScreen:sd];
		
	} else if(self.cuentasListType == CL_CONSULTA_CBU) {
		
		ConsultaCBU* ccbu = [[ConsultaCBU alloc] initWithCuenta:cuenta];
		[[MenuBanelcoController sharedMenuController] pushScreen:ccbu];
		
	} else if(self.cuentasListType == CL_TRANS_ORIGEN) {
		
	} else if(self.cuentasListType == CL_TRANS_DESTINO) {
		
	} else if(self.cuentasListType == CL_ULT_MOVIMIENTOS) {
		
		UltimosMovimientos* uMovimientos = [[UltimosMovimientos alloc] initWithCuenta:cuenta];
		[[MenuBanelcoController sharedMenuController] pushScreen:uMovimientos];
		
	} else if(self.cuentasListType == CL_AGENDA) {
		TransferenciasADesc* adesc = [[TransferenciasADesc alloc] initWithCuenta:cuenta];
		[[MenuBanelcoController sharedMenuController] pushScreen:adesc];

	} else if(self.cuentasListType == CL_PAGAR) {
		
		CuentaCell *ce = [tableView cellForRowAtIndexPath:indexPath];
		[ce setSelected:YES animated:NO];
		if (idxSelecCuenta >= 0 && (idxSelecCuenta != indexPath.row)) {
			ce = [tableView cellForRowAtIndexPath:idxPathSelecCuenta];
			[ce setSelected:NO animated:NO];
		}
		self.idxPathSelecCuenta = indexPath;
		self.idxSelecCuenta = indexPath.row;		
				
		[tableView deselectRowAtIndexPath:[NSIndexPath indexPathWithIndex:idxSelecCuenta] animated:NO];
		self.idxSelecCuenta = indexPath.row;
		[tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
		
		
	} else if(self.cuentasListType == CL_TASAS_PLAZO_FIJO) {
		
	}
    else if(self.cuentasListType == CL_DISPONIBLES) {
        
        DisponibleExtraccion* disp = [[DisponibleExtraccion alloc] initWithCuenta:cuenta];
        [[MenuBanelcoController sharedMenuController] pushScreen:disp];
        
    }
	
}


- (Cuenta *)getSelectedCuenta {

	if (cuentas && idxSelecCuenta <= [cuentas count]-1 && idxSelecCuenta >= 0) {
		return [cuentas objectAtIndex:idxSelecCuenta];
	} else {
		return nil;
	}

}


- (void)dealloc {
	[tableView release];
    [super dealloc];
}


@end

