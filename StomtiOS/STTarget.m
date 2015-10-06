//
//  STTarget.m
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 11/09/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#import "STTarget.h"
#import "STCategory.h"
#import "STStats.h"
#import "strings.h"
#import "dbg.h"

@implementation STTarget

- (instancetype)initWithDataDictionary:(NSDictionary*)data
{
	self = [super init];
	if(data){
		self.identifier = [data objectForKey:kD_Id];
		self.displayName = [data objectForKey:kD_DisplayName];
		
		NSDictionary* categoryDict = [data objectForKey:kD_Category];
		self.category = [STCategory initWithIdentifier:[categoryDict objectForKey:kD_Id]
										   displayName:[categoryDict objectForKey:kD_DisplayName]];
		
		self.profileImage = [[[data objectForKey:kD_Images] objectForKey:kD_Profile] objectForKey:kD_Url];
		
		self.stats = [STStats initWithStatsDictionary:[data objectForKey:kD_Stats]];
		self.isVerified = [[data objectForKey:kD_Verified] boolValue];
		
		return self;
	}_err("No data passed in STTarget constructor. Aborting...");
	
error:
	return nil;
}

+ (instancetype)initWithDataDictionary:(NSDictionary *)data
{
	@synchronized(self)
	{
		if(data)
		{
			STTarget* target = [[STTarget alloc] initWithDataDictionary:data];
			return target;
		}_err("No data passed in STTarget constructor. Aborting...");
error:
	return nil;
		
	}

}

+ (instancetype)targetWithDisplayName:(NSString*)displayName identifier:(NSString*)identifier
{
	@synchronized(self)
	{
		if(displayName && identifier)
		{
			STTarget* target = [[STTarget alloc] init];
			target.displayName = displayName;
			target.identifier = identifier;
			return target;
		}_err("Display name and identifier required.");
	}
	
error:
	return nil;
}
@end

