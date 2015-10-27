#import "ChangePasswordController.h"
#import "Context.h"
#import "CommonUIFunctions.h"
#import "WS_CambiarPin.h"
#import "WSUtil.h"
#import <QuartzCore/QuartzCore.h>
#import "BanelcoMovilIphoneViewController.h"
#import "CommonFunctions.h"
#import "ExecuteLogin.h"


@implementation ChangePasswordController


@synthesize oldPassField;
@synthesize newPassField;
@synthesize newPassConfirmField;
@synthesize blankButton;
@synthesize contr,alert,tituloDePantalla;
@synthesize barTeclado,barTecladoButton, fndImage,titDatos,titPassword,venc,ultAcc,nombre;


- (id)initwithCargaDatos:(BOOL)cargaDatos
{
    self = [super init];
    if (self) {
        cargaD = cargaDatos;
    }
    return self;
}

-(id) initWithController:(BanelcoMovilIphoneViewController*)control CargaDatos:(BOOL)cargaDatos{
	
	if(self = [super init]){
		self.contr = control;
         cargaD = cargaDatos;
        self.nav_volver =YES;
	}
	
	return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
  
	[super viewDidLoad];
    
    if (![Context sharedContext].personalizado) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
	
	//tituloDePantalla.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
    titDatos.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TitleTxtColor"];
    if (![Context sharedContext].personalizado) {
        newPassField.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:13];
        oldPassField.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:13];
        newPassConfirmField.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:13];
    }
	
	oldPassField.delegate = self;
	newPassField.delegate = self;
	newPassConfirmField.delegate = self;
	
	[oldPassField setKeyboardType:UIKeyboardTypeNumberPad];
	[newPassField setKeyboardType:UIKeyboardTypeNumberPad];
	[newPassConfirmField setKeyboardType:UIKeyboardTypeNumberPad];
	
	
	self.blankButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.blankButton.accessibilityLabel = @"Cerrar teclado";
	//self.blankButton.frame = CGRectMake(0, 0, 320, 100);
    self.blankButton.frame = CGRectMake(0, 0, 320, IPHONE5_HDIFF(100));
	self.blankButton.alpha = 0.1;
	[self.blankButton setTitle:@"" forState:UIControlStateNormal];
	[self.blankButton addTarget:self action:@selector(hideKeyboard) forControlEvents:UIControlEventTouchUpInside];


	barTeclado = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"barra_teclado.png"]];
	barTeclado.alpha = 0;
	
	barTecladoButton = [UIButton buttonWithType:UIButtonTypeCustom];
	//barTecladoButton.frame = CGRectMake(222, 488, 88, 29);
    barTecladoButton.frame = CGRectMake(222, IPHONE5_HDIFF(488), 88, 29);
	barTecladoButton.alpha =1;
	//	barTecladoButton.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"barra_boton.png"]];
	
	[barTecladoButton setImage:[UIImage imageNamed:@"btn_TecAceptar.png"] forState:UIControlStateNormal];
    barTecladoButton.accessibilityLabel = @"Aceptar";
	[barTecladoButton setTitle:@"" forState:UIControlStateNormal];
	[barTecladoButton addTarget:self action:@selector(keyboardButtonAction) forControlEvents:UIControlEventTouchUpInside];
	
	
	[self.view addSubview:barTeclado];
	[self.view addSubview:barTecladoButton];
	
	CGRect fi = self.fndImage.frame;
    fi.size.height = IPHONE5_HDIFF(fi.size.height);
    self.fndImage.frame = fi;
	

//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshDatos];
    
    int tipo = 5;
    if (![[Context sharedContext].tipoDoc isEqualToString:@"U"]) {
        tipo = [[Context sharedContext].tipoDoc intValue]-1;
    }
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",tipo] forKey:[Context sharedContext].banco.idBanco];
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

- (void) keyboardWillShow: (NSNotification*) aNotification {	
	
	//Setea el boton de la barra
	[self.view addSubview:self.blankButton];
	if ([newPassConfirmField isFirstResponder]){
		[barTecladoButton setImage:[UIImage imageNamed:@"btn_TecAceptar.png"] forState:UIControlStateNormal];
        barTecladoButton.accessibilityLabel = @"Aceptar";
	}else{
		[barTecladoButton setImage:[UIImage imageNamed:@"btn_TecSiguiente.png"] forState:UIControlStateNormal];
        barTecladoButton.accessibilityLabel = @"Siguiente";
	}
 
	//Oculta la barra
	
    barTeclado.frame = CGRectMake(0, IPHONE5_HDIFF(480), 320, 45);
	barTeclado.alpha = 1;
	
	
    barTecladoButton.frame = CGRectMake(222, IPHONE5_HDIFF(488), 88, 29);
	barTecladoButton.alpha =1;
	
	
	
	
    //Mueve la nueva barra a su posicion y los campos para que sean visibles
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
	
    //[self subirScreen:nil];
    
	
    barTeclado.frame = CGRectMake(0, IPHONE5_HDIFF(144), 320, 45);
    
    barTecladoButton.frame = CGRectMake(222, IPHONE5_HDIFF(152), 88, 29);
    
    [UIView commitAnimations];
	
	
	
}

- (void) keyboardWillHide: (NSNotification*) aNotification {
	
    //Oculta la barra y vuelve todo a su lugar
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];

    barTeclado.frame = CGRectMake(0, IPHONE5_HDIFF(480), 320, 50);
	barTeclado.alpha =0;

    barTecladoButton.frame = CGRectMake(222, IPHONE5_HDIFF(488), 88, 29);
	barTecladoButton.alpha =1;
    
    //[self bajarScreen:nil];

	
	
	
	[UIView commitAnimations];
}





