#import "GenerarUsuarioController.h"
#import "Context.h"
#import "CommonUIFunctions.h"
#import "WS_ManagePerfilUsuario.h"
#import "WSUtil.h"
#import <QuartzCore/QuartzCore.h>
#import "BanelcoMovilIphoneViewController.h"
#import "CommonFunctions.h"
#import "CommonFuncBanelco.h"
#import "ExecuteLogin.h"
#import "Util.h"
#import "ManagePerfilUsuarioResponse.h"

@implementation GenerarUsuarioController


@synthesize oldPassField;
@synthesize newPassField;
@synthesize blankButton;
@synthesize contr,alert,tituloDePantalla;
@synthesize barTeclado,barTecladoButton, fndImage,titDatos, label;


- (id)initwithCargaDatos:(BOOL)cargaDatos
{
    self = [super init];
    if (self) {
    }
    return self;
}

-(id) initWithController:(BanelcoMovilIphoneViewController*)control CargaDatos:(BOOL)cargaDatos{
	
	if(self = [super init]){
		self.contr = control;
        self.nav_volver =YES;
	}
	
	return self;
}

- (void)viewDidLoad {
  
	[super viewDidLoad];
    
    if (![Context sharedContext].personalizado) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
	
	//tituloDePantalla.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
    titDatos.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TitleTxtColor"];
    label.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
    if (![Context sharedContext].personalizado) {
        titDatos.font=[UIFont fontWithName:@"BanelcoBeau-Regular" size:17];
        label.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:15];
        newPassField.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:13];
        oldPassField.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:13];
    }
	
	oldPassField.delegate = self;
	newPassField.delegate = self;
	
	
	self.blankButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.blankButton.accessibilityLabel = @"Cerrar teclado";
	//self.blankButton.frame = CGRectMake(0, 0, 320, 100);
    self.blankButton.frame = CGRectMake(0, 0, 320, IPHONE5_HDIFF(100));
	self.blankButton.alpha = 0.1;
	[self.blankButton setTitle:@"" forState:UIControlStateNormal];
	[self.blankButton addTarget:self action:@selector(hideKeyboard) forControlEvents:UIControlEventTouchUpInside];


//	barTeclado = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"barra_teclado.png"]];
//	barTeclado.alpha = 0;
//	
//	barTecladoButton = [UIButton buttonWithType:UIButtonTypeCustom];
//	//barTecladoButton.frame = CGRectMake(222, 488, 88, 29);
//    barTecladoButton.frame = CGRectMake(222, IPHONE5_HDIFF(488), 88, 29);
//	barTecladoButton.alpha =1;
//	//	barTecladoButton.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"barra_boton.png"]];
//	
//	[barTecladoButton setImage:[UIImage imageNamed:@"btn_TecAceptar.png"] forState:UIControlStateNormal];
//	[barTecladoButton setTitle:@"" forState:UIControlStateNormal];
//	[barTecladoButton addTarget:self action:@selector(keyboardButtonAction) forControlEvents:UIControlEventTouchUpInside];
//	
//	
//	[self.view addSubview:barTeclado];
//	[self.view addSubview:barTecladoButton];
	
	CGRect fi = self.fndImage.frame;
    fi.size.height = IPHONE5_HDIFF(fi.size.height);
    self.fndImage.frame = fi;
	

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshDatos];
}

-(void) subirScreen:(id) n{
	
//	[UIView beginAnimations:nil context:NULL];
//	//self.titDatos.frame = CGRectMake(20, -33, self.titDatos.frame.size.width , self.titDatos.frame.size.height);
//	self.nombre.frame =CGRectMake(20, -33, self.nombre.frame.size.width , self.nombre.frame.size.height);
//    self.ultAcc.frame =CGRectMake(20, -33, self.ultAcc.frame.size.width , self.ultAcc.frame.size.height);
//    self.venc.frame=CGRectMake(20, -31, self.venc.frame.size.width , self.venc.frame.size.height);
//	self.titPassword.frame = CGRectMake(20, -33, self.titPassword.frame.size.width , self.titPassword.frame.size.height);
//    
//	self.oldPassField.frame = CGRectMake(20, 47, self.oldPassField.frame.size.width , self.oldPassField.frame.size.height);
//	self.newPassField.frame = CGRectMake(20, 86, self.newPassField.frame.size.width , self.newPassField.frame.size.height);
//	self.newPassConfirmField.frame = CGRectMake(20, 125, self.newPassConfirmField.frame.size.width , self.newPassConfirmField.frame.size.height);
//    
//	[UIView setAnimationDuration:0.3];
//	[UIView commitAnimations];
}



