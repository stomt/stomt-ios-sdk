//
//  Stats.h
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 12/09/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#import "STTarget.h"

/*!
 * STStats class provides counters for statistics of a target such as followers, follows, created stomts and received stomts.
 */
@interface STStats : NSObject


/*!
 * @brief The number of followers the target has.
 */
@property (nonatomic) NSInteger followers;

/*!
 * @brief The number of people the target follows.
 */
@property (nonatomic) NSInteger follows;

/*!
 * @brief The number of stomts created by the target.
 */
@property (nonatomic) NSInteger createdStomts;

/*!
 * @brief The number of stomts received by the target.
 */
@property (nonatomic) NSInteger receivedStomts;


/*!
 * @brief Constructor for STStats object
 *
 * @params stats Dictionary provided by the raw HTML response.
 * 
 * @return An instance of STStats.
 */
+ (instancetype)initWithStatsDictionary:(NSDictionary*)stats;


@end
