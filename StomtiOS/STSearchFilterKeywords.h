//
//  STSearchKeywords.h
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 25/09/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "declarations.h"

/*!
 * STSearchFilterKeywords class provides filters for STFeed objects.
 * STSearchFilterKeywords is an helper class which is used to create STFeed objects. It provides the
 * possibility to add positive an negative filters in order to obtain the desired STObject(s) array.
 */
@interface STSearchFilterKeywords : NSObject


/*!
 * @brief Positive filter keywords combined with AND.
 */
@property (nonatomic) STKeywordFilter positiveKeywords;

/*!
 * @brief Negated filter keywords combined with AND.
 */
@property (nonatomic) STKeywordFilter negatedKeywords;

/*!
 * @brief Filters list
 */
@property (nonatomic,strong) NSMutableString* keywordFilters;


/*!
 * @brief Create a filter list with positive and negated keywords
 *
 * @param positiveKeywords Positive filter keywords combined with AND
 * @param negatedKeywords Negated filter keywords combined with AND
 *
 * @returns An instance of STSearchFilterKeywords
 */
+ (instancetype)searchFilterWithPositiveKeywords:(STKeywordFilter)positive
								 negatedKeywords:(STKeywordFilter)negated;


@end
