//
//  STUser.m
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 11/09/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#import "STUser.h"
#import "strings.h"

@implementation STUser

- (instancetype)initWithDataDictionary:(NSDictionary *)data
{
	self = [super initWithDataDictionary:[data objectForKey:kD_User]];
	self.accessToken = [data objectForKey:kD_AccessToken];
	self.refreshToken = [data objectForKey:kD_RefreshToken];
	self.isNewUser = [[data objectForKey:kD_NewUser] boolValue];
	return self;
}

+ (instancetype)initWithDataDictionary:(NSDictionary *)data
{
	@synchronized(self)
	{
		STUser* user = [[STUser alloc] initWithDataDictionary:data];
		return user;
	}
}

@end
