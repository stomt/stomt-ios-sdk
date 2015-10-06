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
#import "declarations.h"

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
 */
@property (nonatomic) BOOL isAuthenticated;



+ (instancetype)sharedInstance;
+ (void)setAppID:(NSString *)appid;

// Easy access
+ (NSString*)appID;
+ (NSString*)accessToken;
+ (NSString*)refreshToken;



/*!
 * @brief Prompts an authentication modal if no access token is present
 *
 * @param completion Completion block to be executed after login;
 */
+ (void)promptAuthenticationIfNecessaryWithCompletionBlock:(BooleanCompletion)completion;

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
@end
