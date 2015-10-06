//
//  STLikeOrWishView.h
//  TestView
//
//  Created by Leonardo Cascianelli on 03/10/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "declarations.h"

@class STQualifierView;

@interface STLikeOrWishView : UIView
@property (nonatomic,strong) STQualifierView* likeView;
@property (nonatomic,strong) STQualifierView* wishView;
@property (nonatomic) kSTObjectQualifier likeOrWish;
@property (nonatomic) kSTObjectQualifier whichFirst;
- (instancetype)initWithFrame:(CGRect)frame likeOrWish:(kSTObjectQualifier)likeOrWish;
- (void)switchQualifiers;
@end
