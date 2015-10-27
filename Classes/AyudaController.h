//
//  AyudaController.h
//  BanelcoMovilIphone
//
//  Created by Demian on 9/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AyudaPaginadaController.h"
#import "StackableScreen.h"
#import "AyudaContactoViewController.h"

@interface AyudaController : StackableScreen <UITableViewDelegate, UITableViewDataSource> {

	AyudaPaginadaController* apc ;
    AyudaContactoViewController* acvc;
	IBOutlet UITableView* listaDeAyuda;
    IBOutlet UIView* listaDeAyudaContenedor;
	NSArray* opcionesDeAyuda;
	
	IBOutlet UILabel *lblTitulo;

	BOOL fullScreen;
    
    IBOutlet UIImageView *fndImage;

}

@property (nonatomic, retain) UIImageView *fndImage;

@property(nonatomic,retain) UITableView* listaDeAyuda;
@property(nonatomic,retain) NSArray* opcionesDeAyuda;
@property(nonatomic,retain) AyudaPaginadaController* apc;
@property(nonatomic,retain) AyudaContactoViewController* acvc;
@property(nonatomic,retain) IBOutlet UILabel *lblTitulo;

@property (nonatomic, retain) UIView* listaDeAyudaContenedor;

@property BOOL fullScreen;

-(IBAction) volver;

@end
