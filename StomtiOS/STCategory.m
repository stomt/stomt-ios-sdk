//
//  STCategory.m
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 12/09/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#import "STCategory.h"

@implementation STCategory
+ (instancetype)initWithIdentifier:(NSString*)identifier displayName:(NSString*)name
{
	STCategory* category = [[STCategory alloc] init];
	category.identifier = identifier;
	category.displayName = name;
	return category;
}
@end
