//
//  ManagePerfilUsuarioResponse.m
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 9/3/14.
//
//

#import "ManagePerfilUsuarioResponse.h"

@implementation ManagePerfilUsuarioResponse

@synthesize tokenSeguridad;

- (void)dealloc {
    self.tokenSeguridad = nil;
    [super dealloc];
}

@end
