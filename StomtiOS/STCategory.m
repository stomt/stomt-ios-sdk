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
@end
