//
//  STQualifierView.m
//  TestView
//
//  Created by Leonardo Cascianelli on 03/10/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#import "STQualifierView.h"

@implementation STQualifierView

- (instancetype)initWithFrame:(CGRect)frame likeOrWish:(kSTObjectQualifier)qualifier
{
	CGRect frame_ = (qualifier == kSTObjectLike) ? CGRectMake(0+frame.size.height/4,0,frame.size.width,frame.size.height-frame.size.height/4) : CGRectMake(0,0+frame.size.height/4,frame.size.width,frame.size.height-frame.size.height/4);
	
	self = [super initWithFrame:frame_];
	
	self.backgroundColor = (qualifier == kSTObjectLike) ? [UIColor colorWithRed:131.0f/255.0f green:198.0f/255.0f blue:72.0f/255.0f alpha:1.0f] : [UIColor colorWithRed:0.0f/255.0f green:134.0f/255.0f blue:194.0f/255.0f alpha:1.0f];
	self.layer.cornerRadius = self.frame.size.height/2;
	
	if(!self.label)
		self.label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,self.bounds.size.width,self.bounds.size.height)];
	
	self.label.text = (qualifier == kSTObjectLike) ? @"I like" : @"I wish";
	
	self.label.textAlignment = NSTextAlignmentCenter;
	self.label.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12];
	self.label.textColor = [UIColor whiteColor];
	
	self.type = qualifier;
	
	[self addSubview:self.label];
	return self;
}

@end
