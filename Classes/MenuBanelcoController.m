#import "MenuBanelcoController.h"
#import "Opcion.h"
#import "ConsultasMenu.h"
#import "PagoMisCuentasController.h"
#import "CargaCelularMenu.h"
#import "Context.h"
#import "TransferenciasMenu.h"
#import "MCUITabBarItem.h"
#import "MCUITabBarViewController.h"
#import "CuentasList.h"
#import "StackableScreen.h"
#import "CommonFunctions.h"

@implementation MenuBanelcoController

@synthesize consultasScreen;
@synthesize pagoMisCuentasScreen;
@synthesize cargaCelularScreen;
@synthesize transferenciasScreen;
@synthesize header, titulo;
@synthesize mctabbar;
@synthesize actualIndiceScreen; // 0 = consultas , 1 = pagoMisCuentas , 2 = carga Celular , 3 = tranferencias
@synthesize barra;
@synthesize pantallas;
@synthesize btn_volver, btn_inicio;
@synthesize centralScreenSpace, dismissOnly, smb_bottom, fnd_tabbar;

static MenuBanelcoController * _sharedMenuController = nil;

+ (void)resetMenuBanelcoController {
    if (_sharedMenuController) {
        [_sharedMenuController release];
    }
    _sharedMenuController = nil;
}

+(MenuBanelcoController *)sharedMenuController
{
	@synchronized([MenuBanelcoController class])
	{
		if (!_sharedMenuController)
			_sharedMenuController = [[self alloc] init];

		return _sharedMenuController;
	}
	
	return nil;
}

-(id) initWithIndiceActual:(int) ind {
	
	
	NSLog(@"initWithIndiceActual");
	if (self = [super init]){
		self.actualIndiceScreen = ind;
		pantallas = [[Stack alloc] init];
	}
	@synchronized([MenuBanelcoController class]) {
		_sharedMenuController = self;
	}
	return self;
	
}

-(id) init {
	NSLog(@"init");
	if (self = [super init]){
		self.actualIndiceScreen = 0;
		pantallas = [[Stack alloc] init];
	}
	@synchronized([MenuBanelcoController class]) {
		_sharedMenuController = self;
	}
	return self;
	
}

- (void)viewDidLoad {
	[super viewDidLoad];
	NSLog(@"MenuBanelcoController - View Did Load");
	
    self.dismissOnly = NO;
    
	// HEADER
	//header = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 59)];
	//header.image = [UIImage imageNamed:@"fnd_header.png"];
	
	UIImageView* imV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 9, 320, 41)];
	imV.image = [UIImage imageNamed:[[[Context sharedContext] banco] imagenTitulo]];
//    UIImageView* imV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 9, 320, 44)];
//	imV.image = [UIImage imageNamed:@"lgo_appheader.png"];
	
	//[self.view addSubview:header];
	[self.view addSubview:imV];
	
	[imV release];
	
	// CONTENIDO
	//self.centralScreenSpace = [[UIView alloc] initWithFrame:CGRectMake(0, 87, 320, 317)];
	//self.centralScreenSpace.clipsToBounds = TRUE;
//	self.centralScreenSpace.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"fnd_app.png"]];
    CGRect r = centralScreenSpace.frame;
    r.size.height = IPHONE5_HDIFF(centralScreenSpace.frame.size.height);
    centralScreenSpace.frame = r;
    
    UIImageView *fondo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.centralScreenSpace.frame.size.width, IPHONE5_HDIFF(self.centralScreenSpace.frame.size.height))];
    fondo.image = [UIImage imageNamed:@"fnd_app.png"];
    [self.centralScreenSpace addSubview:fondo];
    [fondo release];
	
	//CGRect initRect = CGRectMake(-320, 0, 320, 317);
    CGRect initRect = CGRectMake(-320, 0, 320, IPHONE5_HDIFF(317));
	//CGRect visibleRect = CGRectMake(0, 0, 320, 317);
    CGRect visibleRect = CGRectMake(0, 0, 320, IPHONE5_HDIFF(317));
	
	consultasScreen = [[ConsultasMenu alloc] initWithColor:AM_FUCSIA];
	consultasScreen.view.frame = initRect;
	[self.centralScreenSpace addSubview:consultasScreen.view];
	
	pagoMisCuentasScreen = [[PagosListController alloc] init] ;
	pagoMisCuentasScreen.view.frame = initRect;
	[self.centralScreenSpace addSubview:pagoMisCuentasScreen.view];
	
	cargaCelularScreen = [[CargaCelularMenu alloc] initWithColor:AM_VIOLETA];
	cargaCelularScreen.view.frame = initRect;
	[self.centralScreenSpace addSubview:cargaCelularScreen.view];
	
	transferenciasScreen = [[TransferenciasMenu alloc] initWithColor:AM_VERDE];
	transferenciasScreen.view.frame = initRect;
	[self.centralScreenSpace addSubview:transferenciasScreen.view];

	//[self.view addSubview:self.centralScreenSpace];

	// Sombra
