//
//  STAuthenticationManager.h
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 22/10/16.
//  Copyright © 2016 Leonardo Cascianelli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "block_declarations.h"

@import SafariServices;

@interface STAuthenticationManager : NSObject
@property (nonatomic,strong) SFSafariViewController* safariViewController;
@property (nonatomic,strong) id privDelegate;
- (instancetype)initWithAppID:(NSString *)appID redirectURI:(NSString *)redirectURI completionBlock:(AuthenticationBlock)completion;
- (BOOL)application:(id)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
- (void)presentAvailableAuthenticationRoute;
@end
