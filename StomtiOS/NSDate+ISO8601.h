//
//  NSDate+ISO8601.h
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 16/09/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (ISO8601)
+ (NSDate*)dateWithISO8601String:(NSString*)date;
@end
