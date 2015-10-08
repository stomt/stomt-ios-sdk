//
//  STTargetDisplayer.m
//  TestView
//
//  Created by Leonardo Cascianelli on 03/10/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#define threshold 4

#import "STTargetDisplayer.h"
#import "STTargetNameRectangle.h"
#import "STTargetDisplayerContainer.h"
#import "STTarget.h"

@interface STTargetDisplayer()

@end

@implementation STTargetDisplayer

- (instancetype)initWithFrame:(CGRect)frame target:(STTarget*)target
{
	if(!target) { fprintf(stderr, "No target specified!"); goto error; };
		
	self = [super initWithFrame:frame];
	self.maxFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
	self.backgroundColor = [UIColor whiteColor];
	
	if(!self.container)
	{
		self.container = [[STTargetDisplayerContainer alloc] initWithMaxFrame:CGRectMake(threshold, 0, self.maxFrame.size.width-threshold, self.maxFrame.size.height) target:target];
	}
	
	[self addSubview:self.container];
	
	return self;
error:
	return nil;
}

- (void)drawRect:(CGRect)rect {
	[STTargetNameRectangle drawCanvas1WithFrame:CGRectMake(rect.origin.x
														   , rect.origin.y
														   , self.container.bounds.size.width,
														   self.container.bounds.size.height)];
	if(!self.container.displayName)
	{
		[STTarget retrieveEssentialTargetWithTargetID:self.container.target.identifier completionBlock:^(NSError *error, STTarget *target) {
			[self.container updateDisplayContainerWithTarget:target];
		}];
		
	}
}

@end
