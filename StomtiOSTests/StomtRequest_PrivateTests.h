//
//  StomtRequest_PrivateTests.h
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 03/01/16.
//  Copyright © 2016 Leonardo Cascianelli. All rights reserved.
//

#import "Stomt.h"

@interface StomtRequest(PrivateTests)
+ (StomtRequest*)normalAuthWithUsername:(NSString*)user password:(NSString*)pass;
- (instancetype)initWithApiRequest:(NSURLRequest*)request;
- (void)authenticateWithBlock:(AuthenticationBlock)completion;
@end

