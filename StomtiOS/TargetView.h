//
//  TargetView.h
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 03/03/16.
//  Copyright © 2016 Leonardo Cascianelli. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STTarget;
@class STImageView;

@interface TargetView : UIView
@property (nonatomic,strong) UIImageView* targetImage;
@property (nonatomic,strong) UILabel* targetName;
- (void)setupWithTarget:(STTarget*)target;
@end
