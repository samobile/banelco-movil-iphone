//
//  Configuration.m
//  BanelcoMovilIphone
//
//  Created by Ezequiel Aceto on 01/10/10.
//  Copyright 2010 Mobile Computing. All rights reserved.
//

#import "Configuration.h"


@implementation Configuration


+ (void) readConfigurationFromPLIST {
	NSString *env = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"Environment"];
	
	if ([env isEqualToString:@"PROD"] || [env isEqualToString:@"TEST"]|| [env isEqualToString:@"DESA"] ) {
		consultaWSURL = [[[NSBundle mainBundle] infoDictionary] objectForKey:
							  [NSString stringWithFormat:@"ConsultasService_%@",env]];
		
		hostBaseURL = [[[NSBundle mainBundle] infoDictionary] objectForKey:
							[NSString stringWithFormat:@"WebServiceHost_%@",env]];	
	}
    
    menuGenerico = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"menuGenerico"] isEqualToString:@"true"] ;
    
    
}


+ (NSString *) getConsultaWebServiceURL {		
	if (consultaWSURL == nil) {
		[self readConfigurationFromPLIST];
	}
	return consultaWSURL;

}

+ (NSString *) getHostBaseURL {
	if (hostBaseURL == nil) {
		[self readConfigurationFromPLIST];
	}
	return hostBaseURL;
}

+ (BOOL) getMenuGenerico {
    
    return menuGenerico;
}

@end
