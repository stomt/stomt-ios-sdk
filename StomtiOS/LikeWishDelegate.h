//
//  LikeWishDelegate.h
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 09/06/16.
//  Copyright © 2016 Leonardo Cascianelli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TempLikeWishView.h"
@class TempLikeWishView;

@protocol LikeWishDelegate <NSObject>
@required
- (void)likeWishView:(TempLikeWishView*)likeWishView changedToState:(int)likeOrWish;
@end
