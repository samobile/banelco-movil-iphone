//
//  LoginController.m
//  BanelcoMovilIphone
//
//  Created by Demian on 8/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LoginController.h"
#import "BanelcoMovilIphoneViewController.h"
#import "BanelcoMovilIphoneViewControllerGenerico.h"
#import "Util.h"
#import "WSUtil.h"
#import "WS_Login.h"
#import "WS_Login_ConPerfil.h"
#import "Context.h"
#import "Usuario.h"
#import "LoginResponse.h"
#import "CommonUIFunctions.h"
#import "AceptarTerminosController.h"
#import "CambioClaveController.h"
#import "Context.h"
#import "ExecuteCheckVersion.h"
#import <QuartzCore/QuartzCore.h>
#import "WaitingAlert.h"
#import "CommonFunctions.h"
#import "GenerarClaveController.h"
#import "SeleccionBancoController.h"
#import "Banco.h"
#import "UpdatesManager.h"
#import "GenerarClaveRestringidaController.h"
#import "ExecuteLogin.h"
#import "OlvideUsuarioController.h"

#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"

@implementation LoginController

//@synthesize tipoSeleccionado;
@synthesize userField;
@synthesize passField;
@synthesize blankButton;
@synthesize lTipoDocumento;
@synthesize subMenu;
@synthesize volverB;
@synthesize link,label;
@synthesize ocultarLink, ingreso, alert, subMenuGeneracion;
@synthesize barTeclado, barTecladoButton;
@synthesize ltdoc;
@synthesize doc, docType, password, fndImage, forceLogin;


-(id) init { //Por defecto esta oculto el link
	
	if (self = [super init]){
		[self initValues];
		ocultarLink = YES;
		ingreso = NO;
		mostrarMsgClave = NO;
        tipoSeleccionado = 0;
        self.forceLogin = NO;
	}
	return self;
	
}

-(id) initPrimerLoginConBanco:(BOOL) plB{

	if (self = [super init]){
		[self initValues];
		ingreso=NO;
		mostrarMsgClave = YES;
		if (plB){
			
			ocultarLink = NO;
		}else{
			
			ocultarLink = YES;
			mostrarMsgClave = NO;
		}
	
        tipoSeleccionado = 0;
        self.forceLogin = NO;
	}
	return self;
	
}

-(id) initPersonalizado {
	
	if (self = [super init]){
		[self initValues];
		ingreso=NO;
		mostrarMsgClave = YES;
		NSDictionary *dict = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"Personalizacion"];
		Banco *bank = [[Banco alloc] initWithDictionary:dict];
		Context* context = [Context sharedContext];
		[context setBanco:bank];
		context.bancosSeleccionados = [[NSMutableArray alloc] init];
		
		if ([[NSFileManager defaultManager] fileExistsAtPath:[self pathSelectedBanks]]){
			NSMutableArray *b = [[NSMutableArray alloc] initWithContentsOfFile:[self pathSelectedBanks]];
			if ([b count] > 0) {
				ocultarLink = YES;
				mostrarMsgClave = NO;
			}
			else {
				ocultarLink = NO;
			}
			[b release];
		}
        
        tipoSeleccionado = 0;
        self.forceLogin = NO;
		
	}
	return self;
	
}


