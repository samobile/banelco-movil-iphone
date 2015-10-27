//
//  ExecuteLogin.h
//  BanelcoMovilIphone
//
//  Created by German Levy on 6/14/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WaitingAlert.h"


@interface ExecuteLogin : NSObject {

	WaitingAlert *alert;
	UIViewController *controller;
	
	NSString *doc;
	NSString *docType;
	NSString *password;
	
}

@property(nonatomic,retain) WaitingAlert *alert;
@property (nonatomic, retain) UIViewController *controller;

@property(nonatomic,retain) NSString *doc;
@property(nonatomic,retain) NSString *docType;
@property(nonatomic,retain) NSString *password;

- (id)initFromController:(UIViewController *)pController withDoc:(NSString *)pDoc ofType:(NSString *)pDocType andPW:(NSString *)pPW;
-(void)executeLogin;
-(void)doLoginAfterChangePassOfDoc:(NSString *)pDoc ofType:(NSString *)pDocType andPW:(NSString *)pPw;
-(void)doLoginOfDoc:(NSString *)pDoc ofType:(NSString *)pDocType andPW:(NSString *)pPw;

@end
