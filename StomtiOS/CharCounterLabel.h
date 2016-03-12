//
//  CharCounterLabel.h
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 11/03/16.
//  Copyright © 2016 Leonardo Cascianelli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CharCounterLabel : UILabel
- (BOOL)increaseCharsBy:(NSInteger)integer;
- (BOOL)decreaseCharsBy:(NSInteger)integer;
- (void)setupWithDefaultText:(NSString*)defaultText;
@end
