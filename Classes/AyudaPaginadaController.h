#import <UIKit/UIKit.h>
#import "WheelAnimationController.h"

@interface AyudaPaginadaController : WheelAnimationController <UIScrollViewDelegate>{

	
	IBOutlet UIScrollView* scrollView;
	IBOutlet UIPageControl* pageControl;
	
	BOOL pageControlIsChangingPage;
	
	int cantidadDePaginas;
	int actualPaginaRequest;
	int indiceDePregunta;
	NSMutableArray* textoDePaginas;
	NSURLConnection *theConnection;
	
	IBOutlet UIImageView *fndApp;
}


-(id) initWithOptionNumber:(int) numero;
-(void) refreshWithNumber:(int) num;

@property (nonatomic, retain) UIView *scrollView;
@property (nonatomic, retain) UIPageControl* pageControl;
@property (nonatomic, retain) NSMutableData* receivedData;
@property (nonatomic, retain) NSURLConnection *theConnection;
@property int indiceDePregunta;
@property int cantidadDePaginas;
@property int actualPaginaRequest;

@property (nonatomic, retain) NSMutableArray* textoDePaginas;

@property (nonatomic, retain) UIImageView *fndApp;


-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andNumber:(int)numero;

/* for pageControl */
- (IBAction)changePage:(id)sender;
-(IBAction) hideHelp;
/* internal */
- (void)setupPage;
-(IBAction) volver;

@end
