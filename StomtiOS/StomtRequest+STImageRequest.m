//
//  StomtRequest+STImageRequest.m
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 16/09/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#import "StomtRequest+STImageRequest.h"
#import "StomtRequest.h"
#import "strings.h"
#import "dbg.h"

@implementation StomtRequest (STImageRequest) //Everything will be implemented soon.

+ (StomtRequest*)imageUploadRequestWithImage:(STImage *)image
{
	return nil;
}

- (void)uploadImageInBackgroundWithBlock:(void (^)(NSError *, NSString *))completion
{
	return;
}

@end