- (void)viewDidUnload {
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
	
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
	[self.newPassConfirmField resignFirstResponder];
	[self.blankButton removeFromSuperview];
	
}
-(IBAction) aceptar {
	
	[self cambiarPassword];
	
}

-(BOOL)doChangeOfPW {
	
	id result;
	
	WS_CambiarPin *request = [[WS_CambiarPin alloc] init];
	
	Context *context = [Context sharedContext];
	
	request.userToken = [context getToken];
	request.actualPW = oldPassField.text;
	request.newPW = newPassField.text;
	result = [WSUtil execute:request];
	
	if ([result isKindOfClass:[NSError class]]) {
		
        NSString *errorCode = [[(NSError *)result userInfo] valueForKey:@"faultCode"];
        if ([errorCode isEqualToString:@"ss"]) {
            return NO;
        }
		NSString *errorDesc = [[(NSError *)result userInfo] valueForKey:@"description"];
		[CommonUIFunctions showAlert:@"Cambio de clave" withMessage:errorDesc cancelButton:@"Volver" andDelegate:self];
		return FALSE;
		
	}else {
        
		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
		[prefs setBool:YES forKey:@"yaCambioPass"];
		if([prefs synchronize]){
		}
        
        [CommonUIFunctions showAlert:@"Contraseña" withMessage:@"La nueva clave de ingreso se actualizó correctamente." andCancelButton:@"Aceptar"];
        
        NSString *pass = newPassField.text;
        
        [oldPassField performSelectorOnMainThread:@selector(setText:) withObject:@"" waitUntilDone:NO];
        [newPassField performSelectorOnMainThread:@selector(setText:) withObject:@"" waitUntilDone:NO];
        [newPassConfirmField performSelectorOnMainThread:@selector(setText:) withObject:@"" waitUntilDone:NO];
        
        NSString *dniOrUser = [context.tipoDoc isEqualToString:@"U"] ? context.usuario.userName : context.usuario.nroDocumento;

        ExecuteLogin *e = [[ExecuteLogin alloc] initFromController:nil withDoc:dniOrUser ofType:context.tipoDoc andPW:pass];
		[e doLoginAfterChangePassOfDoc:dniOrUser ofType:context.tipoDoc andPW:pass];
		
        //actualiza lista deudas para caso de uso de pagos
        [Deuda getDeudas];
        
        [self apagarRueda];
        
        [self performSelectorOnMainThread:@selector(refreshDatos) withObject:nil waitUntilDone:NO];
        
//		oldPassField.text = @"";
//		newPassField.text = @"";
//		newPassConfirmField.text = @"";

		
        
//		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Contraseña" message:@"La nueva clave de ingreso se actualizó correctamente."
//													   delegate:self 
//											  cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
		//[contr inicioAccion];
        [contr performSelectorOnMainThread:@selector(inicioAccion) withObject:nil waitUntilDone:YES];
		//[alert show];
//        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
//		[alert release];
		
		return TRUE;
	}
	
	
	
	
}

- (void)refreshDatos {
//    Context *context = [Context sharedContext];
//    ultAcc.text = @"Último Acceso: ";
//    venc.text = @"Vencimiento de Clave: ";
//    [nombre setText: context.usuario.fullname];
//    ultAcc.text = [[ultAcc.text stringByAppendingString:[CommonFuncBanelco dateToNSString:context.usuario.ultimoLogin withFormat:@"dd/MM/yyyy HH:mm:ss"]]stringByAppendingString:@" Hs"];
//    venc.text =  [venc.text stringByAppendingString:[CommonFuncBanelco dateToNSString:context.usuario.vencimiento withFormat:@"dd/MM/yyyy"]];
}


-(void) apagarRueda{
	[self performSelector:@selector(finalUpdate) withObject:nil afterDelay:0];
}

- (void)alertViewCancel:(UIAlertView *)alertView {
	
	
	if([alertView.message isEqualToString:@"La nueva clave de ingreso se actualizó correctamente." ]){
	}
	
	
}

- (void) doAction {
	NSAutoreleasePool *pool= [[NSAutoreleasePool alloc]init];
	
	[NSThread sleepForTimeInterval:0.2];
	
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
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Contraseña" message:@"La clave debe ser de 8 dígitos." 
													   delegate:self 
											  cancelButtonTitle:@"Aceptar" otherButtonTitles:nil]; 
		[alert show]; 
		[alert release]; 
		return;
	}
	
	if ([newPassField.text length] != 8) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Contraseña" message:@"La nueva clave debe ser de 8 dígitos." 
													   delegate:self 
											  cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
		[alert show]; 
		[alert release]; 
		return;
	}
	
	if(![newPassField.text isEqualToString:newPassConfirmField.text]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Contraseña" message:@"La clave nueva difiere de la clave de confirmación." 
													   delegate:self 
											  cancelButtonTitle:@"Aceptar" otherButtonTitles:nil]; 
		[alert show]; 
		[alert release]; 
		return;
	}
    
    if([newPassField.text isEqualToString:oldPassField.text]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Contraseña" message:@"La clave anterior y nueva deben diferir."
													   delegate:self
											  cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
		[alert show];
		[alert release];
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

- (void)clearFields {
    newPassField.text = @"";
    oldPassField.text = @"";
    newPassConfirmField.text = @"";
}




- (void)dealloc {
	[tituloDePantalla release];
	[alert release];
	[contr release];
	[oldPassField  release];
	[newPassField release];
	[newPassConfirmField release];
	[blankButton release];
    self.fndImage = nil;
    [super dealloc];
}



@end
