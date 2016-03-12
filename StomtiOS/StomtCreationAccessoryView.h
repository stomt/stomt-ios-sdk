//
//  StomtCreationAccessoryView.h
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 11/03/16.
//  Copyright © 2016 Leonardo Cascianelli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimpleButtonDelegate.h"

@class CharCounterLabel;

@interface StomtCreationAccessoryView : UIView
@property (nonatomic,strong) UIButton* sendButton;
@property (nonatomic,weak) id<SimpleButtonDelegate> delegate;
- (instancetype)initWithCharCounter:(CharCounterLabel*)charCounter;
@end
