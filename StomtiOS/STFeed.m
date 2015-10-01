//
//  STFeed.m
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 24/09/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#import "STFeed.h"
#import "STSearchFilterKeywords.h"
#import "STObject.h"
#import "dbg.h"

@interface STFeed ()

- (instancetype)initWithTerm:(NSString *)term
				   belongsTo:(NSString *)belongsTargetID
		  directlyReceivedBy:(NSArray *)directTargetIDs
					  sentBy:(NSArray *)fromTargetIDs
			  filterKeywords:(STSearchFilterKeywords *)keywords
				  likeOrWish:(kSTObjectQualifier)likeOrWish
			  containsLabels:(NSArray *)labels;

- (instancetype)initFeedWithStomtsArray:(NSArray*)array;

@end

@implementation STFeed

+ (instancetype)feedWithTerm:(NSString *)term
{
	STFeed* privFeed = [[STFeed alloc] initWithTerm:term
										  belongsTo:nil
								 directlyReceivedBy:nil
											 sentBy:nil
									 filterKeywords:nil
										 likeOrWish:kStobjectNil
									 containsLabels:nil];
	if(privFeed) return  privFeed;
	
error: // FT Intended
	return nil;
}

+ (instancetype)feedWhichBelongsTo:(NSString *)belongsTargetID
{
	STFeed* privFeed = [[STFeed alloc] initWithTerm:nil
										  belongsTo:belongsTargetID
								 directlyReceivedBy:nil
											 sentBy:nil
									 filterKeywords:nil
										 likeOrWish:kStobjectNil
									 containsLabels:nil];
	if(privFeed) return  privFeed;
	
error: // FT Intended
	return nil;
}

+ (instancetype)feedWhichContainsLabels:(NSArray *)labels
{
	STFeed* privFeed = [[STFeed alloc] initWithTerm:nil
										  belongsTo:nil
								 directlyReceivedBy:nil
											 sentBy:nil
									 filterKeywords:nil
										 likeOrWish:kStobjectNil
									 containsLabels:labels];
	if(privFeed) return  privFeed;
	
error: // FT Intended
	return nil;
}

+ (instancetype)feedWithFilterKeywords:(STSearchFilterKeywords *)keywords
{
	STFeed* privFeed = [[STFeed alloc] initWithTerm:nil
										  belongsTo:nil
								 directlyReceivedBy:nil
											 sentBy:nil
									 filterKeywords:keywords
										 likeOrWish:kStobjectNil
									 containsLabels:nil];
	if(privFeed) return  privFeed;
	
error: // FT Intended
	return nil;
}

+ (instancetype)feedWithLikeOrWish:(kSTObjectQualifier)likeOrWish
{
	STFeed* privFeed = [[STFeed alloc] initWithTerm:nil
										  belongsTo:nil
								 directlyReceivedBy:nil
											 sentBy:nil
									 filterKeywords:nil
										 likeOrWish:likeOrWish
									 containsLabels:nil];
	if(privFeed) return  privFeed;
	
error: // FT Intended
	return nil;
}

+ (instancetype)feedWithStomtsDirectlyReceivedBy:(NSArray *)directTargetIDs
{
	STFeed* privFeed = [[STFeed alloc] initWithTerm:nil
										  belongsTo:nil
								 directlyReceivedBy:directTargetIDs
											 sentBy:nil
									 filterKeywords:nil
										 likeOrWish:kStobjectNil
									 containsLabels:nil];
	if(privFeed) return  privFeed;
	
error: // FT Intended
	return nil;
}

+ (instancetype)feedFrom:(NSArray*)IDs
{
	STFeed* privFeed = [[STFeed alloc] initWithTerm:nil
										  belongsTo:nil
								 directlyReceivedBy:nil
											 sentBy:IDs
									 filterKeywords:nil
										 likeOrWish:kStobjectNil
									 containsLabels:nil];
	if(privFeed) return  privFeed;
	
error: // FT Intended
	return nil;
}

