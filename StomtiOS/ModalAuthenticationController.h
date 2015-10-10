//
//  AuthenticationViewController.h
//  OAuthStomt
//
//  Created by Leonardo Cascianelli on 10/10/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "block_declarations.h"

@class AuthenticationViewController;

@interface ModalAuthenticationController : UINavigationController
@property (nonatomic,strong) AuthenticationViewController* authViewController;
- (instancetype)initWithAppID:(NSString*)appID redirectUri:(NSString*)uri completionBlock:(AuthenticationBlock)completion;
@end