-(void) initValues{
	
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
    if (removeTerm) {
        UIView *v = [self.view viewWithTag:-100];
        if (v) {
            [v removeFromSuperview];
        }
        removeTerm = NO;
    }
    
    if (ocultarLink){
		//self.link.hidden = YES;
	}else {
		//self.link.hidden = NO;
		if (mostrarMsgClave) {
			mostrarMsgClave = NO;
			[CommonUIFunctions showAlert:@"Recordá" withMessage:@"La clave para operar es exclusiva para este servicio." andCancelButton:@"Aceptar"];
		}
	}
    
    //[[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",tipoSeleccionado] forKey:[Context sharedContext].banco.idBanco];
    NSString *tipoDoc = [[NSUserDefaults standardUserDefaults] valueForKey:[Context sharedContext].banco.idBanco];
    if (tipoDoc) {
        [self selectTipoDoc:[tipoDoc intValue]];
    }
    
//    Context *context = [Context sharedContext];
//    if (context.expirationEnabled) {
//        //chequeo de fecha
//        NSDate *actual = [NSDate date];
//        if (context.expirationDate && [actual compare:context.expirationDate] != NSOrderedAscending) {
//            //mostrar mensaje bloqueante
//            UIView *v = [[UIView alloc] initWithFrame:self.view.bounds];
//            v.backgroundColor = [UIColor colorWithRed:85/255 green:85/255 blue:85/255 alpha:0.8];
//            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(30, 30, v.frame.size.width - 60, v.frame.size.height - 60)];
//            lbl.numberOfLines = 5;
//            lbl.backgroundColor = [UIColor clearColor];
//            lbl.text = @"Para poder seguir operando, por favor descargá la aplicación ICBC Mobile Banking desde la tienda de tu Smartphone";
//            lbl.textColor = [UIColor whiteColor];
//            lbl.textAlignment = UITextAlignmentCenter;
//            lbl.font = [UIFont boldSystemFontOfSize:16];
//            [v addSubview:lbl];
//            [lbl release];
//            [self.view addSubview:v];
//            [v release];
//        }
//    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    if (self.forceLogin) {
//        [self performSelector:@selector(ingresarAction:) withObject:nil afterDelay:0.5];
//        self.forceLogin = NO;
//    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)forzarLogin {
    if (self.forceLogin) {
        [self performSelector:@selector(ingresarAction:) withObject:nil afterDelay:0];
        self.forceLogin = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    removeTerm = NO;
    
    self.view.frame = [CommonFunctions frame4inchDisplay:self.view.frame];
    
//	if (ocultarLink) {
//		self.link.hidden = YES;
//	} else {
		self.link.hidden = NO;
//	}

    if (![Context sharedContext].personalizado) {
        ltdoc.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:15];
        lTipoDocumento.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:17];
        userField.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:18];
        passField.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:18];
    }
	ltdoc.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	lTipoDocumento.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	lTipoDocumento.text = @"DNI";
	userField.delegate = self;
	passField.delegate = self;
//	[passField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
	//subMenu = [[UIActionSheet alloc] init];
	subMenuGeneracion = [[UIActionSheet alloc] init];
	//Context* context = [Context sharedContext];
	//NSArray *elementos = [NSArray arrayWithObjects:@"DNI", @"CI", @"PAS", @"LC", @"LE", @"Usuario", nil];
//	NSArray *elementos2;
//	if ([context.banco.url length]>1){
//		elementos2 = [NSArray arrayWithObjects:@"Pago Mis Cuentas", @"Pagomiscuentas Através Home Banking", @"Cancelar", nil];
//	}else{
//		elementos2 = [NSArray arrayWithObjects:@"Pago Mis Cuentas", @"Cancelar", nil];		
//	}

	subMenu = [[UIActionSheet alloc] initWithTitle:@"" delegate:nil cancelButtonTitle:@"Cancelar" destructiveButtonTitle:nil otherButtonTitles:@"DNI", @"CI", @"PAS", @"LC", @"LE", @"Usuario", nil];
	
