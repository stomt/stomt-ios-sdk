//
//  TempLikeWishView.h
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 09/06/16.
//  Copyright © 2016 Leonardo Cascianelli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LikeWishDelegate.h"

@interface TempLikeWishView : UIView
@property (nonatomic,strong) id <LikeWishDelegate> delegate;
@property (nonatomic,strong) UIView* topView;
@property (nonatomic,strong) UIView* botView;
- (instancetype)initWithTopView:(int)likeOrWish;
- (void)setupWithFrontView:(int)likeOrWish;

@end
