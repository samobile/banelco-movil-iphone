
#import "BanelcoMovilIphoneViewControllerGenerico.h"
#import "MenuBanelcoController.h"
#import "LoginController.h"
#import "ChangePasswordController.h"
#import "SeleccionBancoController.h"
#import "MCUITabBarItem.h"
#import "MCUITabBarViewController.h"
#import "TyCPaginadoController.h"
#import "AyudaController.h"
#import "Context.h"
#import "Util.h"
#import "CommonUIFunctions.h"
//#import "AppContainerViewController.h"
#import "CommonFunctions.h"
#import "WS_Logout.h"
#import "WSUtil.h"
#import "MBProgressHUD.h"
#import "UpdatesManager.h"
#import "Configuration.h"

@implementation BanelcoMovilIphoneViewControllerGenerico
@synthesize centralScreenSpace;
@synthesize actualIndiceScreen;
@synthesize mctabbar;
@synthesize changePass;
@synthesize sombra;
@synthesize barra;
@synthesize terminos;
@synthesize ayuda;
@synthesize inicio;
@synthesize imagenBancoHome,btn_volver, opcionesContainer;
@synthesize btnConsulta, btnPmc, btnRecarga, btnTransf, btnBimo/*, appContainer*/, btn_salir, fndImage;



static BanelcoMovilIphoneViewControllerGenerico* _sharedMenuController = nil;

+ (void)resetAll {
    if (_sharedMenuController) {
        [_sharedMenuController release];
    }
    _sharedMenuController = nil;
    
}

+(BanelcoMovilIphoneViewController *)sharedMenuController
{
	@synchronized([BanelcoMovilIphoneViewController class])
	{
		if (!_sharedMenuController)
			_sharedMenuController = [[self alloc] init];
		
		return _sharedMenuController;
	}
	
	return nil;
}



