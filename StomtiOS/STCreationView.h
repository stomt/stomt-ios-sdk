//
//  STCreationView.h
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 22/09/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "declarations.h"

@class STTextView;
@class STLikeOrWishView;
@class STTargetDisplayer;
@class STButtonLabel;
@class STTarget;
@class STCharCountLabel;

@interface STCreationView : UIView
@property (nonatomic,strong) UILabel* stomtLabel;
@property (nonatomic,strong) STButtonLabel* sendLabel;
@property (nonatomic,strong) STButtonLabel* cancelLabel;
@property (nonatomic,strong) STLikeOrWishView* likeOrWishView;
@property (nonatomic,strong) STTextView* textView;
@property (nonatomic,strong) STTargetDisplayer* targetDisplay;
@property (nonatomic,strong) STTarget* target;
@property (nonatomic,strong) STCharCountLabel* charCounter;
@property (nonatomic,strong) NSString* preliminaryBody;
@property (nonatomic) kSTObjectQualifier type;
- (instancetype)initWithFrame:(CGRect)frame textBody:(NSString*)body likeOrWish:(kSTObjectQualifier)likeOrWish target:(STTarget*)target;
@end
