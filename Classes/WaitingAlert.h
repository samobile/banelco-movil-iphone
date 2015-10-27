//
//  WaitingAlert.h
//  BanelcoMovilIphone
//
//  Created by German Levy on 10/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WaitingAlert : UIView {

	UIView *alertView;
	UILabel *label;
	UIActivityIndicatorView *activityConexion;
	int hPos;
	
	NSString* finishSelector;
	id theFinishTarget;
}

@property(nonatomic,retain) UIView *alertView;
@property(nonatomic,retain) UILabel *label;
@property(nonatomic,retain) UIActivityIndicatorView *activityConexion;
@property(nonatomic,retain) NSString* finishSelector;
@property(nonatomic,retain) id theFinishTarget;
@property int hPos;

-(void)startWithSelector:(NSString *)selector fromTarget:(id)t;
-(void) startWithSelector:(NSString *)selector fromTarget:(id)t withObject:(id)object;
-(void) startWithSelector:(NSString *)selector fromTarget:(id)t andFinishSelector:(NSString*)finishSel formTarget:(id) t2; 
-(void)detener;

@end
