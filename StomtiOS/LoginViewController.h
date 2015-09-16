//
//  LoginViewController.h
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 10/09/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "block_declarations.h"

@interface LoginViewController : UINavigationController
@property (nonatomic,strong) BooleanCompletion completionBlock;
@end
