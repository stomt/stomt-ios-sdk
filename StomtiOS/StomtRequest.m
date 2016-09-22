
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

/* Private use only */
#define checkConnectionErrors(ERR,COMP) if(ERR && COMP) { COMP(ERR,nil); return; }\
if(ERR){\
	if([ERR localizedDescription])_warn("%s",[[ERR localizedDescription] UTF8String]);\
	if([ERR localizedFailureReason])_warn("%s",[[ERR localizedFailureReason] UTF8String]);\
	if([ERR localizedFailureReason])_warn("%s",[[ERR localizedRecoverySuggestion] UTF8String]);\
}

#define handleResponseErrors(ERRNO,DATA,COMP,...) if(ERRNO != OK){\
	NSError* err = [HTTPResponseChecker errorWithResponseCode:ERRNO withData:DATA];\
	if(COMP) { COMP(err,nil); }\
	if(err){\
		if([err localizedDescription])_warn("%s",[[err localizedDescription] UTF8String]);\
		if([err userInfo]){[[err userInfo] enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {_warn("%s: %s",[key UTF8String],[[NSString stringWithFormat:@"%@",obj] UTF8String]);}];}\
		if([err localizedFailureReason])_warn("%s",[[err localizedRecoverySuggestion] UTF8String]);\
		return;\
	} return;\
}
/* Private use only */

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
		
		apiUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[Stomt sharedInstance].apiURL,path]];
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
		
			NSString* apiString = [NSString stringWithFormat:@"%@%@%@",[Stomt sharedInstance].apiURL,path,paramString];
			apiUrl = [NSURL URLWithString:apiString];
		
		}
		
		if(!apiUrl) apiUrl = [NSURL URLWithString:path];
		apiRequest = [NSMutableURLRequest requestWithURL:apiUrl];
		[apiRequest setHTTPMethod:@"GET"];
		[apiRequest setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
		[apiRequest setValue:[Stomt sharedInstance].appid forHTTPHeaderField:@"appid"];
		
		return apiRequest;
		
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
	
	if([Stomt sharedInstance].isAuthenticated)
	{
		[apiRequest setValue:[Stomt sharedInstance].accessToken forHTTPHeaderField:@"accesstoken"];
		anonymous = NO;
	}
	
	requestBody = [NSMutableDictionary dictionary];
	
	[requestBody setObject:stomtObject.targetID forKey:@"target_id"];
	[requestBody setObject:[NSNumber numberWithBool:stomtObject.positive] forKey:@"positive"];
	[requestBody setObject:stomtObject.text forKey:@"text"];
	if(stomtObject.url) [requestBody setObject:[stomtObject.url absoluteString] forKey:@"url"];
	[requestBody setObject:[NSNumber numberWithBool:anonymous] forKey:@"anonym"];
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
	if(!imageCategoryStr) _err("Image category string not provided. Aborting...");
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
		[apiRequest setValue:[Stomt accessToken] forHTTPHeaderField:@"accesstoken"];
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
           || [location hasPrefix:@"stomt.com"]
           || [location hasPrefix:@"test.stomt.com"])
		{
			if([location hasPrefix:@"www.stomt.com"]
               || [location hasPrefix:@"http://www.stomt.com"]
               || [location hasPrefix:@"https://www.stomt.com"]
               || [location hasPrefix:@"stomt.com"]
			   || [location hasPrefix:@"http://stomt.com"]
			   || [location hasPrefix:@"https://stomt.com"]
               || [location hasPrefix:@"test.stomt.com"]
			   || [location hasPrefix:@"http://test.stomt.com"]
			   || [location hasPrefix:@"https://test.stomt.com"]
               || [location hasPrefix:@"www.test.stomt.com"]
			   || [location hasPrefix:@"http://www.test.stomt.com"]
			   || [location hasPrefix:@"https://www.test.stomt.com"])
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

+ (StomtRequest*)standardFeedRequestWithStomtFeedObject:(STFeed*)feed
{
	NSMutableURLRequest* apiRequest;
	
	NSString* path = ([feed.pathForStandardFeed isEqualToString:@"home"]) ? kHomeFeed : kDiscoverFeed;
	
	if(!feed) _err("No feed object provided. Aborting...");
	
	apiRequest = [StomtRequest generateBaseGETRequestWithPath:path parametersPair:feed.params];
	
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

+ (StomtRequest*)facebookAuthenticationRequestWithAccessToken:(NSString *)accessToken
{
	NSMutableURLRequest* apiRequest;
	NSMutableDictionary* dictBody;
	NSData* jsonData;
	NSError* error;
	
	if(accessToken)
	{
		apiRequest =  [StomtRequest generateBasePOSTRequestWithPath:kGeneralLoginPath];
		dictBody = [NSMutableDictionary dictionary];
		
		[dictBody setObject:@"facebook" forKey:@"login_method"];
		[dictBody setObject:accessToken forKey:@"accesstoken"];
		
		jsonData = [NSJSONSerialization dataWithJSONObject:dictBody options:0 error:&error];
		if(error) _err("Error while creating jsonData. Aborting...");
		
		[apiRequest setHTTPBody:jsonData];
		
		return [[StomtRequest alloc] initWithApiRequest:apiRequest requestType:kFacebookAuthenticationRequest];
		
	}_err("Missing paramenters. Aborting...");
	
error:
	return nil;
}

+ (StomtRequest*)availabilityRequestForUsername:(NSString *)username
{
	NSMutableURLRequest* apiRequest;
	if(!username) _err("No username given. Aborting...");
	
	apiRequest = [StomtRequest generateBaseGETRequestWithPath:kAvailabilityPath parametersPair:@{@"property":@"username",@"value":username}];
	
	return [[StomtRequest alloc] initWithApiRequest:apiRequest requestType:kAvailabilityRequest];
	
error:
	return nil;
}

+ (StomtRequest*)availabilityRequestForEmail:(NSString *)email
{
	NSMutableURLRequest* apiRequest;
	if(!email) _err("No email given. Aborting...");
	
	apiRequest = [StomtRequest generateBaseGETRequestWithPath:kAvailabilityPath parametersPair:@{@"property":@"email",@"value":email}];
	
	return [[StomtRequest alloc] initWithApiRequest:apiRequest requestType:kAvailabilityRequest];
	
error:
	return nil;
}


+ (StomtRequest*)externalLoginRequestForRoute:(kSTAuthenticationRoute)authenticationRoute withParameters:(NSDictionary *)parameters
{
	NSMutableURLRequest* apiRequest;
	
	NSString *accesstoken;
	NSString* login_method; //stomt backend convention
	
	//Temp --
	NSString* state;
	// --
	
	NSMutableDictionary* bodyDictionary;
	
	if(!parameters || !authenticationRoute) _err("Incorrect args for +[externalLoginRequestForRoute:withParameters:]. Aborting...");
	
	apiRequest = [StomtRequest generateBasePOSTRequestWithPath:kLoginPath];
	
	switch (authenticationRoute) {
		
		//Facebook ----
		case kSTAuthenticationRouteFacebook:
			@try {
				
				accesstoken = [parameters objectForKey:@"access_token"];
				login_method = @"facebook";
				
				state = [parameters objectForKey:@"state"];
				
				bodyDictionary = [NSMutableDictionary dictionaryWithDictionary:NSDictionaryOfVariableBindings(accesstoken,login_method,state)];
				
			}
			@catch (NSException *exception) {
				NSLog(@"Error in parsing dictionary. Aborting...");
				NSLog(@"%@",exception);
				_err("");
			}
			break;
			
		
	}
	
	if(bodyDictionary)
		[apiRequest setHTTPBody:[NSJSONSerialization dataWithJSONObject:bodyDictionary options:0 error:nil]];
	
	return [[StomtRequest alloc] initWithApiRequest:apiRequest requestType:kExternalAuthenticationRequest];
	
error:
	return nil;
}

+ (StomtRequest*)signupUserRequestWithName:(NSString *)displayname username:(NSString *)username email:(NSString *)email password:(NSString *)password
{
	NSMutableURLRequest* apiRequest;
	if(!displayname || !username || !email || !password) _err("Incorrect args. Aborting...");
	
	apiRequest = [StomtRequest generateBasePOSTRequestWithPath:kBasicRegisterPath];
	[apiRequest setHTTPBody:[NSJSONSerialization dataWithJSONObject:NSDictionaryOfVariableBindings(displayname,username,email,password) options:0 error:nil]];
	
	return [[StomtRequest alloc] initWithApiRequest:apiRequest requestType:kBasicSignupRequest];
	
error:
	return nil;
}

+ (StomtRequest*)loginRequestWithUsernameOrEmail:(NSString *)emailusername passsword:(NSString *)password
{
	NSMutableURLRequest* apiRequest;
	NSString* login_method = @"normal"; //stomt's conventions
	if(!emailusername || !password) _err("Incorrect args. Aborting...");
	
	apiRequest = [StomtRequest generateBasePOSTRequestWithPath:kGeneralLoginPath];
	[apiRequest setHTTPBody:[NSJSONSerialization dataWithJSONObject:NSDictionaryOfVariableBindings(emailusername,password,login_method) options:0 error:nil]];
	
	return [[StomtRequest alloc] initWithApiRequest:apiRequest requestType:kLoginRequest];
	
error:
	return nil;
}

+ (StomtRequest*)commentsRequestForStomtWithID:(NSString *)stomtID
{
	NSMutableURLRequest* apiRequest;
	NSString* path;
	if(!stomtID) _err("No stomtID given. Aborting...");
	
	path = [NSString stringWithFormat:@"%@/stomts/%@/comments",[Stomt sharedInstance].apiURL,stomtID];
	apiRequest = [StomtRequest generateBaseGETRequestWithPath:path parametersPair:nil];
	
	return [[StomtRequest alloc] initWithApiRequest:apiRequest requestType:kCommentsRequest];
	
error:
	return nil;
}

+ (StomtRequest*)commentCreationRequestWithStomtID:(NSString *)stomtID parentCommentID:(NSString *)parentID text:(NSString *)text reaction:(BOOL)reaction
{
	NSMutableURLRequest* apiRequest;
	NSString* path;
	
	NSString* parent_id = parentID;
	NSMutableDictionary* dict = [NSMutableDictionary dictionary];
	if(parent_id)[dict setObject:parent_id forKey:@"parent_id"];
	if(text)[dict setObject:text forKey:@"text"];
	if(reaction)[dict setObject:@(reaction) forKey:@"reaction"];
	
	if(!stomtID) _err("No stomtID given. Aborting...");
	if(!text) _err("No text given. Aborting...");
	
	path = [NSString stringWithFormat:@"/stomts/%@/comments",stomtID];
	apiRequest = [StomtRequest generateBasePOSTRequestWithPath:path];
	[apiRequest setValue:[Stomt sharedInstance].accessToken forHTTPHeaderField:@"accesstoken"];
	[apiRequest setHTTPBody:[NSJSONSerialization dataWithJSONObject:dict options:0 error:nil]];
	
	return [[StomtRequest alloc] initWithApiRequest:apiRequest requestType:kCommentCreationRequest];
	
error:
	return nil;
}

#pragma mark Send Requests

- (void)sendStomtInBackgroundWithBlock:(StomtCreationBlock)completion
{
	if(self.requestType == kStomtCreationRequest)
	{
		if(![Stomt sharedInstance].appid) _err("No AppID set. Aborting request...");
		
		[[[NSURLSession sharedSession] dataTaskWithRequest:self.apiRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable connectionError)
		 {
			 checkConnectionErrors(connectionError,completion);
			 handleResponseErrors([HTTPResponseChecker checkResponseCode:response], data, completion);
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
		}] resume];
		return;
	}fprintf(stderr,"\n[ERROR] Stomt creation request not available for this instance.");
	
error:
	return;
}


- (void)uploadImageInBackgroundWithBlock:(ImageUploadBlock)completion
{
	if(self.requestType == kImageUploadRequest){
		
		if(![Stomt sharedInstance].appid) _err("No AppID set. Aborting request...");
		
		[[[NSURLSession sharedSession] dataTaskWithRequest:self.apiRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable connectionError)
		 {
			checkConnectionErrors(connectionError,completion);
			handleResponseErrors([HTTPResponseChecker checkResponseCode:response], data, completion);
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
		}] resume];
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
		
		[[[NSURLSession sharedSession] dataTaskWithRequest:self.apiRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable connectionError)
		 {
			checkConnectionErrors(connectionError,completion);
			handleResponseErrors([HTTPResponseChecker checkResponseCode:response], data, completion);
			if([HTTPResponseChecker checkResponseCode:response] == OK)
			{
				_info("Logged out!");
				if(completion) completion(nil,[NSNumber numberWithBool:YES]);
			}
		}] resume];
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
		
		[[[NSURLSession sharedSession] dataTaskWithRequest:self.apiRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable connectionError)
		 {
			checkConnectionErrors(connectionError,completion);
			handleResponseErrors([HTTPResponseChecker checkResponseCode:response], data, completion);
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
		}] resume];
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
		
		[[[NSURLSession sharedSession] dataTaskWithRequest:self.apiRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable connectionError)
		 {
			checkConnectionErrors(connectionError,completion);
			handleResponseErrors([HTTPResponseChecker checkResponseCode:response], data, completion);
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
		}] resume];
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
		
		[[[NSURLSession sharedSession] dataTaskWithRequest:self.apiRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable connectionError)
		 {
			checkConnectionErrors(connectionError,completion);
			handleResponseErrors([HTTPResponseChecker checkResponseCode:response], data, completion);
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
		}] resume];
		
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
		
		[[[NSURLSession sharedSession] dataTaskWithRequest:self.apiRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable connectionError)
		 {
			checkConnectionErrors(connectionError,completion);
			handleResponseErrors([HTTPResponseChecker checkResponseCode:response], data, completion);
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
		}] resume];
		
		return;
	}fprintf(stderr,"\n[ERROR] Basic target request not available for this instance.");
	
