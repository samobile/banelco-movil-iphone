#import "TransferenciasMenu.h"
#import "MenuOption.h"
#import "MenuOptionsHelper.h"
#import "CommonUIFunctions.h"
#import "Cuenta.h"
#import "MenuBanelcoController.h"
#import "CuentasList.h"
#import "TransferenciasImporte.h"
#import "Context.h"
#import "TransferenciasConsultaMenu.h"

#import "GAITracker.h"
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

@implementation TransferenciasMenu
@synthesize bancoTitulo;

- (void)GAItrack {
    // May return nil if a tracker has not already been initialized with a
    // property ID.
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    // This screen name value will remain set on the tracker and sent with
    // hits until it is set to a new value or to nil.
    [tracker set:kGAIScreenName value:@"Pantalla Transferencias"];
    // New SDK versions
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

- (id) init {
	if ((self = [super init])) {
		
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.title = @"Transferencias";
    self.title.accessibilityLabel = @"Submenú Transferencias";
	
}

- (void)aceptar:(int)cellIdx {
	
	int selectedIndex = [self getSelectedIndex:cellIdx];
	
	if (selectedIndex == CUENTAS_VINCULADAS) {
		
		//TransferenciasImporte *tsc = [[TransferenciasImporte alloc] initWithTitle:@"Cuentas Vinculadas" ctasOrigen:[Context getCuentas] ctasDestino:[Context getCuentas]];
		NSMutableArray *ctas = [Context getCuentas];
		if (ctas && [ctas count] > 1) {
			TransferenciasImporte *tsc = [[TransferenciasImporte alloc] initWithTitle:@"Cuentas Propias" tipoCuentas:CTAS_VINCULADAS];
			[[MenuBanelcoController sharedMenuController] pushScreen:tsc];
		}
		else if	(ctas && [ctas count] == 1) {
			[CommonUIFunctions showAlert:@"Transferencias" withMessage:@"Solo tiene una Cuenta. No puede realizar una transferencia desde/hacia la misma cuenta" andCancelButton:@"Cerrar"];
		}
		else {
			[CommonUIFunctions showAlert:@"Transferencias" withMessage:@"Momentáneamente Ud. no posee cuentas. Para mas información comuníquese con su banco" andCancelButton:@"Cerrar"];
		}
		
	} else if (selectedIndex == CUENTAS_CBU_AGENDADA) {
		
		//NSMutableArray *ctasCBU = [Cuenta getCuentasCBU];
		//if (ctasCBU && [ctasCBU count] > 0) {
			//TransferenciasImporte *tsc = [[TransferenciasImporte alloc] initWithTitle:@"Otras Ctas. CBU Agendada" ctasOrigen:[Context getCuentas] ctasDestino:[Cuenta getCuentasCBU]];
		TransferenciasImporte *tsc = [[TransferenciasImporte alloc] initWithTitle:@"A Otras Ctas. Agendadas" tipoCuentas:CTAS_AGENDADAS];
		[[MenuBanelcoController sharedMenuController] pushScreen:tsc];
		//}
		//else {
		//	[CommonUIFunctions showAlert:@"Transferencias" withMessage:@"Momentáneamente Ud. no posee cuentas con CBU agendada. Para mas información comuníquese con su banco" andCancelButton:@"Cerrar"];
		//}
		
	} 
	else if (selectedIndex == CONSULTAS_TRANSF) {
		
		TransferenciasConsultaMenu *tcm = [[TransferenciasConsultaMenu alloc] initWithColor:AM_VERDE];
		[[MenuBanelcoController sharedMenuController] pushScreen:tcm];
		
	}
	else {
		
	}
	
}

- (void)initOptions {
	
	[super.options removeAllObjects];
	
	MenuOptionsHelper *helper = [MenuOptionsHelper sharedMenuHelper];
	
	if ([helper isEnabled:CUENTAS_VINCULADAS]) {
		[super.options addObject:[[MenuOption alloc] initWithOption:CUENTAS_VINCULADAS andTitle:@"Cuentas Propias"]];
	}
	if ([helper isEnabled:CUENTAS_CBU_AGENDADA]) {
		[super.options addObject:[[MenuOption alloc] initWithOption:CUENTAS_CBU_AGENDADA andTitle:@"A Otras Ctas. Agendadas"]];
	}
	if ([helper isEnabled:CONSULTAS_TRANSF]) {
		[super.options addObject:[[MenuOption alloc] initWithOption:CONSULTAS_TRANSF andTitle:@"Consultas"]];
	}
	
	
	[super.tableView reloadData];
	
}

- (void)dealloc {
	[bancoTitulo release];
    [super dealloc];
}

@end
