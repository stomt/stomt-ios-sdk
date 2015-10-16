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
#import "StomtRequest.h"

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
		
		// TODO: Optimize -> Images array
		self.profileImage = [NSURL URLWithString:[[[data objectForKey:kD_Images] objectForKey:kD_Profile] objectForKey:kD_Url]];
		if(!self.profileImage)
			self.profileImage = [NSURL URLWithString:[[[data objectForKey:kD_Images] objectForKey:kD_Avatar] objectForKey:kD_Url]];
		// --
		
		self.stats = [STStats initWithStatsDictionary:[data objectForKey:kD_Stats]];
		self.isVerified = [[data objectForKey:kD_Verified] boolValue];
		
		return self;
	}_err("No data passed in STTarget constructor. Aborting...");
	
error:
	return nil;
}

- (NSDictionary*)dictionaryRepresentation
{
	
#define ezIn(X,Y) if(X) [dict setObject:X forKey:Y];
	
	NSMutableDictionary* dict = [NSMutableDictionary dictionary];
	ezIn(self.identifier, @"identifier");
	ezIn(self.displayName, @"displayName");
	ezIn(self.category, @"category");
	ezIn(self.profileImage, @"profileImage");
	ezIn(self.stats, @"stats");
	ezIn([NSNumber numberWithBool:self.isVerified], @"isVerified");
	
#undef ezIn
	
	if(dict) return dict;
	_err("STTarget dictionary representation could not be created. Aborting...");
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

+ (instancetype)initWithDictionaryRepresentation:(NSDictionary *)dict
{
	
#define ezOut(X,Y) if([dict objectForKey:Y]) target.X = [dict objectForKey:Y];
	
	if(dict)
	{
		STTarget* target = [[STTarget alloc] init];
		ezOut(identifier, @"identifier");
		ezOut(displayName, @"displayName");
		ezOut(category, @"category");
		ezOut(profileImage, @"profileImage");
		ezOut(stats, @"stats");
		if([dict objectForKey:@"isVerified"]) target.isVerified = [[dict objectForKey:@"isVerified"] boolValue];
		
#undef ezOut
		
		if(target) return target;
		
	}_err("No dictionary passed. Aborting...");
	
error:
	return nil;
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

+ (void)retrieveEssentialTargetWithTargetID:(NSString *)identifier completionBlock:(TargetRequestBlock)completion
{
	StomtRequest* tarRequest = [StomtRequest basicTargetRequestWithTargetID:identifier];
	[tarRequest requestBasicTargetInBackgroundWithBlock:completion];
}

@end

