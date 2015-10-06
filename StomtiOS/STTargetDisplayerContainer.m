//
//  STTargetDisplayerContainer.m
//  TestView
//
//  Created by Leonardo Cascianelli on 04/10/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#define threshold 4

#import "STTargetDisplayerContainer.h"
#import "STTarget.h"
#import "STImage.h"

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
		self.imageDownloader = [[STImage alloc] initWithUrl:target.profileImage];
		[self.imageDownloader downloadInBackground];
		
		self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMidY(frame)-8, 16, 16)];
		self.imageView.image = self.imageDownloader.image;
		self.imageView.contentMode = UIViewContentModeScaleAspectFill;
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
		finWidth = (frame.size.width-self.imageView.image.size.width-threshold);
	}
	self.nameLabel.frame = CGRectMake(self.imageView.frame.size.width+threshold, 0, finWidth, frame.size.height);
	
	self.frame = CGRectMake(frame.origin.x, 0, self.nameLabel.frame.size.width+threshold*3+self.imageView.frame.size.width, frame.size.height);
	
	[self addSubview:self.imageView];
	[self addSubview:self.nameLabel];
	
	return self;
}


@end
