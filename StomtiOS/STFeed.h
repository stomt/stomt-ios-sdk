//
//  STFeed.h
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 24/09/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "declarations.h"

@interface STFeed : NSObject
@property (nonatomic,strong) NSMutableArray* stomts;
@property (nonatomic,strong) NSMutableDictionary* params;

+ (instancetype)feedWithTerm:(NSString*)term belongsTo:(NSString*)belongsTargetID directlyReceivedBy:(NSArray*)directTargetIDs sentBy:(NSArray*)fromTargetIDs filterKeywords:(NSArray*)keywords likeOrWish:(kSTObjectQualifier)likeOrWish containsLabels:(NSArray*)labels;
+ (instancetype)feedWithStomtsArray:(NSArray*)array;
@end
