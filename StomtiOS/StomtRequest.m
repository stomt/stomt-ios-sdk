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
#import "STFeed.h"
#import <CoreLocation/CLLocation.h>
#import "HTTPResponseChecker.h"
#import "strings.h"
#import "dbg.h"


@interface StomtRequest ()
+ (NSMutableURLRequest*)generateBasePOSTRequestWithPath:(NSString*)path;
+ (NSMutableURLRequest*)generateBaseGETRequestWithPath:(NSString*)path
										parametersPair:(NSDictionary*)pPair;
- (instancetype)initWithApiRequest:(NSURLRequest*)request
					   requestType:(RequestType)type;
@end

@implementation StomtRequest

#pragma mark Setup

- (instancetype)initWithApiRequest:(NSURLRequest*)request
					   requestType:(RequestType)type
{
	self = [super init];
	
	if(!request) _err("No api request provided for request constructor. Aborting...");
	self.apiRequest = request;
	self->_requestType = type;
	
	return self;
error:
	return nil;
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
	@synchronized(self)
	{
		NSURL* apiUrl;
		NSMutableURLRequest* apiRequest;
		
		if(!path) _err("No path provided for base POST request creation. Aborting...");
		
		apiUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kAPIURL,path]];
		apiRequest = [NSMutableURLRequest requestWithURL:apiUrl];
		[apiRequest setHTTPMethod:@"POST"];
		[apiRequest setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
		[apiRequest setValue:[Stomt sharedInstance].appid forHTTPHeaderField:@"appid"];
		
		return apiRequest;
error:
	return nil;
	}
}

+ (NSMutableURLRequest*)generateBaseGETRequestWithPath:(NSString *)path
										parametersPair:(NSDictionary *)pPair
{
	@synchronized(self)
	{
		NSMutableString* paramString;
		NSMutableArray* keys;
		NSMutableArray* args;
		NSURL* apiUrl;
		NSMutableURLRequest* apiRequest;
		
		if(path && pPair)
		{
		paramString = [NSMutableString string];
		keys = [NSMutableArray array];
		args = [NSMutableArray array];
		[pPair enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
			[keys addObject:(NSString*)key];
			[args addObject:(NSString*)obj];
		}];
		for(int g_c = 0; g_c < [keys count]; g_c++)
		{
			if([[keys objectAtIndex:g_c] isEqualToString:[keys firstObject]]) //First Obj
			{
				[paramString appendString:[NSString stringWithFormat:@"?%@=%@",[keys objectAtIndex:g_c],[args objectAtIndex:g_c]]];
			}
			else
			{
				[paramString appendString:[NSString stringWithFormat:@"&%@=%@",[keys objectAtIndex:g_c],[args objectAtIndex:g_c]]];
			}
		}
		
		apiUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",kAPIURL,path,paramString]];
		apiRequest = [NSMutableURLRequest requestWithURL:apiUrl];
		[apiRequest setHTTPMethod:@"GET"];
		[apiRequest setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
		[apiRequest setValue:[Stomt sharedInstance].appid forHTTPHeaderField:@"appid"];
		
		return apiRequest;
		}_err("Invalid args for GET request creation. Aborting...");
		
error:
	return nil;
		
	}
}

+ (StomtRequest*)stomtCreationRequestWithStomtObject:(STObject *)stomtObject
{
	NSMutableURLRequest* apiRequest;
	NSError* jsonError;
	NSMutableDictionary* requestBody;
	NSData* jsonData;
	BOOL anonymous;
	
	if(!stomtObject) _err("No stomtObject found. Aborting...");
	if(!stomtObject.targetID) _err("Target id required! Aborting...");
	
	apiRequest = [StomtRequest generateBasePOSTRequestWithPath:kStomtCreationPath];
	anonymous = YES;
	
	if([Stomt sharedInstance].accessToken)
	{
		[apiRequest setValue:[Stomt sharedInstance].accessToken forHTTPHeaderField:@"accesstoken"];
		anonymous = NO;
	}
	
	requestBody = [NSMutableDictionary dictionary];
	
	[requestBody setObject:stomtObject.targetID forKey:@"target_id"];
	[requestBody setObject:[NSNumber numberWithBool:stomtObject.positive] forKey:@"positive"];
	[requestBody setObject:stomtObject.text forKey:@"text"];
	if(stomtObject.url) [requestBody setObject:[stomtObject.url absoluteString] forKey:@"url"];
	[requestBody setObject:[NSNumber numberWithBool:anonymous] forKey:@"anonymous"];
	if(stomtObject.image) [requestBody setObject:stomtObject.image.imageName forKey:@"img_name"];
	
	if(stomtObject.geoLocation) [requestBody setObject:[NSString stringWithFormat:@"%f,%f",stomtObject.geoLocation.coordinate.longitude,stomtObject.geoLocation.coordinate.latitude] forKey:@"lonlat"];
	
	jsonData = [NSJSONSerialization dataWithJSONObject:requestBody options:0 error:&jsonError];
	if(jsonError) _err("Error in generating JSON data. Aborting...");
	[apiRequest setHTTPBody:jsonData];
	return [[StomtRequest alloc] initWithApiRequest:apiRequest requestType:kStomtCreationRequest];
	
error:
	return nil;
}


