
#import "BanelcoMovilIphoneViewController.h"
#import "MenuBanelcoController.h"
#import "LoginController.h"
#import "PerfilMenuController.h"
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

#import "GAIFields.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"

@implementation BanelcoMovilIphoneViewController
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



static BanelcoMovilIphoneViewController * _sharedMenuController = nil;

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
	if (![Context sharedContext].extraccionEnabled) {
        self = [super initWithNibName:@"BanelcoMovilIphoneViewControllerGenerico" bundle:nil];
    }
    else if ([Context sharedContext].extraccionEnabled) {
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
    
    self.screenName = @"Pantalla Menu Principal";
    
	self.actualIndiceScreen = -1;
	//self.centralScreenSpace = [[UIView alloc] initWithFrame:CGRectMake(0, 59,320, 354)];
    self.centralScreenSpace = [[UIView alloc] initWithFrame:CGRectMake(0, 59,320, IPHONE5_HDIFF(354))];
    self.centralScreenSpace.backgroundColor = [UIColor whiteColor];
	//self.centralScreenSpace.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"fnd_app.png"]];
    UIImageView *fondo = [[UIImageView alloc] initWithFrame:self.centralScreenSpace.bounds];
    fondo.image = [UIImage imageNamed:@"fnd_app.png"];
    fondo.tag = 1010;
    [self.centralScreenSpace addSubview:fondo];
    [fondo release];
	self.centralScreenSpace.alpha = 0;
	[self.view addSubview:self.centralScreenSpace];
	//CGRect rect= CGRectMake(0, 0, 320, 354);
    CGRect rect= CGRectMake(0, 0, 320, IPHONE5_HDIFF(354));
	
	
	imagenBancoHome.image = [UIImage imageNamed:[[[Context sharedContext] banco] imagenHome]];
	
    
	changePass = [[PerfilMenuController alloc] initWithController:self  CargaDatos:YES];
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
        item.accessibilityLabel = @"Menu; Ayuda";
        item.tag = 0;
		MCUITabBarItem* item2 = [[MCUITabBarItem alloc] initNombreImagenSimple:@"btn_tbrterminos.png" andNombreImagenSeleccion:@"btn_tbrterminosselec.png"];
        item2.accessibilityLabel = @"Menu; Terminos y condiciones";
        item2.tag = 1;
		MCUITabBarItem* item3 = [[MCUITabBarItem alloc] initNombreImagenSimple:@"btn_tbrcambioclave.png" andNombreImagenSeleccion:@"btn_tbrcambioclaveselec.png"];
        item3.accessibilityLabel = @"Menu; Perfil";
        item3.tag = 2;
		MCUITabBarItem* item4 = [[MCUITabBarItem alloc] initNombreImagenSimple:@"btn_tbrrecomendar.png" andNombreImagenSeleccion:@"btn_tbrrecomendarselec.png"];
        item4.accessibilityLabel = @"Menu; Recomendar a un amigo";
        item4.tag = 3;
		[mctabbar addItem:item withAnimation:YES ];
		[mctabbar addItem:item2 withAnimation:YES ];
		[mctabbar addItem:item3 withAnimation:YES ];
		[mctabbar addItem:item4 withAnimation:YES ];
	}else{
		//mctabbar.frame = CGRectMake(2, 404, 315, 56);
        mctabbar.frame = CGRectMake(2, IPHONE5_HDIFF(404), 315, 56);
		MCUITabBarItem* item = [[MCUITabBarItem alloc] initNombreImagenSimple:@"tbr_ayuda105.png" andNombreImagenSeleccion:@"tbr_ayudaselec105.png"];
        item.accessibilityLabel = @"Menu; Ayuda";
        item.tag = 0;
		MCUITabBarItem* item2 = [[MCUITabBarItem alloc] initNombreImagenSimple:@"tbr_terminos105.png" andNombreImagenSeleccion:@"tbr_terminosselec105.png"];
        item2.accessibilityLabel = @"Menu; Terminos y condiciones";
        item2.tag = 1;
		MCUITabBarItem* item3 = [[MCUITabBarItem alloc] initNombreImagenSimple:@"tbr_clave105.png" andNombreImagenSeleccion:@"tbr_claveselec105.png"];
        item3.accessibilityLabel = @"Menu; Perfil";
        item3.tag = 2;
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
    inicio.accessibilityLabel = @"Inicio";
//	[inicio setTitle:@"Inicio" forState:UIControlStateNormal];
	[inicio setBackgroundImage:[UIImage imageNamed:@"btn_inicio.png"] forState:UIControlStateNormal];
	[inicio setBackgroundImage:[UIImage imageNamed:@"btn_inicioselec.png"] forState:UIControlStateHighlighted];
	[inicio addTarget:self action:@selector(inicioAccion) forControlEvents:UIControlEventTouchUpInside];
	inicio.alpha =0;
	[self.view addSubview:inicio];
    
    self.btn_salir = [UIButton buttonWithType:UIButtonTypeCustom];
	self.btn_salir.frame = CGRectMake(10,16, 59,27);
    self.btn_salir.accessibilityLabel = @"Salir";
    //	[inicio setTitle:@"Inicio" forState:UIControlStateNormal];
	[self.btn_salir setBackgroundImage:[UIImage imageNamed:@"btn_salir.png"] forState:UIControlStateNormal];
	[self.btn_salir setBackgroundImage:[UIImage imageNamed:@"btn_salirselec.png"] forState:UIControlStateHighlighted];
	[self.btn_salir addTarget:self action:@selector(logOut) forControlEvents:UIControlEventTouchUpInside];
	self.btn_salir.hidden = NO;
	[self.view addSubview:self.btn_salir];
	
	
	btn_volver = [UIButton buttonWithType:UIButtonTypeCustom];
	btn_volver.frame = CGRectMake(10,16, 59,27);
    btn_volver.accessibilityLabel = @"Volver";
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
	
    //Control expiracion de app (icbc)
    Context *context = [Context sharedContext];
    if (context.expirationEnabled) {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *expType = [prefs objectForKey:[NSString stringWithFormat:@"%@_%@_exp",context.banco.idBanco,context.usuario.nroDocumento]];
        if (!expType) {
            //mostrar mensaje 1
            NSDictionary *dict = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"Personalizacion"];
            if ([[dict objectForKey:@"idBanco"] isEqualToString:@"SPRE"]) {
                [CommonUIFunctions showAlert:@"" withMessage:@"Supervielle móvil se renueva!. Próximamente podrás disfrutar de una nueva aplicación con más funciones disponibles." andCancelButton:@"Continuar"];
            }
            else {
                [CommonUIFunctions showAlert:@"" withMessage:@"Descargá la nueva aplicación ICBC Mobile Banking en la tienda de tu Smartphone." andCancelButton:@"Aceptar"];
            }
            
            NSDate *d = [NSDate date];
            NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
            [df setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
            
            [prefs setObject:[df stringFromDate:d] forKey:[NSString stringWithFormat:@"%@_%@_exp",context.banco.idBanco,context.usuario.nroDocumento]];
        }
        else if ([expType length] > 0 && ![expType isEqualToString:@"q"]) {
            NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
            [df setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
            NSDate *d = [df dateFromString:expType];
            
            int daysToAdd = 7;
            // set up date components
            NSDateComponents *components = [[[NSDateComponents alloc] init] autorelease];
            [components setDay:daysToAdd];
            // create a calendar
            NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
            NSDate *newDate2 = [gregorian dateByAddingComponents:components toDate:d options:0];
            d = [NSDate date];
            NSComparisonResult result = [d compare:newDate2];
            if (result == NSOrderedDescending) {
                //mostrar mensaje recordatorio
                NSDateFormatter *df2 = [[[NSDateFormatter alloc] init] autorelease];
                [df2 setDateFormat: @"dd/MM/yyyy"];
                NSString *msg = nil;
                NSDictionary *dict = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"Personalizacion"];
                if ([[dict objectForKey:@"idBanco"] isEqualToString:@"SPRE"]) {
                    msg = [NSString stringWithFormat:@"Te informamos que a partir del día %@ esta aplicación dejará de funcionar. Descárgate la nueva aplicación Supervielle Móvil desde Apple Store.", [df2 stringFromDate:context.expirationDate]];
                }
                else {
                    msg = [NSString stringWithFormat:@"Si todavía no bajaste la nueva aplicación ICBC Mobile Banking, por favor descargala ingresando a la tienda de tu Smartphone. Recordá que a partir del %@ no podrás seguir operando con la aplicación actual.", [df2 stringFromDate:context.expirationDate]];
                }
                [CommonUIFunctions showOmitAlert:@"" withMessage:msg andDelegate:self];
                [prefs setObject:[df stringFromDate:[NSDate date]] forKey:[NSString stringWithFormat:@"%@_%@_exp",context.banco.idBanco,context.usuario.nroDocumento]];
            }
        }
        
        [prefs synchronize];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        //omitir
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:@"q" forKey:[NSString stringWithFormat:@"%@_%@_exp",[Context sharedContext].banco.idBanco,[Context sharedContext].usuario.nroDocumento]];
        [prefs synchronize];
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
    
    if (self.btn_salir.hidden) {
        return;
    }
    
    //GAnalytics
    // May return nil if a tracker has not yet been initialized.
    id tracker = [[GAI sharedInstance] defaultTracker];
    // Start a new session with a screenView hit.
    GAIDictionaryBuilder *builder = [GAIDictionaryBuilder createScreenView];
    [builder set:@"end" forKey:kGAISessionControl];
    [tracker set:kGAIScreenName value:@"Logout"];
    [tracker send:[builder build]];
    
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
    lbl.text = @"Extracciones";
    [self.btnBimo addSubview:lbl];
    [lbl release];
    
    
    
    Context *context = [Context sharedContext];
    //if (context.listaBancosBimo.length == 0) {
//        UpdatesManager *up = [[UpdatesManager alloc]init ];
//        [up existNewVersion];
    
    
    //}
    if (context.extraccionEnabled) {
        self.btnBimo.hidden = NO;
    }
    else {
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
    
    [self.view endEditing:YES];
    
	UIViewController* actual = [self getViewControllerByIndice:self.actualIndiceScreen];
	
	//Agregado para cerrar teclado al navegar al inicio
	if ([actual respondsToSelector:@selector(dismissAll)]) {
		[actual performSelector:@selector(dismissAll)];
	}
    
    //?????
    while ([pantallas.array count] > 1) {
        [self peekScreen];
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
	
    UIView *v = [self.centralScreenSpace viewWithTag:-1001];
    if (v) {
        [v removeFromSuperview];
    }
    
	self.actualIndiceScreen = -1;
}

-(IBAction) irMenuConsulta {
    
//    // May return nil if a tracker has not already been initialized with a property
//    // ID.
//    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
//    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"     // Event category (required)
//                                                          action:@"Consultas"  // Event action (required)
//                                                           label:@"consultas"          // Event label
//                                                           value:nil] build]];    // Event value
    
    // May return nil if a tracker has not already been initialized with a
    // property ID.
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    // This screen name value will remain set on the tracker and sent with
    // hits until it is set to a new value or to nil.
    [tracker set:kGAIScreenName value:@"Pantalla Consultas"];
    // New SDK versions
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    
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
    
    // May return nil if a tracker has not already been initialized with a property
    // ID.
//    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
//    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"     // Event category (required)
//                                                          action:@"PagoMisCuentas"  // Event action (required)
//                                                           label:@"pagomiscuentas"          // Event label
//                                                           value:nil] build]];    // Event value
    
    // May return nil if a tracker has not already been initialized with a
    // property ID.
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    // This screen name value will remain set on the tracker and sent with
    // hits until it is set to a new value or to nil.
    [tracker set:kGAIScreenName value:@"Pantalla PagoMisCuentas"];
    // New SDK versions
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
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
    
    // May return nil if a tracker has not already been initialized with a property
    // ID.
//    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
//    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"     // Event category (required)
//                                                          action:@"Carga Celular"  // Event action (required)
//                                                           label:@"cargacelular"          // Event label
//                                                           value:nil] build]];    // Event value
    
    // May return nil if a tracker has not already been initialized with a
    // property ID.
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    // This screen name value will remain set on the tracker and sent with
    // hits until it is set to a new value or to nil.
    [tracker set:kGAIScreenName value:@"Pantalla Carga Celular"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
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
	
    // May return nil if a tracker has not already been initialized with a property
    // ID.
//    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
//    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"     // Event category (required)
//                                                          action:@"Transferencias"  // Event action (required)
//                                                           label:@"transferencias"          // Event label
//                                                           value:nil] build]];    // Event value
    
    // May return nil if a tracker has not already been initialized with a
    // property ID.
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    // This screen name value will remain set on the tracker and sent with
    // hits until it is set to a new value or to nil.
    [tracker set:kGAIScreenName value:@"Pantalla Transferencias"];
    // New SDK versions
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
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
	
    // May return nil if a tracker has not already been initialized with a
    // property ID.
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    // This screen name value will remain set on the tracker and sent with
    // hits until it is set to a new value or to nil.
    [tracker set:kGAIScreenName value:@"Pantalla Extracciones"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
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
    p1.actualIndiceScreen = 4;
    p1.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:p1 animated:YES];
	
}

- (void)cerrarBimo {
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.8];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view.window cache:NO];
    //[self.appContainer.view removeFromSuperview];
    [UIView commitAnimations];
    
   // self.appContainer = nil;
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
	
	
//	actual.view.frame= CGRectMake(0, 0, 320, 345);
	vc.view.frame= CGRectMake(0, 345, 320, IPHONE5_HDIFF(354));
	
	if(self.actualIndiceScreen == -1){
		self.centralScreenSpace.alpha = 0;
	//	[barra removeFromSuperview];
	//	[mctabbar removeFromSuperview];
	//	[sombra removeFromSuperview];
		
	
	//	[self.view addSubview:barra];
		
	//	[self.view addSubview:mctabbar];
		
	//	[self.view addSubview:sombra];
	}
    vc.view.tag = -1001;
	[self.centralScreenSpace addSubview:vc.view];
    
    if (itemId == 2) {
        [vc viewWillAppear:NO];
    }

//	actual.view.alpha = 1;
	//	[self.mainView addSubview:vc.view];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	[UIView setAnimationDidStopSelector:@selector(terminoDeCargar)];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.35];
	if(self.actualIndiceScreen != -1){
		actual.view.alpha = 0;
		actual.view.frame=CGRectMake(0, -345, 320, IPHONE5_HDIFF(354));
		
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
    
    if (itemId == 2) {
        self.btn_salir.hidden = YES;
    }
	
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
	
    screen.view.tag = -1001;
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
	
    [self.view endEditing:YES];
    
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
        if([Context sharedContext].extraccionEnabled) {
            [self customizeMenu];
        }
        menuConfigured = YES;
    }
    
    int tipo = 5;
    if (![[Context sharedContext].tipoDoc isEqualToString:@"U"]) {
        tipo = [[Context sharedContext].tipoDoc intValue]-1;
    }
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",tipo] forKey:[Context sharedContext].banco.idBanco];
    
    UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification,self.btnConsulta);
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
   // self.appContainer = nil;
    self.btn_salir = nil;
    self.fndImage = nil;
    [super dealloc];
}

@end
