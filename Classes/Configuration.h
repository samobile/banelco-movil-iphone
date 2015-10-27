//
//  Configuration.h
//  BanelcoMovilIphone
//
//  Created by Ezequiel Aceto on 01/10/10.
//  Copyright 2010 Mobile Computing. All rights reserved.
//

#import <Foundation/Foundation.h>

// "Class variables"
static NSString *consultaWSURL;
static NSString *hostBaseURL;
static BOOL menuGenerico;

@interface Configuration : NSObject {


	
}

+ (NSString *) getConsultaWebServiceURL;
+ (NSString *) getHostBaseURL;
+ (BOOL) getMenuGenerico;



@end
