//
//  WebServicesHandler.h
//  SyncService
//
//  Created by Federico Lanzani on 4/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IWSRequest.h"
#import "WSRequest.h"


@interface WebServicesHandler : NSObject  {
	
	NSMutableData *webData;
	NSMutableString *soapResults;

	BOOL *recordResults;
	NSString *xmlReturned;
	NSData *xmlDataReturned;
	BOOL isBlocking;
	BOOL isFinished;
	
	NSString * sessionID;
	NSString * xmlForWS;
	
	NSString *urlForWs;
	
	NSString *token;
	NSString *user;
	NSString *pass;
	
}

@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, retain) NSMutableString *soapResults;

@property(nonatomic, retain) NSString *xmlReturned;
@property(nonatomic, retain) NSData *xmlDataReturned;
@property BOOL isBlocking;
@property BOOL isFinished;

@property(nonatomic, retain) NSString *sessionID;
@property(nonatomic, retain) NSString *xmlForWS;

@property (nonatomic, retain)	NSString *urlForWs;

@property (nonatomic, retain) NSString *token;

@property (nonatomic, retain) NSString *user;
@property (nonatomic, retain) NSString *pass;


-(NSData *) callWebServiceGenericMOP:(WSRequest *)wsRequest;
- (id) initwithBlocking:(BOOL)x;

@end
