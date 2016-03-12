//
//  SimpleButtonDelegate.h
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 12/03/16.
//  Copyright © 2016 Leonardo Cascianelli. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIButton;

@protocol SimpleButtonDelegate <NSObject>
@optional
- (void)buttonTouchUpInside:(UIButton*)button;
@end