error:
	return;
}

- (void)authenticateWithFacebookInBackgroundWithBlock:(AuthenticationBlock)completion
{
	if(self.requestType == kFacebookAuthenticationRequest)
	{
		if(![Stomt sharedInstance].appid) _err("No AppID set. Aborting request...");
		
		[[[NSURLSession sharedSession] dataTaskWithRequest:self.apiRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable connectionError)
		 {
			checkConnectionErrors(connectionError,completion);
			handleResponseErrors([HTTPResponseChecker checkResponseCode:response], data, completion);
			if([HTTPResponseChecker checkResponseCode:response] == OK)
			{
				NSDictionary* dataDict;
				if(data) dataDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
				if(dataDict)
				{
					NSError* error;
					STUser* user = [STUser initWithDataDictionary:[dataDict objectForKey:@"data"]];
					if(!user) error = [NSError errorWithDomain:@"Authentication error" code:0 userInfo:@{@"info":@"Could not instantiate an STUser."}];
					
					[Stomt sharedInstance].accessToken = user.accessToken;
					[Stomt sharedInstance].refreshToken = user.refreshToken;
					[[Stomt sharedInstance] setLoggedUser:user];
					
					if(completion) completion(error,user);
					return;
						
				}
			}
		}] resume];
		
		return;
		
	}_err("Authentication request not available for this instance.");