-(void) bajarScreen:(id) n{
    
//	[UIView beginAnimations:nil context:NULL];
////    self.titDatos.frame = CGRectMake(20, 10, self.titDatos.frame.size.width , self.titDatos.frame.size.height);
//	self.nombre.frame =CGRectMake(20, 48, self.nombre.frame.size.width , self.nombre.frame.size.height);
//    self.ultAcc.frame =CGRectMake(20, 84, self.ultAcc.frame.size.width , self.ultAcc.frame.size.height);
//    self.venc.frame=CGRectMake(20, 113, self.venc.frame.size.width , self.venc.frame.size.height);
//    
//    
//	self.titPassword.frame = CGRectMake(20, 147, self.titPassword.frame.size.width , self.titPassword.frame.size.height);
//	self.oldPassField.frame = CGRectMake(20, 185, self.oldPassField.frame.size.width , self.oldPassField.frame.size.height);
//	self.newPassField.frame = CGRectMake(20, 224, self.newPassField.frame.size.width , self.newPassField.frame.size.height);
//	self.newPassConfirmField.frame = CGRectMake(20, 263, self.newPassConfirmField.frame.size.width , self.newPassConfirmField.frame.size.height);
//	
//	[UIView setAnimationDuration:0.3];
//	[UIView commitAnimations];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == oldPassField){
		[newPassField becomeFirstResponder];
		
	}else if (textField == newPassField) {
		
		
		[self.blankButton removeFromSuperview];
		
		//[[NSThread mainThread] performSelector:@selector(bajarScreen)];
		[self performSelectorOnMainThread:@selector(bajarScreen:) withObject:nil waitUntilDone:YES];
		
		
		[NSThread detachNewThreadSelector:@selector(doAction) toTarget:self withObject:nil];
		[newPassField resignFirstResponder];
		[oldPassField resignFirstResponder];
	}else{
		//	[sender resignFirstResponder];
		[self.blankButton removeFromSuperview];
	}
    return YES;
}

- (IBAction)keyboardButtonAction{
	
	if([oldPassField isFirstResponder]){
		[newPassField becomeFirstResponder];
		
	}else if ([newPassField isFirstResponder]) {
		
		
		[self.blankButton removeFromSuperview];
		
		//[[NSThread mainThread] performSelector:@selector(bajarScreen)];
		[self performSelectorOnMainThread:@selector(bajarScreen:) withObject:nil waitUntilDone:YES];
		
		
		[NSThread detachNewThreadSelector:@selector(doAction) toTarget:self withObject:nil];
		[newPassField resignFirstResponder];
		[oldPassField resignFirstResponder];
	}else{
		//	[sender resignFirstResponder];
		[self.blankButton removeFromSuperview];
	}
	
	
}

- (void) keyboardWillShow: (NSNotification*) aNotification {	
	
	//Setea el boton de la barra
	[self.view addSubview:self.blankButton];
//	if ([newPassField isFirstResponder]){
//		[barTecladoButton setImage:[UIImage imageNamed:@"btn_TecAceptar.png"] forState:UIControlStateNormal];
//	}else{
//		[barTecladoButton setImage:[UIImage imageNamed:@"btn_TecSiguiente.png"] forState:UIControlStateNormal];
//	}
// 
//	//Oculta la barra
//	
//    barTeclado.frame = CGRectMake(0, IPHONE5_HDIFF(480), 320, 45);
//	barTeclado.alpha = 1;
//	
//	
//    barTecladoButton.frame = CGRectMake(222, IPHONE5_HDIFF(488), 88, 29);
//	barTecladoButton.alpha =1;
//	
//	
//	
//	
//    //Mueve la nueva barra a su posicion y los campos para que sean visibles
//	[UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:0.3];
//    
//	
//    //[self subirScreen:nil];
//    
//	
//    barTeclado.frame = CGRectMake(0, IPHONE5_HDIFF(144), 320, 45);
//    
//    barTecladoButton.frame = CGRectMake(222, IPHONE5_HDIFF(152), 88, 29);
//    
//    [UIView commitAnimations];
	
	
	
}

