//
//  STImageView.m
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 07/10/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#define __DBG__

#import "STImageView.h"
#import "STImage.h"
#import "dbg.h"

@implementation STImageView

- (instancetype)initWithFrame:(CGRect)frame STImage:(STImage*)stImage placeholder:(UIImage*)placeholder
{
	self = [super initWithFrame:frame];
	
	if(stImage)
	{
		self.downloadManager = stImage;
		if(placeholder) self.placeholder = placeholder;
		
		self.image = self.placeholder;
		
		[self.downloadManager downloadInBackgroundWithBlock:^(NSError* error, NSNumber* success){
			
			dispatch_async(dispatch_get_main_queue(), ^{
				if(success)
					self.image = self.downloadManager.image;
				
			});
			
		}];
		
		self.contentMode = UIViewContentModeScaleAspectFill;
		self.layer.cornerRadius = self.frame.size.width/2;
		self.layer.masksToBounds = YES;
		return self;
	}

error: //FT INTENDED
	return nil;
}

@end