error:
	return;
}

- (void)requestUserCredentialsAvailabilityWithBlock:(UserAvailabilityBlock)completion
{
	if(self.requestType == kAvailabilityRequest)
	{
		if(![Stomt sharedInstance].appid) _err("No AppID set. Aborting request...");
		
		[[[NSURLSession sharedSession] dataTaskWithRequest:self.apiRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable connectionError)
		  {
			  checkConnectionErrors(connectionError,completion);
			  handleResponseErrors([HTTPResponseChecker checkResponseCode:response], data, completion);
			  if([HTTPResponseChecker checkResponseCode:response] == OK)
			  {
				  NSDictionary* dataDict;
				  if(data) dataDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
				  if(dataDict)
				  {
					  NSDictionary* rawDataDict = [dataDict objectForKey:@"data"];
					  NSNumber* success = [rawDataDict objectForKey:@"success"];
					  if(completion) completion(nil,success);
					  return;
				  }
			  }
		  }] resume];
		
		return;
		
	}_err("Availability request not available for this instance");

error:
	return;
}

- (void)authenticateWithExternalRouteWithBlock:(AuthenticationBlock)completion
{
	if(self.requestType == kExternalAuthenticationRequest)
	{
		if(![Stomt sharedInstance].appid) _err("No AppID set. Aborting request...");
		
		[[[NSURLSession sharedSession] dataTaskWithRequest:self.apiRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable connectionError)
		  {
			  checkConnectionErrors(connectionError,completion);
			  handleResponseErrors([HTTPResponseChecker checkResponseCode:response], data, completion);
			  if([HTTPResponseChecker checkResponseCode:response] == OK)
			  {
				  NSDictionary* dataDict;
				  if(data) dataDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
				  if(dataDict)
				  {
					  NSError* error;
					  STUser* user = [STUser initWithDataDictionary:[dataDict objectForKey:@"data"]];
					  if(!user) error = [NSError errorWithDomain:@"Authentication error" code:0 userInfo:@{@"info":@"Could not instantiate an STUser."}];
					  
					  [Stomt sharedInstance].accessToken = user.accessToken;
					  [Stomt sharedInstance].refreshToken = user.refreshToken;
					  [[Stomt sharedInstance] setLoggedUser:user];
					  
					  if(completion) completion(error,user);
					  return;
					  
				  }
			  }
		  }] resume];
		
		return;
		
	}_err("Authentication request not available for this instance.");
