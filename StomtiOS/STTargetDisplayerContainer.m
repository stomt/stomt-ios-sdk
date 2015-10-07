//
//  STTargetDisplayerContainer.m
//  TestView
//
//  Created by Leonardo Cascianelli on 04/10/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#define threshold 4
#define kPlaceholderImage @"https://scontent-frt3-1.xx.fbcdn.net/hphotos-xap1/v/t1.0-9/18484_956324564401523_8885595067265640344_n.jpg?oh=8f0fd86da670f821cc30dd42efeb4a5c&oe=568B972E"

#import "STTargetDisplayerContainer.h"
#import "STTarget.h"
#import "STImage.h"
#import "STImageView.h"

@interface STTargetDisplayerContainer ()
@property (nonatomic,strong) STImage* imageDownloader;
@end

@implementation STTargetDisplayerContainer

- (instancetype)initWithMaxFrame:(CGRect)frame target:(STTarget *)target
{
	self = [super init];
	
	self.displayName = target.displayName;
	
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
	
	CGSize labSize = [self.displayName sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:12.0f]}];
	
	double finWidth = labSize.width;
	
	if((labSize.width >= frame.size.width-self.imageView.image.size.width-threshold))
	{
		finWidth = (frame.size.width-self.imageView.bounds.size.width-threshold);
	}
	self.nameLabel.frame = CGRectMake(self.imageView.frame.size.width+threshold, 0, finWidth, frame.size.height);
	
	self.frame = CGRectMake(frame.origin.x, 0, self.nameLabel.frame.size.width+threshold*3+self.imageView.frame.size.width, frame.size.height);
	
	[self addSubview:self.imageView];
	[self addSubview:self.nameLabel];
	
	return self;
}


@end
