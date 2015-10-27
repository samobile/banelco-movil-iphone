//
//  MandatoViewCell.m
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 10/15/15.
//
//

#import "MandatoViewCell.h"
#import "Context.h"

@implementation MandatoViewCell

@synthesize fechaLbl, dniLbl, statusLbl, montoLbl;

- (void)viewDidLoad {
    // Initialization code
    [super viewDidLoad];
    if (![Context sharedContext].personalizado) {
        self.montoLbl.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:14];
        self.fechaLbl.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:14];
        self.dniLbl.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:14];
        self.statusLbl.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:14];
    }
}

- (void)dealloc {
    self.fechaLbl = nil;
    self.dniLbl = nil;
    self.statusLbl = nil;
    self.montoLbl = nil;
    [super dealloc];
}

@end
