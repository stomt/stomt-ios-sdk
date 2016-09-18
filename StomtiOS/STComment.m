//
//  STComment.m
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 17/09/16.
//  Copyright © 2016 Leonardo Cascianelli. All rights reserved.
//

#import "STComment.h"
#import "STTarget.h"

@implementation STComment

+ (instancetype)initWithDictionary:(NSDictionary *)dataDict
{
	@synchronized(self) {
		
	if(!dataDict) { NSLog(@"[!] No data dict provided for STComment. Aborting..."); return nil; }
	
#define ezOut(X) [dataDict objectForKey:X]
	NSString* identifier = ezOut(@"id");
	NSString* text = ezOut(@"text");
	NSDate* createdAt = ezOut(@"created_at");
	BOOL anonym = [ezOut(@"anonym") boolValue];
	BOOL reaction = [ezOut(@"reaction") boolValue];
	BOOL byStomtCreator = [ezOut(@"byStomtCreator") boolValue];
	BOOL byTargetOwner = [ezOut(@"byTargetOwner") boolValue];
	NSInteger amountSubcomments = [ezOut(@"amountSubcomments") integerValue];
	NSInteger amountVotes = [ezOut(@"amountVotes") integerValue];
	NSInteger amountPositive = [ezOut(@"amountPositive") integerValue];
	NSInteger amountNegative = [ezOut(@"amountNegative") integerValue];
	NSArray<STComment*>* subComments = ezOut(@"subs");
	STTarget* creator = [STTarget initWithDataDictionary:ezOut(@"creator")];
#undef ezOut
	
	return [[STComment alloc] initWithIdentifier:identifier commentText:text createdAt:createdAt anonymous:anonym hasBeenReactedTo:reaction isByTheStomtCreator:byStomtCreator isByTargetOwner:byTargetOwner amountOfSubcomments:amountSubcomments amountOfVotes:amountVotes amountOfPositiveVotes:amountPositive amountOfNegativeVotes:amountNegative subcommentsArray:subComments creator:creator];
		
	}
}


- (instancetype)initWithIdentifier:(NSString *)identifier
					   commentText:(NSString *)text
						 createdAt:(NSDate *)createdAt
						 anonymous:(BOOL)anonym
				  hasBeenReactedTo:(BOOL)reaction
			   isByTheStomtCreator:(BOOL)byStomtCreator
				   isByTargetOwner:(BOOL)byTargetOwner
			   amountOfSubcomments:(NSInteger)amountSubcomments
					 amountOfVotes:(NSInteger)amountVotes
			 amountOfPositiveVotes:(NSInteger)amountPositive
			 amountOfNegativeVotes:(NSInteger)amountNegative
				  subcommentsArray:(NSArray *)subComments
						   creator:(STTarget *)creator
{
	if((self = [super init]))
	{
		_identifier = identifier;
		_text = text;
		_createdAt = createdAt;
		_anonym = anonym;
		_reaction = reaction;
		_byStomtCreator = byStomtCreator;
		_byTargetOwner = byTargetOwner;
		_amountSubcomments = amountSubcomments;
		_amountVotes = amountVotes;
		_amountPositive = amountPositive;
		_amountNegative = amountNegative;
		_subComments = subComments;
		_creator = creator;
	}
	return self;
}

@end