+ (instancetype)feedWithTerm:(NSString *)term
				   belongsTo:(NSString *)belongsTargetID
		  directlyReceivedBy:(NSArray *)directTargetIDs
					  sentBy:(NSArray *)fromTargetIDs
			  filterKeywords:(STSearchFilterKeywords *)keywords
				  likeOrWish:(kSTObjectQualifier)likeOrWish
			  containsLabels:(NSArray *)labels
{
	STFeed* privFeed = [[STFeed alloc] initWithTerm:term
										  belongsTo:belongsTargetID
								 directlyReceivedBy:directTargetIDs
											 sentBy:fromTargetIDs
									 filterKeywords:keywords
										 likeOrWish:likeOrWish
									 containsLabels:labels];
	if(privFeed) return  privFeed;
	
error: // FT Intended
	return nil;
}

+ (instancetype)feedWithStomtsArray:(NSArray *)array
{
	STFeed* feed;
	if(!array) _err("No array provided for STFeed constructor. Aborting...");
	feed = [[STFeed alloc] initFeedWithStomtsArray:array];
	if(feed) return feed;
	_err("Could not instantiate STFeed object. Aborting...");
error:
	return nil;
}

- (instancetype)initFeedWithStomtsArray:(NSArray *)array
{
	self = [super init];
	if(!self.stomts) self.stomts = [NSMutableArray array];
	for(NSDictionary* stDict in array)
	{
		STObject* obj = [STObject objectWithDataDictionary:stDict];
		
		[self.stomts addObject:obj];
	}
	return self;
}

- (instancetype)initWithTerm:(NSString *)term
				   belongsTo:(NSString *)belongsTargetID
		  directlyReceivedBy:(NSArray *)directTargetIDs
					  sentBy:(NSArray *)fromTargetIDs
			  filterKeywords:(STSearchFilterKeywords *)keywords
				  likeOrWish:(kSTObjectQualifier)likeOrWish
			  containsLabels:(NSArray *)labels
{
	self = [super init];
	if(!self.params) self.params = [NSMutableDictionary dictionary];
	if(term) [self.params setObject:term forKey:@"q"];
	if(belongsTargetID)[self.params setObject:belongsTargetID forKey:@"at"];
	if(directTargetIDs)
	{
		NSMutableString* directStr = [NSMutableString string];
		for(int c = 0; c < [directTargetIDs count]; c++)
		{
			if([[directTargetIDs objectAtIndex:c] isEqualToString:[directTargetIDs lastObject]])
				[directStr appendString:[NSString stringWithFormat:@"%@",[directTargetIDs objectAtIndex:c]]];
			
			else [directStr appendString:[NSString stringWithFormat:@"%@,",[directTargetIDs objectAtIndex:c]]];
		}
		[self.params setObject:directStr forKey:@"to"];
	}
	if(fromTargetIDs)
	{
		NSMutableString* fromStr = [NSMutableString string];
		for(int c = 0; c < [fromTargetIDs count]; c++)
		{
			if([[fromTargetIDs objectAtIndex:c] isEqualToString:[fromTargetIDs lastObject]])
				[fromStr appendString:[NSString stringWithFormat:@"%@",[fromTargetIDs objectAtIndex:c]]];
			
			else [fromStr appendString:[NSString stringWithFormat:@"%@,",[fromTargetIDs objectAtIndex:c]]];
		}
		[self.params setObject:fromStr forKey:@"from"];
	}
	if(keywords)
	{
		[self.params setObject:keywords.keywordFilters forKey:@"has"];
	}
	if(likeOrWish)
	{
			NSString* likeStr = (likeOrWish == kSTObjectLike) ? @"like" : @"wish";
			[self.params setObject:likeStr forKey:@"is"];
	}
	if(labels)
	{
		NSMutableString* labelsStr = [NSMutableString string];
		for(int c = 0; c < [labels count]; c++)
		{
			if([[labels objectAtIndex:c] isEqualToString:[labels lastObject]])
				[labelsStr appendString:[NSString stringWithFormat:@"%@",[labels objectAtIndex:c]]];
			
			else [labelsStr appendString:[NSString stringWithFormat:@"%@,",[labels objectAtIndex:c]]];
		}
		[self.params setObject:labelsStr forKey:@"label"];
	}
	return self;
}

@end
