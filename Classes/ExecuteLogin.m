//
//  ExecuteLogin.m
//  BanelcoMovilIphone
//
//  Created by German Levy on 6/14/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ExecuteLogin.h"
#import "Util.h"
#import "WSUtil.h"
#import "WS_Login_ConPerfil.h"
#import "Context.h"
#import "LoginResponse.h"
#import "AceptarTerminosController.h"
#import "ExecuteCheckVersion.h"
#import "CommonUIFunctions.h"
#import "CambioClaveController.h"
#import "GenerarClaveController.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import "CommonFunctions.h"

@implementation ExecuteLogin

@synthesize alert, controller;
@synthesize doc, docType, password;


- (id)initFromController:(UIViewController *)pController withDoc:(NSString *)pDoc ofType:(NSString *)pDocType andPW:(NSString *)pPW {
	
    if ((self = [super init])) {
		
		self.controller = pController;
		self.doc = pDoc;
		self.docType = pDocType;
		self.password = pPW;
		
    }
    return self;
}


-(void)executeLogin {
	
	alert = [[WaitingAlert alloc] initWithH:20];
	[self.controller.view addSubview:alert];
	[alert startWithSelector:@"doLoginOfRestrictedUser" fromTarget:self andFinishSelector:@"finishAlert" formTarget:self];
	
}

