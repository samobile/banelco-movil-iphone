//
//  TyCPaginadoController.h
//  BanelcoMovilIphone
//
//  Created by Demian on 9/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WheelAnimationController.h"

@interface TyCPaginadoController : WheelAnimationController <UIScrollViewDelegate> {

	
	IBOutlet UIScrollView* scrollView;
	IBOutlet UIPageControl* pageControl;
	
	BOOL pageControlIsChangingPage;
	
	int cantidadDePaginas;
	int actualPaginaRequest;
	
	NSMutableArray* textoDePaginas;
	NSURLConnection *theConnection;
	
	BOOL viewLoaded;
    
    IBOutlet UIImageView *fndImage;
}
@property (nonatomic, retain) UIView *scrollView;
@property (nonatomic, retain) UIPageControl* pageControl;
@property (nonatomic, retain) NSMutableData* receivedData;
@property (nonatomic, retain) NSURLConnection *theConnection;

@property int cantidadDePaginas;
@property int actualPaginaRequest;

@property (nonatomic, retain) NSMutableArray* textoDePaginas;

@property (nonatomic, retain) UIImageView *fndImage;

/* for pageControl */
- (IBAction)changePage:(id)sender;
-(IBAction) hideHelp;
/* internal */
- (void)setupPage;


@end
