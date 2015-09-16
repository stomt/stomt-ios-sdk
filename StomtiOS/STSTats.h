//
//  Stats.h
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 12/09/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#import "STTarget.h"

@interface STSTats : NSObject
@property (nonatomic) NSInteger followers;
@property (nonatomic) NSInteger follows;
@property (nonatomic) NSInteger createdStomts;
@property (nonatomic) NSInteger receivedStomts;
+ (instancetype)initWithStatsDictionary:(NSDictionary*)stats;
@end
