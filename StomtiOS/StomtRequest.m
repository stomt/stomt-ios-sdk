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
#import <CoreLocation/CLLocation.h>
#import "HTTPResponseChecker.h"
#import "strings.h"
#import "dbg.h"


@interface StomtRequest ()
+ (NSMutableURLRequest*)generateBasePOSTRequestWithPath:(NSString*)path;
- (instancetype)initWithApiRequest:(NSURLRequest*)request requestType:(RequestType)type;
@end

@implementation StomtRequest

#pragma mark Setup

- (instancetype)initWithApiRequest:(NSURLRequest*)request requestType:(RequestType)type
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
	
	return [[StomtRequest alloc] initWithApiRequest:apiRequest requestType:kAuthRequest];
	
error:
	return nil;
}

+ (StomtRequest*)stomtCreationRequestWithStomtObject:(STObject *)stomtObject targetID:(NSString*)targetID addURL:(NSString*)url geoLocation:(CLLocation*)lonLat image:(STImage*)image
{
	NSMutableURLRequest* apiRequest;
	NSError* jsonError;
	NSMutableDictionary* requestBody;
	NSData* jsonData;
	BOOL anonymous;
	
	if(!targetID) _err("Target id required! Aborting...");
	
	apiRequest = [StomtRequest generateBasePOSTRequestWithPath:kStomtCreationPath];
	anonymous = YES;
	
	if([Stomt sharedInstance].accessToken)
	{
		[apiRequest setValue:[Stomt sharedInstance].accessToken forHTTPHeaderField:@"accesstoken"];
		anonymous = NO;
	}
	
	requestBody = [NSMutableDictionary dictionary];
	
	[requestBody setObject:targetID forKey:@"target_id"];
	[requestBody setObject:[NSNumber numberWithBool:stomtObject.positive] forKey:@"positive"];
	[requestBody setObject:stomtObject.text forKey:@"text"];
	if(url) [requestBody setObject:url forKey:@"url"];
	[requestBody setObject:[NSNumber numberWithBool:anonymous] forKey:@"anonymous"];
	if(image) [requestBody setObject:image.imageName forKey:@"img_name"];
	
	if(lonLat) [requestBody setObject:[NSString stringWithFormat:@"%f,%f",lonLat.coordinate.longitude,lonLat.coordinate.latitude] forKey:@"lonlat"];
	
	jsonData = [NSJSONSerialization dataWithJSONObject:requestBody options:0 error:&jsonError];
	if(jsonError) _err("Error in generating JSON data. Aborting...");
	[apiRequest setHTTPBody:jsonData];
	return [[StomtRequest alloc] initWithApiRequest:apiRequest requestType:kStomtCreationRequest];
	
error:
	return nil;
}


+ (StomtRequest*)imageUploadRequestWithImage:(UIImage *)image forTargetID:(NSString*)targetID withImageCategory:(kSTImageCategory)category
{
	NSMutableURLRequest* apiRequest;
	NSError* jsonError;
	NSMutableDictionary* requestBody;
	NSData* jsonData;
	NSString* imageCategoryStr;
	NSData* imageData;
	NSString* imageBase64;
	
	if(image)
	{
		imageData = UIImageJPEGRepresentation(image, 1.0);
		imageBase64 = [imageData base64EncodedStringWithOptions:0];
	}else _err("No image provided! Aborting...");
	
	if (category == kSTImageCategoryAvatar) imageCategoryStr = @"avatar";
	else if (category == kSTImageCategoryCover) imageCategoryStr = @"cover";
	else if (category == kSTImageCategoryStomt) imageCategoryStr = @"stomt";
	
	apiRequest = [StomtRequest generateBasePOSTRequestWithPath:kImageUploadPath];
	requestBody = [NSMutableDictionary dictionary];
	if(targetID)[requestBody setObject:targetID forKey:@"id"];
	[requestBody setObject:@{imageCategoryStr:@[@{@"data":imageBase64}]} forKey:@"images"];
	
	jsonData = [NSJSONSerialization dataWithJSONObject:requestBody options:0 error:&jsonError];
	if(jsonError) _err("Error in serializing JSON. Aborting...");
	[apiRequest setHTTPBody:jsonData];
	
	return [[StomtRequest alloc] initWithApiRequest:apiRequest requestType:kImageUploadRequest];
error:
	return nil;
}

+ (StomtRequest*)logoutRequest
{
	NSMutableURLRequest* apiRequest;
	apiRequest = [StomtRequest generateBasePOSTRequestWithPath:kLogoutPath];
	apiRequest.HTTPMethod = @"DELETE";
	[apiRequest setValue:[Stomt sharedInstance].accessToken forHTTPHeaderField:@"accesstoken"];
	if(apiRequest)
		return [[StomtRequest alloc] initWithApiRequest:apiRequest requestType:kLogoutRequest];
	
error:
	return nil;
}
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

- (void)sendStomtInBackgroundWithBlock:(StomtCreationBlock)completion
{
	if(self.requestType == kStomtCreationRequest)
	{
		[NSURLConnection sendAsynchronousRequest:self.apiRequest queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
			if([HTTPResponseChecker checkResponseCode:response] == OK)
			{
				_info("Stomt sent.");
				NSError *jsonError;
				NSDictionary* dataDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
				if(jsonError){NSLog(@"Error in json serializing. %@",jsonError); return;}
				
				if(![Stomt sharedInstance].accessToken && ![Stomt sharedInstance].refreshToken)
				{
					[Stomt sharedInstance].accessToken = [dataDict objectForKey:kD_AccessToken];
					[Stomt sharedInstance].refreshToken = [dataDict objectForKey:kD_RefreshToken];
				}
				completion(connectionError,[STObject objectWithDataDictionary:dataDict]);
				
			}else fprintf(stderr, "Error!");
		}];
		return;
	}
	
error:
	fprintf(stderr,"\n[ERROR] Stomt creation request not available for this instance.");
}


- (void)uploadImageInBackgroundWithBlock:(ImageUploadBlock)completion
{
	if(self.requestType == kImageUploadRequest){
		
		[NSURLConnection sendAsynchronousRequest:self.apiRequest queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
				if([HTTPResponseChecker checkResponseCode:response] == OK)
				{
					NSString* category;
					NSDictionary* rDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
					NSDictionary* basePath = [NSDictionary dictionaryWithDictionary:[[rDict objectForKey:@"data"] objectForKey:@"images"]];
					if([basePath objectForKey:@"avatar"]) category = [[basePath objectForKey:@"avatar"] objectForKey:@"name"];
					else if([basePath objectForKey:@"cover"]) category = [[basePath objectForKey:@"cover"] objectForKey:@"name"];
					else if([basePath objectForKey:@"stomt"]) category = [[basePath objectForKey:@"stomt"] objectForKey:@"name"];
					completion(connectionError,[[STImage alloc] initWithStomtImageName:category]);
					
				}else fprintf(stderr, "Error!");
		}];
		
		return;
	}
error:
	fprintf(stderr,"\n[ERROR] Image upload request not available for this instance.");
}

- (void)logoutInBackgroundWithBlock:(BooleanCompletion)completion
{
	if(self.requestType == kLogoutRequest)
	{
		[NSURLConnection sendAsynchronousRequest:self.apiRequest queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
			if([HTTPResponseChecker checkResponseCode:response] == OK)
			{
				_info("Logged out!");
				completion(YES);
			}
			else fprintf(stderr, "Some kind of error. Handle.");
		}];
		return;
	}
	
error:
	fprintf(stderr,"\n[ERROR] Image upload request not available for this instance.");
}
@end
