#import <UIKit/UIKit.h>
#import "WheelAnimationController.h"
#import "Cuenta.h"

@interface CuentasList : WheelAnimationController <UITableViewDelegate> {

	BOOL pantallaCompleta;
	
	BOOL conSaldo;
	
	BOOL seleccionable;
	
	int cuentasListType;
	
	NSMutableArray *cuentas;
	
	int idxSelecCuenta;
	
	IBOutlet UITableView *tableView;
	
	CGRect viewFrame;
	
	NSIndexPath *idxPathSelecCuenta;
}

extern int const CL_SALDOS;
extern int const CL_SALDOS_Y_DISPONIBLES;
extern int const CL_TRANS_ORIGEN;
extern int const CL_TRANS_DESTINO;
extern int const CL_ULT_MOVIMIENTOS;
extern int const CL_PAGAR;
extern int const CL_CONSULTA_CBU; 
extern int const CL_AGENDA;
extern int const CL_SALDOS_Y_DISPONIBLES_TRANSFER;
extern int const CL_TASAS_PLAZO_FIJO;
extern int const CL_DISPONIBLES;

@property BOOL pantallaCompleta;

@property BOOL conSaldo;

@property BOOL seleccionable;

@property int cuentasListType;

@property (nonatomic, retain) NSMutableArray *cuentas;

@property int idxSelecCuenta;

@property (nonatomic, retain) IBOutlet UITableView *tableView;

@property (nonatomic) CGRect viewFrame;

@property (nonatomic, retain) NSIndexPath *idxPathSelecCuenta;


-(id) initConSaldo:(BOOL) saldo andTipoLista:(int) tipoLista;

-(id) initList:(NSString *)title ofType:(int)type withItems:(NSMutableArray *)items inFrame:(CGRect)frame;

- (Cuenta *)getSelectedCuenta;

@end
