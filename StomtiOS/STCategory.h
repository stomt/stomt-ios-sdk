//
//  STCategory.h
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 12/09/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @brief Represents a category.
 @discussion The @p STCategory class is used to represent a category.
 */
@interface STCategory : NSObject

///Specifies the category type.
@property (nonatomic,strong) NSString* identifier;

///Specifies the category display name.
@property (nonatomic,strong) NSString* displayName;

/*!
 @brief Initializes a @p STCategory object with an identifier and a display name.
 @param identifier The category identifier.
 @param displayName The category display name.
 */
+ (instancetype)initWithIdentifier:(NSString*)identifier displayName:(NSString*)name;
@end
