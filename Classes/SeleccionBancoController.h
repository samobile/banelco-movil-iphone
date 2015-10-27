#import <UIKit/UIKit.h>


@interface SeleccionBancoController : UIViewController <UITableViewDelegate,UITableViewDataSource> {
	
	NSMutableArray* bancosSeleccionados;
	NSMutableArray* bancosNoSeleccionados;
		
	NSMutableArray* bancosTotal;
	NSMutableArray* seleccionadosIDs;
	
	
	NSMutableArray* opcionesMuestra;
	
	IBOutlet UITableView* listaBancos;
	
	UITableView* otrosBancosTable;
	IBOutlet UIButton* backBoton;
	BOOL adding;
    
    IBOutlet UIImageView *sombra;
	
}

@property(nonatomic,retain) NSMutableArray* bancosSeleccionados;
@property(nonatomic,retain) NSMutableArray* bancosNoSeleccionados;
@property(nonatomic,retain) UIButton* backBoton;
@property(nonatomic,retain) NSMutableArray* opcionesMuestra;
@property(nonatomic,retain) NSMutableArray* bancosTotal;
@property(nonatomic,retain) UITableView* listaBancos;
@property(nonatomic,retain) NSMutableArray* seleccionadosIDs;

@property(nonatomic,retain) UITableView* otrosBancosTable;
@property BOOL adding;

@property (nonatomic, retain) UIImageView *sombra;

-(NSString*) pathSelectedBanks;
-(NSString*) pathNoSelectedBanks;
+(BOOL) banco:(NSDictionary*) ban estaEn:(NSArray*) listaB;
-(IBAction) backBancosSeleccionados;

@end