+ (StomtRequest*)imageUploadRequestWithImage:(UIImage *)image
								 forTargetID:(NSString*)targetID
						   withImageCategory:(kSTImageCategory)category
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
	@synchronized(self)
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
}


+ (StomtRequest*)stomtRequestWithIdentifierOrURL:(NSString*)location
{
	if(location)
	{
		NSString* slug;
		NSMutableURLRequest* apiRequest;
		
		if([location hasPrefix:@"http://"]
		   || [location hasPrefix:@"https://"]
		   || [location hasPrefix:@"www."]
		   || [location hasPrefix:@"stomt.com"])
		{
			if([location hasPrefix:@"http://www.stomt.com"]
			   || [location hasPrefix:@"https://www.stomt.com"]
			   || [location hasPrefix:@"https://stomt.com"]
			   || [location hasPrefix:@"http://stomt.com"]
			   || [location hasPrefix:@"http://test.stomt.com"]
			   || [location hasPrefix:@"https://test.stomt.com"]
			   || [location hasPrefix:@"https://www.test.stomt.com"]
			   || [location hasPrefix:@"http://www.test.stomt.com"]
			   || [location hasPrefix:@"www.stomt.com"]
			   || [location hasPrefix:@"stomt.com"])
			{
				slug = [[location componentsSeparatedByString:@"/"] lastObject];
			}
			else _err("Not a stomt URL! Aborting...");
		}
		else //Slug
		{
			slug = location;
		}
		
		NSURL* requestPath = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kReadStomtPath,slug]];
		if(requestPath)
		{
			apiRequest = [StomtRequest generateBasePOSTRequestWithPath:[requestPath absoluteString]];
			apiRequest.HTTPMethod = @"GET";
			return [[StomtRequest alloc] initWithApiRequest:apiRequest requestType:kStomtRequest];
			
		}_err("Slug not valid, aborting...");
		
	}_err("No slug or URL found. Aborting...");
	
error:
	return nil;
}

+ (StomtRequest*)feedRequestWithStomtFeedObject:(STFeed*)feed
{
	NSMutableURLRequest* apiRequest;
	
	if(!feed) _err("No feed object provided. Aborting...");
	
	apiRequest = [StomtRequest generateBaseGETRequestWithPath:kSearchPath parametersPair:feed.params];
	
	return [[StomtRequest alloc] initWithApiRequest:apiRequest requestType:kFeedRequest];
	
error:
	return nil;
}

+ (StomtRequest*)targetRequestWithTargetID:(NSString *)targetID
{
	NSMutableURLRequest* apiRequest;
	
	if(!targetID) _err("No targetID provided. Aborting...");
	
	apiRequest = [StomtRequest generateBaseGETRequestWithPath:[NSString stringWithFormat:@"%@%@",kGetTargetPath,targetID] parametersPair:@{}];
	
	return [[StomtRequest alloc] initWithApiRequest:apiRequest requestType:kTargetRequest];
	
error:
	return nil;
}

+ (StomtRequest*)basicTargetRequestWithTargetID:(NSString *)targetID
{
	NSMutableURLRequest* apiRequest;
	
	if(!targetID) _err("No targetID provided. Aborting...");
	
	apiRequest = [StomtRequest generateBaseGETRequestWithPath:[NSString stringWithFormat:@"%@%@/%@",kGetBasicTargetPath,targetID,@"basic"] parametersPair:@{}];
	
	return [[StomtRequest alloc] initWithApiRequest:apiRequest requestType:kBasicTargetRequest];
	
error:
	return nil;
}


#pragma mark Send Requests

- (void)sendStomtInBackgroundWithBlock:(StomtCreationBlock)completion
{
	if(self.requestType == kStomtCreationRequest)
	{
		if(![Stomt sharedInstance].appid) _err("No AppID set. Aborting request...");
		
		[NSURLConnection sendAsynchronousRequest:self.apiRequest queue:[[NSOperationQueue alloc] init]
							   completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
		{
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
				if(completion) completion(connectionError,[STObject objectWithDataDictionary:dataDict]);
				
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
			else if(completion)
				completion(connectionError,nil);
		}];
		return;
	}fprintf(stderr,"\n[ERROR] Stomt creation request not available for this instance.");
	
error:
	return;
}


