//
//  STQualifierView.h
//  TestView
//
//  Created by Leonardo Cascianelli on 03/10/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "declarations.h"

@interface STQualifierView : UIView
@property (nonatomic,strong) UILabel* label;
@property (nonatomic) kSTObjectQualifier type;
- (instancetype)initWithFrame:(CGRect)frame likeOrWish:(kSTObjectQualifier)qualifier;
@end
