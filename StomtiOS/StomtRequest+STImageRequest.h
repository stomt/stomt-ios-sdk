//
//  StomtRequest+STImageRequest.h
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 16/09/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#import <StomtiOS/StomtiOS.h>

@class STImage;

@interface StomtRequest (STImageRequest)
+ (StomtRequest*)imageUploadRequestWithImage:(STImage*)image;
- (void)uploadImageInBackgroundWithBlock:(void(^)(NSError* error,NSString* imageName))completion;
@end
