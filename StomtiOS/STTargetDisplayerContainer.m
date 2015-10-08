//
//  STTargetDisplayerContainer.m
//  TestView
//
//  Created by Leonardo Cascianelli on 04/10/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#define threshold 4
#define kPlaceholderImage @"https://rest.stomt.com/uploads/tOBR/s302x302/tOBRT5XdZe4tVPbn74i3EhysW9ZZ9IwNYirm0C5y_s302x302.png"

#import "STTargetDisplayerContainer.h"
#import "STTarget.h"
#import "STImage.h"
#import "STImageView.h"

@interface STTargetDisplayerContainer ()

@end

@implementation STTargetDisplayerContainer

- (instancetype)initWithMaxFrame:(CGRect)frame target:(STTarget *)target
{
	self = [super init];
	

	self.displayName = target.displayName;
	self.maxFrame = frame;
	self.target = target;
	
	if(!self.imageView)
	{
		NSString* imageLocation = ([target.profileImage absoluteString]) ? [target.profileImage absoluteString] : kPlaceholderImage;
		self.imageView = [[STImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMidY(frame)-8, 16, 16) STImage:[[STImage alloc] initWithUrl:[NSURL URLWithString:imageLocation]] placeholder:nil];
	}
	
	if(!self.nameLabel)
	{
		self.nameLabel = [[UILabel alloc] init];
		self.nameLabel.text = target.displayName;
		self.nameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0f];
		self.nameLabel.adjustsFontSizeToFitWidth = NO;
		self.nameLabel.textAlignment = NSTextAlignmentRight;
		self.nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
	}

	[self refresh];
	
	[self addSubview:self.imageView];
	[self addSubview:self.nameLabel];
	
	return self;
}

- (void)refresh
{
	CGSize labSize = [self.displayName sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:12.0f]}];
	
	double finWidth = labSize.width;
	
	if((labSize.width >= self.maxFrame.size.width-self.imageView.frame.size.width-threshold))
	{
		finWidth = (self.maxFrame.size.width-self.imageView.frame.size.width-threshold);
	}
	self.nameLabel.frame = CGRectMake(self.imageView.frame.size.width+threshold, 0, finWidth, self.maxFrame.size.height);
	
	self.frame = CGRectMake(self.maxFrame.origin.x, 0, self.nameLabel.frame.size.width+threshold*3+self.imageView.frame.size.width, self.maxFrame.size.height);
	
	[self.superview performSelectorOnMainThread:@selector(setNeedsDisplay) withObject:nil waitUntilDone:YES];
	
}

- (void)updateDisplayContainerWithTarget:(STTarget *)target
{
	
	self.displayName = target.displayName;
	
	dispatch_async(dispatch_get_main_queue(), ^{
		self.nameLabel.text = target.displayName;
		if(self.imageView) self.imageView = nil;
		
		NSString* imageLocation = ([target.profileImage absoluteString]) ? [target.profileImage absoluteString] : kPlaceholderImage;
		STImage* stImg = [[STImage alloc] initWithUrl:[NSURL URLWithString:imageLocation]];
		self.imageView = [[STImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMidY(self.frame)-8, 16, 16) STImage:stImg placeholder:nil];
		
		[self addSubview:self.imageView];
		[self refresh];
	});

}

@end
