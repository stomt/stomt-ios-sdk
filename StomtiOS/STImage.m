//
//  STImage.m
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 16/09/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#import "STImage.h"
#import "Stomt.h"
#import "dbg.h"
#import "strings.h"

@interface STImage ()

@end

@implementation STImage
- (instancetype)init
{
	_err("Use class initializer -[[STImage alloc] initWithImage:(UIImage*)]");
error:
	return nil;
}

- (instancetype)initWithImageName:(NSString *)name
{
	self = [super init];

	self.imageName = name;
	self.url = nil;
	
	return self;
}

@end
