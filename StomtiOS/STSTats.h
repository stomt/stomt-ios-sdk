//
//  Stats.h
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 12/09/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#import "STTarget.h"

/*!

 @brief STStats class provides counters for statistics of a target
 @discussion STStats class provides counters for statyistics of a target,
 such as followers, follows, created stomts and received stomts.
 
 */

@interface STStats : NSObject
/// The number of followers the target has.
@property (nonatomic) NSInteger followers;
/// The number of people the target follows.
@property (nonatomic) NSInteger follows;
/// The number of stomts created by the target.
@property (nonatomic) NSInteger createdStomts;
/// The number of stomts received by the target.
@property (nonatomic) NSInteger receivedStomts;

/*!

 @brief Constructor for STStats object
 @params dictionary Dictionary provided by the raw HTML response.
 @warning This method is not meant to be used directly by the user.
 @returns An instance of STStats.
 
 */
+ (instancetype)initWithStatsDictionary:(NSDictionary*)stats;
@end