//	UIImageView* sombra = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15, 320, 433)];
//	sombra.image = [UIImage imageNamed:@"smb.png"];
//	[self.view addSubview:sombra];
//	[sombra release];
	

	// BARRA
	//self.barra = [[UIImageView alloc] initWithFrame:CGRectMake(0, 404, 320, 56)];
	//self.barra.image = [UIImage imageNamed:@"fnd_toolbar.png"];
	//[self.view addSubview:self.barra];
	
	//mctabbar = [[MCUITabBarViewController alloc] initWithFrame:CGRectMake(0, 404, 320, 56)];
    self.mctabbar = [[MCUITabBarViewController alloc] initWithFrame:CGRectMake(0, IPHONE5_HDIFF(404), 320, 56)];
	MCUITabBarItem* item = [[MCUITabBarItem alloc] initNombreImagenSimple:@"btn_tbrconsultas.png" andNombreImagenSeleccion:@"btn_tbrconsultasselec.png"];
    item.accessibilityLabel = @"Menu, Consultas";
    item.tag = 0;
	[mctabbar addItem:item withAnimation:YES ];
	
	MCUITabBarItem* item2 = [[MCUITabBarItem alloc] initNombreImagenSimple:@"btn_tbrpmc.png" andNombreImagenSeleccion:@"btn_tbrpmcselec.png"];
    item2.accessibilityLabel = @"Menu, Pago mis cuentas";
    item2.tag = 1;
	[mctabbar addItem:item2 withAnimation:YES ];
	
	MCUITabBarItem* item3 = [[MCUITabBarItem alloc] initNombreImagenSimple:@"btn_tbrrecarga.png" andNombreImagenSeleccion:@"btn_tbrrecargaselec.png"];
    item3.accessibilityLabel = @"Menu, Recarga de celular";
    item3.tag = 2;
	[mctabbar addItem:item3 withAnimation:YES ];
	
	MCUITabBarItem* item4 = [[MCUITabBarItem alloc] initNombreImagenSimple:@"btn_tbrtransferencias.png" andNombreImagenSeleccion:@"btn_tbrtransferenciasselec.png"];
    item4.accessibilityLabel = @"Menu, Transferencias";
    item4.tag = 3;
	[mctabbar addItem:item4 withAnimation:YES ];
	self.mctabbar.delegate = self;
	[self.view addSubview:mctabbar];


    if (![Context sharedContext].personalizado) {
        self.titulo.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:17];
    }
    
    //mover tabbar para iphone5
    if (IS_IPHONE_5) {
        CGRect r = self.smb_bottom.frame;
        r.origin.y = IPHONE5_HDIFF(r.origin.y);
        self.smb_bottom.frame = r;
        
        r = self.fnd_tabbar.frame;
        r.origin.y = IPHONE5_HDIFF(r.origin.y);
        self.fnd_tabbar.frame = r;
        
        r = self.centralScreenSpace.frame;
        r.size.height = IPHONE5_HDIFF(r.size.height);
        self.centralScreenSpace.frame = r;
        
        [self.view bringSubviewToFront:self.fnd_tabbar];
        [self.view bringSubviewToFront:mctabbar];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
    if (!pantallas) {
        pantallas = [[Stack alloc] init];
    }
    if (!self.dismissOnly) {
        // Se muestra opcion seleccionada inicialmente
        [self opcionInicio:self.actualIndiceScreen];
    }
    self.dismissOnly = NO;
}


-(void) opcionInicio:(int) opc {
	NSLog(@"opcionInicio");
	[mctabbar resetSelection];
	[(MCUITabBarItem*)[mctabbar.listaDeItems objectAtIndex:opc] cambiarEstado];
	
	StackableScreen *controller;
	
	switch (opc)
	{
		case 0:
			controller = consultasScreen;
			break;
		case 1:
			controller = pagoMisCuentasScreen;
			break;
		case 2:
			controller = cargaCelularScreen;
			break;
		case 3:
			controller = transferenciasScreen;
			break;
	}
	controller.view.alpha = 1.0;
	//controller.view.frame = CGRectMake(0, 0, 320, 317);
    controller.view.frame = CGRectMake(0, 0, 320, IPHONE5_HDIFF(317));
	[self initScreen:controller];
		
}

