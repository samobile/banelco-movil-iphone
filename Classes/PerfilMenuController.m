//
//  CargaCelularMenu.m
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 9/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PerfilMenuController.h"
#import "Context.h"
#import "CommonUIFunctions.h"
#import "BanelcoMovilIphoneViewController.h"
#import "CommonFuncBanelco.h"
#import "ChangePasswordController.h"
#import "UsuarioMenuController.h"

@implementation PerfilMenuController

@synthesize contr;
@synthesize usuario, nombre, venc, ultAcc, btnCambioClave, btnUsuario, titDatos, fndImage;

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
    
    self.btnCambioClave.titleLabel.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"MenuTxtColor"];
    self.btnUsuario.titleLabel.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"MenuTxtColor"];

    titDatos.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TitleTxtColor"];
    
    if (![Context sharedContext].personalizado) {
        titDatos.font=[UIFont fontWithName:@"BanelcoBeau-Regular" size:17];
        nombre.font= [UIFont fontWithName:@"BanelcoBeau-Regular" size:17];
        venc.font= [UIFont fontWithName:@"BanelcoBeau-Regular" size:13];
        ultAcc.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:13];
        usuario.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:13];
        self.btnCambioClave.titleLabel.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:17];
        self.btnUsuario.titleLabel.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:17];
    }
    else {
        nombre.font= [UIFont systemFontOfSize:17];
        venc.font= [UIFont systemFontOfSize:14];
        ultAcc.font = [UIFont systemFontOfSize:14];
        usuario.font = [UIFont systemFontOfSize:14];
        self.btnCambioClave.titleLabel.font = [UIFont systemFontOfSize:17];
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
    Context *context = [Context sharedContext];
    ultAcc.text = @"Último Acceso: ";
    venc.text = @"Vencimiento de Clave: ";
    [nombre setText: context.usuario.fullname];
    ultAcc.text = [[ultAcc.text stringByAppendingString:[CommonFuncBanelco dateToNSString:context.usuario.ultimoLogin withFormat:@"dd/MM/yyyy HH:mm:ss"]]stringByAppendingString:@" Hs"];
    venc.text =  [venc.text stringByAppendingString:[CommonFuncBanelco dateToNSString:context.usuario.vencimiento withFormat:@"dd/MM/yyyy"]];
    usuario.text = @"";
    if ([context.usuario.userName length] > 0) {
        usuario.text = [NSString stringWithFormat:@"Usuario: %@", context.usuario.userName];
    }
}

- (IBAction)cambioClave:(id)sender {
    CGRect rect= CGRectMake(0, 0, 320, IPHONE5_HDIFF(354));
	ChangePasswordController *changePass = [[ChangePasswordController alloc] initWithController:self.contr  CargaDatos:NO];
	changePass.view.frame = rect;
    [[BanelcoMovilIphoneViewController sharedMenuController] pushScreen:changePass];
}

- (IBAction)opcionUsuario:(id)sender {
    CGRect rect= CGRectMake(0, 0, 320, IPHONE5_HDIFF(354));
	UsuarioMenuController *changePass = [[UsuarioMenuController alloc] initWithController:self.contr  CargaDatos:NO];
	changePass.view.frame = rect;
    [[BanelcoMovilIphoneViewController sharedMenuController] pushScreen:changePass];
}

- (void)dealloc {

	self.nombre = nil;
    self.ultAcc = nil;
    self.venc = nil;
    self.usuario = nil;
    self.btnUsuario = nil;
    self.btnCambioClave = nil;
    self.titDatos = nil;
    self.fndImage = nil;
    
	[super dealloc];
}

@end
