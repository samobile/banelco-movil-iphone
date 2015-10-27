
#import "CambioClaveController.h"
#import "LoginController.h"
#import "Context.h"
#import "CommonUIFunctions.h"
#import "WS_CambiarPin.h"
#import "WSUtil.h"
#import <QuartzCore/QuartzCore.h>
#import "CommonFunctions.h"
#import "LoginController.h"
#import "ExecuteLogin.h"

@implementation CambioClaveController

@synthesize oldPassField, newPassField, newPassConfirmField;
@synthesize blankButton;

@synthesize barTeclado,barTecladoButton;

@synthesize alert,tituloDePantalla, fndImage, loginController;



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    int tipo = 5;
    if (![[Context sharedContext].tipoDoc isEqualToString:@"U"]) {
        tipo = [[Context sharedContext].tipoDoc intValue]-1;
    }
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",tipo] forKey:[Context sharedContext].banco.idBanco];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
	[super viewDidLoad];
     Context *context = [Context sharedContext];
    
    if (![Context sharedContext].personalizado) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    
    if(context.usuario.needsPinChange && !context.usuario.firstLogin)
    {
        [tituloDePantalla setText:@"La clave ha vencido"];
    }
 
    
	oldPassField.delegate = self;
	newPassField.delegate = self;
	newPassConfirmField.delegate = self;
	//[oldPassField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
	//[newPassField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
	//[newPassConfirmField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
	
	
	[oldPassField setKeyboardType:UIKeyboardTypeNumberPad];
	[newPassField setKeyboardType:UIKeyboardTypeNumberPad];
	[newPassConfirmField setKeyboardType:UIKeyboardTypeNumberPad];
	
	self.blankButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.blankButton.accessibilityLabel = @"Cerrar teclado";
	self.blankButton.frame = CGRectMake(0, 0, 320, IPHONE5_HDIFF(199));
	self.blankButton.alpha = 0.1;
	[self.blankButton setTitle:@"" forState:UIControlStateNormal];
	[self.blankButton addTarget:self action:@selector(hideKeyboard) forControlEvents:UIControlEventTouchUpInside];
	
	 
	
	
	self.barTeclado = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"barra_teclado.png"]];
	barTeclado.alpha = 0;
	
	self.barTecladoButton = [UIButton buttonWithType:UIButtonTypeCustom];
	barTecladoButton.frame = CGRectMake(222, IPHONE5_HDIFF(488), 88, 29);
	barTecladoButton.alpha =1;
//	barTecladoButton.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"barra_boton.png"]];

	[barTecladoButton setImage:[UIImage imageNamed:@"btn_TecSiguiente.png"] forState:UIControlStateNormal];
    barTecladoButton.accessibilityLabel = @"Siguiente";
	[barTecladoButton setTitle:@"" forState:UIControlStateNormal];
	[barTecladoButton addTarget:self action:@selector(keyboardButtonAction) forControlEvents:UIControlEventTouchUpInside];
	
	
	[self.view addSubview:barTeclado];
	[self.view addSubview:barTecladoButton];
	
	tituloDePantalla.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
    if (![Context sharedContext].personalizado) {
        tituloDePantalla.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:18];
        newPassField.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:17];
        oldPassField.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:17];
        newPassConfirmField.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:17];
    }

//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    CGRect fi = self.fndImage.frame;
    fi.size.height = IPHONE5_HDIFF(fi.size.height);
    self.fndImage.frame = fi;
}

- (void)clearFields {
    newPassField.text = @"";
    oldPassField.text = @"";
    newPassConfirmField.text = @"";
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidUnload {
    [super viewDidUnload];
//	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (newPassConfirmField == textField){
        [barTecladoButton setImage:[UIImage imageNamed:@"btn_TecAceptar.png"] forState:UIControlStateNormal];
        barTecladoButton.accessibilityLabel = @"Aceptar";
    }else{
        [barTecladoButton setImage:[UIImage imageNamed:@"btn_TecSiguiente.png"] forState:UIControlStateNormal];
        barTecladoButton.accessibilityLabel = @"Siguiente";
    }
}

