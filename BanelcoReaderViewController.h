//
//  BenelcoReaderViewController.h
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 9/9/15.
//
//

#import <UIKit/UIKit.h>
#import "ZBarReaderView.h"

@class MTBBarcodeScanner, AVAudioPlayer;

@interface BanelcoReaderViewController : UIViewController <ZBarReaderViewDelegate,UIAlertViewDelegate> {
    ZBarReaderView *zbarScanner;
    MTBBarcodeScanner *scanner5;
    BOOL flashIsOn;
    NSString *data;
    id readerDelegate;
    AVAudioPlayer *audioPlayer;
    NSTimer *timer;
    int warnings;
    UIAlertView *alertMsg;
    BOOL scanStarted;
}

@property (nonatomic, retain) ZBarReaderView *zbarScanner;
@property (nonatomic, retain) MTBBarcodeScanner *scanner5;
@property (nonatomic, retain) NSString *data;
@property (nonatomic, assign) id readerDelegate;
@property (nonatomic, retain) AVAudioPlayer *audioPlayer;
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, retain) UIAlertView *alertMsg;

- (void)startScanningInView:(UIView *)v;
- (id)getDeudasConCodigo;
+ (id)getDeudasConCodigo:(NSString *)cod yEmpresa:(NSString *)codEmpresa;

@end
