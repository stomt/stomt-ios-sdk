//
//  STSearchKeywords.m
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 25/09/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#define EnumCount 5

#import "STSearchFilterKeywords.h"
#import "dbg.h"

@interface STSearchFilterKeywords ()
@property (nonatomic,strong) NSMutableArray* keywordsArray;
- (instancetype)initPrivate;
@end

@implementation STSearchFilterKeywords

- (instancetype)init
{
	_err("Init method disabled. Use class constructor.");
error:
	return nil;
}

- (instancetype)initPrivate
{
	self = [super init];
	return self;
}

+ (instancetype)searchFilterWithPositiveKeywords:(STKeywordFilter)positive
								 negatedKeywords:(STKeywordFilter)negated
{
	@synchronized(self)
	{
		STSearchFilterKeywords* privSelf = [[STSearchFilterKeywords alloc] initPrivate];
		
		//Lazy
		if(!privSelf.keywordsArray) privSelf.keywordsArray = [NSMutableArray array];
		
		if(!positive && !negated) _err("No positive nor negated keywords passed. Aborting...");
		
		if(privSelf)
		{
			int STKeywordsArr[2] = {positive,negated};
			for(int e_c = 0; e_c < (sizeof(STKeywordsArr)/sizeof(STKeywordsArr[0])); e_c++)
			{
					if(STKeywordsArr[e_c] & STKeywordFilterReaction)
					{
						if(e_c == 0)
							[privSelf.keywordsArray addObject:@"reaction"];
						else
							[privSelf.keywordsArray addObject:@"!reaction"];
					}
					if(STKeywordsArr[e_c] & STKeywordFilterUrl)
					{
						if(e_c == 0)
							[privSelf.keywordsArray addObject:@"url"];
						else
							[privSelf.keywordsArray addObject:@"!url"];
					}
					if(STKeywordsArr[e_c] & STKeywordFilterVotes)
					{
						if(e_c == 0)
							[privSelf.keywordsArray addObject:@"votes"];
						else
							[privSelf.keywordsArray addObject:@"!votes"];
					}
					if(STKeywordsArr[e_c] & STKeywordFilterLabels)
					{
						if(e_c == 0)
							[privSelf.keywordsArray addObject:@"labels"];
						else
							[privSelf.keywordsArray addObject:@"!labels"];
					}
					if(STKeywordsArr[e_c] & STKeywordFilterImage)
					{
						if(e_c == 0)
							[privSelf.keywordsArray addObject:@"image"];
						else
							[privSelf.keywordsArray addObject:@"!image"];
					}
			}
			
			
			if(!privSelf.keywordFilters) privSelf.keywordFilters = [NSMutableString string];
			
			for(NSString* aStr in privSelf.keywordsArray)
			{
				if(![aStr isEqualToString:[privSelf.keywordsArray lastObject]])
					[privSelf.keywordFilters appendString:[NSString stringWithFormat:@"%@%@",aStr,@","]];
				else
					[privSelf.keywordFilters appendString:aStr];
			}
			
			return privSelf;
			
		}_err("Could not instantiate class.");
		
error:
	return nil;
		
	}

}
@end
