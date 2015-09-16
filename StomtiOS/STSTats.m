//
//  Stats.m
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 12/09/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#import "STSTats.h"

@interface STSTats ()

- (instancetype)initWithFollowers:(NSInteger)followers peopleItFollows:(NSInteger)follows createdStomts:(NSInteger)cStomts receivedStomts:(NSInteger)rStomts;
@end

@implementation STSTats

- (instancetype)init
{
	self = [super init];
	if(self)
	{
		self.followers =
		self.follows =
		self.createdStomts =
		self.receivedStomts = 0;
	}
	return self;
}

- (instancetype)initWithFollowers:(NSInteger)followers peopleItFollows:(NSInteger)follows createdStomts:(NSInteger)cStomts receivedStomts:(NSInteger)rStomts
{
	self = [super init];
	if(self)
	{
		self.followers = followers;
		self.follows = follows;
		self.createdStomts = cStomts;
		self.receivedStomts = rStomts;
	}
	return self;
}

+ (instancetype)initWithStatsDictionary:(NSDictionary*)stats
{
	NSInteger followers = [[stats objectForKey:@"amountFollowers"] integerValue];
	NSInteger follows = [[stats objectForKey:@"amountFollowers"] integerValue];
	NSInteger cStomts = [[stats objectForKey:@"amountFollowers"] integerValue];
	NSInteger rStomts = [[stats objectForKey:@"amountFollowers"] integerValue];
	
	STSTats* statsObject = [[STSTats alloc] initWithFollowers:followers peopleItFollows:follows createdStomts:cStomts receivedStomts:rStomts];
	
	return statsObject;
}
@end
