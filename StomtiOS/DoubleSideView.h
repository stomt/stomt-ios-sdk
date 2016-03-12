//
//  DoubleSideView.h
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 01/03/16.
//  Copyright © 2016 Leonardo Cascianelli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DoubleSideView : UIView
@property (nonatomic,strong) UIView* topView;
@property (nonatomic,strong) UIView* botView;
@property (nonatomic,strong) UITapGestureRecognizer* topGestureRecognizer;
@property (nonatomic,strong) UITapGestureRecognizer* botGestureRecognizer;
@property (nonatomic) NSInteger distance;
- (void)shrinkSendingView:(UITapGestureRecognizer*)gestureRecognizer;
@end
