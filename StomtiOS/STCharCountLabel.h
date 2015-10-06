//
//  STCharCountLabel.h
//  TestView
//
//  Created by Leonardo Cascianelli on 05/10/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "declarations.h"

@interface STCharCountLabel : UILabel
@property (nonatomic) int chars;
- (unsigned int)decreaseChars:(int)len;
- (unsigned int)increaseChars:(int)len;
- (instancetype)initWithFrame:(CGRect)frame likeOrWish:(kSTObjectQualifier)likeOrWish;
@end