-(id) init{
    if ([Configuration getMenuGenerico]) {
        self = [super initWithNibName:@"BanelcoMovilIphoneViewControllerGenerico" bundle:nil];
    }
    else {
        self = [super initWithNibName:@"BanelcoMovilIphoneViewController" bundle:nil];
    }
	if (self){
        pantallas = [[Stack alloc] init];
        menuConfigured = NO;
		
	}
	return self;
	
}
- (void)viewDidLoad {
	[super viewDidLoad];
	self.actualIndiceScreen = -1;
	//self.centralScreenSpace = [[UIView alloc] initWithFrame:CGRectMake(0, 59,320, 354)];
    self.centralScreenSpace = [[UIView alloc] initWithFrame:CGRectMake(0, 59,320, IPHONE5_HDIFF(354))];
    self.centralScreenSpace.backgroundColor = [UIColor whiteColor];
	//self.centralScreenSpace.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"fnd_app.png"]];
    UIImageView *fondo = [[UIImageView alloc] initWithFrame:self.centralScreenSpace.bounds];
    fondo.tag = 1010;
    fondo.image = [UIImage imageNamed:@"fnd_app.png"];
    [self.centralScreenSpace addSubview:fondo];
    [fondo release];
	self.centralScreenSpace.alpha = 0;
	[self.view addSubview:self.centralScreenSpace];
	//CGRect rect= CGRectMake(0, 0, 320, 354);
    CGRect rect= CGRectMake(0, 0, 320, IPHONE5_HDIFF(354));
	
	
	imagenBancoHome.image = [UIImage imageNamed:[[[Context sharedContext] banco] imagenHome]];
	
    
	changePass = [[ChangePasswordController alloc] initWithController:self  CargaDatos:YES];
	changePass.view.frame = rect;
	
	terminos = [[TyCPaginadoController alloc] init];
	terminos.view.frame = rect;
	
	ayuda = [[AyudaController alloc] init];
	ayuda.view.frame = rect;
	
	
    
	
	recomendarSheet= [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Enviar SMS", @"Enviar Mail",@"Facebook",@"Twitter",@"Cancelar",nil];
	recomendarSheet.destructiveButtonIndex = 4;
	
	/*NSArray *elementos = [NSArray arrayWithObjects:@"Enviar SMS", @"Enviar Mail", @"Cancelar", nil];
     
     for (NSString *el in elementos) {
     [recomendarSheet addButtonWithTitle:el];
     }
	 
     recomendarSheet.delegate = self;
     */
	
	
	
	//self.barra = [[UIImageView alloc] initWithFrame:CGRectMake(0, 404, 320, 56)];
    self.barra = [[UIImageView alloc] initWithFrame:CGRectMake(0, IPHONE5_HDIFF(404), 320, 56)];
	self.barra.image = [UIImage imageNamed:@"fnd_toolbar.png"];
	[self.view addSubview:self.barra];
	//mctabbar = [[MCUITabBarViewController alloc] initWithFrame:CGRectMake(2, 404, 320, 56)];
    //mctabbar = [[MCUITabBarViewController alloc] initWithFrame:CGRectMake(2, IPHONE5_HDIFF(404), 320, 56)];
    mctabbar = [[MCUITabBarViewController alloc] initWithFrame:CGRectMake(0, IPHONE5_HDIFF(404), 320, 56)];
    
	
	
	NSString * model = [[UIDevice currentDevice] model];
    
	NSString* sysName = [[UIDevice currentDevice] systemName];
	NSString * version = [[UIDevice currentDevice] systemVersion];
	int versionint = [[version substringToIndex:1] intValue];
    
	Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
	
	if (([model isEqualToString:@"iPhone"])&&(versionint>=3)&&(messageClass)){
		MCUITabBarItem* item = [[MCUITabBarItem alloc] initNombreImagenSimple:@"btn_tbrayuda.png" andNombreImagenSeleccion:@"btn_tbrayudaselec.png"];
		MCUITabBarItem* item2 = [[MCUITabBarItem alloc] initNombreImagenSimple:@"btn_tbrterminos.png" andNombreImagenSeleccion:@"btn_tbrterminosselec.png"];
		MCUITabBarItem* item3 = [[MCUITabBarItem alloc] initNombreImagenSimple:@"btn_tbrcambioclave.png" andNombreImagenSeleccion:@"btn_tbrcambioclaveselec.png"];
		MCUITabBarItem* item4 = [[MCUITabBarItem alloc] initNombreImagenSimple:@"btn_tbrrecomendar.png" andNombreImagenSeleccion:@"btn_tbrrecomendarselec.png"];
		[mctabbar addItem:item withAnimation:YES ];
		[mctabbar addItem:item2 withAnimation:YES ];
		[mctabbar addItem:item3 withAnimation:YES ];
		[mctabbar addItem:item4 withAnimation:YES ];
	}else{
		//mctabbar.frame = CGRectMake(2, 404, 315, 56);
        mctabbar.frame = CGRectMake(2, IPHONE5_HDIFF(404), 315, 56);
		MCUITabBarItem* item = [[MCUITabBarItem alloc] initNombreImagenSimple:@"tbr_ayuda105.png" andNombreImagenSeleccion:@"tbr_ayudaselec105.png"];
		MCUITabBarItem* item2 = [[MCUITabBarItem alloc] initNombreImagenSimple:@"tbr_terminos105.png" andNombreImagenSeleccion:@"tbr_terminosselec105.png"];
		MCUITabBarItem* item3 = [[MCUITabBarItem alloc] initNombreImagenSimple:@"tbr_clave105.png" andNombreImagenSeleccion:@"tbr_claveselec105.png"];
		[mctabbar addItem:item withAnimation:YES ];
		[mctabbar addItem:item2 withAnimation:YES ];
		[mctabbar addItem:item3 withAnimation:YES ];
	}
    
	
	
	self.mctabbar.delegate = self;
	
	[self.view addSubview:mctabbar];
	
	UIImageView* header = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 59)];
	header.image = [UIImage imageNamed:@"fnd_header.png"];
	
	UIImageView* imV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 9, 320, 44)];
	imV.image = [UIImage imageNamed:@"lgo_appheader.png"];
    //[[[Context sharedContext] banco] imagenTitulo]];
	
	[self.view addSubview:header];
	[self.view addSubview:imV];
	
	
	
    
	//sombra = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15, 320, 433)];
    sombra = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15, 320, IPHONE5_HDIFF(433))];
    
	//sombra.image = [UIImage imageNamed:@"smb.png"];
	
	[self.view addSubview:sombra];
    
	
	[header release];
	[imV release];
	
	inicio = [UIButton buttonWithType:UIButtonTypeCustom];
	inicio.frame = CGRectMake(250, 16, 59,27);
    //	[inicio setTitle:@"Inicio" forState:UIControlStateNormal];
	[inicio setBackgroundImage:[UIImage imageNamed:@"btn_inicio.png"] forState:UIControlStateNormal];
	[inicio setBackgroundImage:[UIImage imageNamed:@"btn_inicioselec.png"] forState:UIControlStateHighlighted];
	[inicio addTarget:self action:@selector(inicioAccion) forControlEvents:UIControlEventTouchUpInside];
	inicio.alpha =0;
	[self.view addSubview:inicio];
    
    self.btn_salir = [UIButton buttonWithType:UIButtonTypeCustom];
	self.btn_salir.frame = CGRectMake(10,16, 59,27);
    //	[inicio setTitle:@"Inicio" forState:UIControlStateNormal];
	[self.btn_salir setBackgroundImage:[UIImage imageNamed:@"btn_salir.png"] forState:UIControlStateNormal];
	[self.btn_salir setBackgroundImage:[UIImage imageNamed:@"btn_salirselec.png"] forState:UIControlStateHighlighted];
	[self.btn_salir addTarget:self action:@selector(logOut) forControlEvents:UIControlEventTouchUpInside];
	self.btn_salir.hidden = NO;
	[self.view addSubview:self.btn_salir];
	
	
	btn_volver = [UIButton buttonWithType:UIButtonTypeCustom];
	btn_volver.frame = CGRectMake(10,16, 59,27);
	[btn_volver setBackgroundImage:[UIImage imageNamed:@"btn_volver.png"] forState:UIControlStateNormal];
	[btn_volver setImage:[UIImage imageNamed:@"btn_volverselec.png"] forState:UIControlStateHighlighted];
	[btn_volver addTarget:self action:@selector(peekScreen) forControlEvents:UIControlEventTouchUpInside];
	btn_volver.alpha =1;
	btn_volver.hidden = YES;
	[self.view addSubview:btn_volver];
	
	
	//	[self.view addSubview:self.centralScreenSpace];
    
    
    if (IS_IPHONE_5) {
        CGRect r = self.opcionesContainer.frame;
        CGRect i = self.imagenBancoHome.frame;
        self.opcionesContainer.frame = CGRectMake(r.origin.x, i.origin.y + i.size.height + 30 , r.size.width, r.size.height);
        
        r = self.fndImage.frame;
        r.size.height = IPHONE5_HDIFF(r.size.height);
        self.fndImage.frame = r;
    }
	
    
}

