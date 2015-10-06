//
//  STViewController.h
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 22/09/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "declarations.h"
#import "block_declarations.h"

@class STCreationView;
@class STTarget;
@class STCreationView;

@interface STCreationViewController : UIViewController

@property (nonatomic, strong) STCreationView *STView;
@property (nonatomic, assign) CGPoint originalCenter;
@property (nonatomic) UIDynamicAnimator *dyAnimator;
@property (nonatomic) UIAttachmentBehavior *attachmentBehavior;
@property (nonatomic) UIPushBehavior *pushBehavior;
@property (nonatomic) UIDynamicItemBehavior *itemBehavior;
@property (nonatomic,strong) UIView* backgroundView;
@property (nonatomic,assign) StomtCreationBlock completionBlock;
- (instancetype)initWithBody:(NSString*)body likeOrWish:(kSTObjectQualifier)likeOrWish target:(STTarget*)target completionBlock:(StomtCreationBlock)completion;
@end
