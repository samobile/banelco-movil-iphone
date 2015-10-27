//
//  CargaCelularMenu.m
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 9/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UsuarioMenuController.h"
#import "Context.h"
#import "CommonUIFunctions.h"
#import "BanelcoMovilIphoneViewController.h"
#import "CommonFuncBanelco.h"
#import "GenerarUsuarioController.h"
#import "CommonUIFunctions.h"
#import "CambiarUsuarioController.h"
#import "WS_ManagePerfilUsuario.h"
#import "WSUtil.h"
#import "Util.h"
#import "ManagePerfilUsuarioResponse.h"

@implementation UsuarioMenuController

@synthesize contr;
@synthesize btnVolver, btnUsuario, titDatos, fndImage;

-(id) initWithController:(BanelcoMovilIphoneViewController*)control CargaDatos:(BOOL)cargaDatos{
	
	if(self = [super init]){
		self.contr = control;
	}
	
	return self;
}

- (id) init {
	if ((self = [super init])) {

	}
	return self;
	
}

- (void)viewDidLoad {
	[super viewDidLoad];
    
    self.btnVolver.titleLabel.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"MenuTxtColor"];
    self.btnUsuario.titleLabel.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"MenuTxtColor"];
    
    titDatos.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TitleTxtColor"];
    
    if (![Context sharedContext].personalizado) {
        titDatos.font=[UIFont fontWithName:@"BanelcoBeau-Regular" size:17];
        self.btnVolver.titleLabel.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:17];
        self.btnUsuario.titleLabel.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:17];
    }
    else {
        self.btnVolver.titleLabel.font = [UIFont systemFontOfSize:17];
        self.btnUsuario.titleLabel.font = [UIFont systemFontOfSize:17];
    }
    
    CGRect fi = self.fndImage.frame;
    fi.size.height = IPHONE5_HDIFF(fi.size.height);
    self.fndImage.frame = fi;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self performSelectorOnMainThread:@selector(refreshDatos) withObject:nil waitUntilDone:YES];
}

- (void)refreshDatos {
    //NSString *tipoDoc = [Context sharedContext].tipoDoc;
    NSString *nick = [Context sharedContext].usuario.userName;
    if (nick && [nick length] > 0) {
        [self.btnUsuario setTitle:@"Cambiar usuario" forState:UIControlStateNormal];
        if ([[Context sharedContext].tipoDoc isEqualToString:@"U"]) {
            [self.btnVolver setTitle:@"Volver a ingreso con documento" forState:UIControlStateNormal];
            self.btnVolver.hidden = NO;
        }
        else {
            self.btnVolver.hidden = YES;
        }
    }
    else {
        [self.btnUsuario setTitle:@"Generar usuario" forState:UIControlStateNormal];
        self.btnVolver.hidden = YES;
    }
}

- (IBAction)opcionVolver:(id)sender {
    [CommonUIFunctions showConfirmationAlert:@"Usuario" withMessage:@"Quiero volver a utilizar mi documento para ingresar a la aplicación" andDelegate:self];
}

- (IBAction)opcionUsuario:(id)sender {
    
    CGRect rect= CGRectMake(0, 0, 320, IPHONE5_HDIFF(354));
    
    NSString *nick = [Context sharedContext].usuario.userName;
    if (nick && [nick length] > 0) {
        CambiarUsuarioController *changePass = [[CambiarUsuarioController alloc] initWithController:self.contr  CargaDatos:NO];
        changePass.view.frame = rect;
        [[BanelcoMovilIphoneViewController sharedMenuController] pushScreen:changePass];
        [changePass viewWillAppear:NO];
    }
    else {
        GenerarUsuarioController *changePass = [[GenerarUsuarioController alloc] initWithController:self.contr  CargaDatos:NO];
        changePass.view.frame = rect;
        [[BanelcoMovilIphoneViewController sharedMenuController] pushScreen:changePass];
        [changePass viewWillAppear:NO];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        //invocaciones
        alert = [[WaitingAlert alloc] initWithH:20];
        [self.view addSubview:alert];
        [alert startWithSelector:@"doVolverLogueo" fromTarget:self andFinishSelector:@"finishAlert" formTarget:self];
    }
}

- (void) finishAlert {
	[alert performSelectorOnMainThread:@selector(detener) withObject:nil waitUntilDone:NO];
}

-(BOOL)doVolverLogueo {
	
	ManagePerfilUsuarioResponse *result = nil;
	
	WS_ManagePerfilUsuario *request = [[WS_ManagePerfilUsuario alloc] init];
	
	Context *context = [Context sharedContext];
	
	request.userToken = [context getToken];
	request.nickName = [context.usuario.userName uppercaseString];
	request.email = context.usuario.email;
    request.novedades = context.usuario.showInfo;
    request.vencimientos = context.usuario.showVencim;
    request.retornarLogueoDNI = YES;
    
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
        NSLog(@"Volver Login DNI: %@", result.tokenSeguridad);
        //[self apagarRueda];
        
        [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"0"] forKey:[Context sharedContext].banco.idBanco];
        
        [Util deleteSecurityTokenforBank:context.banco.idBanco andDni:[context.usuario.userName uppercaseString]];
        
        context.usuario.userName = nil;
        context.tipoDoc = @"1";
        context.dni = context.usuario.nroDocumento;
        
        [self performSelectorOnMainThread:@selector(refreshDatos) withObject:nil waitUntilDone:NO];
        
        [self.contr performSelectorOnMainThread:@selector(inicioAccion) withObject:nil waitUntilDone:YES];
		
		return TRUE;
	}
	
	
	
	
}


- (void)dealloc {
    self.btnUsuario = nil;
    self.btnVolver = nil;
    self.titDatos = nil;
    self.fndImage = nil;
	[super dealloc];
}

@end
