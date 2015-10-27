//
//  ExtraccionesConsultas.h
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 10/15/15.
//
//

#import "WheelAnimationController.h"

@interface ExtraccionesConsultas : WheelAnimationController <UITableViewDelegate> {
    IBOutlet UITableView *tableMandatos;
    NSMutableArray *mandatos;
    NSString *dniFilter;
    NSString *dniTipoFilter;
    NSString *statusFilter;
    UIButton *inicio;
    BOOL ejecutarConsulta;
    NSInteger selectedRow;
}

@property (nonatomic, retain) UITableView *tableMandatos;
@property (nonatomic, retain) NSMutableArray *mandatos;
@property (nonatomic, retain) NSString *dniFilter;
@property (nonatomic, retain) NSString *dniTipoFilter;
@property (nonatomic, retain) NSString *statusFilter;
@property (nonatomic, retain) UIButton *inicio;
@property BOOL ejecutarConsulta;

@end