//	for (NSString *el in elementos) { // Se sacan los saldos porque para mostrar la informacion
//									  // correcta se deben pedir nuevamente mediante el WS correspondiente.
//		[subMenu addButtonWithTitle:el];
//	} 
//	for (NSString *el2 in elementos2) { // Se sacan los saldos porque para mostrar la informacion
//		// correcta se deben pedir nuevamente mediante el WS correspondiente.
//		[subMenuGeneracion addButtonWithTitle:el2];
//	} 
	
    subMenu.title = @"Tipo de documento o usuario";
	subMenu.delegate = self;
	subMenuGeneracion.delegate = self;
	self.blankButton = [UIButton buttonWithType:UIButtonTypeCustom];
	//self.blankButton.frame = CGRectMake(0, 0, 320, 199);
    self.blankButton.frame = CGRectMake(0, 0, 320, IPHONE5_HDIFF(280));
	self.blankButton.alpha =0.1;
	[self.blankButton setTitle:@"" forState:UIControlStateNormal];
    self.blankButton.accessibilityLabel = @"Cerrar teclado";

	[self.blankButton addTarget:self action:@selector(hideKeyboard) forControlEvents:UIControlEventTouchUpInside];
	
    //CAMBIO
		UIImageView* imV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 9, 320, 41)];
    	imV.image = [UIImage imageNamed:[[[Context sharedContext] banco] imagenTitulo]];
    //
    //CAMBIADO
    //UIImageView* imV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 9, 320, 44)];
	//imV.image = [UIImage imageNamed:@"lgo_appheader.png"];

	[self.view addSubview:imV];
	
	//personalizacion
	if (![[Context sharedContext] personalizado] || 
		([[Context sharedContext] personalizado] && ([[[[[NSBundle mainBundle] infoDictionary] objectForKey:@"Personalizacion"] objectForKey:@"idBanco"] isEqualToString:@"RBTS"] || [[[[[NSBundle mainBundle] infoDictionary] objectForKey:@"Personalizacion"] objectForKey:@"idBanco"] isEqualToString:@"SDMR"]))) {
		volverB = [UIButton buttonWithType:UIButtonTypeCustom];
        volverB.accessibilityLabel = @"Volver";
		volverB.frame = CGRectMake(10, 15, 59,27);
		//	[inicio setTitle:@"Inicio" forState:UIControlStateNormal];
		[volverB setBackgroundImage:[UIImage imageNamed:@"btn_volver.png"] forState:UIControlStateNormal];
		[volverB setBackgroundImage:[UIImage imageNamed:@"btn_volverselec.png"] forState:UIControlStateHighlighted];
		[volverB addTarget:self action:@selector(volver) forControlEvents:UIControlEventTouchUpInside];
		volverB.alpha =1.0;
		[self.view addSubview:volverB];
	}
	
	
	self.barTeclado = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"barra_teclado.png"]];
	barTeclado.alpha = 0;
	
	self.barTecladoButton = [UIButton buttonWithType:UIButtonTypeCustom];
	//barTecladoButton.frame = CGRectMake(222, 488, 88, 29);
    barTecladoButton.frame = CGRectMake(222, IPHONE5_HDIFF(488), 88, 29);
	barTecladoButton.alpha =1;
	//	barTecladoButton.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"barra_boton.png"]];
	
	[barTecladoButton setImage:[UIImage imageNamed:@"btn_TecSiguiente.png"] forState:UIControlStateNormal];
    barTecladoButton.accessibilityLabel = @"Siguiente";
	[barTecladoButton setTitle:@"" forState:UIControlStateNormal];
	[barTecladoButton addTarget:self action:@selector(keyboardButtonAction) forControlEvents:UIControlEventTouchUpInside];
	
	
	[self.view addSubview:barTeclado];
	[self.view addSubview:barTecladoButton];
    
    CGRect r = self.fndImage.frame;
    r.size.height = IPHONE5_HDIFF(r.size.height);
    self.fndImage.frame = r;
	
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}



- (void) keyboardWillShow: (NSNotification*) aNotification {	
	
	
	[self.view addSubview:self.blankButton];
	
	if ([userField isFirstResponder]){
		[barTecladoButton setImage:[UIImage imageNamed:@"btn_TecSiguiente.png"] forState:UIControlStateNormal];
        barTecladoButton.accessibilityLabel = @"Siguiente";
	}else{
		[barTecladoButton setImage:[UIImage imageNamed:@"btn_TecIngresar.png"] forState:UIControlStateNormal];
        barTecladoButton.accessibilityLabel = @"Ingresar";
	}
	
	//barTeclado.frame = CGRectMake(0, 480, 320, 45);
    barTeclado.frame = CGRectMake(0, IPHONE5_HDIFF(480), 320, 45);
	barTeclado.alpha = 1;
	
	//barTecladoButton.frame = CGRectMake(222, 488, 88, 29);
    barTecladoButton.frame = CGRectMake(222, IPHONE5_HDIFF(488), 88, 29);
	barTecladoButton.alpha =1;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	//barTeclado.frame = CGRectMake(0, 199, 320, 45);
    UIWindow *win = [[[UIApplication sharedApplication] windows] firstObject];
    CGFloat dif = 0;
    if (win) {
        dif = win.frame.origin.y;
    }
    barTeclado.frame = CGRectMake(0, IPHONE5_HDIFF(199) - dif, 320, 45);
	//barTecladoButton.frame = CGRectMake(222, 207, 88, 29);
    barTecladoButton.frame = CGRectMake(222, IPHONE5_HDIFF(207) - dif, 88, 29);
    
    [self.view bringSubviewToFront:barTecladoButton];
    
	[UIView commitAnimations];
	
}

