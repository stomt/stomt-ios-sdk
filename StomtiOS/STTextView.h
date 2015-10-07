//
//  STTextView.h
//  TestView
//
//  Created by Leonardo Cascianelli on 03/10/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "declarations.h"

@interface STTextView : UITextView
@property (nonatomic) unsigned int lines;
- (void)appendText:(NSString*)text;
- (instancetype)initWithFrame:(CGRect)frame likeOrWish:(kSTObjectQualifier)likeOrWish;
@end