- (void) keyboardWillShow: (NSNotification*) aNotification {	
	
	
	[self.view addSubview:self.blankButton];
	if ([newPassConfirmField isFirstResponder]){
		[barTecladoButton setImage:[UIImage imageNamed:@"btn_TecAceptar.png"] forState:UIControlStateNormal];
        barTecladoButton.accessibilityLabel = @"Aceptar";
	}else{
		[barTecladoButton setImage:[UIImage imageNamed:@"btn_TecSiguiente.png"] forState:UIControlStateNormal];
        barTecladoButton.accessibilityLabel = @"Siguiente";
	}

	barTeclado.frame = CGRectMake(0, IPHONE5_HDIFF(480), 320, 45);
	barTeclado.alpha = 1;
	
	barTecladoButton.frame = CGRectMake(222, IPHONE5_HDIFF(488), 88, 29);
	barTecladoButton.alpha =1;
	
	
	
	if ([newPassConfirmField isFirstResponder]) {
		NSLog(@"newPassConfirmField es first response");
	
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3];
		//self.view.frame = CGRectMake(0, -20, 320, 460);
		self.tituloDePantalla.frame = CGRectMake(20, 43, 193, 30);
		
		self.oldPassField.frame = CGRectMake(20, 81, 280, 31);
		self.newPassField.frame = CGRectMake(20, 123, 280, 31);
		self.newPassConfirmField.frame = CGRectMake(20, 162, 280, 31);
		
		
		barTeclado.frame = CGRectMake(0, IPHONE5_HDIFF(199), 320, 45);
		barTecladoButton.frame = CGRectMake(222, IPHONE5_HDIFF(207), 88, 29);
		
		
	//	barTeclado.frame = CGRectMake(0, 239, 320, 45);
	//	barTecladoButton.frame = CGRectMake(222, 247, 88, 29);
		[UIView commitAnimations];
	}else{
		NSLog(@"newPassConfirmField es first response");
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3];
		barTeclado.frame = CGRectMake(0, IPHONE5_HDIFF(199), 320, 45);
		barTecladoButton.frame = CGRectMake(222, IPHONE5_HDIFF(207), 88, 29);
		[UIView commitAnimations];
	}
	
	
	
	
}

