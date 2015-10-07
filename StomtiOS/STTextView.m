//
//  STTextView.m
//  TestView
//
//  Created by Leonardo Cascianelli on 03/10/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#define maxLines 4

#import "STTextView.h"

@implementation STTextView

- (instancetype)initWithFrame:(CGRect)frame likeOrWish:(kSTObjectQualifier)likeOrWish
{
	NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:frame.size];
	NSLayoutManager *layoutManager = [NSLayoutManager new];
	[layoutManager addTextContainer:textContainer];
	
	NSString* prefix = (likeOrWish == kSTObjectLike) ? @"because " : @"would ";
	NSTextStorage *textStorage = [[NSTextStorage alloc] initWithString:prefix];
	[textStorage addLayoutManager:layoutManager];
	
	self = [super initWithFrame:frame textContainer:textContainer];
	self.lines = 0;
	if(self)
	{
		self.backgroundColor = [UIColor clearColor];
		self.scrollEnabled = NO;
		self.contentMode = UIViewContentModeRedraw;
	}
	self.layoutManager.allowsNonContiguousLayout = NO;
	return self;
}

- (void)appendText:(NSString*)text
{
	self.text = [self.text stringByAppendingString:text];
}

@end
