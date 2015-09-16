//
//  LoginView.m
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 10/09/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#import "LoginView.h"
#import "StomtRequest.h"
#import "STUser.h"

@interface LoginView ()
@property (strong,nonatomic) UITextField* userField;
@property (strong,nonatomic) UITextField* passField;
@property (strong,nonatomic) UIButton* sendButton;
- (void)login;
- (void)setup;
@end

@implementation LoginView

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	[self setup];
	return self;
}

- (void)setup
{
	self.backgroundColor = [UIColor lightGrayColor];
	
	CGRect userFieldRect = CGRectMake(0,0,kScreenWidth - kScreenWidth/5 ,40);
	self.userField = [[UITextField alloc] initWithFrame:userFieldRect];
	self.userField.backgroundColor = [UIColor whiteColor];
	self.userField.borderStyle = UITextBorderStyleRoundedRect;
	self.userField.placeholder = @"Username or Email";
	self.userField.center = CGPointMake(CGRectGetMidX(self.frame),kScreenHeight/6);
	
	CGRect passFieldRect = CGRectMake(0,0,kScreenWidth - kScreenWidth/5 ,40);
	self.passField = [[UITextField alloc] initWithFrame:passFieldRect];
	self.passField.backgroundColor = [UIColor whiteColor];
	self.passField.borderStyle = UITextBorderStyleRoundedRect;
	self.passField.placeholder = @"Password";
	self.passField.secureTextEntry = YES;
	self.passField.center = CGPointMake(CGRectGetMidX(self.frame),kScreenHeight/4);
	
	CGRect sendButtonRect = CGRectMake(0,0,(kScreenWidth - kScreenWidth/5)-10 ,50);
	self.sendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	self.sendButton.frame = sendButtonRect;
	self.sendButton.center = CGPointMake(CGRectGetMidX(self.frame),kScreenHeight/3);
	[self.sendButton setTitle:@"Login" forState:UIControlStateNormal];
	[self.sendButton addTarget:self
						action:@selector(login)
	   forControlEvents:UIControlEventTouchUpInside];
	
	
	[self addSubview:self.userField];
	[self addSubview:self.passField];
	[self addSubview:self.sendButton];
}

- (void)login
{
	StomtRequest* authRequest = [StomtRequest authenticationRequestWithEmailOrUser:[self.userField text] password:[self.passField text]];
	[authRequest autenticateInBackgroundWithBlock:^(NSError *error, STUser *user) {
		if(user){
			
			NSDictionary* retDict = @{@"Succeed":[NSNumber numberWithBool:YES]};
			[[NSNotificationCenter defaultCenter] postNotificationName:@"Dismiss-Login-Controller" object:nil userInfo:retDict];
		}
	}];
	
}

@end
