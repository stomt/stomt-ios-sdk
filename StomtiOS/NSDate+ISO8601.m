//
//  NSDate+ISO8601.m
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 16/09/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#import "NSDate+ISO8601.h"

@implementation NSDate (ISO8601)
+ (NSDate*)dateWithISO8601String:(NSString*)date
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
	return [dateFormatter dateFromString:date];
}
@end
