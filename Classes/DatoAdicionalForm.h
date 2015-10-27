#import <UIKit/UIKit.h>
#import "StackableScreen.h"
#import "Empresa.h"


@interface DatoAdicionalForm : StackableScreen <UITextFieldDelegate> {

	Empresa *empresa;
	
	NSString *idCliente;
	
	IBOutlet UIButton *btnContinuar;
	
	IBOutlet UITextField *txtDato;
	
	IBOutlet UILabel *lblDato;
	
	//UIImageView* barTeclado;
	//UIButton* barTecladoButton;
	
}

@property (nonatomic, retain) Empresa *empresa;
@property (nonatomic, retain) NSString *idCliente;

@property (nonatomic, retain) IBOutlet UIButton *btnContinuar;
@property (nonatomic, retain) IBOutlet UITextField *txtDato;
@property (nonatomic, retain) IBOutlet UILabel *lblDato;

//@property(nonatomic,retain) UIButton* barTecladoButton;
//@property(nonatomic,retain) UIImageView* barTeclado;


- (IBAction)continuar;

@end
