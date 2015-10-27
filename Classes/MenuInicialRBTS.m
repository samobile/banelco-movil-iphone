//
//  MenuInicialRBTS.m
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 3/11/13.
//  Copyright 2013 Mobile Computing. All rights reserved.
//

#import "MenuInicialRBTS.h"
#import "LoginController.h"
#import "CommonFunctions.h"

@implementation MenuInicialRBTS

@synthesize images, urls, bannerContainer, container, bannerTimer, load;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
        bannerVisible = 1;
        self.images = [[[NSMutableArray alloc] init] autorelease];
        self.urls = [[[NSMutableArray alloc] init] autorelease];
        
    }
    return self;
}

- (void)procesarRespuesta:(NSString *)url {
	NSString *response = [self procesarRequestHTTP:url];
	[self procesarBanners:response];
}

- (void)procesarBanners:(NSString *)datosStr {
    
    [images removeAllObjects];
    [urls removeAllObjects];
    bannerVisible = 1;
	NSArray *param = [datosStr componentsSeparatedByString:@"\n"];
    for (int i = 0; i < [param count]; i++) {
        NSString *line = [param objectAtIndex:i];
        if (i == 0) {
            timeInterval = [line floatValue];
            continue;
        }
        NSArray *values = [line componentsSeparatedByString:@";"];
        if ([values count] == 2) {
            NSData *dataImage = [NSData dataWithContentsOfURL:[NSURL URLWithString:[values objectAtIndex:0]]];
            if (dataImage && [dataImage length] > 0) {
                [images addObject:dataImage];
                [urls addObject:[values objectAtIndex:1]];
            }
        }
    }
//    if ([images count] == 0) {
//        //carga banner local
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"hsbc_banner" ofType:@"jpg"];
//        [images addObject:[NSData dataWithContentsOfFile:path]];
//        [urls addObject:@""];
//    }
    
}

- (NSString *)procesarRequestHTTP:(NSString *)urlString {
    NSString *urlString2 = [NSString stringWithFormat:@"%@?%@", urlString, [CommonFunctions dateToNSStringCache:[NSDate date]]];
	NSURL *url = [NSURL URLWithString:urlString2];
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:30.0] ;
	NSURLResponse *response = [[[NSURLResponse alloc] init] autorelease];
	NSError *error = [[NSError alloc] init];
	NSData *data = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
	
	return [[NSString alloc] initWithBytes: [data mutableBytes] length:[data length] encoding:NSUTF8StringEncoding];
    
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!IS_IPHONE_5) {
        CGRect r = self.container.bounds;
        //self.container.frame = CGRectMake(0, 0, r.size.width, r.size.height - 20);
        [self.container setContentSize:CGSizeMake(r.size.width, r.size.height + 20)];
    }
    else {
        CGRect r = self.container.bounds;
        self.container.frame = CGRectMake(0, 0, r.size.width, r.size.height + 20);
    }
    
    //carga banner local
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"hsbc_banner" ofType:@"jpg"];
//    [images addObject:[NSData dataWithContentsOfFile:path]];
//    [urls addObject:@""];
//    
//    bannerVisible = 1;
    //carga banner inicial
//    if ([self.images count] > 0) {
//        UIButton *banner = [self obtenerBanner];
//        banner.frame = CGRectMake(0, 0, banner.frame.size.width, banner.frame.size.height);
//        [self.bannerContainer addSubview:banner];
//    }
//    if ([self.images count] > 1) {
//        [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(cambiarBanner) userInfo:nil repeats:YES];
//    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(justAppear) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [self justAppear];
    
}

- (void)justAppear {
    if (self.bannerTimer) {
        [self.bannerTimer invalidate];
        self.bannerTimer = nil;
    }
    
    [images removeAllObjects];
    [urls removeAllObjects];
    
    //carga banner local
    NSString *path = [[NSBundle mainBundle] pathForResource:@"hsbc_banner" ofType:@"jpg"];
    [images addObject:[NSData dataWithContentsOfFile:path]];
    [urls addObject:@""];
    
    [self.bannerContainer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    bannerVisible = 1;
    if ([self.images count] > 0) {
        UIButton *banner = [self obtenerBanner];
        banner.tag = 0;
        banner.frame = CGRectMake(0, 0, banner.frame.size.width, banner.frame.size.height);
        [self.bannerContainer addSubview:banner];
    }
    
    
    [self performSelectorInBackground:@selector(cargarBanners) withObject:nil];
}

- (void)cargarBanners {
    
    [self.load performSelectorOnMainThread:@selector(startAnimating) withObject:nil waitUntilDone:YES];
    
    //cargar banner
    NSString *env = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"Environment"];
    NSString *urlBanners = [[NSBundle mainBundle] objectForInfoDictionaryKey:[NSString stringWithFormat:@"urlBanners_%@",env]];
    [self procesarRespuesta:urlBanners];
    
    [self performSelectorOnMainThread:@selector(carga) withObject:nil waitUntilDone:YES];
    
    [self.load performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:NO];
}