- (void)goLogIn {
    
    [CommonUIFunctions goToLogin];
}

- (void)logOutAccion {
    NSLog(@"Estoy saliendo...");
	if ([[Context sharedContext] usuario]) {
		WS_Logout *request = [[[WS_Logout alloc] init] autorelease];
		[WSUtil execute:request];
		NSLog(@"WSUtil execute...");
	}
    [self performSelectorOnMainThread:@selector(goLogIn) withObject:nil waitUntilDone:NO];
    
}

- (void)logOut {
    
    MBProgressHUD *prog = [[MBProgressHUD alloc] initWithView:[[[UIApplication sharedApplication] delegate] window]];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:prog];
    prog.delegate = nil;
    prog.labelText = @"Aguardá un momento, por favor...";
    [prog showWhileExecuting:@selector(logOutAccion) onTarget:self withObject:nil animated:YES];
    [prog release];
}

- (void)customizeMenu {
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 200, 52)];
    lbl.backgroundColor = [UIColor clearColor];
    if ([Context sharedContext].personalizado) {
        lbl.font = [UIFont systemFontOfSize:16];
    }
    else {
        lbl.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:16];
    }
    lbl.textColor = [CommonFunctions UIColorFromRGB:@"77787B"];
    lbl.text = @"Consultas";
    [self.btnConsulta addSubview:lbl];
    [lbl release];
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 200, 52)];
    lbl.backgroundColor = [UIColor clearColor];
    if ([Context sharedContext].personalizado) {
        lbl.font = [UIFont systemFontOfSize:16];
    }
    else {
        lbl.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:16];
    }
    lbl.textColor = [CommonFunctions UIColorFromRGB:@"77787B"];
    lbl.text = @"PagoMisCuentas";
    [self.btnPmc addSubview:lbl];
    [lbl release];
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 200, 52)];
    lbl.backgroundColor = [UIColor clearColor];
    if ([Context sharedContext].personalizado) {
        lbl.font = [UIFont systemFontOfSize:16];
    }
    else {
        lbl.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:16];
    }
    lbl.textColor = [CommonFunctions UIColorFromRGB:@"77787B"];
    lbl.text = @"Recarga de Celular";
    [self.btnRecarga addSubview:lbl];
    [lbl release];
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 200, 52)];
    lbl.backgroundColor = [UIColor clearColor];
    if ([Context sharedContext].personalizado) {
        lbl.font = [UIFont systemFontOfSize:16];
    }
    else {
        lbl.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:16];
    }
    lbl.textColor = [CommonFunctions UIColorFromRGB:@"77787B"];
    lbl.text = @"Transferencias";
    [self.btnTransf addSubview:lbl];
    [lbl release];
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 200, 52)];
    lbl.backgroundColor = [UIColor clearColor];
    if ([Context sharedContext].personalizado) {
        lbl.font = [UIFont systemFontOfSize:16];
    }
    else {
        lbl.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:16];
    }
    lbl.textColor = [CommonFunctions UIColorFromRGB:@"77787B"];
    lbl.text = @"BiMo: Pago entre Personas";
    [self.btnBimo addSubview:lbl];
    [lbl release];
    
    
    
    Context *context = [Context sharedContext];
    //if (context.listaBancosBimo.length == 0) {
    UpdatesManager *up = [[UpdatesManager alloc]init ];
    [up existNewVersion];
    
    
    //}
    if (context.listaBancosBimo && [context.listaBancosBimo rangeOfString:context.banco.idBanco].location != NSNotFound) {
        self.btnBimo.hidden = NO;
    }
    else {
        //CAMBIO SOLO PARA PRUEBAS en la version final va YES
        self.btnBimo.hidden = YES;
    }
}


