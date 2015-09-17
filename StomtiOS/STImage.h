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
@property (nonatomic,strong) NSString* imageName;
@property (nonatomic,strong) NSURL* url;
- (instancetype)initWithImageName:(NSString *)name;
@end
