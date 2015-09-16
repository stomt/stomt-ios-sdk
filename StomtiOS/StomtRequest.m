//
//  StomtRequest.m
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 10/09/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//


#define __DBG__

#import "StomtRequest.h"
#import "Stomt.h"
#import "STTarget.h"
#import "STUser.h"
#import "STObject.h"
#import "STImage.h"
#import "HTTPResponseChecker.h"
#import "strings.h"
#import "dbg.h"

@interface StomtRequest ()
+ (NSMutableURLRequest*)generateBasePOSTRequestWithPath:(NSString*)path;
- (instancetype)initWithApiRequest:(NSURLRequest*)request requestType:(RequestType)type anonymousRequest:(BOOL)anonymous;
@end

@implementation StomtRequest

#pragma mark Setup

- (instancetype)initWithApiRequest:(NSURLRequest*)request requestType:(RequestType)type anonymousRequest:(BOOL)anonymous
{
	self = [super init];
	self.apiRequest = request;
	self.requestType = type;
	return self;
}

- (instancetype)init
{
	_err("Init disabled for this class. Use class initializers.");
error:
	return nil;
}

#pragma mark Create Requests

+ (NSMutableURLRequest*)generateBasePOSTRequestWithPath:(NSString*)path
{
	NSURL* apiUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kAPIURL,path]];
	NSMutableURLRequest* apiRequest = [NSMutableURLRequest requestWithURL:apiUrl];
	[apiRequest setHTTPMethod:@"POST"];
	[apiRequest setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
	[apiRequest setValue:[Stomt sharedInstance].appid forHTTPHeaderField:@"appid"];
	return apiRequest;
}

+ (StomtRequest*)authenticationRequestWithEmailOrUser:(NSString *)user password:(NSString *)pass
{
	NSMutableURLRequest* apiRequest = [StomtRequest generateBasePOSTRequestWithPath:kLoginPath];
	NSError* jsonError;
	NSDictionary* requestBody;
	NSData* jsonData;
	
	requestBody = @{@"login_method":@"normal",@"emailusername":user,@"password":pass};
	jsonData = [NSJSONSerialization dataWithJSONObject:requestBody options:0 error:&jsonError];
	if(jsonError) _err("Error in generating JSON data. Aborting...");
	[apiRequest setHTTPBody:jsonData];
	
	return [[StomtRequest alloc] initWithApiRequest:apiRequest requestType:kAuthRequest anonymousRequest:NO];
	
error:
	return nil;
}

//NOT READY YET ------

+ (StomtRequest*)stomtCreationRequestWithStomtObject:(STObject *)stomtObject targetID:(NSString*)targetID addURL:(NSString*)url geoLocation:(CLLocation*)lonLat anonymousRequest:(BOOL)anonymous
{
	NSMutableURLRequest* apiRequest;
	NSError* jsonError;
	NSMutableDictionary* requestBody;
	NSData* jsonData;
	
	if(!targetID) _err("Target id required! Aborting...");
	
	apiRequest = [StomtRequest generateBasePOSTRequestWithPath:kStomtCreationPath];
	if(!anonymous)
	{
		if([Stomt sharedInstance].accessToken) [apiRequest setValue:[Stomt sharedInstance].accessToken forHTTPHeaderField:@"accesstoken"];
		else anonymous = YES;
		_warn("Set anonymous = NO but no accesstoken was found. Sending anonymous...");
	}
	
	requestBody = [NSMutableDictionary dictionary];
	
	[requestBody setObject:targetID forKey:@"target_id"];
	[requestBody setObject:[NSNumber numberWithBool:stomtObject.positive] forKey:@"positive"];
	[requestBody setObject:stomtObject.text forKey:@"text"];
	if(url) [requestBody setObject:url forKey:@"url"];
	[requestBody setObject:[NSNumber numberWithBool:anonymous] forKey:@"anonymous"];
	if(stomtObject.image.imageName) [requestBody setObject:stomtObject.image.imageName forKey:@"img_name"];
	if(lonLat) [requestBody setObject:lonLat forKey:@"lonlat"];
	
	jsonData = [NSJSONSerialization dataWithJSONObject:requestBody options:0 error:&jsonError];
	if(jsonError) _err("Error in generating JSON data. Aborting...");
	[apiRequest setHTTPBody:jsonData];
	
	return [[StomtRequest alloc] initWithApiRequest:apiRequest requestType:kStomtCreationRequest anonymousRequest:anonymous];
	
error:
	return nil;
}

//NOT READY YET

#pragma mark Send Requests

- (void)autenticateInBackgroundWithBlock:(AuthenticationBlock)completion
{
	__block NSError* dictErr;
	__block NSDictionary* dataDict;
	
	if(self.requestType == kAuthRequest){
	
		[NSURLConnection sendAsynchronousRequest:self.apiRequest queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
			
			if([HTTPResponseChecker checkResponseCode:response] == OK)
			{
				dataDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&dictErr];
				if(!dictErr)
				{
					STUser* currentUser = [STUser initWithDataDictionary:[dataDict objectForKey:@"data"]];
					if([[NSUserDefaults standardUserDefaults] objectForKey:kToken]) [Stomt logout];
					if(currentUser.accessToken && currentUser.refreshToken)
					{
						[Stomt sharedInstance].accessToken = currentUser.accessToken;
						[Stomt sharedInstance].refreshToken = currentUser.refreshToken;
						[Stomt sharedInstance].isAuthenticated = YES;
					}
					completion(connectionError,currentUser);
				}
				
			}
			else if([HTTPResponseChecker checkResponseCode:response] == OLD_TOKEN)
			{
				[Stomt logout]; //Temporary behavior
				
				/*
				[Stomt requestNewAccessTokenInBackgroundWithBlock:^(BOOL succeeded) {
					
				}];
				 
				 To be implemented soon. 
				 
				 */
				
			} //Better error handler will be implemented
			
		}];
		
		return;
	}
error:
	fprintf(stderr,"\n[ERROR] Authentication request not available for this instance.");
}

//NOT READY YET ------

- (void)sendStomtInBackgroundWithBlock:(StomtCreationBlock)completion
{
	if(self.requestType == kStomtCreationRequest)
	{
		NSLog(@"Stomt sending will be implemented soon.");
		return;
	}
	
error:
	fprintf(stderr,"\n[ERROR] Stomt creation request not available for this instance.");
}

//NOT READY YET ------
@end
