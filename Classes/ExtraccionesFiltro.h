//
//  ExtraccionesFiltro.h
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 10/16/15.
//
//

#import "StackableScreen.h"

@class ExtraccionesConsultas;

@interface ExtraccionesFiltro : StackableScreen <UITextFieldDelegate,UIActionSheetDelegate> {
    UIView* barTeclado;
    IBOutlet UILabel *lTipoDoc;
    IBOutlet UITextField *dniTxt;
    UIActionSheet *subMenuDNI;
    UIActionSheet *subMenuEstados;
    UIButton *barTecladoButton;
    NSInteger tipoSeleccionado;
    IBOutlet UILabel *lEstado;
    NSInteger estadoSeleccionado;
    ExtraccionesConsultas *consultasDelegate;
}

@property (nonatomic, retain) UIView* barTeclado;
@property (nonatomic, retain) UILabel *lTipoDoc;
@property (nonatomic, retain) UITextField *dniTxt;
@property (nonatomic, retain) UIActionSheet *subMenuDNI;
@property (nonatomic, retain) UIActionSheet *subMenuEstados;
@property (nonatomic, retain) UIButton *barTecladoButton;
@property (nonatomic, retain) UILabel *lEstado;
@property (nonatomic, assign) ExtraccionesConsultas *consultasDelegate;

@end
