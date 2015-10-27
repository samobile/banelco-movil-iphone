#import <UIKit/UIKit.h>
#import "WheelAnimationController.h"

@interface TerminosYCondicionesPaginado : WheelAnimationController <UIScrollViewDelegate>
{
	IBOutlet UIScrollView* scrollView;
	IBOutlet UIPageControl* pageControl;

    BOOL pageControlIsChangingPage;
	
	NSMutableData* receivedData;
	
	int cantidadDePaginas;
	int actualPaginaRequest;
	
	NSMutableArray* textoDePaginas;
	NSURLConnection *theConnection;
	
	IBOutlet UILabel *ltyc;
    
    IBOutlet UIImageView *fndApp;
}
@property (nonatomic, retain) UIView *scrollView;
@property (nonatomic, retain) UIPageControl* pageControl;
@property (nonatomic, retain) NSMutableData* receivedData;
@property (nonatomic, retain) NSURLConnection *theConnection;

@property int cantidadDePaginas;
@property int actualPaginaRequest;

@property (nonatomic, retain) NSMutableArray* textoDePaginas;

@property (nonatomic, retain) IBOutlet UILabel *ltyc;

@property (nonatomic, retain) UIImageView *fndApp;

/* for pageControl */
- (IBAction)changePage:(id)sender;
-(IBAction) hideHelp;
/* internal */
- (void)setupPage;

-(IBAction) back;
@end

