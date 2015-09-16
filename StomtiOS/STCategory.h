//
//  STCategory.h
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 12/09/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STCategory : NSObject
@property (nonatomic,strong) NSString* identifier;
@property (nonatomic,strong) NSString* displayName;
+ (instancetype)initWithIdentifier:(NSString*)identifier displayName:(NSString*)name;
@end
