//
//  HTTPResponseChecker.h
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 12/09/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "declarations.h"

@interface HTTPResponseChecker : NSObject
+ (HTTPERCode)checkResponseCode:(NSURLResponse*)response;
+ (NSError*)errorWithResponseCode:(HTTPERCode)responseCode withData:(NSData*)data;
@end
