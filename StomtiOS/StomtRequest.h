//
//  StomtRequest.h
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 10/09/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "block_declarations.h"
#import "declarations.h"

@class STObject;
@class CLLocation;
@class UIImage;
@class STFeed;

/*!
 * @brief StomtRequest class is used to create and send every request to stomt.
 * @discussion StomtRequest class needs you to firstly create an instance of it, providing all the
 * 			 args needed by the desired constructor. Once the request has been created the user
 *			 will need to call the appropriate sender method, possibly specifying a completion
 *			 handler.
 */
@interface StomtRequest : NSObject


/*!
 * @brief The request itself.
 */
@property (nonatomic,strong) NSURLRequest* apiRequest;

/*!
 * @brief The request type.
 */
@property (nonatomic,readonly) RequestType requestType;


//-----------------------------------------------------------------------------
// Request constructors
//-----------------------------------------------------------------------------

/*!
 * @brief Create a request to send a stomt with a STObject instance.
 *
 * @param stomtObject an instance of STObject. @see STObject
 *
 * @return StomtRequest instance with type kStomtCreationRequest
 */
+ (StomtRequest*)stomtCreationRequestWithStomtObject:(STObject *)stomtObject;

/*!
 * @brief Create a request to upload an image to stomt.
 * @discussion Every image needs to be uploaded to stomt with this method
 *			 in order to use it in any other context.
 *
 * @param image The image to upload. @see UIImage
 * @param targetID The id to associate the image to. (Optional)
 * @param category The usage of the image.
 *
 * @return StomtRequest instance with type kImageUploadRequest
 */
+ (StomtRequest*)imageUploadRequestWithImage:(UIImage *)image
								 forTargetID:(NSString*)targetID
						   withImageCategory:(kSTImageCategory)category;

/*!
 * @brief Create a request to log out the current user and delete cached access & refresh tokens.
 *
 * @return StomtRequest instance with type kLogoutRequest
 */
+ (StomtRequest*)logoutRequest;

/*!
 * @brief Create a request to retrieve a stomt from stomt.com
 *
 * @param identifierOrUrl The ID of the stomt or it's complete URL.
 *
 * @return StomtRequest instance with type kStomtRequest
 */
+ (StomtRequest*)stomtRequestWithIdentifierOrURL:(NSString*)location;

/*!
 * @brief Create a request to retrieve a Stomts feed. @see STFeed
 * @discussion The feed will be filtered with the parameters passed while creating the STFeed object.
 *
 * @param feedObject A STFeed object. @see STFeed
 *
 * @return StomtRequest instance with type kFeedRequest
 */
+ (StomtRequest*)feedRequestWithStomtFeedObject:(STFeed*)feed;

/*!
 * @brief Create a request to retrieve a Target.
 * 
 * @param targetID The target id or stomt username
 *
 * @return StomtRequest instance with type kTargetRequest
 */
+ (StomtRequest*)targetRequestWithTargetID:(NSString*)targetID;

/*!
 * @brief Create a request to retrieve a Target with basic properties.
 * @discussion The target will contain its identifier, display name, images array and category.
 *
 * @param targetID The target id or stomt username
 *
 * @return StomtRequest instance with type kBasicTargetRequest
 */
+ (StomtRequest*)basicTargetRequestWithTargetID:(NSString*)targetID;

/*!
 * @brief Authenticate or register an user via Facebook login.
 * @discussion This method accepts raw data retrieved by a successuful login using the Facebook SDK.
 * You will have to provide properties contained in the 'FBSDKProfile' class and in the 'FBSDKAccessToken' class.
 *
 * @param accessToken The access token retrieved by the +[FBSDKAccessToken currentAccessToken] method in the Facebook SDK.
 * @param userID The user identifier retrieved by the @userID property in the FacebookSDK (FBSDKProfile class).
 *
 * @warning This documentation refers to the Facebook SDK version '20151007'.
 *
 * @return StomtRequest instance with type kFacebookAuthenticationRequest
 */
+ (StomtRequest*)facebookAuthenticationRequestWithAccessToken:(NSString*)accessToken userID:(NSString*)userID;

//-----------------------------------------------------------------------------
// Request senders
//-----------------------------------------------------------------------------

/*!
 * @brief Send the stomt saved in the request.
 * @discussion The request will return in the completion handler the newly created STObject in stomt.com
 */
- (void)sendStomtInBackgroundWithBlock:(StomtCreationBlock)completion;

/*!
 * @brief Upload an image to stomt.com
 * @discussion The request will return in the completion handler the name of the image to eventually
 *			 associate it with an STObject. @see Stobject @see STImage
 */
- (void)uploadImageInBackgroundWithBlock:(ImageUploadBlock)completion;

/*!
 * @brief Logs out the current user and deletes cached access & refresh tokens.
 * @warning Logout not available if not connected to the internet.
 */
- (void)logoutInBackgroundWithBlock:(BooleanCompletion)completion;

/*!
 * @brief Retrieve a STObject form stomt.com
 * @discussion The request will return the STObject (if available) in the completion handler.
 */
- (void)requestStomtInBackgroundWithBlock:(StomtCreationBlock)completion;

/*!
 * @brief Requests a feed with the parameters saved in the request object.
 * @discussion The request will return the STFeed object (if available) in the completion handler.
*/
- (void)requestFeedInBackgroundWithBlock:(FeedRequestBlock)completion;

/*!
 * @brief Request a target with the given targetID
 */
- (void)requestTargetInBackgroundWithBlock:(TargetRequestBlock)completion;

/*!
 * @brief Request a basic target (restricted target) with the given targetID
 */
- (void)requestBasicTargetInBackgroundWithBlock:(TargetRequestBlock)completion;

/*!
 * @brief Authenticate the user to Stomt through Facebook.
 */
- (void)authenticateWithFacebookInBackgroundWithBlock:(AuthenticationBlock)completion;

@end