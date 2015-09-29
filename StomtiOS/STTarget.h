//
//  STTarget.h
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 11/09/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#import <Foundation/Foundation.h>

@class STCategory;
@class UIImage;
@class STStats;

/*!
 * STTarget class represents a Target, one of the most important objects in stomt.
 * Almost any object that this library handles inherits from STTarget class or contains an instance of it.
 */
@interface STTarget : NSObject


/*!
 * @brief Unique id of the target, also referred in stomt API as 'slug'.
 */
@property (nonatomic,strong) NSString* identifier;

/*!
 * @brief The name of the target displayed on stomt.
 */
@property (nonatomic,strong) NSString* displayName;

/*!
 * @brief Category of the target. (Stomt, Users, Games...).
 */
@property (nonatomic,strong) STCategory* category;

 /*!
  * @brief The profile image of the target.
  */
@property (nonatomic,strong) NSURL* profileImage;

 /*!
  * @brief Statistics of the target. A comprehensive explanation can be found in the STStats class.
  */
@property (nonatomic,strong) STStats* stats;

 /*!
  * @brief BOOL to check whether the target is a verified or not.
  */
@property (nonatomic) BOOL isVerified;


/*!
 * @brief Create a STTarget instance with a given target dictionary.
 *
 * @param data Target dictionary
 *
 * @return A newly created STTarget instance
 */
+ (instancetype)initWithDataDictionary:(NSDictionary*)data;

/*!
 * @brief (Private!) Create a STTarget instance with a given target dictionary.
 *
 * @param data Target dictionary
 *
 * @return A newly created STTarget instance
 */
- (instancetype)initWithDataDictionary:(NSDictionary*)data;


@end
