//
//  DoubleSideView.m
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 01/03/16.
//  Copyright © 2016 Leonardo Cascianelli. All rights reserved.
//

#import "DoubleSideView.h"

@interface DoubleSideView ()
@property (nonatomic,strong) NSLayoutConstraint* topLeadingConstraint;
@property (nonatomic,strong) NSLayoutConstraint* topTrailingConstraint;
@property (nonatomic,strong) NSLayoutConstraint* botLeadingConstraint;
@property (nonatomic,strong) NSLayoutConstraint* botTrailingConstraint;
@end

@implementation DoubleSideView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	if(self = [super initWithCoder:aDecoder])
	{
		_topView = [[UIView alloc] init];
		_botView = [[UIView alloc] init];
		
		_topGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shrinkSendingView:)];
		[_topGestureRecognizer setNumberOfTapsRequired:1];
		[_topGestureRecognizer setNumberOfTouchesRequired:1];
		
		_botGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shrinkSendingView:)];
		[_botGestureRecognizer setNumberOfTapsRequired:1];
		[_botGestureRecognizer setNumberOfTouchesRequired:1];
		
		self.backgroundColor = [UIColor yellowColor];
		
		_distance = 16;
		
		[self addSubview:_topView];
		[self addSubview:_botView];
	}
	return self;
}


- (void)drawRect:(CGRect)rect {
	
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_topView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_topView)]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_botView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_botView)]];
	
	_topLeadingConstraint = [NSLayoutConstraint constraintWithItem:_topView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
	
	_topTrailingConstraint = [NSLayoutConstraint constraintWithItem:_topView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-_distance];
	
	_botLeadingConstraint = [NSLayoutConstraint constraintWithItem:_botView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:_distance];
	
	_botTrailingConstraint = [NSLayoutConstraint constraintWithItem:_botView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
	
	[self addConstraints:@[_topTrailingConstraint,_topLeadingConstraint,_botLeadingConstraint,_botTrailingConstraint]];
}


- (void)shrinkSendingView:(UITapGestureRecognizer *)gestureRecognizer
{
	if([gestureRecognizer.view isEqual:_topView])
	{
		[self removeConstraints:@[_topTrailingConstraint,_botLeadingConstraint]];
		
		_topTrailingConstraint = [NSLayoutConstraint constraintWithItem:_topView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:_distance];
		
		_botLeadingConstraint = [NSLayoutConstraint constraintWithItem:_botView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:_distance];
		
		[self addConstraints:@[_topTrailingConstraint,_botLeadingConstraint]];
	}
	else
	{
		[self removeConstraints:@[_topTrailingConstraint,_botLeadingConstraint]];
		
		_topTrailingConstraint = [NSLayoutConstraint constraintWithItem:_topView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-_distance];
		
		_botLeadingConstraint = [NSLayoutConstraint constraintWithItem:_botView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:_distance];
		
		[self addConstraints:@[_topTrailingConstraint,_botLeadingConstraint]];
		
	}
	
	[UIView animateWithDuration:.3f delay:.0f usingSpringWithDamping:.7f initialSpringVelocity:.0f options:0 animations:^{
		[self layoutIfNeeded];
	} completion:nil];
}


- (void)setTopView:(UIView *)topView
{
	if(_topView) [_topView removeFromSuperview];
	
	_topView = topView;
	
	_topView.translatesAutoresizingMaskIntoConstraints = NO;
	_topView.userInteractionEnabled = YES;
	
	[_topView addGestureRecognizer:_topGestureRecognizer];
	
	[self addSubview:_topView];
}

- (void)setBotView:(UIView *)botView
{
	if(_botView) [_botView removeFromSuperview];
	_botView = botView;
	
	_botView.userInteractionEnabled = YES;
	_topView.translatesAutoresizingMaskIntoConstraints = NO;
	
	[_botView addGestureRecognizer:_botGestureRecognizer];
	
	[self addSubview:_botView];
}

@end