-(void) terminoDeCargar {
	
	NSLog(@"termine la carga");
	UIViewController* vc = [self getViewControllerByIndice:self.actualIndiceScreen];
	NSLog(@"termine de cargar %@",vc);
	if ([vc isKindOfClass:[WheelAnimationController class]] == YES ) {
		NSLog(@"voy a inicializar");
		[vc inicializar];
		
	}
}



- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
	
	
	switch (buttonIndex) {
		case 0:
			[self sendSMS];
			break;
		case 1:
			[self sendMail];
			break;
		case 2:
            [self recomendarFacebook];
			break;
        case 3:
            [self recomendarTwitter];
			break;
		default:
			break;
	}
    
	
}

//Agregado para cerrar el teclado si se toca cualquier parte de la pantalla en MenuBanelcoController
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	id actual = [self getViewControllerByIndice:self.actualIndiceScreen];
	if (actual) {
		if ([actual respondsToSelector:@selector(dismissAll)]) {
			[actual performSelector:@selector(dismissAll)];
		}
		
	}
    [super touchesBegan:touches withEvent:event];
}


-(void) inicioAccion{
	UIViewController* actual = [self getViewControllerByIndice:self.actualIndiceScreen];
	
	//Agregado para cerrar teclado al navegar al inicio
	if ([actual respondsToSelector:@selector(dismissAll)]) {
		[actual performSelector:@selector(dismissAll)];
	}
	
	MCUITabBarItem* item = (MCUITabBarItem*)[self.mctabbar.listaDeItems objectAtIndex:self.actualIndiceScreen];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
	[UIView setAnimationDuration:0.35];
	
	self.centralScreenSpace.alpha =0;
	actual.view.alpha = 0;
	
    inicio.alpha =0;
    self.btn_salir.hidden = NO;
	btn_volver.hidden = YES;
	[item cambiarEstado];
    
	[UIView commitAnimations];
	
	self.actualIndiceScreen = -1;
}

