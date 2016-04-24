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
	if(!stImage) _err("No STImage passed, aborting...");
	if(self = [self initWithFrame:frame])
	{
		_downloadManager = stImage;
		_placeholder = (placeholder) ? placeholder : nil;
			
		self.image = (_placeholder) ? _placeholder : nil; //[UIImage image]
			
		[_downloadManager downloadInBackgroundWithBlock:^(NSError* error, NSNumber* success){
				
			//Asynchronous block ||
			dispatch_async(dispatch_get_main_queue(), ^{
					
				if(success)
					self.image = _downloadManager.image;
				
			});
			//!Asynchronous block ||
				
		}];
		
		self.contentMode = UIViewContentModeScaleAspectFill;
		self.layer.cornerRadius = self.frame.size.width/2;
		self.layer.masksToBounds = YES;
		
		return self;
	} _err("Error in instantiating STImageView. Aborting...");

//Fallthrough intended ->|
error:
	return nil;
}


- (instancetype)initWithImage:(STImage *)stImage placeholder:(UIImage *)placeholder
{
	if(!stImage) _err("No STImage passed, aborting...");
	if(self = [self init])
	{
		_downloadManager = stImage;
		_placeholder = (placeholder) ? placeholder : nil;
		
		self.image = (_placeholder) ? _placeholder : nil; //[UIImage image]
		
		[_downloadManager downloadInBackgroundWithBlock:^(NSError* error, NSNumber* success){
			
			//Asynchronous block ||
			dispatch_async(dispatch_get_main_queue(), ^{
				
				if(success)
					self.image = _downloadManager.image;
				
			});
			//!Asynchronous block ||
			
		}];
		
		self.contentMode = UIViewContentModeScaleAspectFill;
		self.layer.cornerRadius = self.frame.size.width/2;
		self.layer.masksToBounds = YES;
		
		return self;
	} _err("Error in instantiating STImageView. Aborting...");
	
//Fallthrough intended ->|
error:
	return nil;
}

- (void)setupWithImage:(STImage *)stImage placeholder:(UIImage *)placeholder
{
	//Refactor someday
	if(!stImage)
	{
		_warn("No STImage passed, aborting...");
		return;
	}
	
	_downloadManager = stImage;
	_placeholder = (placeholder) ? _placeholder : nil;
	
	self.image = _placeholder;
	
	[_downloadManager downloadInBackgroundWithBlock:^(NSError* error, NSNumber* success){
		
		//Asynchronous block ||
		dispatch_async(dispatch_get_main_queue(), ^{
			
			if(success)
				self.image = _downloadManager.image;
			
		});
		//!Asynchronous block ||
	}];
	
	// May be unnecessary but just in case
	self.contentMode = UIViewContentModeScaleAspectFill;
	self.layer.cornerRadius = self.frame.size.width/2;
	self.layer.masksToBounds = YES;
	// May be unnecessary but just in case
	
}

@end