- (void)removeTerminos {
    removeTerm = YES;
}

- (void) keyboardWillHide: (NSNotification*) aNotification {
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	//barTeclado.frame = CGRectMake(0, 480, 320, 50);
    barTeclado.frame = CGRectMake(0, IPHONE5_HDIFF(480), 320, 50);
	barTeclado.alpha =0;
	//barTecladoButton.frame = CGRectMake(222, 488, 88, 29);
    barTecladoButton.frame = CGRectMake(222, IPHONE5_HDIFF(488), 88, 29);
	barTecladoButton.alpha =1;

	
	[UIView commitAnimations];
}


- (IBAction)keyboardButtonAction{
	
	
	NSLog(@"keyboardButtonAction");
	
	
	
	if([userField isFirstResponder]){
		[passField becomeFirstResponder];
		[barTecladoButton setImage:[UIImage imageNamed:@"btn_TecIngresar.png"] forState:UIControlStateNormal];
        barTecladoButton.accessibilityLabel = @"Ingresar";
		
	}else if ([passField isFirstResponder]){
	
		[self.blankButton removeFromSuperview];
		
		
		[NSThread detachNewThreadSelector:@selector(doLoginAction) toTarget:self withObject:nil];
		[passField resignFirstResponder];
		[userField resignFirstResponder];
	}else{
		//	[sender resignFirstResponder];
		[self.blankButton removeFromSuperview];
	}
	
	
}



- (void)viewDidUnload {
    [super viewDidUnload];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
	if ((!string)||([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0)){
		return YES;
	}
    
    if ((passField == textField) || (userField == textField && tipoSeleccionado != 5)) {
        //Validacion de nros
        if (![CommonFunctions hasNumbers:string]) {
            return NO;
        }
    }
    else if (userField == textField && tipoSeleccionado == 5) {
        //validacion alfanumerico hasAlphaNumeric
        if (![CommonFunctions hasAlphaNumeric:string]) {
            return NO;
        }
    }
	
	int max = 8;
	if (userField == textField) {
		max = 12;
	}
    if (range.location >= max)
        return NO;
    
    if (userField == textField && tipoSeleccionado == 5) {
        textField.text = [NSString stringWithFormat:@"%@%@",textField.text,[string uppercaseString]];
        return NO;
    }
    
    return YES;

}


- (IBAction)pressDoneKey:(id)sender
{
	[sender resignFirstResponder];
	[self ingresar];

}

-(IBAction) generarClave {
	
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
	alert = [[WaitingAlert alloc] initWithH:20];
	[self.view addSubview:alert];
	[alert startWithSelector:@"doGenerarClave" fromTarget:self andFinishSelector:@"finishAlert" formTarget:self];
	
}

-(void) doGenerarClave {
	
	Context *context = [Context sharedContext];
	UpdatesManager *manager = [[UpdatesManager alloc] init];

	if([manager obtenerRegistracion]) {
		
		if([manager usaNuevaRegistracion:context.banco.idBanco]) {
			
			[self performSelectorOnMainThread:@selector(irAGenerarClave) withObject:nil waitUntilDone:YES];
			return;
			
		}
		
	}
	
	[self performSelectorOnMainThread:@selector(irACambioDeClave) withObject:nil waitUntilDone:YES];
	
}

// Separado para ser llamado desde el hilo principal. De otra forma el DatePicker no funciona.
-(void)irAGenerarClave {

	GenerarClaveRestringidaController *controller = [[GenerarClaveRestringidaController alloc] initFromController:self];
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
    //controller.view.tag = -105;
    //[self.view addSubview:controller.view];
	
}

- (void) doLoginAction {
	NSAutoreleasePool *pool= [[NSAutoreleasePool alloc]init];
	
	[NSThread sleepForTimeInterval:0.2];
	
	//[self ingresar];
	[self performSelectorOnMainThread:@selector(ingresarAction:) withObject:nil waitUntilDone:YES];
	
	[pool release];
}

- (IBAction)dismissKeyboard:(id)sender{
	if(sender == userField){
		[sender resignFirstResponder];
		[passField becomeFirstResponder];
	}else if (sender == passField) {
		[self.blankButton removeFromSuperview];
		[NSThread detachNewThreadSelector:@selector(doLoginAction) toTarget:self withObject:nil];
		
		[passField resignFirstResponder];
		[userField resignFirstResponder];
		
	}else{
		[self.blankButton removeFromSuperview];
		
	}
}


- (BOOL)textFielsShouldReturn:(UITextField *)textField {
	
    if (textField == self.userField) {
        //[self.passField becomeFirstResponder];
        [self keyboardButtonAction];
        return NO;
    }
    else if ((self.passField==textField)&&(ingreso)){
		ingreso =NO;
		[self ingresar];
	}
	return YES;
}



-(void) hideKeyboard {

	[self.userField resignFirstResponder];
	[self.passField resignFirstResponder];
	[self.blankButton removeFromSuperview];
	
}


- (IBAction) activarBoton {
	[self.view addSubview:self.blankButton];
    
    [self.view bringSubviewToFront:barTecladoButton];
}


-(void) irACambioDeClave{
//	if (subMenuGeneracion.numberOfButtons > 0) {
//		[subMenuGeneracion showInView:self.view];		
//	}
	
	Context* context = [Context sharedContext];
	if (!([context.banco.url length]>1)) {
		[self pmc];
	}else{
		GenerarClaveController* gcc = [[GenerarClaveController alloc] init];
		[self presentModalViewController:gcc animated:YES];
		[gcc autorelease];
		return;
	}
	
}


-(void) cancelarGeneracionDeClave{
	
}

-(void) pmc{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.pagomiscuentas.com"]]; 
}

-(void) homebanking{
	Context* context = [Context sharedContext];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[context.banco url]]]; 
}