-(void)doLoginOfRestrictedUser {
	
	[self doLoginOfDoc:doc ofType:docType andPW:password];	
	
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
    request.datosApp = [NSString stringWithFormat: @"{\"plataforma\":\"IOs\",\"aplicacion\":\"%@\"}",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"LoginAppName"]];
	request.userToken = [Util getSecurityToken:context.banco.idBanco forDni:[request.nroDoc uppercaseString]];
	
	[WSRequest setSecurityToken:request.userToken];
	
	// Parseo el xml para obtener los datos del usuario
	result = [WSUtil execute:request];
	
	if (result && ![result isKindOfClass:[NSError class]]) {
        
		context.usuario = result.usuario;
		[Context setCuentas:result.cuentas];
		
		context.startAppHour = [[NSDate date] timeIntervalSince1970];
		context.lastActivityHour = [[NSDate date] timeIntervalSince1970];
		
//		if (context.usuario.firstLogin) {
//			[Util setSecurityToken:result.tokenSeguridad forBank:request.codBanco andDni:request.nroDoc];
//			
//		}
        
        [WSRequest setSecurityToken:[Util getSecurityToken:context.banco.idBanco forDni:[request.nroDoc uppercaseString]]];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *oldNickName = [prefs objectForKey:[NSString stringWithFormat:@"%@_%@",request.codBanco,context.usuario.nroDocumento]];
        if (oldNickName && ![[oldNickName uppercaseString] isEqualToString:[context.usuario.userName uppercaseString]]) {
            [Util deleteSecurityTokenforBank:request.codBanco andDni:[oldNickName uppercaseString]];
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
		
        if ([CommonFunctions validateStrongPassword:pPw] != nil || [context.usuario.nroDocumento isEqualToString:pPw] || context.usuario.needsPinChange) {
            
            //USANDO MISMO TOKEN QUE SE USA EN EL LOGIN-----------------------------//
            [WSRequest setSecurityToken:request.userToken];
//            [Util deleteSecurityTokenforBank:request.codBanco andDni:context.usuario.nroDocumento];
//            [Util setSecurityToken:request.userToken forBank:request.codBanco andDni:context.usuario.nroDocumento];
//            if (context.usuario.userName && [context.usuario.userName length] > 0) {
//                [Util setSecurityToken:request.userToken forBank:request.codBanco andDni:[context.usuario.userName uppercaseString]];
//            }
            //----------------------------------------------------------------------//
            
            //USANDO TOKEN DEVUELTO POR EL LOGIN------------------------------------//
            //[WSRequest setSecurityToken:[Util getSecurityToken:context.banco.idBanco forDni:context.usuario.nroDocumento]];
            //----------------------------------------------------------------------//
            
            //Actualizacion de la clave obtenida en la web de PMC
            [self performSelectorOnMainThread:@selector(presentCambioClave) withObject:nil waitUntilDone:YES];
            return;
        }
        
//        if(context.usuario.firstLogin && context.usuario.needsPinChange)
//        {
//            [WSRequest setSecurityToken:request.userToken];
//            
//            //Actualizacion de la clave obtenida en la web de PMC
//            [self performSelectorOnMainThread:@selector(presentCambioClave) withObject:nil waitUntilDone:YES];
//			return;
//        }
//        else if (context.usuario.needsPinChange) {
//            [WSRequest setSecurityToken:request.userToken];
//            
//			//[self presentCambioClave];
//            //La clave vencio y debe ser actualizada
//            [self performSelectorOnMainThread:@selector(presentCambioClave) withObject:nil waitUntilDone:YES];
//			return;
//		}
		
	} else {
        
        if (self.controller) {
            [self.controller performSelector:@selector(resetKeyboard) withObject:nil];
        }
        
        NSString *errorCode = [[(NSError *)result userInfo] valueForKey:@"faultCode"];
        if ([errorCode isEqualToString:@"ss"]) {
            return;
        }
		NSString *errorDesc = [[(NSError *)result userInfo] valueForKey:@"description"];
        
		if (!errorDesc) {
			UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Ingreso" message:@"En este momento no se puede realizar la operación. Reintenta más tarde." delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
			//[alertView show];
            [alertView performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
			[alertView release];
			return;
		}
		
		if (errorDesc) {
            
            NSRange range = [errorDesc rangeOfString:@"igo 14"];
            if (range.location != NSNotFound) {
                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Ingreso" message:@"Para comenzar a operar, deberás generar tu clave de acceso. ¿Deseas realizarlo ahora?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Si",nil];
                //[alertView show];
                [alertView performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
                [alertView release];
                return;
            }
            
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Ingreso" message:errorDesc delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
			//[alertView show];
            [alertView performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
			[alertView release];
            return;
        }
        
		
        [CommonUIFunctions showAlert:@"Ingreso" withMessage:errorDesc andCancelButton:@"Volver"];
		
		
		return;
		
	}
    
    [WSRequest setSecurityToken:[Util getSecurityToken:context.banco.idBanco forDni:context.usuario.nroDocumento]];
	
	[self performSelectorOnMainThread:@selector(correctLog) withObject:nil waitUntilDone:YES];
	
}

-(void)doLoginAfterChangePassOfDoc:(NSString *)pDoc ofType:(NSString *)pDocType andPW:(NSString *)pPw {
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
	request.userToken = [Util getSecurityToken:context.banco.idBanco forDni:request.nroDoc];
	
	[WSRequest setSecurityToken:request.userToken];
	
	// Parseo el xml para obtener los datos del usuario
	result = [WSUtil execute:request];
	
	if (result && ![result isKindOfClass:[NSError class]]) {
		
		context.usuario = result.usuario;
		[Context setCuentas:result.cuentas];
		
		context.startAppHour = [[NSDate date] timeIntervalSince1970];
		context.lastActivityHour = [[NSDate date] timeIntervalSince1970];
		
//		if (context.usuario.firstLogin) {
//			[Util setSecurityToken:result.tokenSeguridad forBank:request.codBanco andDni:request.nroDoc];
//			
//		}
		

		[WSRequest setSecurityToken:[Util getSecurityToken:context.banco.idBanco forDni:context.usuario.nroDocumento]];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *oldNickName = [prefs objectForKey:[NSString stringWithFormat:@"%@_%@",request.codBanco,context.usuario.nroDocumento]];
        if (oldNickName && ![[oldNickName uppercaseString] isEqualToString:[context.usuario.userName uppercaseString]]) {
            [Util deleteSecurityTokenforBank:request.codBanco andDni:[oldNickName uppercaseString]];
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
        
        if ([CommonFunctions validateStrongPassword:pPw] != nil || [context.usuario.nroDocumento isEqualToString:pPw] || context.usuario.needsPinChange) {
            //Actualizacion de la clave obtenida en la web de PMC
            //[WSRequest setSecurityToken:result.tokenSeguridad];
            [WSRequest setSecurityToken:request.userToken];
            [self performSelectorOnMainThread:@selector(presentCambioClave) withObject:nil waitUntilDone:YES];
            return;
        }
        
//        if(context.usuario.firstLogin && context.usuario.needsPinChange)
//        {
//            //Actualizacion de la clave obtenida en la web de PMC
//            [self performSelectorOnMainThread:@selector(presentCambioClave) withObject:nil waitUntilDone:YES];
//			return;
//        }
//        else if (context.usuario.needsPinChange) {
//			//[self presentCambioClave];
//            //La clave vencio y debe ser actualizada
//            [self performSelectorOnMainThread:@selector(presentCambioClave) withObject:nil waitUntilDone:YES];
//			return;
//		}
		
	} else {
        
        NSString *errorCode = [[(NSError *)result userInfo] valueForKey:@"faultCode"];
        if ([errorCode isEqualToString:@"ss"]) {
            return;
        }
		NSString *errorDesc = [[(NSError *)result userInfo] valueForKey:@"description"];
		
		if (!errorDesc) {
			UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Ingreso" message:@"En este momento no se puede realizar la operación. Reintenta más tarde." delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
			//[alertView show];
            [alertView performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
			[alertView release];
			return;
		}
		
		
		NSRange range = [errorDesc rangeOfString:@"igo 14"];
		if (range.location != NSNotFound) {
			UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Ingreso" message:@"Para comenzar a operar, deberás generar tu clave de acceso. ¿Deseas realizarlo ahora?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Si",nil];
			//[alertView show];
            [alertView performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
			[alertView release];
		} else {
			[CommonUIFunctions showAlert:@"Ingreso" withMessage:errorDesc andCancelButton:@"Volver"];
		}
		
		return;
		
	}
    
    [WSRequest setSecurityToken:[Util getSecurityToken:context.banco.idBanco forDni:context.usuario.nroDocumento]];
	
    [self performSelectorOnMainThread:@selector(correctLog) withObject:nil waitUntilDone:YES];
}

- (void)showBlock {
    
    UIWindow *win = [[[UIApplication sharedApplication] windows] firstObject];
    UIView *oldv = [win viewWithTag:-909];
    if (oldv) {
        [oldv removeFromSuperview];
    }
    [win endEditing:YES];
    //mostrar mensaje bloqueante
    UIView *v = [[UIView alloc] initWithFrame:win.bounds];
    v.tag = -909;
    v.backgroundColor = [UIColor colorWithRed:85/255 green:85/255 blue:85/255 alpha:0.8];
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(30, 30, v.frame.size.width - 60, v.frame.size.height - 60)];
    lbl.numberOfLines = 5;
    lbl.backgroundColor = [UIColor clearColor];
    lbl.text = @"Para poder seguir operando, por favor descargá la aplicación ICBC Mobile Banking desde la tienda de tu Smartphone";
    lbl.textColor = [UIColor whiteColor];
    lbl.textAlignment = UITextAlignmentCenter;
    lbl.font = [UIFont boldSystemFontOfSize:16];
    [v addSubview:lbl];
    [lbl release];
    [win addSubview:v];
    [v release];
}

-(void) correctLog {
    
    Context *context = [Context sharedContext];
    if (context.expirationEnabled) {
        
        //chequeo de fecha
        NSDate *actual = [NSDate date];
        if (context.expirationDate && [actual compare:context.expirationDate] != NSOrderedAscending) {
            
            [self performSelectorOnMainThread:@selector(showBlock) withObject:nil waitUntilDone:YES];
            return;
            
            
        }
    }
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    //GAnalytics
    // May return nil if a tracker has not yet been initialized.
    id tracker = [[GAI sharedInstance] defaultTracker];
    // Start a new session with a screenView hit.
    GAIDictionaryBuilder *builder = [GAIDictionaryBuilder createScreenView];
    [builder set:@"start" forKey:kGAISessionControl];
    [tracker set:kGAIScreenName value:@"Pantalla Login"];
    [tracker send:[builder build]];
	
//	if (context.usuario.viewTerminos) {
//		//redireccion para que acepte los terminos y condiciones
//		AceptarTerminosController* atycc = [[AceptarTerminosController alloc] initWithController:controller];
//		atycc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//		[controller presentModalViewController:atycc animated:YES];
//		[atycc autorelease];
//		return;
//	}
	
	if(![self banco:context.banco estaEn:context.bancosSeleccionados]) {
		
		[context.bancosSeleccionados addObject:[context.banco valueForKey:@"idBanco"]];
		
	}
	
	//[context.bancosNoSeleccionados writeToFile:[self pathNoSelectedBanks] atomically:YES];
	[context.bancosSeleccionados writeToFile:[self pathSelectedBanks] atomically:YES];
	[prefs synchronize];
	
	ExecuteCheckVersion *checkVersion = [[ExecuteCheckVersion alloc] initFromController:controller];
	[checkVersion execute];
	
}

-(BOOL) banco:(Banco*) ban estaEn:(NSArray*) listaB {
	
	for (int i =0; i<[listaB count]; i++) {
		
		if ([ban.idBanco isEqualToString:[listaB objectAtIndex:i] ]) {
			return YES;
		}
		
	}
	return NO;
}

-(NSString*) pathSelectedBanks{
	NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	return [path stringByAppendingPathComponent:@"selectedBanks2.plist"];
}

-(NSString*) pathNoSelectedBanks{
	NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	return [path stringByAppendingPathComponent:@"noselectedBanks2.plist"];
}

- (void) finishAlert {
	[alert performSelectorOnMainThread:@selector(detener) withObject:nil waitUntilDone:NO];
}

- (void) presentCambioClave {
    
	CambioClaveController* fcdcc = [[CambioClaveController alloc] init];
	fcdcc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    fcdcc.loginController = (LoginController *)self.controller;
	//[controller presentModalViewController:fcdcc animated:YES];
    fcdcc.view.tag = -105;
    [[(LoginController *)self.controller view] addSubview:fcdcc.view];
}


//--------------------------------------------------------------------
//-----------------------ALERT DE CLAVE-------------------------------
//--------------------------------------------------------------------

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
	
	if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Si"]) {
		//[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.pagomiscuentas.com"]]; 
		[self irACambioDeClave];
	} else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"No"]) {
		return;
	}
	
	if ([alertView.title isEqualToString:@"Ingreso"]) {
		return;
	}
	
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	NSLog(@"didDismissWithButtonIndex%d", buttonIndex);
}

//--------------------------------------------------------------------


-(void) irACambioDeClave {
	
	Context* context = [Context sharedContext];
	if (!([context.banco.url length]>1)) {
		[self pmc];
	} else {
		GenerarClaveController *gcc = [[GenerarClaveController alloc] init];
		[controller presentModalViewController:gcc animated:YES];
		[gcc autorelease];
		return;
	}
	
}


-(void) pmc{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.pagomiscuentas.com"]]; 
}

@end
