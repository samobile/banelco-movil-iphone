//
//  CargaCelularResultado.h
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 9/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StackableScreen.h"
#import "Cuenta.h"
#import "Empresa.h"
#import "Ticket.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface CargaCelularResultado : StackableScreen <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate> {

	Ticket *ticket;
	Empresa *empresa;
	Cuenta *cuenta;
	NSString *importe;
	NSString *idCliente;
	NSString *descCliente;
	
	
	IBOutlet UILabel* lFecha;
	IBOutlet UILabel* lTransNum;
	IBOutlet UILabel* lImporte;
	IBOutlet UILabel* lDebito;
	IBOutlet UILabel* lCliente;
	IBOutlet UILabel* lEmpresa;
	
	IBOutlet UILabel* leyendaFecha;
	IBOutlet UILabel* leyendaTransNum;
	IBOutlet UILabel* leyendaImporte;
	IBOutlet UILabel* leyendaDebito;
	IBOutlet UILabel* leyendaCliente;
	IBOutlet UILabel* leyendaSeuo;
	IBOutlet UILabel* leyenda;
    
    IBOutlet UIButton *enviarMailBtn;
}

@property (nonatomic,retain) Ticket *ticket;
@property (nonatomic,retain) Empresa *empresa;
@property (nonatomic,retain) Cuenta *cuenta;
@property (nonatomic,retain) NSString *importe;
@property (nonatomic,retain) NSString *idCliente;
@property (nonatomic,retain) NSString *descCliente;

@property (nonatomic,retain)  UILabel* lFecha;
@property (nonatomic,retain)  UILabel* lTransNum;
@property (nonatomic,retain)  UILabel* lImporte;
@property (nonatomic,retain)  UILabel* lDebito;
@property (nonatomic,retain)  UILabel* lCliente;
@property (nonatomic,retain)  UILabel* lEmpresa;

@property (nonatomic,retain) IBOutlet UILabel* leyendaFecha;
@property (nonatomic,retain) IBOutlet UILabel* leyendaTransNum;
@property (nonatomic,retain) IBOutlet UILabel* leyendaImporte;
@property (nonatomic,retain) IBOutlet UILabel* leyendaDebito;
@property (nonatomic,retain) IBOutlet UILabel* leyendaCliente;
@property (nonatomic,retain) IBOutlet UILabel* leyendaSeuo;
@property (nonatomic,retain) IBOutlet UILabel* leyenda;

@property (nonatomic, retain) UIButton *enviarMailBtn;

- (IBAction)enviarPorMail:(id)sender;

@end
