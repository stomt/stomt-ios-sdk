//
//  AuthenticationView.m
//  OAuthStomt
//
//  Created by Leonardo Cascianelli on 10/10/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#define authorizeURL @"https://test.rest.stomt.com/authentication/authorize"

#import "AuthenticationView.h"
#import "STUser.h"

@interface AuthenticationView () <UIWebViewDelegate,NSURLConnectionDataDelegate>
@property (nonatomic,strong) UIWebView* webView;
@property (nonatomic,strong) NSString* clientID;
@property (nonatomic,strong) NSString* redirectUri;
@property (nonatomic,strong) NSString* authorizationCode;
@property (nonatomic,strong) NSString* state;
@property (nonatomic,strong) NSString* accessToken;
@property (nonatomic,strong) NSMutableData* finalData;
- (void)setup;
- (void)authorize;
- (void)authenticate;
@end

@implementation AuthenticationView

- (instancetype)initWithFrame:(CGRect)frame appID:(NSString*)appID redirectUri:(NSString*)uri
{
	self = [super initWithFrame:frame];
	
	self.clientID = appID;
	self.redirectUri = uri;
	self.backgroundColor = [UIColor whiteColor];
	[self setup];
	
	return self;
}

- (void)setup
{
	if(!self.webView)
	{
		self.webView = [[UIWebView alloc] initWithFrame:self.bounds];
		self.webView.delegate = self;
		[self addSubview:self.webView];
	}
}

- (void)entryPoint
{
	if(self.clientID)
		[self authorize];
	else
		_err("No AppID found. Aborting authentication");
error:
	return;
}

- (void)authorize
{
	NSURL* authorizationURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@",authorizeURL,self.clientID,self.redirectUri]];
	[self.webView loadRequest:[NSURLRequest requestWithURL:authorizationURL]];
}

- (void)authenticate
{
	NSError* error;
	
	if(self.authorizationCode && self.state)
	{
		NSURL* apiUrl;
		NSMutableURLRequest* apiRequest;
		NSMutableDictionary* bodyDict;
		NSURLConnection* conn;
		
		apiUrl = [NSURL URLWithString:kLoginPath];
		apiRequest = [NSMutableURLRequest requestWithURL:apiUrl];
		[apiRequest setHTTPMethod:@"POST"];
		[apiRequest setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
		[apiRequest setValue:self.clientID forHTTPHeaderField:@"appid"];
		bodyDict = [NSMutableDictionary dictionary];
		[bodyDict setObject:self.authorizationCode forKey:@"code"];
		[bodyDict setObject:self.state forKey:@"state"];
		[apiRequest setHTTPBody:[NSJSONSerialization dataWithJSONObject:bodyDict options:0 error:&error]];
		if(error) goto error;
		
		conn = [[NSURLConnection alloc] initWithRequest:apiRequest delegate:self];
		[conn start];
		
		return;
		
	}fprintf(stderr, "App authotization failed. Aborting authentication.");
	
	error = [[NSError alloc] initWithDomain:@"Authorization" code:401 userInfo:@{@"description":@"Authorizaion of the application failed. Check appID."}];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"Dismiss-OAuth" object:nil userInfo:@{@"error":error}];
	
error:
	return;
}


#pragma mark Delegates

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSError* error;
	NSDictionary* dataDict = [NSJSONSerialization JSONObjectWithData:self.finalData options:0 error:&error];
	if(!error)
	{
		STUser* user = [STUser initWithDataDictionary:[dataDict objectForKey:@"data"]];
		if(user)
			[[NSNotificationCenter defaultCenter] postNotificationName:@"Dismiss-OAuth" object:nil userInfo:@{@"user":user}];
		else
		{
			NSError* error = [[NSError alloc] initWithDomain:@"Authentication" code:401 userInfo:@{@"description":@"Authentication failed. Check credentials."}];
			[[NSNotificationCenter defaultCenter] postNotificationName:@"Dismiss-OAuth" object:nil userInfo:@{@"error":error}];
		}_err("Authentication failed");
		
		return;
	}
	else
	{
		NSError* error = [[NSError alloc] initWithDomain:@"JSON" code:0 userInfo:@{@"description":@"Error in parsing JSON response."}];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"Dismiss-OAuth" object:nil userInfo:@{@"error":error}];
	}_err("Error in parsing JSON.");
	
error:
	return;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	if(!self.finalData)
		self.finalData = [[NSMutableData alloc] init];
	[self.finalData appendData:data];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	if([[[request URL] host] isEqualToString:@"localhost"])
	{
		NSArray* respArray = [[[request URL] query] componentsSeparatedByString:@"&"];
		NSMutableArray* queryArray;
		for(NSString* queryElem in respArray)
		{
			queryArray = [NSMutableArray arrayWithArray:[queryElem componentsSeparatedByString:@"="]];
			if([[queryArray objectAtIndex:0] isEqualToString:@"code"])
			{
				self.authorizationCode = [queryArray lastObject];
			}
			else if([[queryArray objectAtIndex:0] isEqualToString:@"state"])
			{
				self.state = [queryArray lastObject];
			}
			
			queryArray = nil;
		}
		
		[self authenticate];
		return NO;
	}
	return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Connection error" message:@"There was an error while connecting to the stomt's servers." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
	[alertView show];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"Dismiss-OAuth" object:nil userInfo:nil];
	_err("Error %s",[[error localizedDescription] UTF8String]);
error:
	return;
}
@end
