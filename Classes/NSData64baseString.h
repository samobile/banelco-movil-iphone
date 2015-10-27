//
//  NSData64baseString.h
//  MING_iPad
//
//  Created by Federico Lanzani on 5/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface NSData (MBBase64) 


+ (id)dataWithBase64EncodedString:(NSString *)string;     //  Padding '=' characters are optional. Whitespace is ignored.
- (NSString *)base64Encoding;






@end
