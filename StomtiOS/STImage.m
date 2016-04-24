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
	if(self = [super init])
	{
		if(!self) _err("Could not instantiate STImage.");
		if(!name) _err("Could not instantiate STImage. Name is not valid.");
		_imageName = name;
		_url = nil;
	}
	
//Fallthrough intended ->|
error:
	return self;
}

- (instancetype)initWithUrl:(NSURL*)imageUrl
{
	if(!imageUrl) _err("Image URL not provided. Aborting...");
	
	if(self = [super init])
		_url = imageUrl;
	
//Fallthrough intended ->|
error:
	return self;
}

- (void)downloadInBackgroundWithBlock:(BooleanCompletion)completion
{
	@synchronized(self)
	{
		dispatch_async(dispatch_get_global_queue(0,0), ^{
			
			//Asynchronous block ||
			
			NSData * data = [[NSData alloc] initWithContentsOfURL: _url];
			dispatch_async(dispatch_get_main_queue(), ^{
				
				//Asynchronous block ||
				
				if(data)
				{
					self.image = [UIImage imageWithData:data];
					if(completion) completion(nil, [NSNumber numberWithBool:YES]);
					return;
				}
				
				_warn("Could not retrieve data from async request for STImage.");
				NSError* err = [NSError errorWithDomain:@"StomtConnectionDomain"
												   code:0
											   userInfo:@{@"NSLocalizedDescriptionKey":@"The image could not be retrieved from remote server.",
														  @"NSLocalizedFailureReasonErrorKey":[NSNull null],
														  @"NSLocalizedRecoverySuggestionErrorKey":@"Check your firewall and connection. If the error persists, contact @H3xept"}];
				if(completion) completion(err, [NSNumber numberWithBool:NO]);
				
				//!Asynchronous block ||
				
			});
			
			
			//!Asynchronous block ||
			
		});
		
	}
}

@end
