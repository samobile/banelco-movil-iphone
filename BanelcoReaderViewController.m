//
//  BenelcoReaderViewController.m
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 9/9/15.
//
//

#import "BanelcoReaderViewController.h"
#import "MTBBarcodeScanner.h"
#import "WS_ValidarCodigoDeBarras.h"
#import "Context.h"
#import "WSUtil.h"
#import "CommonUIFunctions.h"
#import "CommonFunctions.h"


#define DEGREES_RADIANS(angle) ((angle) / 180.0 * M_PI)

@interface BanelcoReaderViewController ()

@end

@implementation BanelcoReaderViewController

@synthesize zbarScanner, scanner5, data, readerDelegate, audioPlayer, timer, alertMsg;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:nil];
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    flashIsOn = NO;
    self.data = nil;
    self.zbarScanner = nil;
    self.scanner5 = nil;
    self.timer = nil;
    warnings = 0;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)timesUp {
    self.alertMsg = [[[UIAlertView alloc] init] autorelease];
    alertMsg.title = @"Avisos";
    [alertMsg addButtonWithTitle:@"Salir"];
    alertMsg.cancelButtonIndex = 0;
    alertMsg.delegate = self;
    if (warnings < 2) {
        alertMsg.message = @"No es posible leer la factura. Por favor intentá nuevamente. Si el problema persiste, realizá el pago a través del buscador por empresa.";
        [alertMsg addButtonWithTitle:@"Reintentar"];
       
    }
    if (warnings == 2) {
        alertMsg.message = @"No es posible leer la factura. Intentá realizar el pago a través del buscador de empresas.";
    }
    [alertMsg show];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self closeView];
    }
    else {
        if (warnings == 1) {
            if (!flashIsOn) {
                [self flashAction];
            }
        }
        warnings++;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(timesUp) userInfo:nil repeats:NO];
    }
    self.alertMsg = nil;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)orientationChanged:(NSNotification *)notification {
    [self adjustViewsForOrientation:[[UIDevice currentDevice] orientation]];
}

- (void) adjustViewsForOrientation:(UIInterfaceOrientation)orientation {
    switch (orientation)
    {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
        {
            //load the landscape view
            [self addLineViewWithOrientation:orientation];
            [self addFlashBtnWithOrientation:orientation];
            [self addMessageViewWithOrientation:orientation];
        }
        break;
        case UIInterfaceOrientationUnknown:
            break;
    }
}