error:
	return;
}

- (void)registerInBackgroundWithBlock:(AuthenticationBlock)completion
{
	if(self.requestType == kBasicSignupRequest)
	{
		if(![Stomt sharedInstance].appid) _err("No AppID set. Aborting request...");
		
		[[[NSURLSession sharedSession] dataTaskWithRequest:self.apiRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable connectionError)
		  {
			  checkConnectionErrors(connectionError,completion);
			  handleResponseErrors([HTTPResponseChecker checkResponseCode:response], data, completion);
			  if([HTTPResponseChecker checkResponseCode:response] == OK)
			  {
				  NSDictionary* dataDict;
				  if(data) dataDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
				  if(dataDict)
				  {
					  NSError* error;
					  STUser* user = [STUser initWithDataDictionary:[dataDict objectForKey:@"data"]];
					  if(!user) error = [NSError errorWithDomain:@"Authentication error" code:0 userInfo:@{@"info":@"Could not instantiate an STUser."}];
					  
					  [Stomt sharedInstance].accessToken = user.accessToken;
					  [Stomt sharedInstance].refreshToken = user.refreshToken;
					  [[Stomt sharedInstance] setLoggedUser:user];
					  
					  if(completion) completion(error,user);
					  return;
					  
				  }
			  }
		  }] resume];
		
		return;
		
	}_err("Register request not available for this instance.");