-(IBAction) irMenuConsulta {
    
    while ([pantallas.array count] > 1) {
		[self peekScreen];
	}
    NSArray *a = self.centralScreenSpace.subviews;
    for (UIView *v in a) {
        if (v.tag != 1010) {
            [v removeFromSuperview];
        }
    }
	
	MenuBanelcoController* p1 = [MenuBanelcoController sharedMenuController];
	p1.actualIndiceScreen = 0;
	p1.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:p1 animated:YES];
    
}

-(IBAction) irMenuPagoCuentas {
    
    while ([pantallas.array count] > 1) {
		[self peekScreen];
	}
    NSArray *a = self.centralScreenSpace.subviews;
    for (UIView *v in a) {
        if (v.tag != 1010) {
            [v removeFromSuperview];
        }
    }
	
	MenuBanelcoController* p1 = [MenuBanelcoController sharedMenuController];
	p1.actualIndiceScreen = 1;
	p1.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:p1 animated:YES];
    
}

-(IBAction) irMenuCargaCelular {
	
    while ([pantallas.array count] > 1) {
		[self peekScreen];
	}
    NSArray *a = self.centralScreenSpace.subviews;
    for (UIView *v in a) {
        if (v.tag != 1010) {
            [v removeFromSuperview];
        }
    }
    
	MenuBanelcoController* p1 = [MenuBanelcoController sharedMenuController];
	p1.actualIndiceScreen = 2;
	p1.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:p1 animated:YES];
	
}

-(IBAction) irMenuTransferencias {
	
    while ([pantallas.array count] > 1) {
		[self peekScreen];
	}
    NSArray *a = self.centralScreenSpace.subviews;
    for (UIView *v in a) {
        if (v.tag != 1010) {
            [v removeFromSuperview];
        }
    }
    
	MenuBanelcoController* p1 = [MenuBanelcoController sharedMenuController];
	p1.actualIndiceScreen = 3;
	p1.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:p1 animated:YES];
	
}

-(IBAction)irBimo {
	
    Context *context = [Context sharedContext];
    
    if([context.usuario esRestringido]) {
		
        [CommonUIFunctions showRestrictedAlert:@"BiMo" withDelegate:nil];
        return;
		
    }
    
    while ([pantallas.array count] > 1) {
		[self peekScreen];
	}
    NSArray *a = self.centralScreenSpace.subviews;
    for (UIView *v in a) {
        if (v.tag != 1010) {
            [v removeFromSuperview];
        }
    }
    
    //self.appContainer = [[[AppContainerViewController alloc] initWithNibName:@"AppContainerViewController" bundle:nil tipoDoc:context.tipoDoc userDoc:context.dni codBanco:context.banco andDirIP:@"87B0C65215" andToken:@"87B0C65215" andDelegate:self] autorelease];
  //  self.appContainer = [[[AppContainerViewController alloc] initWithNibName:@"AppContainerViewController" bundle:nil tipoDoc:context.tipoDoc userDoc:context.dni codBanco:context.banco.idBanco andDirIP:[Util getSecurityToken:context.banco.idBanco forDni:context.dni]/*corto*/ andToken:[context getToken]/*largo*/ andInactivityTime:context.maxInactivityTimeBimo andDelegate:self] autorelease];
	/*CGRect r = appContainer.view.frame;
    r = CGRectOffset(r, 0, [UIApplication sharedApplication].statusBarFrame.size.height);
    [appContainer.view setFrame:r];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.8];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view.window cache:NO];
    [self.view.window addSubview:self.appContainer.view];
    UIView *v = [self.view.window viewWithTag:-1000];
    if (v) {
        [self.view.window bringSubviewToFront:v];
    }
    [UIView commitAnimations];
	*/
	
}