- (void)startScanningInView:(UIView *)v {
    
    scanStarted = NO;
    
    if (v) {
        [v addSubview:self.view];
        self.view.frame = v.bounds;
    }
    
    //if (IS_IPHONE_5 && SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
    if (([CommonFunctions isiPhone4S] && SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) || (IS_IPHONE_5 && SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7"))) {
        //api nativa
        [self startScan5];
    }
    else {
        //zbar
        [self startZBarScan];
    }
    
    [self addCustomButtons];
    
    [self performSelector:@selector(startScanDelayed) withObject:nil afterDelay:5];
}

- (void)addCustomButtons {
    
    [self addLineViewWithOrientation:[[UIDevice currentDevice] orientation]];
    
    UIButton *btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
    btnClose.frame = CGRectMake(self.view.frame.size.width - 20 - 40, self.view.frame.size.height - 10 - 40, 40, 40);
    btnClose.accessibilityLabel = @"Cerrar";
    [btnClose setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnClose];
    
    [self addFlashBtnWithOrientation:[[UIDevice currentDevice] orientation]];
    
    [self addMessageViewWithOrientation:[[UIDevice currentDevice] orientation]];
    
}

- (void)addFlashBtnWithOrientation:(UIInterfaceOrientation)orientation {
    UIView *v = [self.view viewWithTag:-9];
    if (v) {
        [v removeFromSuperview];
    }
    UIButton *btnFlash = [UIButton buttonWithType:UIButtonTypeCustom];
    btnFlash.tag = -9;
    btnFlash.frame = CGRectMake(20, self.view.frame.size.height - 10 - 40, 40, 40);
    btnFlash.accessibilityLabel = @"Flash";
    [btnFlash setBackgroundImage:[UIImage imageNamed:@"bulb.png"] forState:UIControlStateNormal];
    [btnFlash addTarget:self action:@selector(flashAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnFlash];
    if (orientation == UIInterfaceOrientationLandscapeRight) {
        CGAffineTransform rotationTransform = CGAffineTransformIdentity;
        rotationTransform = CGAffineTransformRotate(rotationTransform, DEGREES_RADIANS(90));
        btnFlash.transform = rotationTransform;
    }
    else if (orientation == UIInterfaceOrientationLandscapeLeft) {
        CGAffineTransform rotationTransform = CGAffineTransformIdentity;
        rotationTransform = CGAffineTransformRotate(rotationTransform, DEGREES_RADIANS(-90));
        btnFlash.transform = rotationTransform;
    }
}

- (void)addLineViewWithOrientation:(UIInterfaceOrientation)orientation {
    UIView *v = [self.view viewWithTag:-7];
    if (v) {
        [v removeFromSuperview];
    }
    CGRect r;
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown || orientation == UIInterfaceOrientationUnknown) {
        r = CGRectMake(0, (self.view.frame.size.height / 2) - 0.5, self.view.frame.size.width, 1);
    }
    else {
        r = CGRectMake((self.view.frame.size.width / 2) - 0.5, 20, 1, self.view.frame.size.height - 40);
    }
    
    UIView *line = [[UIView alloc] initWithFrame:r];
    line.backgroundColor = [UIColor redColor];
    line.tag = -7;
    [self.view addSubview:line];
    [line release];
}

- (void)addMessageViewWithOrientation:(UIInterfaceOrientation)orientation {
    UIView *v = [self.view viewWithTag:-8];
    if (v) {
        [v removeFromSuperview];
    }
    CGRect r = CGRectMake((self.view.bounds.size.width/2) - 125, 20, 250, 54);
    
    UILabel *aviso = [[UILabel alloc] initWithFrame:r];
    aviso.backgroundColor = [UIColor grayColor];
    aviso.numberOfLines = 2;
    aviso.tag = -8;
    aviso.textColor = [UIColor whiteColor];
    aviso.alpha = 0.6;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6")) {
        aviso.textAlignment = NSTextAlignmentCenter;
    }
    else {
        aviso.textAlignment = UITextAlignmentCenter;
    }
    if (![Context sharedContext].personalizado) {
        aviso.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:14];
    }
    else {
        aviso.font = [UIFont systemFontOfSize:14];
    }
    aviso.text = @"Ocupá toda la pantalla de tu celular con el código de barras completo";
    aviso.layer.cornerRadius = 10;
    aviso.layer.masksToBounds = YES;
    aviso.layer.borderColor = [UIColor blackColor].CGColor;
    aviso.layer.borderWidth = 3.0f;
    [self.view addSubview:aviso];
    if (orientation == UIInterfaceOrientationLandscapeRight) {
        CGAffineTransform rotationTransform = CGAffineTransformIdentity;
        rotationTransform = CGAffineTransformRotate(rotationTransform, DEGREES_RADIANS(90));
        aviso.transform = rotationTransform;
        r = CGRectMake(self.view.bounds.size.width - 64, (self.view.bounds.size.height/2) - 125, 54, 250);
        aviso.frame = r;
    }
    else if (orientation == UIInterfaceOrientationLandscapeLeft) {
        CGAffineTransform rotationTransform = CGAffineTransformIdentity;
        rotationTransform = CGAffineTransformRotate(rotationTransform, DEGREES_RADIANS(-90));
        aviso.transform = rotationTransform;
        r = CGRectMake(10, (self.view.bounds.size.height/2) - 125, 54, 250);
        aviso.frame = r;
    }
    
    [aviso release];
}

