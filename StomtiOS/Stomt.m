//
//  Stomt.m
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 10/09/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#define __DBG__

#import "Stomt.h"
#import "LoginViewController.h"
#import "dbg.h"
#import "declarations.h"
#import "strings.h"

@interface Stomt ()
- (void)setup;
@end

@implementation Stomt

#pragma mark Setup

+ (instancetype)sharedInstance
{
	static Stomt* privateInstance = nil;
	if(!privateInstance)
	{
		privateInstance = [[Stomt alloc] init];
		[privateInstance setup];
	}
	return privateInstance;
}

- (void)setup
{
	//SETUP
}

+ (void)setAppID:(NSString *)appid
{
	if(!appid) _err("No appid. Aborting...");
	[Stomt sharedInstance].appid = appid;
	if([Stomt sharedInstance].accessToken && [Stomt sharedInstance].refreshToken) [Stomt sharedInstance].isAuthenticated = YES;
error:
	return;
}

#pragma mark Authentication Related

+ (void)promptAuthenticationIfNecessaryWithCompletionBlock:(BooleanCompletion)completion
{
	if(![[NSUserDefaults standardUserDefaults] objectForKey:kToken])
	{
		LoginViewController* controllerToPresent = [[LoginViewController alloc] init];
		controllerToPresent.completionBlock = completion;
		[[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:controllerToPresent animated:YES completion:nil];
	}
	else _info("Already logged in. Continuing execution...");

	return;
	
error:
	return;
}

+ (void)logout
{
	[Stomt sharedInstance].accessToken = nil;
	[Stomt sharedInstance].refreshToken = nil;
	[Stomt sharedInstance].isAuthenticated = NO;
}

#pragma mark TODO

// NOT YET IMPLEMENTED -----------
+ (void)requestNewAccessTokenInBackgroundWithBlock:(BooleanCompletion)completion
{
	NSString* access = [Stomt sharedInstance].accessToken;
	NSString* refresh = [Stomt sharedInstance].refreshToken;
	if(access && refresh)
	{
		//Magic not available.
		return;
	}
error:
	_warn("Requesting new token without logging in first!");
}
// NOT YET IMPLEMENTED -----------

#pragma mark Accessory

+ (NSString*)appID //Easy access appid from class
{
	return [Stomt sharedInstance].appid;
}

+ (NSString*)accessToken //Easy access accessToken from class
{
	return [Stomt sharedInstance].accessToken;
}

+ (NSString*)refreshToken //Easy access refreshToken from class
{
	return [Stomt sharedInstance].refreshToken;
}

+ (BOOL)isAuthenticated //Easy access isAuthenticated from class
{
	return [Stomt sharedInstance].isAuthenticated;
}

- (void)setAccessToken:(NSString *)accessToken
{
	[[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:kToken];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString*)accessToken
{
	return [[NSUserDefaults standardUserDefaults] objectForKey:kToken];
}

- (void)setRefreshToken:(NSString *)refreshToken
{
	[[NSUserDefaults standardUserDefaults] setObject:refreshToken forKey:kRToken];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString*)refreshToken
{
	return [[NSUserDefaults standardUserDefaults] objectForKey:kRToken];
}




@end