- (void) keyboardWillHide: (NSNotification*) aNotification {
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	barTeclado.frame = CGRectMake(0, IPHONE5_HDIFF(480), 320, 50);
	barTeclado.alpha =0;
	barTecladoButton.frame = CGRectMake(222, IPHONE5_HDIFF(488), 88, 29);
	barTecladoButton.alpha =1;
	
	self.tituloDePantalla.frame = CGRectMake(20, 63, 193, 30);
	
	self.oldPassField.frame = CGRectMake(20, 105, 280, 31);
	self.newPassField.frame = CGRectMake(20, 147, 280, 31);
	self.newPassConfirmField.frame = CGRectMake(20, 186, 280, 31);
	
	
	
	[UIView commitAnimations];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	if (string && [string rangeOfString:@" "].location != NSNotFound) {
        return NO;
    }
    if ((!string)||([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0)){
		return YES;
	}
	if (![CommonFunctions hasNumbers:string]) {
		return NO;
	}
	
	
	int max = 8;
    if (range.location >= max)
        return NO; 
    return YES;
}


- (IBAction)keyboardButtonAction{
	
	if([oldPassField isFirstResponder]){
		[newPassField becomeFirstResponder];
		
		
		
	}else if ([newPassField isFirstResponder]) {
		
		[newPassConfirmField becomeFirstResponder];
			[barTecladoButton setImage:[UIImage imageNamed:@"btn_TecAceptar.png"] forState:UIControlStateNormal];
        barTecladoButton.accessibilityLabel = @"Aceptar";
		[NSThread sleepForTimeInterval:0.3];
		
		[self performSelectorOnMainThread:@selector(subirScreen:) withObject:nil waitUntilDone:YES];
	
		
		
		
	
	}else if ([newPassConfirmField isFirstResponder]) {
		
		
		[self.blankButton removeFromSuperview];
		
		//[[NSThread mainThread] performSelector:@selector(bajarScreen)];
		[self performSelectorOnMainThread:@selector(bajarScreen:) withObject:nil waitUntilDone:YES];
		   
		
		[NSThread detachNewThreadSelector:@selector(doAction) toTarget:self withObject:nil];
		[newPassConfirmField resignFirstResponder];
		[newPassField resignFirstResponder];
		[oldPassField resignFirstResponder];
	}else{
	//	[sender resignFirstResponder];
		[self.blankButton removeFromSuperview];
	}
	
	
}

-(void) subirScreen:(id) n{
	
	[UIView beginAnimations:nil context:NULL];
	
	self.tituloDePantalla.frame = CGRectMake(20, 43, 193, 30);
	
	self.oldPassField.frame = CGRectMake(20, 81, 280, 31);
	self.newPassField.frame = CGRectMake(20, 123, 280, 31);
	self.newPassConfirmField.frame = CGRectMake(20, 162, 280, 31);
	
	[UIView setAnimationDuration:0.3];
	[UIView commitAnimations];
}



-(void) bajarScreen:(id) n{
	[UIView beginAnimations:nil context:NULL];
	
	self.tituloDePantalla.frame = CGRectMake(20, 63, 193, 30);
	
	self.oldPassField.frame = CGRectMake(20, 105, 280, 31);
	self.newPassField.frame = CGRectMake(20, 147, 280, 31);
	self.newPassConfirmField.frame = CGRectMake(20, 186, 280, 31);
	
	
	[UIView setAnimationDuration:0.3]; 
	[UIView commitAnimations];
}


- (IBAction)dismissKeyboard:(id)sender{

	
	
	if(sender == oldPassField){
		[newPassField becomeFirstResponder];
	}else if (sender == newPassField) {
		[newPassConfirmField becomeFirstResponder];
	}else if (sender == newPassConfirmField) {
		[self.blankButton removeFromSuperview];
		[NSThread detachNewThreadSelector:@selector(doAction) toTarget:self withObject:nil];
		[newPassConfirmField resignFirstResponder];
		[newPassField resignFirstResponder];
		[oldPassField resignFirstResponder];
	}else{
		[sender resignFirstResponder];
		[self.blankButton removeFromSuperview];
	}
	
	
}

- (void)dismissAll {
	oldPassField.text = @"";
	newPassField.text = @"";
	newPassConfirmField.text = @"";
	[self hideKeyboard];
}





-(IBAction) activarBoton{
	[self.view addSubview:self.blankButton];
}


-(void) hideKeyboard{
	[self.oldPassField resignFirstResponder]; 
	[self.newPassField resignFirstResponder];
	[self.newPassConfirmField resignFirstResponder];
	[self.blankButton removeFromSuperview];
	
//	[UIView beginAnimations:nil context:NULL];
//	self.view.frame = CGRectMake(0, 20, 320, 460);
	
	
//	[UIView setAnimationDuration:0.3];
	
}


-(IBAction) aceptar {
	
	[self cambiarPassword];
	
}

-(BOOL)doChangeOfPW {
	
	id result;
	
	WS_CambiarPin *request = [[WS_CambiarPin alloc] init];
	
	Context *context = [Context sharedContext];
	
	request.userToken = [context getToken];//@"09A5642209";
	//request.userToken = [Util getSecurityToken:context.banco.idBanco forDni:request.nroDoc]; //@"EDF2BB222C";
	request.actualPW = oldPassField.text;
	request.newPW = newPassField.text;
	
	// Parseo el xml para obtener los datos del usuario
	result = [WSUtil execute:request];
	
	if ([result isKindOfClass:[NSError class]]) {
		
        NSString *errorCode = [[(NSError *)result userInfo] valueForKey:@"faultCode"];
        if ([errorCode isEqualToString:@"ss"]) {
            return NO;
        }
        
		NSString *errorDesc = [[(NSError *)result userInfo] valueForKey:@"description"];
		//[CommonUIFunctions showAlert:@"Error de cambio de clave" withMessage:errorDesc andCancelButton:@"Volver"];

		[CommonUIFunctions showAlert:@"Cambio de clave" withMessage:errorDesc cancelButton:@"Volver" andDelegate:self];
		return FALSE;
		
	}else {
		//[self apagarRueda];
		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
		[prefs setBool:YES forKey:@"yaCambioPass"];
		if([prefs synchronize]){
		}
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Contraseña" message:@"La nueva clave de ingreso se actualizó correctamente." 
													   delegate:self 
											  cancelButtonTitle:@"Aceptar" otherButtonTitles:nil]; 
		
//		LoginController* lvc = [[LoginController alloc] init];
//		lvc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//		[self presentModalViewController:lvc animated:YES];
//		[self dismissModalViewControllerAnimated:YES];
		//[alert show];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
		[alert release];
        
        [self apagarRueda];
        
//        NSString *dniOrUser = [context.tipoDoc isEqualToString:@"U"] ? context.usuario.userName : context.usuario.nroDocumento;
//        self.loginController.password = newPassField.text;
//        self.loginController.userField.text = dniOrUser;
//        self.loginController.passField.text = newPassField.text;
//        self.loginController.forceLogin = YES;
//        
//        //[contr performSelectorOnMainThread:@selector(inicioAccion) withObject:nil waitUntilDone:YES];
//        [self dismissViewControllerAnimated:YES completion:nil];

		return TRUE;
	}


	
	
}

