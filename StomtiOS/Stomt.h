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

/*!
 @brief Handles connection to Stomt.
 */
@interface Stomt : NSObject

/// The application ID.
@property (nonatomic,strong) NSString* appid;

/// The access token.
@property (nonatomic,strong) NSString* accessToken;

/// The refresh token, used to regenerate an access token.
@property (nonatomic,strong) NSString* refreshToken;

/// Is the user authenticated?
@property (nonatomic) BOOL isAuthenticated;

+ (instancetype)sharedInstance;
+ (void)setAppID:(NSString *)appid;

// Easy access
+ (NSString*)appID;
+ (NSString*)accessToken;
+ (NSString*)refreshToken;

/*!
 
 @brief Prompts an authentication modal if no access token is present
 @param completion Completion block to be executed after login;
 
 */
+ (void)promptAuthenticationIfNecessaryWithCompletionBlock:(BooleanCompletion)completion;
/*!
 
 @brief Unused.
 
 */
+ (void)requestNewAccessTokenInBackgroundWithBlock:(BooleanCompletion)completion; //Unused!
/*!
 
 @brief Logout the current user.
 
 */
+ (void)logout; //Only works with connection.
@end
