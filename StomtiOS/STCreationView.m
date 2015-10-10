//
//  STCreationView.m
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 22/09/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//



#import "STCreationView.h"
#import "STTextView.h"
#import "STCreationTop.h"
#import "STLikeOrWishView.h"
#import "STTargetDisplayer.h"
#import "STTarget.h"
#import "STButtonLabel.h"
#import "STCharCountLabel.h"

@interface STCreationView () <UITextViewDelegate>
- (void)setupSubviews;
- (void)switchStrings;
@end

@implementation STCreationView

- (instancetype)initWithFrame:(CGRect)frame textBody:(NSString*)body likeOrWish:(kSTObjectQualifier)likeOrWish target:(STTarget*)target {
	self = [super initWithFrame:frame];
	self.backgroundColor = [UIColor colorWithRed:236 green:240 blue:241 alpha:1.0];
	self.layer.cornerRadius = 5;
	self.layer.masksToBounds = YES;
	self.translatesAutoresizingMaskIntoConstraints = YES;
	
	if(target)
		self.target = target;
	else goto error;
	
	if(body)
		self.preliminaryBody = body;
	
	if(likeOrWish != kStobjectNil)
	{
		self.type = likeOrWish;
	}
	
	[self setupSubviews];
	return self;

error:
	fprintf(stderr, "Error!");
	return nil;
}

- (void)setupSubviews
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchStrings) name:@"Switch-Strings" object:nil];
	
	if(!self.textView)
		self.textView = [[STTextView alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width-5,self.frame.size.height-self.frame.size.height/2) likeOrWish:self.type];
	self.textView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height-self.textView.bounds.size.height/2);
	self.textView.delegate = self;
	if(!self.charCounter)
	{
		CGSize cSize = [@"-100" sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:8]}];
		
		self.charCounter = [[STCharCountLabel alloc] initWithFrame:CGRectMake(self.bounds.size.width-6-cSize.width, self.bounds.size.height-6-cSize.height, cSize.width, cSize.height) likeOrWish:self.type];
	}
	
	if(self.preliminaryBody)
	{
		[self.textView appendText:self.preliminaryBody];
		[self.charCounter decreaseChars:(int)strlen([self.preliminaryBody UTF8String])];
	}
	[self addSubview:self.textView];
}

- (void)drawRect:(CGRect)rect
{
	CGRect topRect = CGRectMake(0,0,rect.size.width,rect.size.height/5);
	CGRect topRectLabels = CGRectMake(topRect.origin.x+10,topRect.origin.y,topRect.size.width-20,topRect.size.height);
	[STCreationTop drawCanvas1WithFrame:topRect];
	
	CGRect lineRect = CGRectMake(4, self.bounds.size.height-self.charCounter.bounds.size.height-8, self.bounds.size.width-8, 1);
	UIBezierPath *linePath = [UIBezierPath bezierPath];
	[linePath moveToPoint:lineRect.origin];
	[linePath addLineToPoint:CGPointMake(lineRect.size.width,lineRect.origin.y)];
	linePath.lineWidth = 0.40f;
	[[UIColor colorWithRed:0 green:0 blue:0 alpha:0.20] setStroke];
	[linePath stroke];
	
	if(!self.stomtLabel)
		self.stomtLabel = [[UILabel alloc] initWithFrame:topRect];
	self.stomtLabel.textAlignment = NSTextAlignmentCenter;
	self.stomtLabel.text = @"Stomt";
	self.stomtLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12];
	self.stomtLabel.textColor = [UIColor whiteColor];
	
	if(!self.sendLabel)
		self.sendLabel = [[STButtonLabel alloc] initWithFrame:CGRectMake(topRectLabels.size.width+10-[@"Send" sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Medium" size:10]}].width,topRectLabels.origin.y,[@"Send" sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Medium" size:10]}].width,topRectLabels.size.height)];
	self.sendLabel.textAlignment = NSTextAlignmentRight;
	self.sendLabel.text = @"Send";
	self.sendLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:10];
	self.sendLabel.textColor = [UIColor whiteColor];
	
	__block STCreationView* selfObj = self;
	
	self.sendLabel.HandleTapBlock = ^{
		[[NSNotificationCenter defaultCenter] postNotificationName:@"Send-Stomt-Notification" object:nil userInfo:@{@"body":selfObj.textView.text,@"targetID":selfObj.target.identifier,@"likeOrWish":[NSNumber numberWithInteger:selfObj.type]}];
	};
	
	[self addSubview:self.stomtLabel];
	[self addSubview:self.sendLabel];
	
	if(!self.cancelLabel)
		self.cancelLabel = [[STButtonLabel alloc] initWithFrame:CGRectMake(topRectLabels.origin.x,topRectLabels.origin.y,[@"Cancel" sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Medium" size:10]}].width,topRectLabels.size.height)];
	self.cancelLabel.textAlignment = NSTextAlignmentLeft;
	self.cancelLabel.text = @"Cancel";
	self.cancelLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:10];
	self.cancelLabel.textColor = [UIColor whiteColor];
	self.cancelLabel.HandleTapBlock = ^{
		[[NSNotificationCenter defaultCenter] postNotificationName:@"PrepareForDismiss-StomtCreation" object:nil];
	};
	
	if(!self.likeOrWishView)
		self.likeOrWishView = [[STLikeOrWishView alloc] initWithFrame:CGRectMake(10, topRect.size.height+10, 52, 34) likeOrWish:self.type];
	
	if(!self.targetDisplay)
	{
		self.targetDisplay = [[STTargetDisplayer alloc] initWithFrame:CGRectMake(self.likeOrWishView.bounds.size.width + 10+ 20,topRect.size.height+10+(self.likeOrWishView.bounds.size.height/2 - 12),topRect.size.width-self.likeOrWishView.bounds.size.width+40,24) target:self.target];
	}
	
	[self addSubview:self.charCounter];
	[self addSubview:self.targetDisplay];
	[self addSubview:self.stomtLabel];
	[self addSubview:self.sendLabel];
	[self addSubview:self.cancelLabel];
	[self addSubview:self.likeOrWishView];
	
}

- (void)switchStrings
{
	int rt = -1;
	
	self.type = (self.type == kSTObjectLike) ? kSTObjectWish : kSTObjectLike;
	
	NSMutableArray* split = [NSMutableArray arrayWithArray:[self.textView.text componentsSeparatedByString:@" "]];
	if([[split objectAtIndex:0] isEqualToString:@"because"])
	{
		[split removeObjectAtIndex:0];
		[split insertObject:@"would" atIndex:0];
		rt = 1;
	}
	else if([[split objectAtIndex:0] isEqualToString:@"would"])
	{
		[split removeObjectAtIndex:0];
		[split insertObject:@"because" atIndex:0];
		rt = 1;
	}
	if(rt==1)
		self.textView.text = [split componentsJoinedByString:@" "];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
	BOOL rt = NO;
	if(range.length > 0)
	{
		if([text isEqualToString:@""]) [self.charCounter increaseChars:(int)range.length];
		[self.charCounter increaseChars:(int)strlen([text UTF8String])];
		rt = YES;
	}else
	{
		if([[text componentsSeparatedByString:@"\n"] count] == 1)
		{
			if([self.charCounter decreaseChars:(int)strlen([text UTF8String])])
			{
				
				rt = YES;
			}
		}
	}
	
	if(self.charCounter.chars <= 0) self.charCounter.textColor = [UIColor colorWithRed:255.0f/255 green:82.0f/255 blue:82.0f/255 alpha:1.0];
	else self.charCounter.textColor = [UIColor blackColor];
	
	return rt;
}
@end