- (void)uploadImageInBackgroundWithBlock:(ImageUploadBlock)completion
{
	if(self.requestType == kImageUploadRequest){
		
		if(![Stomt sharedInstance].appid) _err("No AppID set. Aborting request...");
		
		[NSURLConnection sendAsynchronousRequest:self.apiRequest queue:[[NSOperationQueue alloc] init]
							   completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
		{
				if([HTTPResponseChecker checkResponseCode:response] == OK)
				{
					NSString* category;
					NSDictionary* rDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
					NSDictionary* basePath = [NSDictionary dictionaryWithDictionary:[[rDict objectForKey:@"data"] objectForKey:@"images"]];
					if([basePath objectForKey:@"avatar"]) category = [[basePath objectForKey:@"avatar"] objectForKey:@"name"];
					else if([basePath objectForKey:@"cover"]) category = [[basePath objectForKey:@"cover"] objectForKey:@"name"];
					else if([basePath objectForKey:@"stomt"]) category = [[basePath objectForKey:@"stomt"] objectForKey:@"name"];
					if(completion) completion(connectionError,[[STImage alloc] initWithStomtImageName:category]);
					
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
				else if(completion) completion(connectionError,nil);
		}];
		
		return;
	}fprintf(stderr,"\n[ERROR] Image upload request not available for this instance.");
	
error:
	return;
}

- (void)logoutInBackgroundWithBlock:(BooleanCompletion)completion
{
	if(self.requestType == kLogoutRequest)
	{
		if(![Stomt sharedInstance].appid) _err("No AppID set. Aborting request...");
		
		[NSURLConnection sendAsynchronousRequest:self.apiRequest queue:[[NSOperationQueue alloc] init]
							   completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
		{
			if([HTTPResponseChecker checkResponseCode:response] == OK)
			{
				_info("Logged out!");
				if(completion) completion(YES);
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
			else if(completion) completion(NO);
		}];
		return;
	}fprintf(stderr,"\n[ERROR] Image upload request not available for this instance.");
	
error:
	return;
}

- (void)requestStomtInBackgroundWithBlock:(StomtCreationBlock)completion
{
	if(self.requestType == kStomtRequest)
	{
		if(![Stomt sharedInstance].appid) _err("No AppID set. Aborting request...");
		
		[NSURLConnection sendAsynchronousRequest:self.apiRequest queue:[[NSOperationQueue alloc] init]
							   completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
		 {
			if([HTTPResponseChecker checkResponseCode:response] == OK)
			{
				NSDictionary* dataDict;
				
				if(data) dataDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
				if(dataDict)
				{
					STObject* stomtObj = [STObject objectWithDataDictionary:dataDict];
					if(completion) completion(connectionError,stomtObj);
					return;
				}
				_info("Could not retrieve data dictionary. Aborting...");
				return;
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
			else if(completion) completion(connectionError,nil);
		}];
		return;
	}fprintf(stderr,"\n[ERROR] Stomt request not available for this instance.");
error:
	return;
}

- (void)requestFeedInBackgroundWithBlock:(FeedRequestBlock)completion
{
	if(self.requestType == kFeedRequest)
	{
		if(![Stomt sharedInstance].appid) _err("No AppID set. Aborting request...");
		
		[NSURLConnection sendAsynchronousRequest:self.apiRequest queue:[[NSOperationQueue alloc] init]
							   completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
		{
			if([HTTPResponseChecker checkResponseCode:response] == OK)
			{
				NSDictionary* dataDict;
				if(data) dataDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
				if(dataDict)
				{
					STFeed* rtFeed = [STFeed feedWithStomtsArray:[dataDict objectForKey:@"data"]];
					if(completion) completion(connectionError,rtFeed);
					return;
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
			else if(completion) completion(connectionError,nil);
		}];
		return;
	}fprintf(stderr,"\n[ERROR] Feed request not available for this instance.");
error:
	return;
}

- (void)requestTargetInBackgroundWithBlock:(TargetRequestBlock)completion
{
	if(self.requestType == kTargetRequest)
	{
		if(![Stomt sharedInstance].appid) _err("No AppID set. Aborting request...");
		
		[NSURLConnection sendAsynchronousRequest:self.apiRequest queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
			
			if([HTTPResponseChecker checkResponseCode:response] == OK)
			{
				NSDictionary* dataDict;
				if(data) dataDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
				if(dataDict)
				{
					STTarget* target = [[STTarget alloc] initWithDataDictionary:[dataDict objectForKey:@"data"]];
		
					if(completion) completion(connectionError,target);
					return;
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
			else if(completion) completion(connectionError,nil);
		}];
		
		return;
	}fprintf(stderr,"\n[ERROR] Target request not available for this instance.");
	
error:
	return;
}

- (void)requestBasicTargetInBackgroundWithBlock:(TargetRequestBlock)completion
{
	if(self.requestType == kBasicTargetRequest)
	{
		if(![Stomt sharedInstance].appid) _err("No AppID set. Aborting request...");
		
		[NSURLConnection sendAsynchronousRequest:self.apiRequest queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
			
			if([HTTPResponseChecker checkResponseCode:response] == OK)
			{
				NSDictionary* dataDict;
				if(data) dataDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
				if(dataDict)
				{
					STTarget* target = [[STTarget alloc] initWithDataDictionary:[dataDict objectForKey:@"data"]];
					
					if(completion) completion(connectionError,target);
					return;
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
			else if(completion) completion(connectionError,nil);
		}];
		
		return;
	}fprintf(stderr,"\n[ERROR] Basic target request not available for this instance.");
	
error:
	return;
}
@end
