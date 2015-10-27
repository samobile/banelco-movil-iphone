//
//  MenuInicialPatagonia.m
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 4/24/14.
//
//

#import "MenuInicialPatagonia.h"
#import "LoginController.h"

@interface MenuInicialPatagonia ()

@end

@implementation MenuInicialPatagonia

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)mobileBanking:(id)sender {
    LoginController *controller = [[LoginController alloc] initPersonalizado];
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
}

- (IBAction)ahorroBeneficios:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://ahorrosybeneficios.bancopatagonia.com.ar/"]];
}

- (IBAction)patagoniaMas:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.bancopatagonia.com/personas/patagonia_mas/"]];
}

- (IBAction)contactenos:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.bancopatagonia.com.ar/comunes/contacto.shtml"]];
}

@end
