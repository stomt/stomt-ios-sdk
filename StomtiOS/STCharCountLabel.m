//
//  STCharCountLabel.m
//  TestView
//
//  Created by Leonardo Cascianelli on 05/10/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#define maxChars 100

#import "STCharCountLabel.h"

@implementation STCharCountLabel

- (instancetype)initWithFrame:(CGRect)frame likeOrWish:(kSTObjectQualifier)likeOrWish
{
	self = [super initWithFrame:frame];
	
	self.textColor = [UIColor blackColor];
	self.alpha = 0.5;
	self.chars = (likeOrWish == kSTObjectLike) ? maxChars-8 : maxChars-5;
	self.text = (likeOrWish == kSTObjectLike) ? [NSString stringWithFormat:@"%d",self.chars] : [NSString stringWithFormat:@"%d",self.chars];
	self.font = [UIFont fontWithName:@"HelveticaNeue" size:8];
	return self;
}

- (unsigned int)decreaseChars:(int)len
{
	if(self.chars - len >= 0)
	{
		self.chars -= len;
		self.text = [NSString stringWithFormat:@"%d",self.chars];
		return 1;
	}
	
	//self.chars -= len;
	//self.text = [NSString stringWithFormat:@"-%d",abs(self.chars)];
	
	return 0;
}

- (unsigned int)increaseChars:(int)len
{
	if(self.chars + len <= 100)
	{
		self.chars += len;
		self.text = [NSString stringWithFormat:@"%d",self.chars];
		return 1;
	}
	
	self.chars = maxChars;
	self.text = [NSString stringWithFormat:@"%d",self.chars];
	
	return 0;
}

@end
