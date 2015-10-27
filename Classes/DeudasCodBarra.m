//
//  DeudasCodBarra.m
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 9/15/15.
//
//

#import "DeudasCodBarra.h"
#import "Empresa.h"
#import "Deuda.h"

@implementation DeudasCodBarra

@synthesize empresa, deuda;

- (void)dealloc {
    self.empresa = nil;
    self.deuda = nil;
    [super dealloc];
}

@end
