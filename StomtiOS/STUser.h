//
//  STUser.h
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 11/09/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#import "STTarget.h"

@interface STUser : STTarget
@property (nonatomic,strong) NSString* accessToken;
@property (nonatomic,strong) NSString* refreshToken;
@property (nonatomic) BOOL isNewUser;
@end
