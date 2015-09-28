//
//  STImage.m
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 16/09/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#import "STImage.h"
#import "Stomt.h"
#import "dbg.h"
#import "strings.h"

@interface STImage ()
- (void)downloadInBackground;
@end

@implementation STImage
- (instancetype)init
{
	_err("Use class initializer -[[STImage alloc] initWithImage:(UIImage*)]");
error:
	return nil;
}

- (instancetype)initWithStomtImageName:(NSString *)name
{
	self = [super init];
	if(!self) _err("Could not instantiate STImage.");
	if(!name) _err("Could not instantiate STImage. Name is not valid.");
	self.imageName = name;
	self.url = nil;
	
	return self;

error:
	return nil;
}

- (instancetype)initWithUrl:(NSURL*)imageUrl
{
	self = [super init];
	
	if(imageUrl)
	{
		self.url = imageUrl;
		return self;
	}
	
	_err("Could not instantiate STImage. ImageUrl not valid.");
error:
	return nil;
}

- (void)downloadInBackground
{
	@synchronized(self)
	{
		dispatch_async(dispatch_get_global_queue(0,0), ^{
			NSData * data = [[NSData alloc] initWithContentsOfURL: self.url];
			dispatch_async(dispatch_get_main_queue(), ^{
				if(data) self.image = [UIImage imageWithData:data];
				else fprintf(stderr,"Could not retrieve data from async request for STImage.");
			});
		});
	}
}
@end
