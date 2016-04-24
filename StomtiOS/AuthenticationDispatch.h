//
//  AuthenticationDispatch.h
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 26/03/16.
//  Copyright © 2016 Leonardo Cascianelli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthenticationDispatch : NSObject
+ (instancetype)sharedInstance;
- (void)handleOpenUrl:(NSURL*)url;
@end
