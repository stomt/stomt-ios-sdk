//
//  AuthenticationViewController.h
//  OAuthStomt
//
//  Created by Leonardo Cascianelli on 10/10/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuthenticationViewController : UIViewController
- (instancetype)initWithAppID:(NSString*)appID redirectUri:(NSString*)uri;
@end
