//
//  ExecuteCheckVersion.m
//  BanelcoMovilIphone
//
//  Created by German Levy on 9/26/10.
//  Copyright 2010 -. All rights reserved.
//

#import "ExecuteCheckVersion.h"
#import "UpdatesManager.h"
#import "Context.h"
#import "CommonUIFunctions.h"
#import "BanelcoMovilIphoneViewController.h"
#import "BanelcoMovilIphoneViewControllerGenerico.h"
#import "Configuration.h"
#import "AceptarTerminosController.h"

@implementation ExecuteCheckVersion

@synthesize viewController;

- (id)initFromController:(UIViewController *)controller {
	
    if ((self = [super init])) {

		self.viewController = controller;
		
    }
    return self;
}

- (void)removeCambioClave {
    UIView *v = [self.viewController.view viewWithTag:-105];
    if (v) {
        [v performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:2];
    }
}

- (void)execute {
#if WSDEBUG
    [self mostrarMenuPrincipal];
    return;
#endif
    
	Context *context = [Context sharedContext];
	
	UpdatesManager *updatesManager = [[UpdatesManager alloc] init];
	
	int stateUpdate = [updatesManager existNewVersion];
	
	if ( stateUpdate == NEW_VERSION) {
		
        if (self.viewController) {
            [self.viewController performSelector:@selector(resetKeyboard) withObject:nil];
        }
        
		BOOL versionMandatoria = (context.appOpcional && [context.appOpcional isEqualToString:@"1"])?YES:NO;
		
		if (versionMandatoria) {
			NSString *message = [NSString stringWithFormat:@"Hay una nueva versión de la aplicación %@.\n Debes descargarla para seguir operando"
					   , context.applicationName];
			[self showConfirmationAlert:@"Nueva versión" withMessage:message andConfirmButton:@"Aceptar" andCancelButton:@"Cancelar" andDelegate:self];
		}
		else {
			NSString *message = [NSString stringWithFormat:@"Hay una nueva versión de la aplicación %@ con mejoras opcionales.\n¿Deseas descargarla ahora?"
					   , context.applicationName];
			[self showConfirmationAlert:@"Nueva versión" withMessage:message andConfirmButton:@"Si" andCancelButton:@"No" andDelegate:self];
		}
		
	} else if (stateUpdate == CONN_ERROR) {
		
        if (self.viewController) {
            [self.viewController performSelector:@selector(resetKeyboard) withObject:nil];
        }
		
	} else if (stateUpdate == SAME_VERSION) {
		
		[self mostrarMenuPrincipal];
        [self performSelectorOnMainThread:@selector(removeCambioClave) withObject:nil waitUntilDone:NO];
        return;
	}
	[self performSelectorOnMainThread:@selector(removeCambioClave) withObject:nil waitUntilDone:NO];
}

- (BOOL)executeAndWait {
#if WSDEBUG
    return YES;
#endif
    
    [self performSelectorOnMainThread:@selector(removeCambioClave) withObject:nil waitUntilDone:NO];
    
	Context *context = [Context sharedContext];
	
	UpdatesManager *updatesManager = [[UpdatesManager alloc] init];
	
	int stateUpdate = [updatesManager existNewVersion];
	
	if ( stateUpdate == NEW_VERSION) {
		
        if (self.viewController) {
            [self.viewController performSelector:@selector(resetKeyboard) withObject:nil];
        }
        
		BOOL versionMandatoria = (context.appOpcional && [context.appOpcional isEqualToString:@"1"])?NO:YES;
		
		if (versionMandatoria) {
			NSString *message = [NSString stringWithFormat:@"Hay una nueva versión de la aplicación %@.\n Debes descargarla para seguir operando"
                                 , context.applicationName];
			[self showConfirmationAlert:@"Nueva versión" withMessage:message andConfirmButton:@"Aceptar" andCancelButton:@"Cancelar" andDelegate:self];
		}
		else {
			NSString *message = [NSString stringWithFormat:@"Hay una nueva versión de la aplicación %@ con mejoras opcionales.\n¿Deseas descargarla ahora?"
                                 , context.applicationName];
			[self showConfirmationAlert:@"Nueva versión" withMessage:message andConfirmButton:@"Si" andCancelButton:@"No" andDelegate:self];
		}
		
	} else if (stateUpdate == CONN_ERROR) {
        if (self.viewController) {
            [self.viewController performSelector:@selector(resetKeyboard) withObject:nil];
        }
		return NO;
		
	} else if (stateUpdate == SAME_VERSION) {
		[self configureMenuPrincipal];
		return YES;
	}
    return NO;
	
}

