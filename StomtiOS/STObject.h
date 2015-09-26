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
 
 @brief The actual stomt object, which at least contains text, targetID and a type qualifier.
 @discussion The STObject class represents the actual stomt object that can be created on the stomt.com website.

 */
@interface STObject : NSObject
/// The ID of the object in stomt.com.
@property (nonatomic,strong) NSString* identifier;
/// The ID of the target of the Stomt object.
@property (nonatomic,strong) NSString* targetID; //Required
/// The url associated with the stomt.
@property (nonatomic,strong) NSURL* url;
/// The geolocation in terms of latitude and longitude associated with the Stomt object.
@property (nonatomic,strong) CLLocation* geoLocation;
/// Qualifier of the Ftomt in terms of like (positive = 1) or wish (positive = 0)
@property (nonatomic,readonly) BOOL positive; //Required (set by constructor)
/// The text body of the Stomt.
@property (nonatomic,strong) NSString* text; //Required
/// The language of the Stomt.
@property (nonatomic,strong) NSString* lang;
/// The creation date of the Stomt.
@property (nonatomic,strong) NSDate* createdAt;
/// Boolean to identify whether the Stomt has been anonymously sent.
@property (nonatomic) BOOL anonym;
/// The image associated with the Stomt. @see STImage
@property (atomic,strong) STImage* image;
/// The creator of the Stomt. @see STTarget
@property (nonatomic,strong) STTarget* creator;
/// The target of the Stomt. @see STTarget
@property (nonatomic,strong) STTarget* target;
/// The amount of agreements (upvotes) of the Stomt.
@property (nonatomic) NSInteger amountOfAgreements;
/// The amount of comments of the Stomt.
@property (nonatomic) NSInteger amountOfComments;
@property (nonatomic) BOOL agreed;

//Overloaded constructors

/*!
 
 @brief Constructor for a Stomt object to be sent with a StomtRequest.
 @param body The text body of the Stomt.
 @param likeOrWish A type qualifier which specifies whether the stomt will be a "like" type or "whish" type.
 @param targetID The ID of the target of the Stomt.
 @returns An instance of STObject.
 
 */
+ (instancetype)objectWithTextBody:(NSString *)body likeOrWish:(kSTObjectQualifier)likeOrWish targetID:(NSString*)targetID;

/*!
 
 @brief Constructor for a Stomt object to be sent with a StomtRequest.
 @param body The text body of the Stomt.
 @param likeOrWish A type qualifier which specifies whether the stomt will be a "like" type or "whish" type.
 @param targetID The ID of the target of the Stomt.
 @param image The image associated with the Stomt object @see STImage
 @returns An instance of STObject.
 
 */
+ (instancetype)objectWithTextBody:(NSString *)body likeOrWish:(kSTObjectQualifier)likeOrWish targetID:(NSString*)targetID image:(STImage*)img;

/*!
 
 @brief Constructor for a Stomt object to be sent with a StomtRequest.
 @param body The text body of the Stomt.
 @param likeOrWish A type qualifier which specifies whether the stomt will be a "like" type or "whish" type.
 @param targetID The ID of the target of the Stomt.
 @param geoLocation The location point in terms of latitude and longitude associated with the Stomt object.
 @returns An instance of STObject.
 
 */
+ (instancetype)objectWithTextBody:(NSString *)body likeOrWish:(kSTObjectQualifier)likeOrWish targetID:(NSString*)targetID geoLocation:(CLLocation*)geoLocation;

/*!
 
 @brief Constructor for a Stomt object to be sent with a StomtRequest.
 @param body The text body of the Stomt.
 @param likeOrWish A type qualifier which specifies whether the stomt will be a "like" type or "whish" type.
 @param targetID The ID of the target of the Stomt.
 @param url The url associated with the Stomt object.
 @returns An instance of STObject.
 
 */
+ (instancetype)objectWithTextBody:(NSString *)body likeOrWish:(kSTObjectQualifier)likeOrWish targetID:(NSString*)targetID url:(NSString*)url;

//Comprehensive constructor

/*!
 
 @brief Constructor for a Stomt object to be sent with a StomtRequest.
 @param body The text body of the Stomt.
 @param likeOrWish A type qualifier which specifies whether the stomt will be a "like" type or "whish" type.
 @param targetID The ID of the target of the Stomt.
 @param image The image associated with the Stomt object @see STImage
 @param geoLocation The location point in terms of latitude and longitude associated with the Stomt object.
 @param url The url associated with the Stomt object.
 @returns An instance of STObject.
 
 */
+ (instancetype)objectWithTextBody:(NSString *)body likeOrWish:(kSTObjectQualifier)likeOrWish targetID:(NSString*)targetID image:(STImage*)img url:(NSString*)url geoLocation:(CLLocation*)geoLocation;

//Dictionary constructors

/*!

 @brief Constructor for a STObject
 @param dictionary The dictionary returned by the raw HTTP request.
 @returns an instance of STObject
 
 */

+ (instancetype)objectWithDataDictionary:(NSDictionary*)dictionary;
@end