- (void)alertViewCancel:(UIAlertView *)alertView {
	
	
	if([alertView.message isEqualToString:@"La nueva clave de ingreso se actualizó correctamente." ]){
	}
	
	
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	
	if([alertView.message isEqualToString:@"La nueva clave de ingreso se actualizó correctamente." ]){
		
        if ([[Context sharedContext].usuario.userName length] > 0 && ![[Context sharedContext].tipoDoc isEqualToString:@"U"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Tu usuario es: %@", [Context sharedContext].usuario.userName] message:@"En el próximo ingreso deberás completar este usuario y tu clave para ingresar a la aplicación." delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
            alert.tag = 999;
            [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
            [alert release];
            
        }
        else {
            Context *context = [Context sharedContext];
            NSString *dniOrUser = [context.tipoDoc isEqualToString:@"U"] ? context.usuario.userName : context.usuario.nroDocumento;
            self.loginController.password = newPassField.text;
            self.loginController.userField.text = dniOrUser;
            self.loginController.passField.text = newPassField.text;
            self.loginController.forceLogin = YES;
            
            [self.loginController forzarLogin];
//            LoginController* lvc = [[LoginController alloc] init];
//            lvc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//            [self presentModalViewController:lvc animated:YES];
            
//            ExecuteLogin *e = [[ExecuteLogin alloc] initFromController:self withDoc:[Context sharedContext].usuario.userName
//                                                                ofType:@"U"
//                                                                 andPW:newPassField.text];
//            [e executeLogin];
            
            
        }
	}
	
    if(alertView.tag == 999){
//		LoginController* lvc = [[LoginController alloc] init];
//		lvc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//		[self presentModalViewController:lvc animated:YES];
        
        Context *context = [Context sharedContext];
        NSString *dniOrUser = [context.tipoDoc isEqualToString:@"U"] ? context.usuario.userName : context.usuario.nroDocumento;
        self.loginController.password = newPassField.text;
        self.loginController.userField.text = dniOrUser;
        self.loginController.passField.text = newPassField.text;
        self.loginController.forceLogin = YES;
        
        [self.loginController forzarLogin];
	}
}


- (void) doAction {
	NSAutoreleasePool *pool= [[NSAutoreleasePool alloc]init];
	
	[NSThread sleepForTimeInterval:0.4];
	
	//[self ingresar];
	[self performSelectorOnMainThread:@selector(cambiarPassword) withObject:nil waitUntilDone:YES];
	
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



-(void) cambiarPassword{
	
	if ([oldPassField.text length] != 8) {	
		UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@"Contraseña" message:@"La clave debe ser de 8 dígitos."
												   delegate:self 
										  cancelButtonTitle:@"Aceptar" otherButtonTitles:nil]; 
		[alert2 show];
		[alert2 release];
		return;
	}
	
	if ([newPassField.text length] != 8) {
		UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@"Contraseña" message:@"La nueva clave debe ser de 8 dígitos."
												   delegate:self 
										  cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
		[alert2 show];
		[alert2 release];
		return;
	}
	
	if(![newPassField.text isEqualToString:newPassConfirmField.text]) {
		UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@"Contraseña" message:@"La clave nueva difiere de la clave de confirmación."
												   delegate:self 
										  cancelButtonTitle:@"Aceptar" otherButtonTitles:nil]; 
		[alert2 show];
		[alert2 release];
		return;
	}
    
    if([newPassField.text isEqualToString:oldPassField.text]) {
		UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@"Contraseña" message:@"La clave anterior y nueva deben diferir."
													   delegate:self
											  cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
		[alert2 show];
		[alert2 release];
		return;
	}
	
    if([newPassField.text isEqualToString:oldPassField.text]) {
		UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@"Contraseña" message:@"La clave anterior y nueva deben diferir."
													   delegate:self
											  cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
		[alert2 show];
		[alert2 release];
		return;
	}
    
	Context* context = [Context sharedContext];
    if ([context.usuario.nroDocumento isEqualToString:newPassField.text]) {
        UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@"Contraseña" message:@"La contraseña no puede ser tu número de documento."
                                                       delegate:self
                                              cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
        [alert2 show];
        [alert2 release];
        return;
    }
    
	//NSString* msn = [self validPassword:newPassField.text withDni:context.dni];
    NSString* msn = [CommonFunctions validateStrongPassword:newPassField.text];
	if (msn){
		UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@"Contraseña" message:msn
													   delegate:self 
											  cancelButtonTitle:@"Aceptar" otherButtonTitles:nil]; 
		[alert2 show];
		[alert2 release];
		return;
	}

	
	
	
	alert = [[WaitingAlert alloc] initWithH:20];
	[self.view addSubview:alert];
	[alert startWithSelector:@"doChangeOfPW" fromTarget:self andFinishSelector:@"finishAlert" formTarget:self];
	
	
}


