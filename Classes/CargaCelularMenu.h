//
//  CargaCelularMenu.h
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 9/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractMenu.h"

@interface CargaCelularMenu : AbstractMenu {


}


-(NSString *)buscarCarrier:(NSString *)carrierId;
-(NSMutableArray *)getOtrosCelulares;
-(NSMutableArray *) getDeudas:(NSMutableArray *)deudas conEmpresaId:(NSString *)empresaId;



@end
