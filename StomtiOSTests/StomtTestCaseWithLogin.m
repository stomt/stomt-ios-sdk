//
//  StomtTestCaseWithLogin.m
//  StomtiOS
//
//  Created by Max Klenk on 30/09/15.
//  Copyright © 2015 Leonardo Cascianelli. All rights reserved.
//


#import "StomtTestCaseWithLogin.h"
#import "Stomt.h"
#import "StomtRequest_PrivateTests.h"

@implementation StomtRequest(PrivateTests)

+ (StomtRequest*)normalAuthWithUsername:(NSString *)user password:(NSString *)pass
{
	NSURL* apiUrl;
	NSMutableURLRequest* apiRequest;
	NSMutableDictionary* requestBody = [[NSMutableDictionary alloc] init];
	
	apiUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"https://test.rest.stomt.com",@"/authentication/session"]];
	apiRequest = [NSMutableURLRequest requestWithURL:apiUrl];
	[apiRequest setHTTPMethod:@"POST"];
	[apiRequest setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
	[apiRequest setValue:[Stomt sharedInstance].appid forHTTPHeaderField:@"appid"];
	[requestBody setValue:@"normal" forKey:@"login_method"];
	[requestBody setValue:user forKey:@"emailusername"];
	[requestBody setValue:pass forKey:@"password"];
	[apiRequest setHTTPBody:[NSJSONSerialization dataWithJSONObject:requestBody options:0 error:nil]];
	return [[StomtRequest alloc] initWithApiRequest:apiRequest];
}

- (instancetype)initWithApiRequest:(NSURLRequest*)request
{
	self = [super init];
	self.apiRequest = request;
	return self;
}

- (void)authenticateWithBlock:(AuthenticationBlock)completion
{
	NSData* result = [NSURLConnection sendSynchronousRequest:self.apiRequest  returningResponse:nil error:nil];
	NSDictionary* resDict = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
	if(completion) completion(nil, [[STUser alloc] initWithDataDictionary:[resDict objectForKey:@"data"]]);
	return;
}
@end


@implementation StomtTestCaseWithLogin

- (void)setUp {
    [super setUp];
		StomtRequest* authReq = [StomtRequest normalAuthWithUsername:@"test" password:@"test"];
		[authReq authenticateWithBlock:^(NSError *error, STUser *user) {
			if(user)
			{
				[Stomt sharedInstance].accessToken = user.accessToken;
				[Stomt sharedInstance].refreshToken = user.refreshToken;
				[[Stomt sharedInstance] setLoggedUser:user];
			}
		}];
	
}

- (void)tearDown {
	[Stomt logout];
    [super tearDown];
}

@end
