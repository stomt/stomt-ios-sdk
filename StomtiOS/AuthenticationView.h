//
//  AuthenticationView.h
//  OAuthStomt
//
//  Created by Leonardo Cascianelli on 10/10/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "strings.h"
#import "dbg.h"

@interface AuthenticationView : UIView
- (instancetype)initWithFrame:(CGRect)frame appID:(NSString*)appID redirectUri:(NSString*)uri;
- (void)entryPoint;
@end
