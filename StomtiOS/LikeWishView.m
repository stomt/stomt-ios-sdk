//
//  LikeWishView.m
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 02/03/16.
//  Copyright © 2016 Leonardo Cascianelli. All rights reserved.
//

#define kWishColor [UIColor colorWithRed:0.565 green:0.075 blue:0.996 alpha:1]
#define kLikeColor [UIColor colorWithRed:0.314 green:0.89 blue:0.761 alpha:1]

#import "LikeWishView.h"

@implementation LikeWishView

- (void)setupWithIdentifier:(kSTObjectQualifier)likeOrWish
{
	NSString* identifier;
	
	if(likeOrWish == kSTObjectLike)
	{
		self.backgroundColor = kLikeColor;
		identifier = @"I like";
	}
	else
	{
		self.backgroundColor = kWishColor;
		identifier = @"I wish";
	}
	
	UILabel* identifierLabel = [[UILabel alloc] init];
	identifierLabel.text = identifier;
	identifierLabel.font = [UIFont systemFontOfSize:16];
	identifierLabel.textAlignment = NSTextAlignmentCenter;
	identifierLabel.textColor = [UIColor whiteColor];
	identifierLabel.translatesAutoresizingMaskIntoConstraints = NO;
	
	[self addSubview:identifierLabel];
	
	NSArray* hConstraintsArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[identifierLabel]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(identifierLabel)];
	NSArray* vConstraintsArray = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[identifierLabel]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(identifierLabel)];
	
	[self addConstraints:hConstraintsArray];
	[self addConstraints:vConstraintsArray];
}

@end
