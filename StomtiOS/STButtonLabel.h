//
//  STButtonLabel.h
//  TestView
//
//  Created by Leonardo Cascianelli on 04/10/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STButtonLabel : UILabel
@property (nonatomic,copy) void (^HandleTapBlock)();
@property (nonatomic,strong) NSTimer* highlightTimer;
@end
