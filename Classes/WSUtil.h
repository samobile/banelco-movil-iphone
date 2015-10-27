//
//  WSUtil.h
//  BanelcoMovil
//
//  Created by German Levy on 8/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
#import "WSRequest.h"


@interface WSUtil : NSObject <UIAlertViewDelegate> {

}

+ (void)addProperty:(NSString *)namespace inSOAP:(GDataXMLElement *)soapObject withName:(NSString *)name andValue:(NSString *)value;

+ (id)execute:(WSRequest *)request;

+ (id) parseError:(NSData *)xml;

+ (NSString *)getStringProperty:(NSString *)property ofSoap:(GDataXMLElement *)soap;

+ (int)getIntegerProperty:(NSString *)property ofSoap:(GDataXMLElement *)soap;

+ (double)getDoubleProperty:(NSString *)property ofSoap:(GDataXMLElement *)soap;

+ (NSDecimalNumber *)getDecimalProperty:(NSString *)property ofSoap:()soap;

+ (BOOL)getBooleanProperty:(NSString *)property ofSoap:()soap;

+ (GDataXMLElement *)getRootElement:(NSString *)elementName inData:(NSData *)data;

+ (NSMutableArray *)parseStringList:(GDataXMLElement *)soap;

+ (void)showSessionAlert;

+(NSString * )formatDateFromWS:(NSString *) fecha;

@end
