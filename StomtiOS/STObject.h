//
//  STObject.h
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 15/09/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIImage;
@class STTarget;
@class STImage;
@class CLLocation;


typedef enum{
	kSTObjectLike,kSTObjectWish
}kSTObjectQualifier;

/*!
 
 @brief The actual Stomt object, which at least contains text, targetID and a type qualifier.
 @discussion The STObject class represents the actual Stomt object that can be created from the stomt.com website.

 */
@interface STObject : NSObject
@property (nonatomic,strong) NSString* identifier;
@property (nonatomic,strong) NSString* targetID; //Required
@property (nonatomic,strong) NSURL* url;
@property (nonatomic,strong) CLLocation* geoLocation;
@property (nonatomic,readonly) BOOL positive; //Required (set by constructor)
@property (nonatomic,strong) NSString* text; //Required
@property (nonatomic,strong) NSString* lang;
@property (nonatomic,strong) NSDate* createdAt;
@property (nonatomic) BOOL anonym;
@property (atomic,strong) STImage* image;
@property (nonatomic,strong) STTarget* creator;
@property (nonatomic,strong) STTarget* target;
@property (nonatomic) NSInteger amountOfAgreements;
@property (nonatomic) NSInteger amountOfComments;
@property (nonatomic) BOOL agreed;

//Overloaded constructors
+ (instancetype)objectWithTextBody:(NSString *)body likeOrWish:(kSTObjectQualifier)likeOrWish targetID:(NSString*)targetID;
+ (instancetype)objectWithTextBody:(NSString *)body likeOrWish:(kSTObjectQualifier)likeOrWish targetID:(NSString*)targetID image:(STImage*)img;
+ (instancetype)objectWithTextBody:(NSString *)body likeOrWish:(kSTObjectQualifier)likeOrWish targetID:(NSString*)targetID geoLocation:(CLLocation*)geoLocation;
+ (instancetype)objectWithTextBody:(NSString *)body likeOrWish:(kSTObjectQualifier)likeOrWish targetID:(NSString*)targetID url:(NSString*)url;

//Comprehensive constructor
+ (instancetype)objectWithTextBody:(NSString *)body likeOrWish:(kSTObjectQualifier)likeOrWish targetID:(NSString*)targetID image:(STImage*)img url:(NSString*)url geoLocation:(CLLocation*)geoLocation;

//Dictionary constructors
+ (instancetype)objectWithDataDictionary:(NSDictionary*)dictionary;
@end
