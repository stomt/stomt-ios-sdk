//
//  STViewController.h
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 22/09/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STCreationView;
@interface STCreationViewController : UIViewController

@property (nonatomic, strong) UIView *STView;
@property (nonatomic, assign) CGPoint originalCenter;
@property (nonatomic) UIDynamicAnimator *dyAnimator;
@property (nonatomic) UIAttachmentBehavior *attachmentBehavior;
@property (nonatomic) UIPushBehavior *pushBehavior;
@property (nonatomic) UIDynamicItemBehavior *itemBehavior;
@end
