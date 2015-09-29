//
//  STObject.h
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 15/09/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "declarations.h"

@class UIImage;
@class STTarget;
@class STImage;
@class CLLocation;

/*!
 * The actual stomt object, which at least contains text, targetID and a type qualifier.
 * The STObject class represents the actual stomt object that can be created on the stomt.com website.
 */
@interface STObject : NSObject


/*!
 * @brief The ID of the object in stomt.com.
 */
@property (nonatomic,strong) NSString* identifier;

/*!
 * @brief The ID of the target of the stomt object.
 */
@property (nonatomic,strong) NSString* targetID; //Required

/*!
 * @brief The url associated with the stomt.
 */
@property (nonatomic,strong) NSURL* url;

/*!
 * @brief The geolocation in terms of latitude and longitude associated with the stomt object.
 */
@property (nonatomic,strong) CLLocation* geoLocation;

/*!
 * @brief Qualifier of the stomt in terms of like (positive = 1) or wish (positive = 0)
 */
@property (nonatomic,readonly) BOOL positive; //Required (set by constructor)

/*!
 * @brief The text body of the stomt.
 */
@property (nonatomic,strong) NSString* text; //Required

/*!
 * @brief The language of the stomt.
 */
@property (nonatomic,strong) NSString* lang;

/*!
 * @brief The creation date of the stomt.
 */
@property (nonatomic,strong) NSDate* createdAt;

/*!
 * @brief Boolean to identify whether the stomt has been anonymously sent.
 */
@property (nonatomic) BOOL anonym;

/*!
 * @brief The image associated with the stomt.
 * @see STImage
 */
@property (atomic,strong) STImage* image;

/*!
 * @brief The creator of the stomt.
 * @see STTarget
 */
@property (nonatomic,strong) STTarget* creator;

/*!
 * @brief The target of the stomt.
 * @see STTarget
 */
@property (nonatomic,strong) STTarget* target;

/*!
 * @brief The amount of agreements (upvotes) of the stomt.
 */
@property (nonatomic) NSInteger amountOfAgreements;

/*!
 * @brief The amount of comments of the stomt.
 */
@property (nonatomic) NSInteger amountOfComments;

/*!
 * @brief Boolean, has the current user agreed to the stomt.
 */
@property (nonatomic) BOOL agreed;


//-----------------------------------------------------------------------------
// Overloaded constructors
//-----------------------------------------------------------------------------

/*!
 * @brief Constructor for a stomt object to be sent with a StomtRequest.
 *
 * @param body The text body of the stomt.
 * @param likeOrWish A type qualifier which specifies whether the stomt will be a "like" type or "wish" type.
 * @param targetID The ID of the target of the stomt.
 *
 * @return An instance of STObject.
 */
+ (instancetype)objectWithTextBody:(NSString *)body
						likeOrWish:(kSTObjectQualifier)likeOrWish
						  targetID:(NSString*)targetID;

/*!
 * @brief Constructor for a stomt object to be sent with a StomtRequest.
 *
 * @param body The text body of the stomt.
 * @param likeOrWish A type qualifier which specifies whether the stomt will be a "like" type or "wish" type.
 * @param targetID The ID of the target of the stomt.
 * @param image The image associated with the stomt object @see STImage
 *
 * @return An instance of STObject.
 */
+ (instancetype)objectWithTextBody:(NSString *)body
						likeOrWish:(kSTObjectQualifier)likeOrWish
						  targetID:(NSString*)targetID
							 image:(STImage*)img;

/*!
 * @brief Constructor for a stomt object to be sent with a StomtRequest.
 *
 * @param body The text body of the stomt.
 * @param likeOrWish A type qualifier which specifies whether the stomt will be a "like" type or "wish" type.
 * @param targetID The ID of the target of the stomt.
 * @param geoLocation The location point in terms of latitude and longitude associated with the stomt object.
 *
 * @return An instance of STObject.
 */
+ (instancetype)objectWithTextBody:(NSString *)body
						likeOrWish:(kSTObjectQualifier)likeOrWish
						  targetID:(NSString*)targetID
					   geoLocation:(CLLocation*)geoLocation;

/*!
 * @brief Constructor for a stomt object to be sent with a StomtRequest.
 *
 * @param body The text body of the stomt.
 * @param likeOrWish A type qualifier which specifies whether the stomt will be a "like" type or "wish" type.
 * @param targetID The ID of the target of the stomt.
 * @param url The url associated with the stomt object.
 *
 * @return An instance of STObject.
 */
+ (instancetype)objectWithTextBody:(NSString *)body
						likeOrWish:(kSTObjectQualifier)likeOrWish
						  targetID:(NSString*)targetID
							   url:(NSString*)url;

//-----------------------------------------------------------------------------
// Comprehensive constructor
//-----------------------------------------------------------------------------

/*!
 * @brief Constructor for a stomt object to be sent with a StomtRequest.
 *
 * @param body The text body of the stomt.
 * @param likeOrWish A type qualifier which specifies whether the stomt will be a "like" type or "wish" type.
 * @param targetID The ID of the target of the stomt.
 * @param image The image associated with the stomt object @see STImage
 * @param geoLocation The location point in terms of latitude and longitude associated with the stomt object.
 * @param url The url associated with the stomt object.
 *
 * @return An instance of STObject.
 */
+ (instancetype)objectWithTextBody:(NSString *)body
						likeOrWish:(kSTObjectQualifier)likeOrWish
						  targetID:(NSString*)targetID
							 image:(STImage*)img
							   url:(NSString*)url
					   geoLocation:(CLLocation*)geoLocation;

//-----------------------------------------------------------------------------
// Dictionary constructors
//-----------------------------------------------------------------------------


/*!
 * @brief Constructor for a STObject
 * 
 * @param dictionary The dictionary returned by the raw HTTP request.
 * 
 * @return an instance of STObject
 */
+ (instancetype)objectWithDataDictionary:(NSDictionary*)dictionary;


@end
