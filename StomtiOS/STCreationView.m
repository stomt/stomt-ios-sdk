//
//  STCreationView.m
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 22/09/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//



#import "STCreationView.h"

@interface STCreationView ()
- (void)setupSubviews;
@end

@implementation STCreationView

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	self.backgroundColor = [UIColor lightGrayColor];
	self.layer.cornerRadius = 5;
	self.layer.masksToBounds = YES;
	self.translatesAutoresizingMaskIntoConstraints = YES;
	[self setupSubviews];
	//self.center = CGPointMake(CGRectGetMidX([UIScreen mainScreen].bounds),CGRectGetMidY([UIScreen mainScreen].bounds));
	return self;
}

- (void)setupSubviews
{
	UITextField* text = [[UITextField alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width-self.frame.size.width/5,self.frame.size.height-self.frame.size.height/2)];
	text.backgroundColor = [UIColor redColor];
	text.borderStyle = UITextBorderStyleRoundedRect;
	text.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2 - self.bounds.size.height/4.5);
	NSLog(@"Frame: %@",NSStringFromCGRect(self.frame));
	[self addSubview:text];
}
@end
