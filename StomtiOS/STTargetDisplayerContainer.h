//
//  STTargetDisplayerContainer.h
//  TestView
//
//  Created by Leonardo Cascianelli on 04/10/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STTarget;

@interface STTargetDisplayerContainer : UIView
@property (nonatomic) CGRect maxFrame;
@property (nonatomic,strong) UIImageView* imageView;
@property (nonatomic,strong) NSString* displayName;
@property (nonatomic,strong) UILabel* nameLabel;
- (instancetype)initWithMaxFrame:(CGRect)frame target:(STTarget*)target;
@end
