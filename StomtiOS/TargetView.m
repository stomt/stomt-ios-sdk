//
//  TargetView.m
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 03/03/16.
//  Copyright © 2016 Leonardo Cascianelli. All rights reserved.
//

#import "TargetView.h"
#import "Stomt.h"
#import "TargetViewOutline.h"

@interface TargetView ()
@property (nonatomic,strong) STTarget* target;
@end

@implementation TargetView

- (void)setupWithTarget:(STTarget *)target
{
	if(!target)
	{
		fprintf(stderr, "[!] No target provided. Aborting...");
		return;
	}
	
	_target = target;
	STImage* dImage = [[STImage alloc] initWithUrl:_target.profileImage];
	[dImage downloadInBackgroundWithBlock:nil];
	UIImage* placeholderImage = [UIImage imageNamed:@"AnonymousUserImage" inBundle:[NSBundle bundleWithIdentifier:@"com.h3xept.stomtiOS"] compatibleWithTraitCollection:nil];
	
	_targetImage = [[STImageView alloc] initWithImage:dImage placeholder:placeholderImage];
	
	_targetName = [[UILabel alloc] init];
	_targetName.font = [UIFont systemFontOfSize:14];
	_targetName.textColor = [UIColor blackColor];
	_targetName.alpha = .54f;
	_targetName.text = _target.displayName;
	_targetName.lineBreakMode = NSLineBreakByTruncatingTail;
	
	_targetName.translatesAutoresizingMaskIntoConstraints = NO;
	_targetImage.translatesAutoresizingMaskIntoConstraints = NO;
	
	[self addSubview:_targetImage];
	[self addSubview:_targetName];
	
}


- (void)drawRect:(CGRect)rect {
	
	[super drawRect:rect];
	
	NSDictionary* metrics = @{@"circleDiameter":@((rect.size.height-12)), @"maxWidth":@(rect.size.width-16-rect.size.height-12)};
	
	NSArray* vImageConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_targetImage(==circleDiameter)]" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(_targetImage)];
	NSLayoutConstraint* centeredY = [NSLayoutConstraint constraintWithItem:_targetImage attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
	
	NSArray* vLabelConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_targetName]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_targetName)];
	
	NSArray* hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_targetImage(==circleDiameter)]-[_targetName(<=maxWidth)]" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(_targetImage,_targetName)];
	
	[self addConstraints:vImageConstraints];
	[self addConstraints:vLabelConstraints];
	[self addConstraint:centeredY];
	[self addConstraints:hConstraints];
	
	[self layoutIfNeeded];
	
	NSInteger width = rect.size.height+14 + _targetName.bounds.size.width;
	CGRect targetFrame = rect;
	targetFrame.size.width = width;
	
	_targetImage.layer.cornerRadius = _targetImage.bounds.size.width/2;
	_targetImage.layer.masksToBounds = YES;
	
	[TargetViewOutline drawCanvas1WithFrame:targetFrame];

}


@end
