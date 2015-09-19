//
//  STObject.m
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 15/09/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#define __DBG__

#import "STObject.h"
#import "NSDate+ISO8601.h"
#import "STImage.h"
#import "STUser.h"
#import "STTarget.h"
#import "dbg.h"

@interface STObject ()
- (instancetype)initObjectWithTextBody:(NSString *)body positiveOrWish:(kSTObjectQualifier)positiveOrWish;
@end

@implementation STObject

+ (instancetype)objectWithTextBody:(NSString *)body positiveOrWish:(kSTObjectQualifier)positiveOrWish
{
	STObject* rt = [[STObject alloc] initObjectWithTextBody:body positiveOrWish:positiveOrWish];
	return rt;
}

+ (instancetype)objectWithDataDictionary:(NSDictionary *)dictionary
{
	STObject* rtObject = [[STObject alloc] initWithDataDictionary:dictionary];
	if(rtObject) return rtObject;
error:
	return nil;
}

- (instancetype)initObjectWithTextBody:(NSString *)body positiveOrWish:(kSTObjectQualifier)positiveOrWish
{
	self = [super init];
	self.positive = (positiveOrWish == kSTObjectPositive) ?  YES : NO;
	self.text = body;
	if(!self.text) _err("Chars length exceeded");
	return self;
error:
	return nil;
}

- (instancetype)initWithDataDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	NSDictionary* hDict = [NSDictionary dictionaryWithDictionary:[dictionary objectForKey:@"data"]];
	self.identifier = [hDict objectForKey:@"id"];
	self.positive = [hDict objectForKey:@"positive"];
	self.text = [hDict objectForKey:@"text"];
	self.createdAt = [NSDate dateWithISO8601String:[hDict objectForKey:@"created_at"]];
	self.anonym = [hDict objectForKey:@"anonym"];
	
	@try {
		NSDictionary* imagesDict = [NSDictionary dictionaryWithDictionary:[hDict objectForKey:@"images"]];
		NSDictionary* stomtImageDict = [NSDictionary dictionaryWithDictionary:[imagesDict objectForKey:@"stomt"]];
		NSURL* imgUrl = [NSURL URLWithString:[stomtImageDict objectForKey:@"url"]];
		if(imgUrl)
		{
			self.image = [[STImage alloc] initWithUrl:imgUrl];
			[self.image downloadInBackground];
		}
	}
	@catch (NSException *exception) {
		self.image = nil;
	}

	self.creator = [STUser initWithDataDictionary:[hDict objectForKey:@"creator"]];
	self.target = [STTarget initWithDataDictionary:[hDict objectForKey:@"target"]];
	self.amountOfAgreements = [[hDict objectForKey:@"amountAgreements"] integerValue];
	self.amountOfComments = [[hDict objectForKey:@"amountComments"] integerValue];
	self.agreed = [hDict objectForKey:@"agreed"] ? YES : NO;
	return self;
}

- (void)setText:(NSString *)text
{
	NSInteger chars_required = (self.positive == YES) ? 92 : 94;
	if(!([text length] <= chars_required))
		_err("Maximum chars for this stomt: %ld",(long)chars_required);
	_text = text;
	return;
error:
	_text = nil;
}
@end
