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
#import "AuthenticationDispatch.h"
#import "TempLikeWishView.h"
#import "NSDate+ISO8601.h"
#import "STImagePoolDelegate.h"
#import "STComment.h"

@class STUser;
@class STTarget;

/*!
 * @brief Handles connection to Stomt.
 */
@interface Stomt : NSObject

/*!
 * @brief The application ID.
 */
@property (nonatomic,strong,nullable) NSString* appid;

@property (nonatomic,strong,nullable) NSString* apiURL;

/*!
 * @brief The access token.
 */
@property (nonatomic,strong,nullable) NSString* accessToken;

/*!
 * @brief The refresh token, used to regenerate an access token.
 */
@property (nonatomic,strong,nullable) NSString* refreshToken;

/*!
 * @brief Is the user authenticated?
 * @warning Returns 'YES' even if anonymously authenticated.
 */
@property (nonatomic,readonly) BOOL isAuthenticated;

@property (nonatomic,strong,nullable) STUser* loggedUser;

@property (nonatomic,strong,nullable) id<STAuthenticationDelegate> authenticationDelegate;

+ (instancetype _Nonnull)sharedInstance;
+ (void)setAppID:(NSString * _Nonnull)appid;
- (void)setAccessToken:(NSString * _Null_unspecified)accessToken;

// Easy access
+ (NSString* _Null_unspecified)appID;
+ (NSString* _Null_unspecified)accessToken;
+ (NSString* _Null_unspecified)refreshToken;
+ (STUser* _Null_unspecified)loggedUser;

// Private
/// @warning Private usage only.
+ (void)setAPIHost:(NSString* _Nonnull)host;

/*!
 * @brief Prompts an authentication modal if no access token is present
 *
 * @param completion Completion block to be executed after login;
 */
+ (void)promptAuthenticationIfNecessaryWithCompletionBlock:(AuthenticationBlock _Nullable)completion;

/*!
 * @brief Prompts an authentication modal if no access token is present
 *
 * @param delegate The delegate to be called when an event occurs.
 */
+ (void)promptAuthenticationIfNecessaryWithDelegate:(id<STAuthenticationDelegate> _Nullable)delegate;

/*!
 * @brief Unused.
 */
+ (void)requestNewAccessTokenInBackgroundWithBlock:(BooleanCompletion _Nullable)completion; //Unused!

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
 * @param fromViewController The view controller from where present stomt creation controller.
 * @param completionBlock The completion handler to be called after the stomtCreation request.
 */
+ (void)presentStomtCreationPanelWithTarget:(STTarget* _Nonnull)target defaultText:(NSString* _Nullable)defaultText likeOrWish:(kSTObjectQualifier)likeOrWish fromViewController:(UIViewController* _Nonnull)viewController completionBlock:(__nullable StomtCreationBlock)completion;

/*!
 * @brief Present a panel to let the user create and send a stomt.
 * @discussion A panel is presented with the specified target, default text, stomt qualifier
 and completion block.
 *
 * @param targetID The identifier of the desired target.
 * @param defaultText The inial text of the stomt. Can be modified by the user.
 * @param likeOrWish Stomt qualifier.
 * @param fromViewController The view controller from where present stomt creation controller.
 * @param completionBlock The completion handler to be called after the stomtCreation request.
 */
+ (void)presentStomtCreationPanelWithTargetID:(NSString* _Nonnull)targetID defaultText:(NSString* _Nonnull)defaultText likeOrWish:(kSTObjectQualifier)likeOrWish fromViewController:(UIViewController* _Nonnull)viewController completionBlock:(__nullable StomtCreationBlock)completion;

/*!
 * @brief Handle different authentication methods
 * @discussion You may find a complete explanation of the implementation here: https://rest.stomt.com/#authentication
 *
 * @param authenticationRoute Gives information to the method on what parameters to expect. @see declarations.h
 * @param parameters Parameters needed in order to authenticate to the stomt's servers.
 */
+ (void)handleLoginFromExternalRoute:(kSTAuthenticationRoute)authenticationRoute withParameters:(NSDictionary* _Nonnull)parameters;

/// To be called in AppDelegate in order to perform an OAuth login.
- (BOOL)application:(UIApplication* _Nullable)application openURL:(NSURL * _Nonnull)url sourceApplication:( NSString * _Nullable )sourceApplication annotation:(__nullable id)annotation;

@end
