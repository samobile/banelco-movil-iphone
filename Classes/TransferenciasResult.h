//
//  TransferenciasRes.h
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 10/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StackableScreen.h"
#import "Transfer.h"
#import "Ticket.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface TransferenciasResult : StackableScreen <UIActionSheetDelegate,MFMailComposeViewControllerDelegate,
MFMessageComposeViewControllerDelegate> {
	Transfer *transfer;
	Ticket *ticket;
	
	NSString *importeConvertido;
	
	
	IBOutlet UILabel* lFecha;
	IBOutlet UILabel* lTransNum;
	
	IBOutlet UILabel* lDe;
	IBOutlet UILabel* lImporte;
	IBOutlet UILabel* lA;
	
	IBOutlet UILabel* lImporteDescCruz;
	IBOutlet UILabel* lImporteCruz;
	
	IBOutlet UILabel* lImporteDesc;
	IBOutlet UILabel* lADesc;
	
	IBOutlet UILabel* lTransInmediata;
	
	IBOutlet UILabel* leyendaFecha;
	IBOutlet UILabel* leyendaTransNum;
	IBOutlet UILabel* leyendaTitulo;
	IBOutlet UILabel* leyendaDe;
	IBOutlet UILabel* leyendaSeuo;
    
    IBOutlet UIButton *enviarMailBtn;
	
}

@property (nonatomic, retain) Transfer *transfer;
@property (nonatomic, retain) Ticket *ticket;

@property (nonatomic, retain) NSString *importeConvertido;


@property (nonatomic, retain)  UILabel* lFecha;
@property (nonatomic, retain)  UILabel* lTransNum;

@property (nonatomic, retain)  UILabel* lDe;
@property (nonatomic, retain)  UILabel* lImporte;
@property (nonatomic, retain)  UILabel* lA;

@property (nonatomic, retain)  UILabel* lImporteDescCruz;
@property (nonatomic, retain)  UILabel* lImporteCruz;

@property (nonatomic, retain) IBOutlet UILabel* lImporteDesc;
@property (nonatomic, retain) IBOutlet UILabel* lADesc;

@property (nonatomic, retain) IBOutlet UILabel* lTransInmediata;

@property (nonatomic, retain) IBOutlet UILabel* leyendaFecha;
@property (nonatomic, retain) IBOutlet UILabel* leyendaTransNum;
@property (nonatomic, retain) IBOutlet UILabel* leyendaTitulo;
@property (nonatomic, retain) IBOutlet UILabel* leyendaDe;
@property (nonatomic, retain) IBOutlet UILabel* leyendaSeuo;

@property (nonatomic, retain) UIButton *enviarMailBtn;

- (IBAction)enviarPorMail:(id)sender;

@end
