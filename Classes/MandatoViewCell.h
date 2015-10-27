//
//  MandatoViewCell.h
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 10/15/15.
//
//

#import <UIKit/UIKit.h>

@interface MandatoViewCell : UIViewController {
    IBOutlet UILabel *fechaLbl;
    IBOutlet UILabel *dniLbl;
    IBOutlet UILabel *statusLbl;
    IBOutlet UILabel *montoLbl;
}

@property (nonatomic, retain) UILabel *fechaLbl;
@property (nonatomic, retain) UILabel *dniLbl;
@property (nonatomic, retain) UILabel *statusLbl;
@property (nonatomic, retain) UILabel *montoLbl;

@end