- (void)cerrarBimo {
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.8];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view.window cache:NO];
   // [self.appContainer.view removeFromSuperview];
    [UIView commitAnimations];
    
    //Uself.appContainer = nil;
}

- (void)cerrarBimoSesion {
    
    [self cerrarBimo];
    [self performSelector:@selector(irAlLogin) withObject:nil afterDelay:1];
    
}

- (void)irAlLogin {
    
    [CommonUIFunctions goToLogin];
}

-(void) onMCUITabBar:(MCUITabBarViewController*) mcUITabBar andItemAction:(int) itemId{
	
	
	
	while ([pantallas.array count] > 1) {
		[self peekScreen];
	}
	
	
	NSLog(@"Llegue con numero = %d",itemId);
	
	if (itemId == 3){
		if (self.actualIndiceScreen >= 0){
			NSLog(@"numero de actual indice screen = %d",self.actualIndiceScreen);
			[self inicioAccion];
		}
        
		[mcUITabBar resetSelection];
		[recomendarSheet showInView:self.view];
		return;
		
	}
	
	if(itemId == self.actualIndiceScreen){
		return;
	}
	
	UIViewController* actual = [self getViewControllerByIndice:self.actualIndiceScreen];
	UIViewController* vc = [self getViewControllerByIndice:itemId];
	
    if (vc == changePass) {
        [changePass clearFields];
    }
	
	
    //	actual.view.frame= CGRectMake(0, 0, 320, 345);
	vc.view.frame= CGRectMake(0, 345,320, IPHONE5_HDIFF(354));
	
	if(self.actualIndiceScreen == -1){
		self.centralScreenSpace.alpha = 0;
        //	[barra removeFromSuperview];
        //	[mctabbar removeFromSuperview];
        //	[sombra removeFromSuperview];
		
        
        //	[self.view addSubview:barra];
		
        //	[self.view addSubview:mctabbar];
		
        //	[self.view addSubview:sombra];
	}
    
	[self.centralScreenSpace addSubview:vc.view];
    
    //	actual.view.alpha = 1;
	//	[self.mainView addSubview:vc.view];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	[UIView setAnimationDidStopSelector:@selector(terminoDeCargar)];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.35];
    
	if(self.actualIndiceScreen != -1){
		actual.view.alpha = 0;
		actual.view.frame=CGRectMake(0, -345, 320, 354);
		
	}else {
		self.centralScreenSpace.alpha = 1;
		inicio.alpha = 1;
        //self.btn_salir.hidden = NO;
	}
    
	vc.view.alpha = 1;
    //	actual.view.alpha = 0;
    //	actual.view.frame=CGRectMake(0, -345, 320, 345);
	vc.view.frame= CGRectMake(0, 0, 320, IPHONE5_HDIFF(354));
	[UIView commitAnimations];
	[pantallas resetStackWith:vc];
	self.actualIndiceScreen = itemId;
	btn_volver.hidden = YES;
    self.btn_salir.hidden = NO;
    
	
}


-(UIViewController*) getViewControllerByIndice:(int) indice{
	
	UIViewController* vc;
	
	switch (indice)
	{
		case 0:
			vc = ayuda;
			break;
		case 1:
			vc = terminos;
			break;
		case 2:
			vc = changePass;
			break;
		default:
			vc = nil;
			break;
	}
	
	return vc;
	
}