-(void) ingresarAction:(id) sender{
	
	Context* context = [Context sharedContext];
	
    NSLog(@"ingresar");
    
	if(([userField.text length] < 1) || ([passField.text length] < 1)) {
		
		[CommonUIFunctions showAlert:@"Ingreso" withMessage:@"El Nro de documento/Usuario y/o la contraseña no deben estar vacíos." andCancelButton:@"Aceptar"];
		return;
	}
	if( [passField.text length] != 8) {
		[CommonUIFunctions showAlert:@"Ingreso" withMessage:@"La clave debe tener 8 digitos." andCancelButton:@"Aceptar"];
		return;
	}
	
	
//	if (![self doLoginOfUser]) {
//		return;
//	}
	
	alert = [[WaitingAlert alloc] initWithH:20];
	[self.view addSubview:alert];
	[alert startWithSelector:@"doLoginOfUser" fromTarget:self andFinishSelector:@"finishAlert" formTarget:self];
	
}

- (void) finishAlert {
	[alert performSelectorOnMainThread:@selector(detener) withObject:nil waitUntilDone:NO];
}

//- (void)removeCambioClave {
//    UIView *v = [self.view viewWithTag:-105];
//    if (v) {
//        [v removeFromSuperview];
//    }
//}


- (IBAction) ingresar:(id) sender {	
//	[self irACambioDeClave];
//	return;
	[self ingresarAction:sender];
}

- (void)updateText:(NSString *)newText
{
    [self.label performSelectorOnMainThread:@selector(setText:) withObject:newText waitUntilDone:YES];
    //self.label.text = newText;
}

- (void) volver {
	
	[self dismissModalViewControllerAnimated:YES];
}

-(NSString*) pathSelectedBanks{
	NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	return [path stringByAppendingPathComponent:@"selectedBanks2.plist"];
}

-(NSString*) pathNoSelectedBanks{
	NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	return [path stringByAppendingPathComponent:@"noselectedBanks2.plist"];
}


-(void)loginOfDoc:(NSString *)pDoc ofType:(NSString *)pDocType andPW:(NSString *)pPW {
	
    //NSString * typeD = (tipoSeleccionado == 5) ? @"U" : docType;
    
	self.doc = pDoc;
	self.docType = pDocType;
	self.password = pPW;
	
	alert = [[WaitingAlert alloc] initWithH:20];
	[self.view addSubview:alert];
	[alert startWithSelector:@"doLoginOfRestrictedUser" fromTarget:self andFinishSelector:@"finishAlert" formTarget:self];
	
}

-(void)doLoginOfRestrictedUser {

	[self doLoginOfDoc:doc ofType:docType andPW:password];	

}