- (void)initScreen:(StackableScreen *)screen {

	StackableScreen *controller = (StackableScreen *)[pantallas pop];
	
	while (controller) {
		
		[controller.view removeFromSuperview];
		controller = (StackableScreen *)[pantallas pop];
	}
	
	[pantallas resetStackWith:screen];
	
	[self.centralScreenSpace addSubview:screen.view];
	//personalizacion
	self.titulo.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TitleTxtColor"];
	
	self.titulo.text = screen.title;
    self.titulo.accessibilityLabel = screen.title.accessibilityLabel;
	
	self.btn_inicio.enabled = YES;
	self.btn_volver.hidden = YES;
	
	[screen viewDidAppear:NO];
    
    [screen performSelector:@selector(GAItrack)];
	
	[self terminoDeCargar];

}

- (void)pushScreen:(StackableScreen *)screen {

    
    
	[self.centralScreenSpace addSubview:screen.view];

	UIView *actualView = [(StackableScreen *)[pantallas getLastObject] view];

	if (!actualView) {
		
		actualView = [[self getViewControllerByIndice:self.actualIndiceScreen] view];
		
	}
	
	//actualView.frame = CGRectMake(0, 0, 320, 317);
    actualView.frame = CGRectMake(0, 0, 320, IPHONE5_HDIFF(317));
	//screen.view.frame = CGRectMake(320, 0, 320, 317);
    screen.view.frame = CGRectMake(320, 0, 320, IPHONE5_HDIFF(317));
	screen.view.alpha = 0;
	actualView.alpha = 1;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	[UIView setAnimationDuration:0.35];
	[UIView setAnimationDidStopSelector:@selector(terminoDeCargar)];
	[UIView setAnimationDelegate:self];
	screen.view.alpha = 1;
	actualView.alpha = 0;
	//actualView.frame = CGRectMake(-320, 0, 320, 317);
    actualView.frame = CGRectMake(-320, 0, 320, IPHONE5_HDIFF(317));
	//screen.view.frame = CGRectMake(0, 0, 320, 317);
    screen.view.frame = CGRectMake(0, 0, 320, IPHONE5_HDIFF(317));
	[UIView commitAnimations];
	
	
	[pantallas push:screen];
	
	// Botones navegacion
	self.btn_inicio.enabled = YES;
	self.btn_volver.hidden = !screen.nav_volver;
	// Titulo pantalla
	self.titulo.text = screen.title;
    self.titulo.accessibilityLabel = screen.title.accessibilityLabel;
    UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, self.titulo);
}


-(void) terminoDeCargar {

	StackableScreen* vc = (StackableScreen *)[pantallas getLastObject];
	if ([vc isKindOfClass:[WheelAnimationController class]] == YES ) {
		if (([vc isMemberOfClass:[CuentasList class]] == YES ) && (![vc conSaldo] && [vc cuentasListType] != CL_AGENDA && [vc cuentasListType] != CL_DISPONIBLES)){
			return;
		}
		[vc inicializar];
		
	}
	else {
		if ([vc respondsToSelector:@selector(screenDidAppear)]) {
			[vc performSelector:@selector(screenDidAppear)];
		}
	}

}

-(void) peekScreen {
	
	UIView *actualView = [(StackableScreen *)[pantallas pop] view];
	
	if (!actualView) {
		
		[self dismissModalViewControllerAnimated:YES];
		
		return;
		
	}
	
	StackableScreen *prevController = (StackableScreen *)[pantallas getLastObject];
	
	if (!prevController) {
		
		[actualView removeFromSuperview];
		
		[self dismissModalViewControllerAnimated:YES];
		
		return;
		
	}
	
	// Si es el inicio de la pila, deshabilito el boton "Inicio"
	if ([pantallas.array count] == 1) {
		self.btn_inicio.enabled = YES;
		self.btn_volver.hidden = YES;
	}
	//Agregado para cuando se vuelve de una pantalla donde se deshabilito el boton "volver".
	else {
		self.btn_volver.hidden = !prevController.nav_volver;
	}

	//Al volver a la pantalla de lista de Agenda, recarga la tabla
	if (([prevController isMemberOfClass:[CuentasList class]] == YES ) && ([prevController cuentasListType] == CL_AGENDA)){
		[[prevController tableView] reloadData];
	}
	
	actualView.frame = CGRectMake(0, 0, 320, IPHONE5_HDIFF(317));
	prevController.view.frame = CGRectMake(-320, 0, 320, IPHONE5_HDIFF(317));
	prevController.view.alpha = 0;
	actualView.alpha = 1;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	[UIView setAnimationDuration:0.35];
	prevController.view.alpha = 1;
	actualView.alpha = 0;
	actualView.frame = CGRectMake(320, 0, 320, IPHONE5_HDIFF(317));
	prevController.view.frame = CGRectMake(0, 0, 320, IPHONE5_HDIFF(317));
	[UIView commitAnimations];
	
	self.titulo.text = prevController.title;
    self.titulo.accessibilityLabel = prevController.title.accessibilityLabel;
	
	// Si la pantalla necesita refrescar info antes de mostrarse implementa este metodo
	[prevController screenWillBeBack];
}

