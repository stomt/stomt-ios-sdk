//
//  STImagePool.m
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 19/06/16.
//  Copyright © 2016 Leonardo Cascianelli. All rights reserved.
//

#import "STImagePool.h"
#import "STImageView.h"
#import "STImage.h"

@interface STImagePool ()
- (void)setup;
@end

@implementation STImagePool
+ (instancetype)sharedInstance
{
	static STImagePool* privateInstance = nil;
	if(!privateInstance)
	{
		privateInstance = [[STImagePool alloc] init];
		[privateInstance setup];
	}
	return privateInstance;
}

- (void)setup
{
	if(!_imagePool)
	{
		_imagePool = [NSMutableDictionary dictionary];
	}

}

- (STImageView*)addToPoolImageView:(STImageView *)imageView
{
	if(!imageView) { fprintf(stderr, "No imageview passed. Aborting...\n"); return nil; }
	NSString* key = [imageView.downloadManager.url absoluteString];
	
	if(![_imagePool objectForKey:key])
		[_imagePool setObject:imageView forKey:key];
	
	return [_imagePool objectForKey:key];
}

@end
