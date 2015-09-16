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
@class STSTats;

@interface STTarget : NSObject
@property (nonatomic,strong) NSString* identifier;
@property (nonatomic,strong) NSString* displayName;
@property (nonatomic,strong) STCategory* category;
@property (nonatomic,strong) NSURL* profileImage;
@property (nonatomic,strong) STSTats* stats;
@property (nonatomic) BOOL isVerified;
+ (instancetype)initWithDataDictionary:(NSDictionary*)data;
- (instancetype)initWithDataDictionary:(NSDictionary*)data;
@end