- (void)recomendarFacebook {
    Context *context = [Context sharedContext];
    NSString *strName = nil;
	if (context.personalizado) {
		strName = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"Personalizacion"] objectForKey:@"AppName"];
	}
	else {
		strName = @"Banelco MÓVIL";
	}
    NSString *str = [NSString stringWithFormat:@"http://www.facebook.com/sharer.php?m2w&s=100&p[url]=%@&p[title]=%@&p[summary]=Excelente aplicación para iPhone. Te la recomiendo.", context.urlVersion, strName];
    NSString* webName = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:webName];
    [[UIApplication sharedApplication] openURL:url];
    
}

- (void)recomendarTwitter {
    Context *context = [Context sharedContext];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://twitter.com/intent/tweet?text=Excelente+aplicaci%%C3%%B3n+para+iPhone.+Te+la+recomiendo.+La+baj%%C3%%A1s+desde%%3A+%@", context.urlVersion]];
    [[UIApplication sharedApplication] openURL:url];
}

-(void)sendSMS {
	//	The MFMessageComposeViewController class is only available in iPhone OS 4.0 or later.
	//	So, we must verify the existence of the above class and log an error message for devices
	//		running earlier versions of the iPhone OS. Set feedbackMsg if device doesn't support
	//		MFMessageComposeViewController API.
	Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"El dispositivo no esta configurado para enviar SMS." delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
	
    
	if (messageClass != nil) {
		// Check whether the current device is configured for sending SMS messages
		if ([messageClass canSendText]) {
			[self displaySMSComposerSheet];
		}
		else {
            
			[alert show];
		}
	}
	else {
		
		[alert show];
	}
	[alert release];
}

-(void) sendMail{
    
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
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

// Displays an SMS composition interface inside the application.
-(void)displaySMSComposerSheet
{
	Context *context = [Context sharedContext];
	
	MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
	picker.messageComposeDelegate = self;
	picker.body = [NSString stringWithFormat:@"Excelente aplicación para iPhone. Te la recomiendo. La bajás desde: %@", context.urlVersion];
	[self presentModalViewController:picker animated:YES];
	[picker release];
}


#pragma mark -
#pragma mark Dismiss Mail/SMS view controller

// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the
// message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller
		  didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	
	// Notifies users about errors associated with the interface
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Mail" delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
	
	switch (result)
	{
		case MFMailComposeResultCancelled:
			alert.message =@"Se cancelo el envio de recomendacion.";
			break;
		case MFMailComposeResultSaved:
			alert.message =@"Se grabo el envio de recomendacion.";
			break;
		case MFMailComposeResultSent:
			alert.message =@"La recomendacion fue enviada con exito!";
			break;
		case MFMailComposeResultFailed:
			alert.message =@"Fallo el envio de la recomendacion.";
			break;
		default:
			alert.message =@"La recomendacion no ha sido enviada.";
			break;
	}
	[alert show];
	[alert release];
	[self dismissModalViewControllerAnimated:YES];
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
	//self.btn_inicio.enabled = YES;
	self.btn_volver.hidden = !screen.nav_volver;
	// Titulo pantalla
	//self.titulo.text = screen.title;
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
		//self.btn_inicio.enabled = YES;
		self.btn_volver.hidden = YES;
	}
	//Agregado para cuando se vuelve de una pantalla donde se deshabilito el boton "volver".
	else {
		self.btn_volver.hidden = !prevController.nav_volver;
	}
	
	//Al volver a la pantalla de lista de Agenda, recarga la tabla
	
	//actualView.frame = CGRectMake(0, 0, 320, 317);
    actualView.frame = CGRectMake(0, 0, 320, IPHONE5_HDIFF(317));
	//prevController.view.frame = CGRectMake(-320, 0, 320, 317);
    prevController.view.frame = CGRectMake(-320, 0, 320, IPHONE5_HDIFF(317));
	prevController.view.alpha = 0;
	actualView.alpha = 1;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	[UIView setAnimationDuration:0.35];
	prevController.view.alpha = 1;
	actualView.alpha = 0;
	//actualView.frame = CGRectMake(320, 0, 320, 317);
    actualView.frame = CGRectMake(320, 0, 320, IPHONE5_HDIFF(317));
	//prevController.view.frame = CGRectMake(0, 0, 320, 317);
    prevController.view.frame = CGRectMake(0, 0, 320, IPHONE5_HDIFF(317));
	[UIView commitAnimations];
	
	//self.titulo.text = prevController.title;
}



