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

@interface Configuration : NSObject {


	
}

+ (NSString *) getConsultaWebServiceURL;
+ (NSString *) getHostBaseURL;



@end
