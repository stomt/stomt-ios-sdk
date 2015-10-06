//
//  STButtonLabel.m
//  TestView
//
//  Created by Leonardo Cascianelli on 04/10/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#import "STButtonLabel.h"


@interface STButtonLabel ()
- (void)toggleHighlight;
@end

@implementation STButtonLabel

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	
	self.highlightedTextColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
	self.userInteractionEnabled = YES;
	
	return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesBegan:touches withEvent:event];
	self.highlighted = YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if(self.HandleTapBlock)
		self.HandleTapBlock();
	[super touchesEnded:touches withEvent:event];
		self.highlightTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(toggleHighlight) userInfo:nil repeats:NO];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesCancelled:touches withEvent:event];
		self.highlightTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(toggleHighlight) userInfo:nil repeats:NO];
}

- (void)toggleHighlight
{
	self.highlighted = NO;
}

- (void)dealloc
{
	if(self.highlightTimer)
		[self.highlightTimer invalidate];
}

@end
