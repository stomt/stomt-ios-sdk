//
//  Stomt.m
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 10/09/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#define __DBG__

#import "Stomt.h"
#import "StomtRequest.h"
#import "dbg.h"
#import "declarations.h"
#import "strings.h"
#import "STCreationViewController.h"
#import "STTarget.h"
#import "ModalAuthenticationController.h"
#import "STUser.h"

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
error:
	return;
}

#pragma mark Authentication Related

+ (void)promptAuthenticationIfNecessaryWithCompletionBlock:(AuthenticationBlock)completion
{
	if(![Stomt appID]) _err("No AppID set. Aborting authentication modal presentation...");
	
	if(![[NSUserDefaults standardUserDefaults] objectForKey:kToken])
	{
		ModalAuthenticationController* modal = [[ModalAuthenticationController alloc] initWithAppID:[Stomt appID] redirectUri:@"http://localhost" completionBlock:^(BOOL succeeded, NSError *error, STUser *user) {
			if(succeeded)
			{
				[Stomt sharedInstance].accessToken = user.accessToken;
				[Stomt sharedInstance].refreshToken = user.refreshToken;
			}completion(succeeded,error,user);
		}];
		[[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:modal animated:YES completion:nil];
	}
	else _info("Already logged in. Continuing execution...");
	return;
	
error:
	return;
}

+ (void)logout
{
	if(![Stomt sharedInstance].appid) _err("No AppID set. Aborting logout...");
	
	@synchronized(self)
	{
        // logout on client side
        [Stomt sharedInstance].accessToken = nil;
        [Stomt sharedInstance].refreshToken = nil;
        
        // logout on server side
		StomtRequest* logoutRequest = [StomtRequest logoutRequest];
		[logoutRequest logoutInBackgroundWithBlock:nil];
	}
	
error:
	return;
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
	return [Stomt sharedInstance].accessToken != nil;
}

+ (void)setAccessToken:(NSString *)accessToken
{
	@synchronized(self)
	{
		[[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:kToken];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}

- (NSString*)accessToken
{
	return [[NSUserDefaults standardUserDefaults] objectForKey:kToken];
}

- (void)setRefreshToken:(NSString *)refreshToken
{
	@synchronized(self)
	{
		[[NSUserDefaults standardUserDefaults] setObject:refreshToken forKey:kRToken];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}

- (NSString*)refreshToken
{
	return [[NSUserDefaults standardUserDefaults] objectForKey:kRToken];
}

+ (void)presentStomtCreationPanelWithTarget:(STTarget*)target defaultText:(NSString*)defaultText likeOrWish:(kSTObjectQualifier)likeOrWish completionBlock:(StomtCreationBlock)completion
{
	@synchronized(self)
	{
		STCreationViewController* cont;
		
		if(![Stomt sharedInstance].appid) _err("No AppID set. Aborting stomt creation modal presentation...");
		
		cont = [[STCreationViewController alloc] initWithBody:defaultText
																			 likeOrWish:likeOrWish
																				 target:target
																		completionBlock:completion];
		[[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:cont
																					 animated:YES
																				   completion:nil];
error:
	return;
		
	}
}

+ (void)presentStomtCreationPanelWithTargetID:(NSString*)targetID defaultText:(NSString*)defaultText likeOrWish:(kSTObjectQualifier)likeOrWish completionBlock:(StomtCreationBlock)completion
{
	@synchronized(self)
	{
		STTarget* target = [[STTarget alloc] init];
		target.identifier = targetID;
		[Stomt presentStomtCreationPanelWithTarget:target defaultText:defaultText likeOrWish:likeOrWish completionBlock:completion];
	}
}
@end
