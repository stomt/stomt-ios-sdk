//
//  STTargetDisplayer.h
//  TestView
//
//  Created by Leonardo Cascianelli on 03/10/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STTarget;

//
//  STTarget.h
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 11/09/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#import <Foundation/Foundation.h>

@class STCategory;
@class UIImage;
@class STStats;
@class STTarget;
@class STTargetDisplayerContainer;

@interface STTargetDisplayer : UIView
@property (nonatomic) CGRect maxFrame;
@property (nonatomic) CGRect rectFrame;
@property (nonatomic,strong) STTargetDisplayerContainer* container;
- (instancetype)initWithFrame:(CGRect)frame target:(STTarget*)target;
@end
