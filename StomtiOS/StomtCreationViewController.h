//
//  StomtCreationViewController.h
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 28/02/16.
//  Copyright © 2016 Leonardo Cascianelli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "declarations.h"

@class STTarget;

@interface StomtCreationViewController : UIViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil target:(STTarget *)target defaultText:(NSString *)defaultText likeOrWish:(kSTObjectQualifier)likeOrWish;
@end
