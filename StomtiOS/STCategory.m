//
//  STCategory.m
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 12/09/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#import "STCategory.h"
#import "dbg.h"

@implementation STCategory
+ (instancetype)initWithIdentifier:(NSString*)identifier
					   displayName:(NSString*)name
{
	STCategory* category;
	
	if(!identifier || !name) _err("Error in instantiating STCategory object. Args not valid. Aborting...");
	category = [[STCategory alloc] init];
	category.identifier = identifier;
	category.displayName = name;
	
	return category;
	
error:
	return nil;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeObject:_identifier forKey:@"identifier"];
	[aCoder encodeObject:_displayName forKey:@"displayName"];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	if(self)
	{
		_identifier = [aDecoder decodeObjectForKey:@"identifier"];
		_displayName = [aDecoder decodeObjectForKey:@"displayName"];
		return self;
	} _err("Could not init with coder. Aborting...");
error:
	return nil;
}

- (NSString*)description
{
	return [NSString stringWithFormat:@"<STCategory: %@>",_displayName];
}
@end
