//
//  AuthenticationDispatch.m
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 26/03/16.
//  Copyright © 2016 Leonardo Cascianelli. All rights reserved.
//

#import "Stomt.h"
#import "AuthenticationDispatch.h"

@interface AuthenticationDispatch ()
- (NSDictionary*)urlParametersForUrl:(NSURL*)url;
@end

@implementation AuthenticationDispatch

+ (instancetype)sharedInstance
{
	static AuthenticationDispatch* privInstance = nil;
	
	if(!privInstance)
	{
		privInstance = [[AuthenticationDispatch alloc] init];
		//Some setup maybe?
	}
	
	return privInstance;
}

- (NSDictionary*)urlParametersForUrl:(NSURL *)url
{
	NSMutableDictionary* urlDict;
	
	NSArray* parameters = [[[[url absoluteString] componentsSeparatedByString:@"#"] lastObject] componentsSeparatedByString:@"&"];
	
	if(!urlDict) urlDict = [NSMutableDictionary dictionary];
	
	for (NSString* couple in parameters)
	{
		NSArray* coupleArray = [couple componentsSeparatedByString:@"="];
		NSString* key = [coupleArray firstObject];
		NSString* value = [coupleArray lastObject];
		[urlDict setObject:value forKey:key];
	}
	
	return urlDict;
}

- (void)handleOpenUrl:(NSURL *)url
{
	StomtRequest* loginRequest;
	
	if([[url absoluteString] containsString:@"fb"])
	{
		loginRequest = [StomtRequest externalLoginRequestForRoute:kSTAuthenticationRouteFacebook withParameters:[self urlParametersForUrl:url]];
	}
	
	[loginRequest authenticateWithExternalRouteWithBlock:^(NSError *error, STUser *user) {
		NSLog(@"%@",error);
	}];
	

}


@end
