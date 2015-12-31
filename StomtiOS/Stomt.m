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
#import "STUser.h"
#import "STAuthenticationController.h"
#import "STAuthenticationDelegate.h"

@interface Stomt ()
@property (nonatomic,strong) STAuthenticationController* authController;
- (void)setup;
@end

@implementation Stomt

@synthesize loggedUser;

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
	kAPIURL = @"https://rest.stomt.com";
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
	if(![Stomt accessToken])
	{
		if([Stomt sharedInstance].authController) [Stomt sharedInstance].authController = nil;
		
		[Stomt sharedInstance].authController = [[STAuthenticationController alloc] initWithAppID:[Stomt appID] redirectURI:@"stomtAPI://" completionBlock:^(NSError *error, STUser *user) {
			if(user)
			{
				[[Stomt sharedInstance] setAccessToken:user.accessToken];
				[[Stomt sharedInstance] setRefreshToken:user.refreshToken];
				if(user) [[Stomt sharedInstance] setLoggedUser:user];
			}if(completion) completion(error,user);
		}];
		[[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:[Stomt sharedInstance].authController animated:YES completion:nil];
	}
	else _info("Already logged in. Continuing execution...");
	return;
	
error:
	return;
}

+ (void)promptAuthenticationIfNecessaryWithDelegate:(id<STAuthenticationDelegate>)delegate
{
	if(![Stomt appID]) _err("No AppID set. Aborting authentication modal presentation...");
	if(![Stomt accessToken])
	{
		if([Stomt sharedInstance].authController) [Stomt sharedInstance].authController = nil;
		
		[Stomt sharedInstance].authController = [[STAuthenticationController alloc] initWithAppID:[Stomt appID] redirectURI:@"stomtAPI://" completionBlock:^(NSError *error, STUser *user) {
			if(user)
			{
				[[Stomt sharedInstance] setAccessToken:user.accessToken];
				[[Stomt sharedInstance] setRefreshToken:user.refreshToken];
				if(user) [[Stomt sharedInstance] setLoggedUser:user];
			}
		}];
		[Stomt sharedInstance].authController.privDelegate = delegate;
		[[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:[Stomt sharedInstance].authController animated:YES completion:nil];
		
	}else _info("Already logged in. Continuing execution...");
	return;
error:
	return;
}

+ (void)logout
{
	if(![Stomt sharedInstance].appid) _err("No AppID set. Aborting logout...");
	
	@synchronized(self)
	{
		// logout on server side
		StomtRequest* logoutRequest = [StomtRequest logoutRequest];
		[logoutRequest logoutInBackgroundWithBlock:^(NSError *error, NSNumber *succeeded) {
			if(error) NSLog(@"%@",error);
		}];
		
        // logout on client side
        [Stomt sharedInstance].accessToken = nil;
        [Stomt sharedInstance].refreshToken = nil;
		[Stomt sharedInstance].loggedUser = nil;
		

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
		_warn("METHOD NOT AVAILABLE!");
		return;
	}
error:
	_warn("Requesting new token without logging in first!");
}
// NOT YET IMPLEMENTED -----------

#pragma mark Private
+ (void)setAPIHost:(NSString *)host
{
	kAPIURL = host;
}

- (void)setLoggedUser:(STUser *)user
{
	NSData *usr = [NSKeyedArchiver archivedDataWithRootObject:user];
	[[NSUserDefaults standardUserDefaults] setObject:usr forKey:kCurrentUser];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (STUser*)loggedUser
{
	if(!loggedUser)
	{
		NSData *extUser = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentUser];
		STUser *usr = [NSKeyedUnarchiver unarchiveObjectWithData:extUser];
		if(usr)
		{
			loggedUser = usr;
		}
	}
	return loggedUser;
}

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

+ (STUser*)loggedUser //Easy access to the authenticated user. (Not anonymous!)
{
	return [Stomt sharedInstance].loggedUser;
}

+ (BOOL)isAuthenticated //Easy access isAuthenticated from class
{
	return [Stomt sharedInstance].isAuthenticated;
}

#pragma mark Private accessors

- (void)setAccessToken:(NSString *)accessToken
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

- (BOOL)isAuthenticated
{
	return ([Stomt accessToken] != nil);
}

#pragma mark UI

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

- (BOOL)application:(UIApplication*)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
	if(self.authController)
	{
		return [self.authController application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
	}_err("No authentication controller set. Aborting...");
	
error:
	return NO;
}

@end