- (void)mostrarMenuPrincipal {
	
	//Si no hay que actualizar la aplicacion, me fijo si es una aplicacion personalizada
	//Si es guardo los datos del banco
	NSString *codBanco = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"codigoBanco"];
	if (codBanco && ![codBanco isEqualToString:@""]) {
		NSString *nombreBanco = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"nombreBanco"];
		Context *context = [Context sharedContext];
		context.banco.idBanco = codBanco;
		context.banco.nombre = nombreBanco;
		
	}
	Context *context = [Context sharedContext];
    if (context.usuario.viewTerminos) {
    //if (YES) {
        //redireccion para que acepte los terminos y condiciones
    	AceptarTerminosController* atycc = [[AceptarTerminosController alloc] initWithController:self.viewController];
        //atycc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    	//[self.viewController presentModalViewController:atycc animated:YES];
        //[atycc autorelease];
        
        if (self.viewController) {
            [self.viewController performSelector:@selector(resetKeyboard) withObject:nil];
        }
        
        atycc.view.tag = -100;
        [self.viewController.view addSubview:atycc.view];
    	return;
    }
	
	if (self.viewController) {
        // Menu Principal
        BanelcoMovilIphoneViewController* p1 = [BanelcoMovilIphoneViewController sharedMenuController];
        p1.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        
        
        [self.viewController presentModalViewController:p1 animated:YES];
        //CAMBIO agregado
        //[p1 viewDidLoad];
    }
    

	
}

- (void)configureMenuPrincipal {
	
	//Si no hay que actualizar la aplicacion, me fijo si es una aplicacion personalizada
	//Si es guardo los datos del banco
	NSString *codBanco = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"codigoBanco"];
	if (codBanco && ![codBanco isEqualToString:@""]) {
		NSString *nombreBanco = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"nombreBanco"];
		Context *context = [Context sharedContext];
		context.banco.idBanco = codBanco;
		context.banco.nombre = nombreBanco;
		
	}
}

- (void)showConfirmationAlert:(NSString *)title withMessage:(NSString *)message andConfirmButton:(NSString *)confirmText andCancelButton:(NSString *)cancelText andDelegate:(id)delegate {
	
	UIAlertView *alert = [[UIAlertView alloc] init];
	alert.title = title;
	alert.message = message;
	[alert addButtonWithTitle:confirmText];
	alert.cancelButtonIndex = 1;
	[alert addButtonWithTitle:cancelText];
	alert.delegate = delegate;
	//[alert show];
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
	
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex { 
	
	Context *context = [Context sharedContext];
	BOOL versionMandatoria = (context.appOpcional && [context.appOpcional isEqualToString:@"1"])?NO:YES;
	NSString *urlNewVersion = context.urlVersion;
	switch(buttonIndex) {
		case 1: 
			//si la nueva version no es mandatoria, continua con la ejecucion de la aplicacion
			if (!versionMandatoria) {
				[self mostrarMenuPrincipal];
			}
			else {
				
			}
			
			break;
		
		case 0:
			if (urlNewVersion && ![urlNewVersion isEqualToString:@""]) {
				[[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlNewVersion]];
			}
			break;
	}
}


@end
