//
//  STImage.m
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 16/09/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#import "STImage.h"
#import "dbg.h"

@implementation STImage
- (instancetype)init
{
	_err("Use class initializer -[[STImage alloc] initWithImage:(UIImage*)]");
error:
	return nil;
}

- (instancetype)initWithImage:(UIImage *)image
{
	self = [super init];
	self.image = image;
	self.imageName = nil;
	self.isReady = NO;
	return self;
}

- (void)prepare
{
	
}
@end
