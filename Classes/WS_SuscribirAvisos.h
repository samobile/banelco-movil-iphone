#import <Foundation/Foundation.h>
#import "WSRequest.h"

@interface WS_SuscribirAvisos : WSRequest {

	NSString *userToken;
	NSString *userMail;
	NSString *showVencimientos;
	NSString *showInfo;
	
}


@property(nonatomic,retain) NSString *userToken;
@property(nonatomic,retain) NSString *userMail;
@property(nonatomic,retain) NSString * showVencimientos;
@property(nonatomic,retain) NSString * showInfo;

@end
