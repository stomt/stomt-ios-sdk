
//  AuthenticationViewController.m
//  OAuthStomt
//
//  Created by Leonardo Cascianelli on 10/10/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#import "ModalAuthenticationController.h"
#import "AuthenticationViewController.h"
#import "STUser.h"

@interface ModalAuthenticationController ()
@property (nonatomic,copy) AuthenticationBlock completion;
- (void)setup;
- (void)dismiss:(NSNotification*)notification;
@end

@implementation ModalAuthenticationController

- (instancetype)initWithAppID:(NSString*)appID redirectUri:(NSString*)uri completionBlock:(AuthenticationBlock)completion
{
	self = [super init];
	self.authViewController = [[AuthenticationViewController alloc] initWithAppID:appID redirectUri:uri];
	self.viewControllers = @[self.authViewController];
	self.completion = completion;
	[self setup];
	return self;
}

- (void)setup
{
	self.automaticallyAdjustsScrollViewInsets = NO;
	self.navigationBar.translucent = NO;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss:) name:@"Dismiss-OAuth" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dismiss:(NSNotification *)notification
{
	__block AuthenticationBlock authBlock = self.completion;
	
	[self dismissViewControllerAnimated:YES completion:^{
		NSDictionary* userInfo = [notification userInfo];
		if(!userInfo)
		{
			NSError* error = [[NSError alloc] initWithDomain:@"Authentication" code:0 userInfo:@{@"description":@"Authentication modal has been dismissed."}];
			authBlock(NO,error,nil);
		}
		else
		{
			NSError* error = [userInfo objectForKey:@"error"];
			STUser* user = [userInfo objectForKey:@"user"];
			BOOL rt = (!error && user) ? YES:NO;
			authBlock(rt,error,user);
		}
	}];
}

@end
