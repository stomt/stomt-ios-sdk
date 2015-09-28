//
//  STImage.h
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 16/09/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIImage;

@interface STImage : NSObject

///The actual image.
@property (nonatomic,strong) UIImage* image;

/// The image name, associated with the image on Stomt servers.
@property (nonatomic,strong) NSString* imageName;

///The image URL on Stomt servers.
@property (nonatomic,strong) NSURL* url;


- (instancetype)initWithStomtImageName:(NSString *)name;
- (instancetype)initWithUrl:(NSURL*)imageUrl;

/*!
 
 @brief Asynchronously download the image.
 
 */
- (void)downloadInBackground;
@end
