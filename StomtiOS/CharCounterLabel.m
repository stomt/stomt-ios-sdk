//
//  CharCounterLabel.m
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 11/03/16.
//  Copyright © 2016 Leonardo Cascianelli. All rights reserved.
//

#import "CharCounterLabel.h"

@interface CharCounterLabel ()
@property (nonatomic) BOOL restricted;
@property (nonatomic) NSInteger maxChars;
@property (nonatomic) NSInteger charNumber;
@property (nonatomic) NSInteger displayChars;
@end

@implementation CharCounterLabel

- (instancetype)init
{
	if(self = [super init])
	{
		_maxChars = 120;
		_charNumber = 0;
		_restricted = NO;
		_displayChars = _maxChars;
		_restricted = NO;
		
		self.text = [NSString stringWithFormat:@"%ld",(long)_displayChars];
	}
	
	return self;
}

- (BOOL)increaseCharsBy:(NSInteger)integer
{
	if(_charNumber == _maxChars || _charNumber+integer > _maxChars)
		return NO;
	
	if(_maxChars - _charNumber - integer <= 5 && _restricted == NO)
	{
		_restricted = YES;
		self.textColor = [UIColor redColor];
		
	}
	else if(_maxChars - _charNumber - integer > 5 && _restricted == YES)
	{
		_restricted = NO;
		self.textColor = [UIColor blackColor];
	}
	
	_charNumber += integer;
	_displayChars -= integer;
	
	self.text = [NSString stringWithFormat:@"%ld",(long)_displayChars];
	
	return YES;
}

- (BOOL)decreaseCharsBy:(NSInteger)integer
{
	if(_charNumber == 0 || _charNumber-integer < 0)
		return NO;
	
	if(_maxChars - _charNumber + integer <= 5 && _restricted == NO)
	{
		_restricted = YES;
		self.textColor = [UIColor redColor];
		
	}
	else if(_maxChars - _charNumber + integer > 5 && _restricted == YES)
	{
		_restricted = NO;
		self.textColor = [UIColor blackColor];
	}
	
	_charNumber -= integer;
	_displayChars += integer;
	
	self.text = [NSString stringWithFormat:@"%ld",(long)_displayChars];
	
	return YES;
}

- (void)setupWithDefaultText:(NSString *)defaultText
{
	[self increaseCharsBy:defaultText.length];
}

@end