-(void)doLoginOfUser {
	
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
//	[self doLoginOfDoc:userField.text 
//				ofType:[NSString stringWithFormat:@"%d",tipoSeleccionado+1] 
//				 andPW:passField.text];
	
    NSString * typeD = (tipoSeleccionado == 5) ? @"U" : [NSString stringWithFormat:@"%d",tipoSeleccionado+1];
	ExecuteLogin *e = [[ExecuteLogin alloc] initFromController:self withDoc:userField.text 
														ofType:typeD
														 andPW:passField.text];
	[e executeLogin];
	
    [userField performSelectorOnMainThread:@selector(setText:) withObject:@"" waitUntilDone:YES];
    [passField performSelectorOnMainThread:@selector(setText:) withObject:@"" waitUntilDone:YES];
	//userField.text = @"";
	//passField.text = @"";
    
    
	
}

- (void)resetKeyboard {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)doLoginOfDoc:(NSString *)pDoc ofType:(NSString *)pDocType andPW:(NSString *)pPw {
	LoginResponse *result;
	Context *context = [Context sharedContext];

	//WS_Login *request = [[[WS_Login alloc] init] autorelease];
	WS_Login_ConPerfil *request = [[[WS_Login_ConPerfil alloc] init] autorelease];
	request.tipoDoc = pDocType;
	request.nroDoc = pDoc;
	request.codBanco = context.banco.idBanco;
	request.clave = pPw;
	request.codApp = @"4546571003383927";
	request.appOrigen = @"O";
	request.userToken = [Util getSecurityToken:context.banco.idBanco forDni:[request.nroDoc uppercaseString]];
    request.datosApp = [NSString stringWithFormat: @"{\"plataforma\":\"IOs\",\"aplicacion\":\"%@\"}",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"LoginAppName"]];
	
	[WSRequest setSecurityToken:request.userToken];
	
	// Parseo el xml para obtener los datos del usuario
	result = [WSUtil execute:request];

	if (result && ![result isKindOfClass:[NSError class]]) {
	
		context.usuario = result.usuario;
		[Context setCuentas:result.cuentas];
        
        [WSRequest setSecurityToken:[Util getSecurityToken:context.banco.idBanco forDni:context.usuario.nroDocumento]];
		
		context.startAppHour = [[NSDate date] timeIntervalSince1970];
		context.lastActivityHour = [[NSDate date] timeIntervalSince1970];
		
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *oldNickName = [prefs objectForKey:[NSString stringWithFormat:@"%@_%@",request.codBanco,context.usuario.nroDocumento]];
        if (oldNickName && ![[oldNickName uppercaseString] isEqualToString:[context.usuario.userName uppercaseString]]) {
            [Util deleteSecurityTokenforBank:request.codBanco andDni:oldNickName];
        }
        if ([context.usuario.userName length] > 0) {
            [prefs setObject:[context.usuario.userName uppercaseString] forKey:[NSString stringWithFormat:@"%@_%@",request.codBanco,context.usuario.nroDocumento]];
        }
        else {
            [prefs removeObjectForKey:[NSString stringWithFormat:@"%@_%@",request.codBanco,context.usuario.nroDocumento]];
        }
        [prefs synchronize];
        
        [Util deleteSecurityTokenforBank:request.codBanco andDni:context.usuario.nroDocumento];
        [Util setSecurityToken:result.tokenSeguridad forBank:request.codBanco andDni:context.usuario.nroDocumento];
        if (context.usuario.userName && [context.usuario.userName length] > 0) {
            [Util setSecurityToken:result.tokenSeguridad forBank:request.codBanco andDni:[context.usuario.userName uppercaseString]];
        }
		
		context.dni = request.nroDoc;
		context.tipoDoc = request.tipoDoc;
		
		// No va mas. Ahora las mascaras estan fijos en un plist.
		/*id mascara = [context.mascaraCuentas valueForKey:request.codBanco];
		if (mascara) {
			[Cuenta setMascara:(NSString *)mascara];
		}*/
		
		if ([CommonFunctions validateStrongPassword:pPw] != nil || [context.usuario.nroDocumento isEqualToString:pPw] || context.usuario.needsPinChange) {
            [WSRequest setSecurityToken:[Util getSecurityToken:context.banco.idBanco forDni:context.usuario.nroDocumento]];
			[self presentCambioClave];
			return;
		}
		
	} else {
        
        NSString *errorCode = [[(NSError *)result userInfo] valueForKey:@"faultCode"];
        if ([errorCode isEqualToString:@"ss"]) {
            return;
        }
        
		NSString *errorDesc = [[(NSError *)result userInfo] valueForKey:@"description"];
	
		if (!errorDesc){
			UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Ingreso" message:@"En este momento no se puede realizar la operación. Reintenta más tarde." delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
			//[alertView show];
            [alertView performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
			[alertView release];
			return;
		}
		
		NSRange range = [errorDesc rangeOfString:@"igo 14"];
		if (range.location != NSNotFound)
		{
			UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Ingreso" message:@"Para comenzar a operar, deberás generar tu clave de acceso. ¿Deseas realizarlo ahora?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Si",nil];
				//[alertView show];
            [alertView performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
			[alertView release];
		}else{
			[CommonUIFunctions showAlert:@"Ingreso" withMessage:errorDesc andCancelButton:@"Volver"];
		}
		
		return;
		
	}
    
    [WSRequest setSecurityToken:[Util getSecurityToken:context.banco.idBanco forDni:context.usuario.nroDocumento]];
    
	[self performSelectorOnMainThread:@selector(correctLog) withObject:nil waitUntilDone:YES];
	
	
}

- (void)removeCambioClave {
    UIView *v = [self.view viewWithTag:-105];
    if (v) {
        [v removeFromSuperview];
    }
}

-(void) correctLog {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	Context *context = [Context sharedContext];
	
    //GAnalytics
    // May return nil if a tracker has not yet been initialized.
    id tracker = [[GAI sharedInstance] defaultTracker];
    // Start a new session with a screenView hit.
    GAIDictionaryBuilder *builder = [GAIDictionaryBuilder createScreenView];
    [builder set:@"start" forKey:kGAISessionControl];
    [tracker set:kGAIScreenName value:@"Pantalla Login"];
    [tracker send:[builder build]];
    
	if (context.usuario.viewTerminos) {
		//redireccion para que acepte los terminos y condiciones
		AceptarTerminosController* atycc = [[AceptarTerminosController alloc] initWithController:self];
		atycc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
		[self presentModalViewController:atycc animated:YES];
		[atycc autorelease];
        
        [self performSelectorOnMainThread:@selector(removeCambioClave) withObject:nil waitUntilDone:NO];
        
		return;
	}
	
	if(![self banco:context.banco estaEn:context.bancosSeleccionados]) {
		
		[context.bancosSeleccionados addObject:[context.banco valueForKey:@"idBanco"]];
		
	}
	
	//[context.bancosNoSeleccionados writeToFile:[self pathNoSelectedBanks] atomically:YES];
	[context.bancosSeleccionados writeToFile:[self pathSelectedBanks] atomically:YES];
	[prefs synchronize];
	
	ExecuteCheckVersion *checkVersion = [[ExecuteCheckVersion alloc] initFromController:self];
	[checkVersion execute];
    
}

- (void) executePresentCambioClave {

	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	[NSThread sleepForTimeInterval:0.1];
	//[self presentCambioClave];
    [self performSelectorOnMainThread:@selector(presentCambioClave) withObject:nil waitUntilDone:YES];
	[pool release];

}


-(BOOL) banco:(Banco*) ban estaEn:(NSArray*) listaB {
	
	for (int i =0; i<[listaB count]; i++) {

		if ([ban.idBanco isEqualToString:[listaB objectAtIndex:i] ]) {
			return YES;
		}
		
	}
	return NO;
}



- (void) presentCambioClave : (BOOL)estaVencida {
	self.userField.text=@"";
	self.passField.text=@"";
	CambioClaveController* fcdcc = [[CambioClaveController alloc]init];
    fcdcc.loginController = self;
	fcdcc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	//[self presentModalViewController:fcdcc animated:YES];
    fcdcc.view.tag = -105;
    [self.view addSubview:fcdcc.view];
}


-(IBAction) cambiarTipoDocumento {
	
	if (subMenu.numberOfButtons > 0) {
		[subMenu showInView:self.view];
	}
}

- (void)selectTipoDoc:(NSInteger)buttonIndex {
    if (tipoSeleccionado == 5 && buttonIndex != 5) {
        self.userField.text = @"";
    }
    else if (tipoSeleccionado != 5 && buttonIndex == 5) {
        self.userField.text = @"";
    }
    
    switch (buttonIndex) {
        case 0:
            self.lTipoDocumento.text = @"DNI";
            self.userField.placeholder = @"Nro de Documento";
            self.userField.accessibilityLabel = self.userField.placeholder;
            self.userField.keyboardType = UIKeyboardTypeNumberPad;
            tipoSeleccionado = buttonIndex;
            break;
        case 1:
            self.lTipoDocumento.text = @"CI";
            self.userField.placeholder = @"Nro de Documento";
            self.userField.accessibilityLabel = self.userField.placeholder;
            self.userField.keyboardType = UIKeyboardTypeNumberPad;
            tipoSeleccionado = buttonIndex;
            break;
        case 2:
            self.lTipoDocumento.text = @"PAS";
            self.userField.placeholder = @"Nro de Documento";
            self.userField.accessibilityLabel = self.userField.placeholder;
            self.userField.keyboardType = UIKeyboardTypeNumberPad;
            tipoSeleccionado = buttonIndex;
            break;
        case 3:
            self.lTipoDocumento.text = @"LC";
            self.userField.placeholder = @"Nro de Documento";
            self.userField.accessibilityLabel = self.userField.placeholder;
            self.userField.keyboardType = UIKeyboardTypeNumberPad;
            tipoSeleccionado = buttonIndex;
            break;
        case 4:
            self.lTipoDocumento.text = @"LE";
            self.userField.placeholder = @"Nro de Documento";
            self.userField.accessibilityLabel = self.userField.placeholder;
            self.userField.keyboardType = UIKeyboardTypeNumberPad;
            tipoSeleccionado = buttonIndex;
            break;
        case 5:
            self.lTipoDocumento.text = @"Usuario";
            self.userField.placeholder = @"Usuario";
            self.userField.accessibilityLabel = self.userField.placeholder;
            self.userField.keyboardType = UIKeyboardTypeAlphabet;
            tipoSeleccionado = buttonIndex;
            break;
        default:
            break;
    }
    
    
}

//------------------------------------------------------------------------------------------------------------------------
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{

	if (actionSheet == subMenu){
        
        [self selectTipoDoc:buttonIndex];
		
	}
    else if (actionSheet == subMenuGeneracion){
		switch (buttonIndex) {
			case 0:
				[self pmc];	
				break;
			case 1:
				if ([[[[Context sharedContext] banco] url] length]>1) {
					[self homebanking];
				}else {
					break;
				}
				break;
			case 2:
				break;
			default:
				break;
	}
	}
		
}

-(void) cambioTipoDocumento{
	
}

//--------------------------------------------------------------------
//--------------------------------------------------------------------
//-----------------------ALERT DE CLAVE-------------------------------
//--------------------------------------------------------------------

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{
	if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Si"]){
		//[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.pagomiscuentas.com"]]; 
		[self irACambioDeClave];
	}else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"No"]){
		return;
	}
	
	if ([alertView.title isEqualToString:@"Ingreso"]){
		return;
	}
	
	
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
	NSLog(@"didDismissWithButtonIndex%d", buttonIndex);
}



- (IBAction) mostrarAyuda{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
	AyudaController* ac = [[AyudaController alloc] initWithNibName:@"AyudaFullScreen" bundle:nil];
	[self presentModalViewController:ac animated:YES];
	[ac autorelease];
	return; 
}

- (IBAction)irAOlvideUsuario:(id)sender {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    OlvideUsuarioController *gcc = [[[OlvideUsuarioController alloc] init] autorelease];
    [self presentModalViewController:gcc animated:YES];
    return;
	
}


- (void)dealloc {
	[barTeclado release];
	[barTecladoButton release];	
	[subMenuGeneracion release];
	[link release];
	[lTipoDocumento release];
	[label release];
	//[volverB release];
	[userField release];
	[passField release];
	[blankButton release];
	[subMenu release];
	[ltdoc release];
    self.fndImage = nil;
    [super dealloc];
}


-(BOOL) accessibilityPerformEscape {
    // Dismiss your view
    [self volver];
    return YES;
}

@end
