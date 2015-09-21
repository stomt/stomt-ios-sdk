//
//  STTarget.m
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 11/09/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#import "STTarget.h"
#import "STCategory.h"
#import "STSTats.h"
#import "strings.h"

@implementation STTarget

- (instancetype)initWithDataDictionary:(NSDictionary*)data
{
	self = [super init];
	
	self.identifier = [data objectForKey:kD_Id];
	self.displayName = [data objectForKey:kD_DisplayName];
	
	NSDictionary* categoryDict = [data objectForKey:kD_Category];
	self.category = [STCategory initWithIdentifier:[categoryDict objectForKey:kD_Id] displayName:[categoryDict objectForKey:kD_DisplayName]];
	
	self.profileImage = [[[data objectForKey:kD_Images] objectForKey:kD_Profile] objectForKey:kD_Url];
	
	self.stats = [STSTats initWithStatsDictionary:[data objectForKey:kD_Stats]];
	self.isVerified = [[data objectForKey:kD_Verified] boolValue];
	
	return self;
}

+ (instancetype)initWithDataDictionary:(NSDictionary *)data
{
	STTarget* target = [[STTarget alloc] initWithDataDictionary:data];
	return target;
}
@end

