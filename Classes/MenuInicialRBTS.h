//
//  MenuInicialRBTS.h
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 3/11/13.
//  Copyright 2013 Mobile Computing. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MenuInicialRBTS : UIViewController {
    NSMutableArray *images;
    NSMutableArray *urls;
    IBOutlet UIView *bannerContainer;
    int bannerVisible;
    NSTimer *bannerTimer;
    CGFloat timeInterval;
    IBOutlet UIScrollView *container;
    IBOutlet UIActivityIndicatorView *load;
}

@property (nonatomic, retain) NSMutableArray *images;
@property (nonatomic, retain) NSMutableArray *urls;
@property (nonatomic, retain) UIView *bannerContainer;
@property (nonatomic, retain) UIScrollView *container;
@property (nonatomic, retain) UIActivityIndicatorView *load;

@property (nonatomic, retain) NSTimer *bannerTimer;

- (IBAction)mobileBanking;
- (IBAction)programaBeneficios;
- (IBAction)beneficiosSMS;
- (IBAction)sitioWeb;
- (IBAction)producto;
- (IBAction)beneficioFace;
- (IBAction)rewards;
- (IBAction)sucursales;

@end