error:
	return;
}

- (void)loginInBackgroundWithBlock:(AuthenticationBlock)completion
{
	if(self.requestType == kLoginRequest)
	{
		if(![Stomt sharedInstance].appid) _err("No AppID set. Aborting request...");
		
		[[[NSURLSession sharedSession] dataTaskWithRequest:self.apiRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable connectionError)
		  {
			  checkConnectionErrors(connectionError,completion);
			  handleResponseErrors([HTTPResponseChecker checkResponseCode:response], data, completion);
			  if([HTTPResponseChecker checkResponseCode:response] == OK)
			  {
				  NSDictionary* dataDict;
				  if(data) dataDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
				  if(dataDict)
				  {
					  NSError* error;
					  STUser* user = [STUser initWithDataDictionary:[dataDict objectForKey:@"data"]];
					  if(!user) error = [NSError errorWithDomain:@"Authentication error" code:0 userInfo:@{@"info":@"Could not instantiate an STUser."}];
					  
					  if(!error) _info("Logged in!");
					  
					  [Stomt sharedInstance].accessToken = user.accessToken;
					  [Stomt sharedInstance].refreshToken = user.refreshToken;
					  [[Stomt sharedInstance] setLoggedUser:user];
					  
					  if(completion) completion(error,user);
					  return;
					  
				  }
			  }
		  }] resume];
		
		return;
		
	}_err("Register request not available for this instance.");
error:
	return;
}

- (void)requestCommentsInBackgroundWithBlock:(CommentsRequestBlock)completion
{
	if(self.requestType == kCommentsRequest)
	{
		if(![Stomt sharedInstance].appid) _err("No AppID set. Aborting request...");
		
		[[[NSURLSession sharedSession] dataTaskWithRequest:self.apiRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable connectionError)
		  {
			  checkConnectionErrors(connectionError,completion);
			  handleResponseErrors([HTTPResponseChecker checkResponseCode:response], data, completion);
			  if([HTTPResponseChecker checkResponseCode:response] == OK)
			  {
				  NSDictionary* dataDict;
				  if(data) dataDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
				  if(dataDict)
				  {
					  NSArray* commentsArray = [dataDict objectForKey:@"data"];
					  if(completion)
						  completion(nil,commentsArray);
				  }
			  }
		  }] resume];
		
		return;
		
	}_err("Register request not available for this instance.");
error:
	return;
}

- (void)requestCommentCreationWithBlock:(CommentCreationBlock)completion
{
	if(self.requestType == kCommentCreationRequest)
	{
		if(![Stomt sharedInstance].appid) _err("No AppID set. Aborting request...");
		
		NSLog(@"%@", [Stomt accessToken]);
		[[[NSURLSession sharedSession] dataTaskWithRequest:self.apiRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable connectionError)
		  {
			  checkConnectionErrors(connectionError,completion);
			  handleResponseErrors([HTTPResponseChecker checkResponseCode:response], data, completion);
			  if([HTTPResponseChecker checkResponseCode:response] == OK)
			  {
				  NSDictionary* dataDict;
				  if(data) dataDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
				  if(dataDict)
				  {
					  STComment* comment = [STComment initWithDictionary:[dataDict objectForKey:@"data"]];
					  if(completion)
						  completion(nil,comment);
				  }
			  }
		  }] resume];
		
		return;
		
	}_err("Register request not available for this instance.");
error:
	return;
}
- (NSString*)description
{
	return [NSString stringWithFormat:@"<StomtRequest: %d>",self.requestType];
}

@end
