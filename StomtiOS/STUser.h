//
//  STUser.h
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 11/09/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#import "STTarget.h"

@interface STUser : STTarget
/// Access token given by stomt.com after loggin in.
@property (nonatomic,strong) NSString* accessToken;
/// Refresh token given by stomt.com after loggin in.
@property (nonatomic,strong) NSString* refreshToken;
/// BOOL to check whether the instance of the user is newly created.
@property (nonatomic) BOOL isNewUser;
@end
