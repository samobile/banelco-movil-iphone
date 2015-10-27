#import "ConfiguracionAvisosController.h"
#import "Context.h"
#import "CommonUIFunctions.h"
#import "WaitingAlert.h"
#import "WS_SuscribirAvisos.h"
#import "WSUtil.h"
#import "WS_ManagePerfilUsuario.h"

@implementation ConfiguracionAvisosController

@synthesize labelTitulo;
@synthesize btnAceptar;

@synthesize generalActiva;
@synthesize vencimientosActiva;
@synthesize opcionGeneral;
@synthesize labelGeneral;
@synthesize opcionVencimientos;
@synthesize labelVencimientos;

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Configuración de Avisos";
	
    if (![Context sharedContext].personalizado) {
        labelTitulo.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:20];
        labelGeneral.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:17];
        labelVencimientos.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:17];
    }
	labelTitulo.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	labelGeneral.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	labelVencimientos.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	
	[self apagarRueda];
	Context* context = [Context sharedContext];
	
	generalActiva = NO;
	vencimientosActiva = NO;
	
	if (!context.usuario.showInfo){
		opcionGeneral.hidden = YES;
		labelGeneral.hidden = YES;
	}
	if (!context.usuario.showVencim){
		opcionVencimientos.hidden = YES;
		labelVencimientos.hidden = YES;
	}
	
	if ((opcionGeneral.hidden) && (opcionVencimientos.hidden)){
		btnAceptar.hidden = YES;
		labelTitulo.hidden = YES;
		[CommonUIFunctions showAlert:@"Avisos" withMessage:@"Esta opción no esta habilitada para tu banco" cancelButton:@"Aceptar" andDelegate:self];
	}else{
		if (context.usuario.marcaInfo){
			self.generalActiva = YES;
			[self.opcionGeneral setImage:[UIImage imageNamed:@"btn_checkselec.png"] forState:UIControlStateNormal];
            self.opcionGeneral.accessibilityLabel = @"General Activado";
		}
		if (context.usuario.marcaVencim) {
			self.vencimientosActiva = YES;
			[self.opcionVencimientos setImage:[UIImage imageNamed:@"btn_checkselec.png"] forState:UIControlStateNormal];
            self.opcionVencimientos.accessibilityLabel = @"Sobre venciemientos Activado";
		}
	}
}


-(void) iniciarValores{
	
	Context* context = [Context sharedContext];
	if ((!context.usuario.showInfo)&&(!context.usuario.showVencim)){
		return;
	}else{
		
		[super iniciarValores];
	}
}

-(IBAction) activarGeneral{
	
	if(self.generalActiva){
		self.generalActiva = NO;
		[self.opcionGeneral setImage:[UIImage imageNamed:@"btn_check.png"] forState:UIControlStateNormal];
        self.opcionGeneral.accessibilityLabel = @"General Desactivado";
	}else {
		self.generalActiva = YES;
		[self.opcionGeneral setImage:[UIImage imageNamed:@"btn_checkselec.png"] forState:UIControlStateNormal];
        self.opcionGeneral.accessibilityLabel = @"General Activado";
	}
}


-(IBAction) activarVencimientos{
	
	if(self.vencimientosActiva){
		self.vencimientosActiva = NO;
		[self.opcionVencimientos setImage:[UIImage imageNamed:@"btn_check.png"] forState:UIControlStateNormal];
        self.opcionVencimientos.accessibilityLabel = @"Sobre vencimientos Desactivado";
	}else {
		self.vencimientosActiva = YES;
		[self.opcionVencimientos setImage:[UIImage imageNamed:@"btn_checkselec.png"] forState:UIControlStateNormal];
        self.opcionVencimientos.accessibilityLabel = @"Sobre vencimientos Activado";
	}
}
-(IBAction) aceptar{
	
	WaitingAlert* wa = [[WaitingAlert alloc] init];
	
	[self.view addSubview:wa];
	
	[wa startWithSelector:@"doChangeAvisos" fromTarget:self];
	
}

-(void)doChangeAvisos{
	id result;
	BOOL sGeneral = NO;
	BOOL sVencimientos = NO;
	
	if(self.generalActiva){
		sGeneral = YES;
	}else{
		sGeneral = NO;
	}
	if(self.vencimientosActiva){
		sVencimientos = YES;
	}else{
		sVencimientos = NO;
	}
	
	Context* context = [Context sharedContext];
    
    //WS_ManagePerfilUsuario *ws = [[WS_ManagePerfilUsuario alloc] init];
	
    WS_SuscribirAvisos* ws = [[WS_SuscribirAvisos alloc] init];
	ws.showInfo = sGeneral  ? @"true" : @"false";
//    ws.novedades = sGeneral;
//    ws.vencimientos = sVencimientos;
//    ws.email = context.usuario.email;
//    ws.retornarLogueoDNI = NO;
	ws.showVencimientos = sVencimientos ? @"true" : @"false";
	ws.userMail = [[context usuario] email];
//    ws.nickName = context.usuario.userName && [context.usuario.userName length] > 0 ? context.usuario.userName : @"";
	ws.userToken = [context getToken];
	
	result = [WSUtil execute:ws];

	if (![result isKindOfClass:[NSError class]]) {
		context.usuario.marcaInfo = generalActiva;
		context.usuario.marcaVencim = vencimientosActiva; 
		[CommonUIFunctions showAlert:@"Configuración de Avisos" withMessage:@"Hemos recibido tu solicitud." cancelButton:@"Aceptar" andDelegate:self];
	}else{
        
        NSString *errorCode = [[(NSError *)result userInfo] valueForKey:@"faultCode"];
        if ([errorCode isEqualToString:@"ss"]) {
            return;
        }
        
		NSString *errorDesc = [[(NSError *)result userInfo] valueForKey:@"description"];
		
		if (!errorDesc){
			UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Ingreso" message:@"En este momento no se puede realizar la operación. Reintentá más tarde." delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
			//[alertView show];
            [alertView performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
			[alertView release];
			return;
		}else{
			[CommonUIFunctions showAlert:@"Configuración de Avisos" withMessage:errorDesc andCancelButton:@"Aceptar"];
			
		}

		
	}
	
}


- (void)accionWithDelegate:(WheelAnimationController *)delegate {

	NSLog(@"action wwith delegate");
	[delegate accionFinalizada:TRUE];
}



- (void)dealloc {
	
	
	[labelTitulo release];
	[btnAceptar release];
	
	[labelGeneral release];
	[opcionVencimientos release];
	[labelVencimientos release];
	
	[generalActiva release];
	[vencimientosActiva release];
	[opcionGeneral release];
	[opcionVencimientos release];
    [super dealloc];
}


@end
