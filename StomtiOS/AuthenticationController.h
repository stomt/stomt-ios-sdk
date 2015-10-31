//
//  AuthenticationController.h
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 30/10/15.
//  Copyright © 2015 Leonardo Cascianelli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "block_declarations.h"

@import SafariServices;

@interface AuthenticationController : SFSafariViewController
- (instancetype)initWithAppID:(NSString *)appID redirectURI:(NSString *)redirectURI completionBlock:(AuthenticationBlock)completion;
- (BOOL)application:(UIApplication*)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
@end
