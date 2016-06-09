//
//  STUser.m
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 11/09/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#import "STUser.h"
#import "strings.h"
#import "dbg.h"

@implementation STUser

- (instancetype)initWithDataDictionary:(NSDictionary *)data
{
	if(!data || ![data count]) _err("No data dictionary provided!");
		
	if([data objectForKey:kD_User])
		self = [super initWithDataDictionary:[data objectForKey:kD_User]];
	else
		self = [super initWithDataDictionary:data];
	
	_accessToken = [data objectForKey:kD_AccessToken];
	_refreshToken = [data objectForKey:kD_RefreshToken];
	_isNewUser = [[data objectForKey:kD_NewUser] boolValue];
	return self;
	
error:
	return nil;
}

+ (instancetype)initWithDataDictionary:(NSDictionary *)data
{
	@synchronized(self)
	{
		if(data)
		{
			STUser* user = [[STUser alloc] initWithDataDictionary:data];
			return user;
		}_err("No data provided for STUser constructor. Aborting...");
		
error:
	return nil;
		
	}
}

+ (instancetype)initWithDictionaryRepresentation:(NSDictionary *)dict
{
	
#define ezOut(X,Y) if([dict objectForKey:Y]) target.X = [dict objectForKey:Y];
	
	if(dict)
	{
		STUser* target = [[STUser alloc] init];
		ezOut(identifier, @"identifier");
		ezOut(displayName, @"displayName");
		ezOut(category, @"category");
		ezOut(profileImage, @"profileImage");
		ezOut(stats, @"stats");
		if([dict objectForKey:@"isVerified"]) target.isVerified = [[dict objectForKey:@"isVerified"] boolValue];
		ezOut(accessToken, @"accessToken");
		ezOut(refreshToken, @"refreshToken");
		if([dict objectForKey:@"isNewUser"]) target.isVerified = [[dict objectForKey:@"isNewUser"] boolValue];
		
#undef ezOut
		
		if(target) return target;
		
	}_err("No dictionary passed. Aborting...");
	
error:
	return nil;
}

- (NSDictionary*)dictionaryRepresentation
{
	NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryRepresentation]];
	
#define ezIn(X,Y) if(X) [dict setObject:X forKey:Y];
	
	ezIn(_accessToken, @"accessToken");
	ezIn(_refreshToken, @"refreshToken");
	ezIn([NSNumber numberWithBool:_isNewUser], @"isNewUser");

#undef ezIn
	if(dict) return dict;
	_err("STUser dictionary representation could not be created. Aborting...");
error:
	return nil;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[super encodeWithCoder:aCoder];
	
	if(_accessToken)
		[aCoder encodeObject:_accessToken forKey:@"accessToken"];
	if(_refreshToken)
		[aCoder encodeObject:_refreshToken forKey:@"refreshToken"];
	
	[aCoder encodeBool:_isNewUser forKey:@"isNewUser"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if(self)
	{
		_accessToken = [aDecoder decodeObjectForKey:@"accessToken"];
		_refreshToken = [aDecoder decodeObjectForKey:@"refreshToken"];
		_isNewUser = [aDecoder decodeBoolForKey:@"isNewUser"];
		
		return self;
		
	}_err("Could not init with coder. Aborting...");
	
error:
	return nil;
}


- (NSString*)description
{
	NSString* name = (self.displayName) ? self.displayName : @"Anonymous User";
	return [NSString stringWithFormat:@"<STUser: %@>",name];
}

@end