- (void) finishAlert {
	[alert performSelectorOnMainThread:@selector(detener) withObject:nil waitUntilDone:NO];
}

-(NSString*) validPassword:(NSString*) pass withDni:(NSString*) dni{
	NSString* message = nil;
	
	int c3 = 1;
	int sa = 1; // secuencia ascendentes
	int sd = 1; // secuencias descendentes.
	int cantPermitida = 3;
	
	int digito1;
	int digito2;
	
	for (int i=0; i<6; i++) {
		digito1 =[pass characterAtIndex:i];
		digito2 =[pass characterAtIndex:i+1];
		
		if (digito1+1 == digito2){
			sa++;
		}
		if (digito1 == digito2+1){
			sd++;
		}
		if (digito1 == digito2){
			c3++;
		}
		
	}
	
	NSRange aRange = [pass rangeOfString:dni];
	NSRange bRange = [dni rangeOfString:pass];
    
      BOOL rep = [[pass substringToIndex:4]isEqualToString:[pass substringFromIndex:4]];
	
	if ((c3 > cantPermitida) || (sa > cantPermitida) || (sd > cantPermitida) || (aRange.location != NSNotFound) || (bRange.location != NSNotFound) || rep){
		
		message = @"Ingresá otra clave. Recordá que la misma no debe ser asociable a tu número de documento, no debe repetir caracteres, ni estar conformada por secuencias ascendentes o descendentes.";
	}
	return message;
	
	
}



-(void) apagarRueda{
	[self performSelector:@selector(finalUpdate) withObject:nil afterDelay:0];
}


- (void)dealloc {
	[tituloDePantalla release];
	[alertView release];	
	[barTeclado release];
	[oldPassField  release];
	[newPassField release];
	[newPassConfirmField release];
	[blankButton release];
    self.fndImage = nil;
    [super dealloc];
}


@end
