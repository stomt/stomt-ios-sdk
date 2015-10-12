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


@interface STObject () //Internal use only. Use class methods.

- (instancetype)initObjectWithTextBody:(NSString *)body
							likeOrWish:(kSTObjectQualifier)likeOrWish
							  targetID:(NSString*)targetID
								 image:(STImage*)img
								   url:(NSString*)url
						   geoLocation:(CLLocation*)geoLocation;

- (instancetype)initWithDataDictionary:(NSDictionary*)dictionary;

@end

@implementation STObject

#pragma mark Overloaded Constructors

+ (instancetype)objectWithTextBody:(NSString *)body
						likeOrWish:(kSTObjectQualifier)likeOrWish
						  targetID:(NSString *)targetID
{
	STObject* rt = [[STObject alloc] initObjectWithTextBody:body
												 likeOrWish:likeOrWish
												   targetID:targetID
													  image:nil
														url:nil
												geoLocation:nil];
	return rt;
}

+ (instancetype)objectWithTextBody:(NSString *)body
						likeOrWish:(kSTObjectQualifier)likeOrWish
						  targetID:(NSString *)targetID
					   geoLocation:(CLLocation *)geoLocation
{
	STObject* rt = [[STObject alloc] initObjectWithTextBody:body
												 likeOrWish:likeOrWish
												   targetID:targetID
													  image:nil
														url:nil
												geoLocation:geoLocation];
	return rt;
}

+ (instancetype)objectWithTextBody:(NSString *)body
						likeOrWish:(kSTObjectQualifier)likeOrWish
						  targetID:(NSString *)targetID
							 image:(STImage *)img
{
	STObject* rt = [[STObject alloc] initObjectWithTextBody:body
												 likeOrWish:likeOrWish
												   targetID:targetID
													  image:img
														url:nil
												geoLocation:nil];
	return rt;
}

+ (instancetype)objectWithTextBody:(NSString *)body
						likeOrWish:(kSTObjectQualifier)likeOrWish
						  targetID:(NSString *)targetID
							   url:(NSString *)url
{
	STObject* rt = [[STObject alloc] initObjectWithTextBody:body
												 likeOrWish:likeOrWish
												   targetID:targetID
													  image:nil
														url:url
												geoLocation:nil];
	return rt;
}

+ (instancetype)objectWithTextBody:(NSString *)body
						likeOrWish:(kSTObjectQualifier)likeOrWish
						  targetID:(NSString *)targetID
							 image:(STImage *)img
							   url:(NSString *)url
					   geoLocation:(CLLocation *)geoLocation
{
	@synchronized(self)
	{
		STObject* rt = [[STObject alloc] initObjectWithTextBody:body
													 likeOrWish:likeOrWish
													   targetID:targetID
														  image:img
															url:url
													geoLocation:geoLocation];
		return rt;
	}
}

#pragma mark Constructors 

+ (instancetype)objectWithDataDictionary:(NSDictionary *)dictionary
{
	@synchronized(self)
	{
		STObject* rtObject;
		if(!dictionary) _err("No dictionary provided. Aborting...");

		if([dictionary objectForKey:@"data"])
			rtObject = [[STObject alloc] initWithDataDictionary:[dictionary objectForKey:@"data"]];
		else
			rtObject = [[STObject alloc] initWithDataDictionary:dictionary];
		if(rtObject) return rtObject;
		
error:
	return nil;
	}

}

- (instancetype)initObjectWithTextBody:(NSString *)body
							likeOrWish:(kSTObjectQualifier)likeOrWish
							  targetID:(NSString *)targetID
								 image:(STImage *)img
								   url:(NSString *)url
						   geoLocation:(CLLocation *)geoLocation
{
	self = [super init];
	if(!likeOrWish) _err("No like or wish qualifier provided. Aborting...")
	self->_positive = (likeOrWish == kSTObjectLike) ?  YES : NO;
	self.text = body;
	if(!self.text) _err("Chars length exceeded");
	
	self.targetID = targetID;
	if(!self.targetID) _err("TargetID required")
		
	self.image = img;
	self.url = [NSURL URLWithString:url];
	self.geoLocation = geoLocation;
	
	return self;
	
error:
	return nil;
}

- (instancetype)initWithDataDictionary:(NSDictionary *)hDict
{
	self = [super init];
	self.identifier = [hDict objectForKey:@"id"];
	self->_positive = [[hDict objectForKey:@"positive"] boolValue];
	self.text = [hDict objectForKey:@"text"];
	self.createdAt = [NSDate dateWithISO8601String:[hDict objectForKey:@"created_at"]];
	self.anonym = [[hDict objectForKey:@"anonym"] boolValue];
    
    // parse urls to url
    if([hDict objectForKey:@"urls"] != [NSNull null]) {
        NSArray *urls = [hDict objectForKey:@"urls"];
        for (NSURL *oneUrl in urls) {
            self.url = oneUrl;
        }
    }
    
	@try {
		NSDictionary* imagesDict = [NSDictionary dictionaryWithDictionary:[hDict objectForKey:@"images"]];
		NSDictionary* stomtImageDict = [NSDictionary dictionaryWithDictionary:[imagesDict objectForKey:@"stomt"]];
		NSURL* imgUrl = [NSURL URLWithString:[stomtImageDict objectForKey:@"url"]];
		if(imgUrl)
		{
			self.image = [[STImage alloc] initWithUrl:imgUrl];
			[self.image downloadInBackgroundWithBlock:nil];
		}
	}
	@catch (NSException *exception) {
		self.image = nil;
	}
	
	if([hDict objectForKey:@"creator"] != [NSNull null])
		self.creator = [STUser initWithDataDictionary:[hDict objectForKey:@"creator"]];
	if([hDict objectForKey:@"target"] != [NSNull null])
		self.target = [STTarget initWithDataDictionary:[hDict objectForKey:@"target"]];
	
	self.amountOfAgreements = [[hDict objectForKey:@"amountAgreements"] integerValue];
	self.amountOfComments = [[hDict objectForKey:@"amountComments"] integerValue];
	self.agreed = [hDict objectForKey:@"agreed"] ? YES : NO;
	
	return self;
}

- (void)setText:(NSString *)text
{
	//NSInteger chars_required = (self.positive == YES) ? 92 : 94;
	NSInteger chars_required = 100;
	
	if(!([text length] <= chars_required))
		_err("Maximum chars for this stomt: %ld",(long)chars_required);
	_text = text;
	return;
	
error:
	_text = nil;
}
@end