//Agregado para cerrar el teclado si se toca cualquier parte de la pantalla en MenuBanelcoController
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	id actual = [pantallas getLastObject];
	if (actual) {
		if ([actual respondsToSelector:@selector(dismissAll)]) {
			[actual performSelector:@selector(dismissAll)];
		}
		
	}
    [super touchesBegan:touches withEvent:event];    
}


-(IBAction) volver {
	//Agregado para cerrar teclado al navegar a la pantalla anterior
	id actual = [pantallas getLastObject];
	if ([actual respondsToSelector:@selector(dismissAll)]) {
		[actual performSelector:@selector(dismissAll)];
	}
	
	[self peekScreen];
}

- (IBAction)inicio {

	//Agregado para cerrar teclado al navegar al inicio
	id actual = [pantallas getLastObject];
	if ([actual respondsToSelector:@selector(dismissAll)]) {
		[actual performSelector:@selector(dismissAll)];
	}
	
	StackableScreen *controller = (StackableScreen *)[pantallas pop];
	
	while (controller) {
		
		[controller.view removeFromSuperview];
		controller = (StackableScreen *)[pantallas pop];
	}
	
	[self dismissModalViewControllerAnimated:NO];
}

-(void) transicionHorizontal{
	
}

-(void) transicionHorizontalBack{
	
}

-(UIViewController*) getViewControllerByIndice:(int) indice{
	
	UIViewController* vc;
	
	switch (indice)
	{ 
		case 0:
			vc = consultasScreen;
			break;
		case 1:
			vc = pagoMisCuentasScreen;
			break;
		case 2:
			vc = cargaCelularScreen;
			break;
		case 3:
			vc = transferenciasScreen;
			break;
		default:
			vc = nil;
			break;
	}
	
	return vc;
	
}

-(void) onMCUITabBar:(MCUITabBarViewController*) mcUITabBar andItemAction:(int)itemId {
	
	
	NSLog(@"Llegue con numero = %d", itemId);
	
	if(itemId == self.actualIndiceScreen) {
		
		while ([pantallas.array count] > 1) {
			[self volver];
		}
		
	} else {
		
		StackableScreen* actual = [self getViewControllerByIndice:self.actualIndiceScreen];
		StackableScreen* vc = [self getViewControllerByIndice:itemId];
		
        if (![vc isKindOfClass:[PagosListController class]]) {
            [vc screenWillBeBack];
        }
		
		[self initScreen:vc];
		
		self.actualIndiceScreen = itemId;
		
		actual.view.frame = CGRectMake(0, 0, 320, IPHONE5_HDIFF(317));
		actual.view.alpha = 1;
		vc.view.frame = CGRectMake(0, 345, 320, IPHONE5_HDIFF(317));
		vc.view.alpha = 0;
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
		[UIView setAnimationDuration:0.35];
		actual.view.frame = CGRectMake(0, -345, 320, IPHONE5_HDIFF(317));
		actual.view.alpha = 0;
		vc.view.frame = CGRectMake(0, 0, 320, IPHONE5_HDIFF(317));
		vc.view.alpha = 1;
		[UIView commitAnimations];
		
	}

}


- (void)didReceiveMemoryWarning {
	NSLog(@"MenuBanelcoController - Did Receive Memory Warning");
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	NSLog(@"MenuBanelcoController - View Did Unload");
    [super viewDidUnload];
}


- (void)dealloc {
	NSLog(@"MenuBanelcoController - Dealloc");
    
    self.smb_bottom = nil;
    self.fnd_tabbar = nil;
	[barra release];
	[btn_volver release];
	//[mctabbar release];
    self.mctabbar = nil;
	[header release];
	[consultasScreen release];
	[pagoMisCuentasScreen release];
	[cargaCelularScreen release];
	[transferenciasScreen release];
	[centralScreenSpace release];

    [super dealloc];
}


@end