- (void)startZBarScan {
//    self.zbarScanner = [[[ZBarReaderViewController alloc] init] autorelease];
//    self.zbarScanner.readerDelegate = self;
//    self.zbarScanner.supportedOrientationsMask = ZBarOrientationMask(UIInterfaceOrientationMaskAll);
//    self.zbarScanner.showsZBarControls = NO;
//    ZBarImageScanner *scanner = self.zbarScanner.scanner;
//    // TODO: (optional) additional reader configuration here
//    
//    // EXAMPLE: disable rarely used I2/5 to improve performance
//    //[scanner setSymbology: ZBAR_I25 config: ZBAR_CFG_ENABLE to: 0];
//    
//    [scanner setSymbology: 0
//                   config: ZBAR_CFG_ENABLE
//                       to: 0];
//    
//    [scanner setSymbology:ZBAR_EAN2 config:ZBAR_CFG_ENABLE to:1];
//    [scanner setSymbology:ZBAR_EAN5 config:ZBAR_CFG_ENABLE to:1];
//    [scanner setSymbology:ZBAR_EAN8 config:ZBAR_CFG_ENABLE to:1];
//    [scanner setSymbology:ZBAR_UPCE config:ZBAR_CFG_ENABLE to:1];
//    [scanner setSymbology:ZBAR_ISBN10 config:ZBAR_CFG_ENABLE to:1];
//    [scanner setSymbology:ZBAR_UPCA config:ZBAR_CFG_ENABLE to:1];
//    [scanner setSymbology:ZBAR_EAN13 config:ZBAR_CFG_ENABLE to:1];
//    [scanner setSymbology:ZBAR_COMPOSITE config:ZBAR_CFG_ENABLE to:1];
//    //[scanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:1];
//    [scanner setSymbology:ZBAR_DATABAR config:ZBAR_CFG_ENABLE to:1];
//    [scanner setSymbology:ZBAR_DATABAR_EXP config:ZBAR_CFG_ENABLE to:1];
//    [scanner setSymbology:ZBAR_CODE39 config:ZBAR_CFG_ENABLE to:1];
//    [scanner setSymbology:ZBAR_CODE93 config:ZBAR_CFG_ENABLE to:1];
//    [scanner setSymbology:ZBAR_CODE128 config:ZBAR_CFG_ENABLE to:1];
//    
//    [scanner setSymbology: 0
//                   config: ZBAR_CFG_X_DENSITY
//                       to: 3];
//    [scanner setSymbology: 0
//                   config: ZBAR_CFG_Y_DENSITY
//                       to: 3];
//    [self.view addSubview:self.zbarScanner.view];
//    self.zbarScanner.view.frame = self.view.bounds;
    
    self.zbarScanner = [[ZBarReaderView new] autorelease];
    self.zbarScanner.trackingColor = [UIColor clearColor];
    ZBarImageScanner *scanner = [ZBarImageScanner new];
    [scanner setSymbology:ZBAR_PARTIAL config:0 to:0];
    [self.zbarScanner initWithImageScanner:scanner];
    [scanner release];
    self.zbarScanner.readerDelegate = self;
    
    const float h = [UIScreen mainScreen].bounds.size.height;
    const float w = [UIScreen mainScreen].bounds.size.width;
    CGRect reader_rect = CGRectMake(0,0,w, h);
    self.zbarScanner.frame = reader_rect;
    self.zbarScanner.backgroundColor = [UIColor redColor];
    [self.zbarScanner start];
    
    [self.view addSubview:self.zbarScanner];
}

- (void)startScanDelayed {
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(timesUp) userInfo:nil repeats:NO];
    }
    scanStarted = YES;
}

- (void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
    if (!scanStarted) {
        return;
    }
    if (self.alertMsg) {
        [self.alertMsg dismissWithClickedButtonIndex:-1 animated:YES];
        self.alertMsg = nil;
    }
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    [self playSound];
    for (ZBarSymbol *s in symbols)
    {
        self.data = s.data;
        break;
    }
    [self closeView];
}

