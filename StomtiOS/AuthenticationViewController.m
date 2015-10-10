//
//  AuthenticationViewController.m
//  OAuthStomt
//
//  Created by Leonardo Cascianelli on 10/10/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#import "AuthenticationViewController.h"
#import "AuthenticationView.h"

@interface AuthenticationViewController ()
@property (nonatomic,strong) NSString* appID;
@property (nonatomic,strong) NSString* uri;
- (void)simpleDismiss;
@end

@implementation AuthenticationViewController

- (instancetype)initWithAppID:(NSString*)appID redirectUri:(NSString*)uri
{
	self = [super init];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(simpleDismiss)];
	self.navigationItem.title = @"Stomt";
	self.appID = appID;
	self.uri = uri;
	return self;
}

- (void)loadView
{
	self.view = [[AuthenticationView alloc] initWithFrame:[UIScreen mainScreen].bounds appID:self.appID	redirectUri:self.uri];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[(AuthenticationView*)self.view entryPoint];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)simpleDismiss
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"Dismiss-OAuth" object:nil userInfo:nil];
}

@end
