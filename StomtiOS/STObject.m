//
//  STObject.m
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 15/09/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#import "STObject.h"

@interface STObject ()
- (instancetype)initObjectWithTextBody:(NSString *)body positiveOrWish:(kSTObjectQualifier)positiveOrWish;
@end

@implementation STObject

+ (instancetype)objectWithTextBody:(NSString *)body positiveOrWish:(kSTObjectQualifier)positiveOrWish
{
	STObject* rt = [[STObject alloc] initObjectWithTextBody:body positiveOrWish:positiveOrWish];
	return rt;
}

- (instancetype)initObjectWithTextBody:(NSString *)body positiveOrWish:(kSTObjectQualifier)positiveOrWish
{
	self = [super init];
	self.positive = (positiveOrWish == kSTObjectPositive) ?  YES : NO;
	self.text = body;
	//self.image = image;
	return self;
}
@end