- (void) keyboardWillHide: (NSNotification*) aNotification {
	
    //Oculta la barra y vuelve todo a su lugar
//	[UIView beginAnimations:nil context:NULL];
//	[UIView setAnimationDuration:0.3];
//
//    barTeclado.frame = CGRectMake(0, IPHONE5_HDIFF(480), 320, 50);
//	barTeclado.alpha =0;
//
//    barTecladoButton.frame = CGRectMake(222, IPHONE5_HDIFF(488), 88, 29);
//	barTecladoButton.alpha =1;
//    
//    //[self bajarScreen:nil];
//
//	
//	
//	
//	[UIView commitAnimations];
}





- (void)viewDidUnload {
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
	
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	if (string && [string rangeOfString:@" "].location != NSNotFound) {
        return NO;
    }
	if ((!string)||([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0)){
		return YES;
	}
	if (![CommonFunctions hasAlphaNumeric:string]) {
		return NO;
	}
	
	int max = 12;
    if (range.location >= max)
        return NO;
    
    textField.text = [NSString stringWithFormat:@"%@%@",textField.text,[string uppercaseString]];
    
    return NO;
}



- (IBAction)dismissKeyboard:(id)sender{
	

	if(sender == oldPassField){
		[newPassField becomeFirstResponder];
	}else if (sender == newPassField) {
		[self.blankButton removeFromSuperview];
		[NSThread detachNewThreadSelector:@selector(doAction) toTarget:self withObject:nil];
		[newPassField resignFirstResponder];
		[oldPassField resignFirstResponder];
	}else{
		[sender resignFirstResponder];
		[self.blankButton removeFromSuperview];
	}
	
	
}



-(IBAction) activarBoton{

	[self.view addSubview:self.blankButton];
}

- (void)dismissAll {

	
	NSLog(@"Dismiss All");
//	oldPassField.text = @"";
//	newPassField.text = @"";
//	newPassConfirmField.text = @"";
	//[self hideKeyboard];
    [self performSelectorOnMainThread:@selector(hideKeyboard) withObject:nil waitUntilDone:YES];
}



-(void) hideKeyboard{
	
	NSLog(@"Hide Keyboard");
	[self.oldPassField resignFirstResponder]; 
	[self.newPassField resignFirstResponder];
	[self.blankButton removeFromSuperview];
	
}
-(IBAction) aceptar {
	
	[self generarUsuario];
	
}

-(BOOL)doGeneraUsuario {
	
	ManagePerfilUsuarioResponse *result = nil;
	
	WS_ManagePerfilUsuario *request = [[WS_ManagePerfilUsuario alloc] init];
	
	Context *context = [Context sharedContext];
	
	request.userToken = [context getToken];
	request.nickName = [oldPassField.text uppercaseString];
	request.email = context.usuario.email;
    request.novedades = context.usuario.showInfo;
    request.vencimientos = context.usuario.showVencim;
    request.retornarLogueoDNI = NO;
    
	result = [WSUtil execute:request];
	
	if ([result isKindOfClass:[NSError class]]) {
		
        NSString *errorCode = [[(NSError *)result userInfo] valueForKey:@"faultCode"];
        if ([errorCode isEqualToString:@"ss"]) {
            return NO;
        }
		NSString *errorDesc = [[(NSError *)result userInfo] valueForKey:@"description"];
		[CommonUIFunctions showAlert:@"Usuario" withMessage:errorDesc cancelButton:@"Volver" andDelegate:self];
		return FALSE;
		
	}else {
        
        //if (result.tokenSeguridad && [result.tokenSeguridad length] > 0) {
            
            NSLog(@"Generar Usuario: %@", result.tokenSeguridad);
            
            context.usuario.userName =  [oldPassField.text uppercaseString];
            //context.tipoDoc = @"U";
            
            [CommonUIFunctions showAlert:@"Usuario" withMessage:@"El usuario se generó correctamente." andCancelButton:@"Aceptar"];
            
            [self apagarRueda];
            
            [self performSelectorOnMainThread:@selector(refreshDatos) withObject:nil waitUntilDone:NO];
            
            [self.contr performSelectorOnMainThread:@selector(inicioAccion) withObject:nil waitUntilDone:YES];
            //[alert show];
            //        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
            //		[alert release];
            
            Context *context = [Context sharedContext];
            NSString *token = [Util getSecurityToken:context.banco.idBanco forDni:context.usuario.nroDocumento];
        
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *oldNickName = [prefs objectForKey:[NSString stringWithFormat:@"%@_%@",context.banco.idBanco,context.usuario.nroDocumento]];
        if (oldNickName && ![[oldNickName uppercaseString] isEqualToString:[context.usuario.userName uppercaseString]]) {
            [Util deleteSecurityTokenforBank:context.banco.idBanco andDni:[oldNickName uppercaseString]];
        }
        if ([context.usuario.userName length] > 0) {
            [prefs setObject:[context.usuario.userName uppercaseString] forKey:[NSString stringWithFormat:@"%@_%@",context.banco.idBanco,context.usuario.nroDocumento]];
        }
        else {
            [prefs removeObjectForKey:[NSString stringWithFormat:@"%@_%@",context.banco.idBanco,context.usuario.nroDocumento]];
        }
        [prefs synchronize];
        //}
        
        [Util setSecurityToken:token forBank:context.banco.idBanco andDni:[self.oldPassField.text uppercaseString]];
		
		return TRUE;
	}
	
	
	
	
}

- (void)refreshDatos {

}


-(void) apagarRueda{
	[self performSelector:@selector(finalUpdate) withObject:nil afterDelay:0];
}

- (void)alertViewCancel:(UIAlertView *)alertView {
	
	
}

- (void) doAction {
	NSAutoreleasePool *pool= [[NSAutoreleasePool alloc]init];
	
	[NSThread sleepForTimeInterval:0.2];
	
	//[self ingresar];
	[self performSelectorOnMainThread:@selector(generarUsuario) withObject:nil waitUntilDone:YES];
	
	[pool release];
}


- (void)finalUpdate
{
    [UIView beginAnimations:@"" context:nil];
    self.alertView.alpha = 0.0;
    [UIView commitAnimations];
    [UIView setAnimationDuration:0.35];
    [self performSelector:@selector(removeAlert) withObject:nil afterDelay:0.5];
	[[UIApplication sharedApplication] endIgnoringInteractionEvents];
}


- (void)removeAlert
{
    [self.alertView removeFromSuperview];
    self.alertView.alpha = 1.0;
	
	
	
}




-(void) generarUsuario{
	
    if ([oldPassField.text length] == 0) {
		UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@"Usuario" message:@"El usuario no debe estar vacío." delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
		[alert2 show];
		[alert2 release];
		return;
	}
    
	if ([oldPassField.text length] < 8) {
		UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@"Usuario" message:@"Ingresá un usuario alfanumérico de 8 a 12 caracteres." delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
		[alert2 show];
		[alert2 release];
		return;
	}
    
    BOOL ok = [CommonFunctions hasNumbersAndLetters:oldPassField.text];
    //BOOL letters = [CommonFunctions hasAlphabet:oldPassField.text];
    //BOOL num = [CommonFunctions hasNumeric:oldPassField.text];
    if (!ok) {
        UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@"Usuario" message:@"Ingresá un usuario alfanumérico de 8 a 12 caracteres." delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
		[alert2 show];
		[alert2 release];
		return;
    }
	
	if(![[newPassField.text uppercaseString] isEqualToString:[oldPassField.text uppercaseString]]) {
		UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@"Usuario" message:@"El usuario nuevo difiere del usuario de confirmación." delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
		[alert2 show];
		[alert2 release];
		return;
	}
	
	alert = [[WaitingAlert alloc] initWithH:20];
	[self.view addSubview:alert];
	[alert startWithSelector:@"doGeneraUsuario" fromTarget:self andFinishSelector:@"finishAlert" formTarget:self];
	
}


- (void) finishAlert {
	[alert performSelectorOnMainThread:@selector(detener) withObject:nil waitUntilDone:NO];
}


- (void)clearFields {
    newPassField.text = @"";
    oldPassField.text = @"";
}




- (void)dealloc {
    self.label = nil;
	[tituloDePantalla release];
	[alert release];
	[contr release];
	[oldPassField  release];
	[newPassField release];
	[blankButton release];
    self.fndImage = nil;
    [super dealloc];
}



@end