- (void)carga {
    if ([self.images count] > 0) {
        UIButton *banner = [self obtenerBanner];
        banner.frame = CGRectMake(0, 0, banner.frame.size.width, banner.frame.size.height);
        [self.bannerContainer addSubview:banner];
    }
    if ([self.images count] > 1) {
        if (self.bannerTimer) {
            [self.bannerTimer invalidate];
            self.bannerTimer = nil;
        }
        self.bannerTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(cambiarBanner) userInfo:nil repeats:YES];
    }
}

- (void)cambiarBanner {
    UIButton *lastBanner = (UIButton *)[self.bannerContainer viewWithTag:bannerVisible];
    if (bannerVisible == [self.images count]) {
        bannerVisible = 1;
    }
    else {
        bannerVisible++;
    }
    
    UIButton *banner = [self obtenerBanner];
    banner.frame = CGRectMake(320, 0, banner.frame.size.width, banner.frame.size.height);
    [self.bannerContainer addSubview:banner];
    
    [UIView animateWithDuration:1 animations:^{
        if (lastBanner) {
            lastBanner.frame = CGRectMake(-320, 0, lastBanner.frame.size.width, lastBanner.frame.size.height);
        }
        banner.frame = CGRectMake(0, 0, banner.frame.size.width, banner.frame.size.height);
    } completion:^(BOOL finished) {
        if (lastBanner) {
            [lastBanner removeFromSuperview];
        }
    }];
    
}

- (UIButton *)obtenerBanner {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = bannerVisible;
    btn.backgroundColor = [UIColor clearColor];
    btn.frame = self.bannerContainer.bounds;
    btn.showsTouchWhenHighlighted = YES;
    //NSString *targetUrl = [self.urls objectAtIndex:bannerVisible-1];
    //if (targetUrl && [targetUrl length] > 0) {
    [btn addTarget:self action:@selector(goToLink:) forControlEvents:UIControlEventTouchUpInside];
    //}

    UIImageView *imv = [[UIImageView alloc] initWithFrame:btn.bounds];
    imv.clipsToBounds = YES;
    imv.contentMode = UIViewContentModeScaleAspectFill;
    imv.image = [UIImage imageWithData:[self.images objectAtIndex:bannerVisible-1]];
    [btn addSubview:imv];
    [imv release];
    
    //[btn setBackgroundImage:imv forState:UIControlStateNormal];
    
    return btn;
}

- (void)goToLink:(id)sender {
    if ([sender tag] <= 0) {
        return;
    }
    NSString *url = [self.urls objectAtIndex:[sender tag]-1];
    if (url && [url length] > 0) {
        NSURL *ur = [NSURL URLWithString:[url stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        [[UIApplication sharedApplication] openURL:ur];
    }
}

- (IBAction)mobileBanking {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
	LoginController *controller = [[LoginController alloc] initPersonalizado];
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
}

- (IBAction)sucursales  {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.hsbc.com.ar/mapa/?WT.ac=HBAR_e140618MOB01PFS"]];
}

- (IBAction)programaBeneficios {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.hsbc.com.ar/m/beneficios.asp?WT.mc_id=HBAR_e130415MOB11PFS"]]; 
}

- (IBAction)beneficiosSMS {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.hsbc.com.ar/m/sms.asp?WT.mc_id=HBAR_e130415MOB12PFS"]]; 
}

- (IBAction)sitioWeb {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.hsbc.com.ar/m/default.asp?WT.mc_id=HBAR_e130415MOB14PFS"]]; 
}

- (IBAction)rewards {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.hsbc.com.ar/m/gift-card.asp?WT.mc_id=HBAR_e130715MOB06PFS"]];
}

- (IBAction)producto {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.hsbc.com.ar/m/quiero.asp?WT.mc_id=HBAR_e130415MOB15PFS"]]; 
}

- (IBAction)beneficioFace {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.hsbc.com.ar/ar/bancapersonal/redirect_fb.asp?WT.mc_id=HBAR_e130415MOB13PFS"]]; 
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    self.images = nil;
    self.urls = nil;
    self.bannerContainer = nil;
    self.container = nil;
    self.bannerTimer = nil;
    self.load = nil;
    [super dealloc];
}


@end