// Dismisses the message composition interface when users tap Cancel or Send. Proceeds to update the
// feedback message field with the result of the operation.
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
				 didFinishWithResult:(MessageComposeResult)result {
	// Notifies users about errors associated with the interface
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"SMS" delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
	switch (result)
	{
		case MessageComposeResultCancelled:
			alert.message =@"Se cancelo el envio del SMS de recomendacion.";
			break;
		case MessageComposeResultSent:
			alert.message =@"El SMS de recomendacion fue enviado con exito!";
			break;
		case MessageComposeResultFailed:
			alert.message =@"Fallo el envio de SMS de recomendacion.";
			break;
		default:
			alert.message =@"El SMS de recomendacion no ha podido ser enviado.";
			break;
	}
	[alert show];
	[alert release];
	[self dismissModalViewControllerAnimated:YES];
}






// Displays an email composition interface inside the application. Populates all the Mail fields.
-(void)displayMailComposerSheet
{
	Context *context = [Context sharedContext];
	
	NSString *str;
	if (context.personalizado) {
		str = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"Personalizacion"] objectForKey:@"AppName"];
	}
	else {
		str = @"Banelco MÓVIL";
	}
	
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
	[picker setSubject:[NSString stringWithFormat:@"%@ para iPhone",str]];
	
	
	// Set up recipients
    //	NSArray *toRecipients = nil;
    //	NSArray *ccRecipients = nil;
    //	NSArray *bccRecipients =nil;
	
    //	[picker setToRecipients:toRecipients];
    //	[picker setCcRecipients:ccRecipients];
    //	[picker setBccRecipients:bccRecipients];
	
	// Fill out the email body text
    
    NSDictionary *dict = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"Personalizacion"];
    NSString *emailBody = nil;
    if (context.personalizado && [[dict objectForKey:@"idBanco"] isEqualToString:@"QLMS"]) {
        emailBody = [NSString stringWithFormat:@"Hola, te recomiendo la aplicación %@ para iPhone que te permite operar con Banco Comafi desde tu celular. Para descargarla seguí este link: %@",
                     str,
                     context.urlVersion];
    }
    else {
        emailBody = [NSString stringWithFormat:@"Hola, te recomiendo la aplicación %@ para iPhone que te permite operar con el banco desde tu celular.\n\nPara bajarla desde tu iPhone seguí este link: %@",
                     str,
                     context.urlVersion];
    }
    
	[picker setMessageBody:emailBody isHTML:NO];
	
	[self presentModalViewController:picker animated:YES];
	[picker release];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	if (!pantallas) {
		pantallas = [[Stack alloc] init];
	}
	if (!menuConfigured) {
       // [self customizeMenu];
        menuConfigured = YES;
    }
    
}

- (void)dismiss {
    
	[self dismissModalViewControllerAnimated:NO];
	
}


- (void)dealloc {
	[pantallas release];
	[btn_volver release];
	[imagenBancoHome release];
	[inicio release];
	[terminos  release];
	[ayuda release];
	[barra release];
	[sombra release];
	[changePass release];
    self.opcionesContainer = nil;
    self.btnConsulta = nil;
    self.btnPmc = nil;
    self.btnRecarga = nil;
    self.btnTransf = nil;
    self.btnBimo = nil;
    //self.appContainer = nil;
    self.btn_salir = nil;
    self.fndImage = nil;
    [super dealloc];
}

@end