- (void)playSound {
    //NSString *path = [NSString stringWithFormat:@"%@/camera_click.mp3", [[NSBundle mainBundle] resourcePath]];
    NSString *path = [[NSBundle mainBundle]pathForResource:@"camera_click" ofType:@"mp3"];
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    self.audioPlayer = [[[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:NULL] autorelease];
    [self.audioPlayer prepareToPlay];
    [self.audioPlayer play];
    
}

//zbar
//- (void)imagePickerController:(UIImagePickerController*)reader didFinishPickingMediaWithInfo:(NSDictionary*)info
//{
//    [self playSound];
//    
//    // ADD: get the decode results
//    id<NSFastEnumeration> results = [info objectForKey:ZBarReaderControllerResults];
//    ZBarSymbol *symbol = nil;
//    for(symbol in results)
//        // EXAMPLE: just grab the first barcode
//        break;
//    
//    // EXAMPLE: do something useful with the barcode data
//    //resultText.text = symbol.data;
//    //NSLog(@"%@", symbol.data);
//    self.data = symbol.data;
//    
//    [self closeView];
//}

- (void)startScan5 {
    
    self.scanner5 = [[[MTBBarcodeScanner alloc] initWithPreviewView:self.view] autorelease];
    
    [MTBBarcodeScanner requestCameraPermissionWithSuccess:^(BOOL success) {
        if (success) {
            
            [self.scanner5 startScanningWithResultBlock:^(NSArray *codes) {
                
                if (!scanStarted) {
                    return;
                }
                
                if (self.alertMsg) {
                    [self.alertMsg dismissWithClickedButtonIndex:-1 animated:YES];
                    self.alertMsg = nil;
                }
                if (self.timer) {
                    [self.timer invalidate];
                    self.timer = nil;
                }
                
                [self playSound];
                
                AVMetadataMachineReadableCodeObject *code = [codes firstObject];
                
                //NSLog(@"Found code: %@", code.stringValue);
                self.data = code.stringValue;
                
                [self closeView];
            }];
            
        } else {
            // The user denied access to the camera
            [self closeView];
        }
    }];
}

- (void)closeView {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    if (flashIsOn) {
        [self flashAction];
    }
    if (self.zbarScanner) {
        [self.zbarScanner stop];
        self.zbarScanner = nil;
    }
    if (self.scanner5) {
        [self.scanner5 stopScanning];
        self.scanner5 = nil;
    }
    [self.view removeFromSuperview];
    if ([self.readerDelegate respondsToSelector:@selector(finishReadingBarCodeWithResult:)]) {
        [self.readerDelegate performSelector:@selector(finishReadingBarCodeWithResult:) withObject:self.data];
    }
}

- (void)flashAction {
    // check if flashlight available
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch] && [device hasFlash]) {
            [device lockForConfiguration:nil];
            if (device.torchMode == AVCaptureTorchModeOff) {
                flashIsOn = YES;
                [device setTorchMode:AVCaptureTorchModeOn];
                [device setFlashMode:AVCaptureFlashModeOn];
            }
            else {
                flashIsOn = NO;
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];
            }
            [device unlockForConfiguration];
        }
    }
}

- (id)getDeudasConCodigo {
    
    if (!self.data) {
        return nil;
    }
    WS_ValidarCodigoDeBarras * request = [[WS_ValidarCodigoDeBarras alloc] init];
    Context *context = [Context sharedContext];
    request.userToken = [context getToken];
    request.codigoBarra = self.data;
    request.codEmpresa = nil;
    request.longitud = [self.data length];
    return [WSUtil execute:request];
}

+ (id)getDeudasConCodigo:(NSString *)cod yEmpresa:(NSString *)codEmpresa {
    
    WS_ValidarCodigoDeBarras * request = [[WS_ValidarCodigoDeBarras alloc] init];
    Context *context = [Context sharedContext];
    request.userToken = [context getToken];
    request.codigoBarra = cod;
    request.codEmpresa = codEmpresa;
    request.longitud = [cod length];
    return [WSUtil execute:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.timer = nil;
    self.audioPlayer = nil;
    self.zbarScanner = nil;
    self.scanner5 = nil;
    self.data = nil;
    self.readerDelegate = nil;
    self.alertMsg = nil;
    [super dealloc];
}

@end
