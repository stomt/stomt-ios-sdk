//
//  STSearchKeywords.h
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 25/09/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "declarations.h"

@interface STSearchFilterKeywords : NSObject
@property (nonatomic) STKeywordFilter positiveKeywords;
@property (nonatomic) STKeywordFilter negatedKeywords;
@property (nonatomic,strong) NSMutableString* keywordFilters;
+ (instancetype)searchFilterWithPositiveKeywords:(STKeywordFilter)positive negatedKeywords:(STKeywordFilter)negated;
@end
