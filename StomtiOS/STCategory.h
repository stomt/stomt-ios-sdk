//
//  STCategory.h
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 12/09/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 * Represents a category of @p STTargets.
 */
@interface STCategory : NSObject <NSCoding>


/*!
 * @brief Specifies the category type.
 */
@property (nonatomic,strong) NSString* identifier;

/*!
 * @brief Specifies the category display name.
 */
@property (nonatomic,strong) NSString* displayName;


/*!
 * @brief Initializes a @p STCategory object with an identifier and a display name.
 * 
 * @param identifier The category identifier.
 * @param displayName The category display name.
 *
 * @return Newly created instance of STCategory.
 */
+ (instancetype)initWithIdentifier:(NSString*)identifier
                       displayName:(NSString*)name;


@end
