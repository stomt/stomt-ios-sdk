//
//  StomtCreationViewController.h
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 21/01/2017.
//  Copyright © 2017 Leonardo Cascianelli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "block_declarations.h"

@interface StomtCreationViewController : UIViewController
@property (nonatomic, copy, nullable) StomtCreationBlock completion;
@property (nonatomic) BOOL dismissOnSend;
- (nonnull instancetype)initWithTargetID:(nonnull NSString*)identifier defaultText:(nullable NSString*)defaultText likeOrWish:(NSInteger)likeOrWish;
@end
