//
//  WebServicesHandler.m
//  SyncService
//
//  Created by Federico Lanzani on 4/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WebServicesHandler.h"
#import "IWSRequest.h"
#import "WSRequest.h"
#import "CommonUIFunctions.h"

@implementation WebServicesHandler

@synthesize webData, soapResults, xmlReturned, xmlDataReturned;
@synthesize isBlocking, isFinished, xmlForWS, sessionID, urlForWs, token, user, pass;

- (id) init
{
	self = [super init];
	if (self != nil) {
		
	}
	return self;
}

- (id) initwithBlocking:(BOOL)x
{
	self = [super init];
	if (self != nil) {
		self.isBlocking = x;
		self.isFinished = FALSE;
	}
	return self;
}


-(void) ConnectASYNCRO:(NSMutableURLRequest *)theRequest
{

	NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	
	if( theConnection )
	{
		webData = [[NSMutableData data] retain];
	}
	else
	{
		NSLog(@"theConnection is NULL");
	}
	
}

-(NSData *) ConnectSYNCRO:(NSMutableURLRequest *)theRequest
{

	//NSLog(@"entre a connectSYNCRO");
	NSURLResponse *response = [[NSURLResponse alloc] init];
	NSError *error = nil;
	NSData *data = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error]; 
	//NSLog(@"Conexion finalizada");
//    if (error) {
//        [CommonUIFunctions showAlert:@"" withMessage:[error description] andCancelButton:@"Aceptar"];
//    }
	return data;
	
}


-(NSData *)callWebServiceGenericMOP:(WSRequest *)wsRequest
{
	NSLog(@"entre al devolverXML");
	
	
	NSString *soapMessage = [wsRequest getSoapMessage];
	
	NSLog(@"Arme el mensaje SOAP");
	NSLog(@"%@",soapMessage);
	
	NSURL *url = [NSURL URLWithString:[wsRequest getWSURL]];
	NSLog(@"]]]]]]]]]]]]] %@",[url host]);
	
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url] ;
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	
	[theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[theRequest addValue: [wsRequest getWSHost] forHTTPHeaderField:@"Host"];
	[theRequest addValue: [wsRequest getWSName] forHTTPHeaderField:@"SOAPAction"];
	[theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
	[theRequest setHTTPMethod:@"POST"];
	[theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSLog(@"antes de armar la conexion");
	
	
	NSData *data = [self ConnectSYNCRO:theRequest];
	
	self.xmlDataReturned = data;
	self.xmlReturned = [[[NSString alloc] initWithBytes: [data bytes] length:[data length] encoding:NSUTF8StringEncoding] autorelease];
	
	
	NSLog(@"REQUESTED: %@",theRequest);
	NSLog(@"%@",soapMessage);	
	NSLog(@"RETURNED: %@",self.xmlReturned);
	
	//OJO!! NO DESCOMENTAR PQ TIRA EXC_BAD_ACCESS!!!!
	//[theRequest release];
	//[msgLength release];
	//[url release];
	//[soapMessage release];
	
	return data;
	
}


@end
