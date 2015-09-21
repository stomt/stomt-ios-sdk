//
//  Stomt.h
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 10/09/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "block_declarations.h"

@class STUser;

@interface Stomt : NSObject
@property (nonatomic,strong) NSString* appid;
@property (nonatomic,strong) NSString* accessToken;
@property (nonatomic,strong) NSString* refreshToken;
@property (nonatomic) BOOL isAuthenticated;
+ (instancetype)sharedInstance;
+ (void)setAppID:(NSString *)appid;

// Easy access
+ (NSString*)appID;
+ (NSString*)accessToken;
+ (NSString*)refreshToken;

+ (void)promptAuthenticationIfNecessaryWithCompletionBlock:(BooleanCompletion)completion;
+ (void)requestNewAccessTokenInBackgroundWithBlock:(BooleanCompletion)completion; //Unused!
+ (void)logout; //Only works with connection.
@end
