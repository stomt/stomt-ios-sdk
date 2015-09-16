//
//  LoginViewController.m
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 10/09/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginView.h"

@interface LoginViewController()
- (void)setup;
- (void)dismiss:(NSNotification*)notification;
- (void)simpleDismiss;
@end

@implementation LoginViewController

- (instancetype)init
{
	self = [super init];
	[self setup];
	return self;
}

- (void)setup
{
	//Setup
	UIViewController* mainController = [[UIViewController alloc] init];
	mainController.view = [[LoginView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	mainController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(simpleDismiss)];
	self.viewControllers = @[mainController];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss:) name:@"Dismiss-Login-Controller" object:nil];
	
}

- (void)dismiss:(NSNotification*)notification
{
	if(self.completionBlock)
	{
		NSDictionary* userInfo = [notification userInfo];
		__block BOOL rt = [[userInfo objectForKey:@"Succeed"] boolValue];
		self.completionBlock(rt);
	}
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)simpleDismiss
{
	NSDictionary* retDict = @{@"Succeed":[NSNumber numberWithBool:NO]};
	[[NSNotificationCenter defaultCenter] postNotificationName:@"Dismiss-Login-Controller" object:nil userInfo:retDict];
}
@end
