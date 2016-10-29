//
//  StomtCreationAccessoryView.m
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 11/03/16.
//  Copyright © 2016 Leonardo Cascianelli. All rights reserved.
//

#import "StomtCreationAccessoryView.h"
#import "CharCounterLabel.h"

@interface StomtCreationAccessoryView() <SimpleButtonDelegate>
@property (nonatomic,weak) CharCounterLabel* charCounter;
- (void)buttonPressed;
@end

@implementation StomtCreationAccessoryView

- (instancetype)initWithCharCounter:(CharCounterLabel*)charCounter
{
	if(self = [super initWithFrame:CGRectMake(0, 0, 0, 40)])
	{
		_sendButton = [UIButton buttonWithType:UIButtonTypeCustom];

		NSBundle* designedBundle = [NSBundle bundleWithIdentifier:@"com.h3xept.StomtiOS"] ? [NSBundle bundleWithIdentifier:@"com.h3xept.StomtiOS"] : [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"Stomt-iOS-SDK" ofType:@"bundle"]];
		
		[_sendButton setImage:[UIImage imageNamed:@"SendButton" inBundle:designedBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
		_sendButton.translatesAutoresizingMaskIntoConstraints = NO;
		[_sendButton addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
		self.backgroundColor = [UIColor whiteColor];
		
		if(charCounter) {
			_charCounter = charCounter;
			_charCounter.translatesAutoresizingMaskIntoConstraints = NO;
			[self addSubview:_charCounter];
		}
		[self addSubview:_sendButton];
		

	}
	return self;
}

- (void)drawRect:(CGRect)rect {
	
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_sendButton]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_sendButton)]];
	
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_charCounter]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_charCounter)]];
	
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_charCounter]-[_sendButton]-(<=8)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_sendButton,_charCounter)]];
	
	
}

- (void)buttonPressed
{
	if(!_delegate)
	{
		fprintf(stderr, "[!] No delegate set. Aborting...");
		return;
	}
	
	if([_delegate respondsToSelector:@selector(buttonTouchUpInside:)])
	{
		[_delegate buttonTouchUpInside:_sendButton];
		_sendButton.userInteractionEnabled = NO;
	}
	
}

- (BOOL)canBecomeFirstResponder
{
	return YES;
}

@end
