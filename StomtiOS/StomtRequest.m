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
+ (NSMutableURLRequest*)generateBaseGETRequestWithPath:(NSString*)path parametersPair:(NSDictionary*)pPair;
- (instancetype)initWithApiRequest:(NSURLRequest*)request requestType:(RequestType)type;
@end

@implementation StomtRequest

#pragma mark Setup

- (instancetype)initWithApiRequest:(NSURLRequest*)request requestType:(RequestType)type
{
	self = [super init];
	self.apiRequest = request;
	self->_requestType = type;
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
	@synchronized(self)
	{
		NSURL* apiUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kAPIURL,path]];
		NSMutableURLRequest* apiRequest = [NSMutableURLRequest requestWithURL:apiUrl];
		[apiRequest setHTTPMethod:@"POST"];
		[apiRequest setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
		[apiRequest setValue:[Stomt sharedInstance].appid forHTTPHeaderField:@"appid"];
		return apiRequest;
	}
}

+ (NSMutableURLRequest*)generateBaseGETRequestWithPath:(NSString *)path parametersPair:(NSDictionary *)pPair
{
	@synchronized(self)
	{
		NSMutableString* paramString = [NSMutableString string];
		NSMutableArray* keys = [NSMutableArray array];
		NSMutableArray* args = [NSMutableArray array];
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
		
		NSURL* apiUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",kAPIURL,path,paramString]];
		NSMutableURLRequest* apiRequest = [NSMutableURLRequest requestWithURL:apiUrl];
		[apiRequest setHTTPMethod:@"GET"];
		[apiRequest setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
		[apiRequest setValue:[Stomt sharedInstance].appid forHTTPHeaderField:@"appid"];
		return apiRequest;
	}
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

+ (StomtRequest*)stomtCreationRequestWithStomtObject:(STObject *)stomtObject
{
	NSMutableURLRequest* apiRequest;
	NSError* jsonError;
	NSMutableDictionary* requestBody;
	NSData* jsonData;
	BOOL anonymous;
	
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
		
		if([location hasPrefix:@"http://"] || [location hasPrefix:@"https://"])
		{
			if([location hasPrefix:@"http://www.stomt.com"] || [location hasPrefix:@"https://www.stomt.com"])
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
	
	apiRequest = [StomtRequest generateBaseGETRequestWithPath:kSearchPath parametersPair:feed.params];
	if(!feed) _err("Feed object not provided. Aborting...");
	
	return [[StomtRequest alloc] initWithApiRequest:apiRequest requestType:kFeedRequest];
	
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

- (void)requestStomtInBackgroundWithBlock:(StomtCreationBlock)completion
{
	if(self.requestType == kStomtRequest)
	{
		[NSURLConnection sendAsynchronousRequest:self.apiRequest queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
			if([HTTPResponseChecker checkResponseCode:response] == OK)
			{
				NSDictionary* dataDict;
				
				if(data) dataDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
				if(dataDict)
				{
					STObject* stomtObj = [STObject objectWithDataDictionary:dataDict];
					completion(connectionError,stomtObj);
					return;
				}
				_info("Could not retrieve data dictionary. Aborting...");
				return;
			}
			else fprintf(stderr, "Some kind of error. Handle.");
		}];
		return;
	}
error:
	fprintf(stderr,"\n[ERROR] Stomt request not available for this instance.");
}

- (void)requestFeedInBackgroundWithBlock:(FeedRequestBlock)completion
{
	if(self.requestType == kFeedRequest)
	{
		[NSURLConnection sendAsynchronousRequest:self.apiRequest queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
			if([HTTPResponseChecker checkResponseCode:response] == OK)
			{
				NSDictionary* dataDict;
				if(data) dataDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
				if(dataDict)
				{
					STFeed* rtFeed = [STFeed feedWithStomtsArray:[dataDict objectForKey:@"data"]];
					completion(connectionError,rtFeed);
					return;
				}
			}
			else fprintf(stderr,"[!] Some kind of error. Handle.");
		}];
		return;
	}
error:
	fprintf(stderr,"\n[ERROR] Feed request not available for this instance.");
}

@end
