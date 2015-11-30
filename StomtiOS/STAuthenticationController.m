//
//  AuthenticationController.m
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 30/10/15.
//  Copyright © 2015 Leonardo Cascianelli. All rights reserved.
//

#define __DBG__

#import "STAuthenticationController.h"
#import "block_declarations.h"
#import "strings.h"
#import "HTTPResponseChecker.h"
#import "STUser.h"
#import "dbg.h"
#import "STAuthenticationDelegate.h"

@interface STAuthenticationController ()
@property (nonatomic,strong) NSString* clientID;
@property (nonatomic,strong) NSString* authorizationCode;
@property (nonatomic,strong) NSString* authorizationState;
@property (nonatomic,strong) AuthenticationBlock completion;
- (void)authenticate;
- (void)prepareToDismiss:(NSData*)data response:(NSURLResponse*)response error:(NSError*)error;
- (NSDictionary*)evaluateResult:(NSData*)data response:(NSURLResponse*)response error:(NSError*)error;
- (void)gracefullyDismiss:(NSDictionary*)retDict;
@end

@implementation STAuthenticationController

- (instancetype)init
{
	_err("Use designed initialize. Aborting...");
	
error:
	return nil;
}

- (instancetype)initWithAppID:(NSString *)appID redirectURI:(NSString *)redirectURI completionBlock:(AuthenticationBlock)completion
{
	NSURL* authorizationURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@",[NSString stringWithFormat:@"%@%@",kAPIURL,kAuthorizePath],appID,redirectURI]];
	
	self = [super initWithURL:authorizationURL];
	if(self)
	{
		self.clientID = appID;
		self.completion = completion;
		return self;
	}_err("Could not instantiate class. Aborting...");
	
error:
	return nil;
}

- (BOOL)application:(UIApplication*)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
	NSArray* respArray = [((NSString*)[[[url absoluteString] componentsSeparatedByString:@"?"] lastObject]) componentsSeparatedByString:@"&"];
	NSMutableArray* tempArray = [NSMutableArray array];
	
	for(NSString* aggregate in respArray)
	{
		tempArray = [NSMutableArray arrayWithArray:[(NSString*)aggregate componentsSeparatedByString:@"="]];
		if([[tempArray firstObject] isEqualToString:@"code"])
			self.authorizationCode = [tempArray lastObject];
		if([[tempArray firstObject] isEqualToString:@"state"])
			self.authorizationState = [tempArray lastObject];
	}
	
	[self authenticate];
	
	return YES;
error:
	return NO;
}

- (void)authenticate
{
	if(self.authorizationCode && self.authorizationState)
	{
		NSURLSession *session = [NSURLSession sharedSession];
		NSMutableDictionary* bodyDict;
		NSError* error;
		NSMutableURLRequest* apiRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kAPIURL,kLoginPath]]];
		
		[apiRequest setHTTPMethod:@"POST"];
		[apiRequest setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
		[apiRequest setValue:self.clientID forHTTPHeaderField:@"appid"];
		bodyDict = [NSMutableDictionary dictionary];
		[bodyDict setObject:self.authorizationCode forKey:@"code"];
		[bodyDict setObject:self.authorizationState forKey:@"state"];
		[apiRequest setHTTPBody:[NSJSONSerialization dataWithJSONObject:bodyDict options:0 error:&error]];
		if(error) _err("Json parse error.");
		
		[[session dataTaskWithRequest:apiRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
			[self prepareToDismiss:data response:response error:error];
		}] resume];
		
		return;
	}_err("Authorization error. Aborting...");
error:
	return;
}

- (void)prepareToDismiss:(NSData *)data response:(NSURLResponse *)response error:(NSError *)error
{
	if(data)
	{
		NSDictionary* rtDict = [NSDictionary dictionaryWithDictionary:[self evaluateResult:data response:response error:error]];
		if([rtDict objectForKey:@"user"])
		{
			[self gracefullyDismiss:rtDict];
			return;
		}_err("Data evaluation error. Aborting...");
	}_err("Could not retrieve data. Aborting...");
error:
	return;
}

- (NSDictionary*)evaluateResult:(NSData*)data response:(NSURLResponse*)response error:(NSError*)error
{
	NSError* jsonError;
	NSDictionary* dataDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
	NSMutableDictionary* rtDict;
	if(jsonError) _err("Error in creating JSON, malformed response. Aborting...");
	

	rtDict = [NSMutableDictionary dictionary];
	[rtDict setObject:[NSNumber numberWithBool:YES] forKey:@"success"];
	[rtDict setObject:[NSNull null] forKey:@"error"];
	if([[dataDict objectForKey:@"data"] count]) [rtDict setObject:[STUser initWithDataDictionary:[dataDict objectForKey:@"data"]] forKey:@"user"];
	if(data) [rtDict setObject:data forKey:@"data"];
	[rtDict setObject:response forKey:@"response"];
	
	return rtDict;
	
error:
	return nil;
}

- (void)gracefullyDismiss:(NSDictionary*)retDict
{
	BOOL succeeded = [[retDict objectForKey:@"success"] boolValue];
	NSError* error = [retDict objectForKey:@"error"];
	STUser* user = [retDict objectForKey:@"user"];
	NSData* data = [retDict objectForKey:@"data"];
	NSURLResponse* response = [retDict objectForKey:@"response"];
	
	if(self.completion){ self.completion(succeeded,error,user); }
	if(self.privDelegate)
	{
		if(succeeded){ if([self.privDelegate respondsToSelector:@selector(authenticationController:successfullyLoggedInWithUser:)]){
			[self.privDelegate authenticationController:self successfullyLoggedInWithUser:user];
		}}
		else
		{
			if([self.privDelegate respondsToSelector:@selector(authenticationController:loginFailedWithResponse:receivedData:error:)])
			{
				[self.privDelegate authenticationController:self loginFailedWithResponse:response receivedData:data error:error];
			}
		}
	}
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
