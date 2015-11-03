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
#import "StomtRequest.h"
#import "STUser.h"
#import "STCategory.h"
#import "STStats.h"
#import "STObject.h"
#import "STImage.h"
#import "STImageView.h"
#import "STFeed.h"
#import "STSearchFilterKeywords.h"
#import "STAuthenticationDelegate.h"

@class STUser;
@class STTarget;

/*!
 * @brief Handles connection to Stomt.
 */
@interface Stomt : NSObject

/*!
 * @brief The application ID.
 */
@property (nonatomic,strong) NSString* appid;

/*!
 * @brief The access token.
 */
@property (nonatomic,strong) NSString* accessToken;

/*!
 * @brief The refresh token, used to regenerate an access token.
 */
@property (nonatomic,strong) NSString* refreshToken;

/*!
 * @brief Is the user authenticated?
 * @warning Returns 'YES' even if anonymously authenticated.
 */
@property (nonatomic) BOOL isAuthenticated;

@property (nonatomic,strong) STUser* loggedUser;

+ (instancetype)sharedInstance;
+ (void)setAppID:(NSString *)appid;
- (void)setAccessToken:(NSString *)accessToken;

// Easy access
+ (NSString*)appID;
+ (NSString*)accessToken;
+ (NSString*)refreshToken;
+ (STUser*)loggedUser;

// Private
/// @warning Private usage only.
+ (void)setAPIHost:(NSString*)host;

/*!
 * @brief Prompts an authentication modal if no access token is present
 *
 * @param completion Completion block to be executed after login;
 */
+ (void)promptAuthenticationIfNecessaryWithCompletionBlock:(AuthenticationBlock)completion;

/*!
 * @brief Prompts an authentication modal if no access token is present
 *
 * @param delegate The delegate to be called when an event occurs.
 */
+ (void)promptAuthenticationIfNecessaryWithDelegate:(id<STAuthenticationDelegate>)delegate;

/*!
 * @brief Unused.
 */
+ (void)requestNewAccessTokenInBackgroundWithBlock:(BooleanCompletion)completion; //Unused!

/*!
 * @brief Logout the current user.
 */
+ (void)logout; //Only works with connection.

/*!
 * @brief Present a panel to let the user create and send a stomt.
 * @discussion A panel is presented with the specified target, default text, stomt qualifier
 and completion block.
 * 
 * @param target @see STTarget
 * @param defaultText The inial text of the stomt. Can be modified by the user.
 * @param likeOrWish Stomt qualifier.
 * @param completionBlock The completion handler to be called after the stomtCreation request.
 */
+ (void)presentStomtCreationPanelWithTarget:(STTarget*)target defaultText:(NSString*)defaultText likeOrWish:(kSTObjectQualifier)likeOrWish completionBlock:(StomtCreationBlock)completion;

/*!
 * @brief Present a panel to let the user create and send a stomt.
 * @discussion A panel is presented with the specified target, default text, stomt qualifier
 and completion block.
 *
 * @param targetID The identifier of the desired target.
 * @param defaultText The inial text of the stomt. Can be modified by the user.
 * @param likeOrWish Stomt qualifier.
 * @param completionBlock The completion handler to be called after the stomtCreation request.
 */
+ (void)presentStomtCreationPanelWithTargetID:(NSString*)targetID defaultText:(NSString*)defaultText likeOrWish:(kSTObjectQualifier)likeOrWish completionBlock:(StomtCreationBlock)completion;

- (BOOL)application:(UIApplication*)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

@end
