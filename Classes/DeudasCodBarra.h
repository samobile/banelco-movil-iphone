//
//  DeudasCodBarra.h
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 9/15/15.
//
//

#import <Foundation/Foundation.h>

@class Empresa, Deuda;

@interface DeudasCodBarra : NSObject {
    Empresa *empresa;
    Deuda *deuda;
}

@property (nonatomic, retain) Empresa *empresa;
@property (nonatomic, retain) Deuda *deuda;

@end
