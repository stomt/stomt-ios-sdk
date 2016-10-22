//
//  TempLikeWishView.m
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 09/06/16.
//  Copyright © 2016 Leonardo Cascianelli. All rights reserved.
//

#import "TempLikeWishView.h"
#import "Stomt.h"

@interface TempLikeWishView ()
@property (nonatomic) kSTObjectQualifier likeOrWish;
@property (nonatomic,strong) UILabel* topLabel;
@property (nonatomic,strong) UILabel* botLabel;
- (void)switchViews;
@end

@implementation TempLikeWishView

- (instancetype)initWithTopView:(int)likeOrWish
{
	if(self = [super init])
	{
		_likeOrWish = likeOrWish;
	}
	return self;
}

- (UIView*)generateViewWithQualifier:(kSTObjectQualifier)likeOrWish
{
	UIView* finalView = [[UIView alloc] init];
	finalView.translatesAutoresizingMaskIntoConstraints = NO;
	UIColor* color = (likeOrWish == kSTObjectLike) ? [UIColor colorWithRed:0.35 green:0.91 blue:0.79 alpha:1.0] : [UIColor colorWithRed:0.61 green:0.05 blue:1.00 alpha:1.0];
	finalView.backgroundColor = color;
	
	return finalView;
}

- (void)setupWithFrontView:(int)likeOrWish;
{
	_likeOrWish = likeOrWish;
}

- (void)switchViews
{
	_topLabel.text = (_likeOrWish == kSTObjectLike) ? @"I wish" : @"I like";
	_botLabel.text = (_likeOrWish != kSTObjectLike) ? @"I wish" : @"I like";
	
	_topView.backgroundColor = (_likeOrWish == kSTObjectLike) ?  [UIColor colorWithRed:0.61 green:0.05 blue:1.00 alpha:1.0] : [UIColor colorWithRed:0.35 green:0.91 blue:0.79 alpha:1.0];
	_botView.backgroundColor = (_likeOrWish != kSTObjectLike) ?  [UIColor colorWithRed:0.61 green:0.05 blue:1.00 alpha:1.0] : [UIColor colorWithRed:0.35 green:0.91 blue:0.79 alpha:1.0];
	
	_likeOrWish = (_likeOrWish == kSTObjectLike) ? kSTObjectWish : kSTObjectLike;
	
	if(_delegate) [_delegate likeWishView:self changedToState:_likeOrWish];
	
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
	[self switchViews];
}

- (void)drawRect:(CGRect)rect
{
	
	kSTObjectQualifier topViewQualifier = _likeOrWish;
	kSTObjectQualifier botViewQualifier = (_likeOrWish == 1) ? kSTObjectWish : kSTObjectLike;
	
	_topView = [self generateViewWithQualifier:topViewQualifier];
	_topLabel = [[UILabel alloc] init];
	_topLabel.font = [UIFont systemFontOfSize:12];
	_topLabel.text =  (_likeOrWish == kSTObjectLike) ? @"I like" : @"I wish";
	_topLabel.textColor = [UIColor whiteColor];
	_topLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[_topView addSubview:_topLabel];
	
	_botView = [self generateViewWithQualifier:botViewQualifier];
	_botLabel = [[UILabel alloc] init];
	_botLabel.font = [UIFont systemFontOfSize:12];
	_botLabel.text = (_likeOrWish == kSTObjectLike) ? @"I wish": @"I like";
	_botLabel.textColor = [UIColor whiteColor];
	_botLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[_botView addSubview:_botLabel];
	
	[self addSubview:_botView];
	[self addSubview:_topView];
	
	NSArray* topViewHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_topView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_topView)];
	NSLayoutConstraint* topViewWidth = [NSLayoutConstraint constraintWithItem:_topView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:.9f constant:.0f];
	NSLayoutConstraint* topViewHeight = [NSLayoutConstraint constraintWithItem:_topView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:.8f constant:.0f];
	NSArray* topViewVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_topView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_topView)];
	
	NSArray* botViewHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_botView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_botView)];
	NSLayoutConstraint* botViewWidth = [NSLayoutConstraint constraintWithItem:_botView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:.9f constant:.0f];
	NSLayoutConstraint* botViewHeight = [NSLayoutConstraint constraintWithItem:_botView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:.8f constant:.0f];
	NSArray* botViewVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_botView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_botView)];

	
	[self addConstraint:topViewHeight];
	[self addConstraint:topViewWidth];
	[self addConstraints:topViewHorizontalConstraints];
	[self  addConstraints:topViewVerticalConstraints];
	
	[self addConstraint:botViewHeight];
	[self addConstraint:botViewWidth];
	[self addConstraints:botViewHorizontalConstraints];
	[self addConstraints:botViewVerticalConstraints];
	
	[self layoutIfNeeded];
	_topView.layer.cornerRadius = _topView.bounds.size.height/2;
	_botView.layer.cornerRadius = _botView.bounds.size.height/2;
	
	
	NSLayoutConstraint* midTopLabelH = [NSLayoutConstraint constraintWithItem:_topLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_topView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:.0f];
	NSLayoutConstraint *midTopLabelV = [NSLayoutConstraint constraintWithItem:_topLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_topView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:.0f];
	
	NSLayoutConstraint* midBotLabelH = [NSLayoutConstraint constraintWithItem:_botLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_botView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:.0f];
	NSLayoutConstraint *midBotLabelV = [NSLayoutConstraint constraintWithItem:_botLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_botView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:.0f];
	
	[self layoutIfNeeded];
	[self.topView addConstraint:midTopLabelH];
	[self.topView addConstraint:midTopLabelV];
	[self.botView addConstraint:midBotLabelH];
	[self.botView addConstraint:midBotLabelV];
	
}
@end
