//
//  STImagePool.h
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 19/06/16.
//  Copyright © 2016 Leonardo Cascianelli. All rights reserved.
//

#import <Foundation/Foundation.h>

@class STImageView;

@interface STImagePool : NSObject
@property (nonatomic,strong) NSMutableDictionary* imagePool;
+ (instancetype)sharedInstance;
- (STImageView*)addToPoolImageView:(STImageView*)imageView;
@end
