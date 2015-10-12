//
//  STLikeOrWishView.m
//  TestView
//
//  Created by Leonardo Cascianelli on 03/10/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#define front CGRectMake(0+self.frame.size.height/4,0,self.frame.size.width,self.frame.size.height-self.frame.size.height/4)
#define back CGRectMake(0,0+self.frame.size.height/4,self.frame.size.width,self.frame.size.height-self.frame.size.height/4)

#define ext_front CGRectMake(-self.frame.size.height/4,self.frame.size.height/8,self.frame.size.width,self.frame.size.height-self.frame.size.height/4)
#define ext_back CGRectMake(+self.frame.size.height/4,self.frame.size.height/8,self.frame.size.width,self.frame.size.height-self.frame.size.height/4)

#import "STLikeOrWishView.h"
#import "STQualifierView.h"

@interface STLikeOrWishView ()

@end

@implementation STLikeOrWishView

- (instancetype)init
{
	NSLog(@"Init method disabled. Use initWithFrame:likeOrWish:");
error:
	return nil;
}

- (instancetype)initWithFrame:(CGRect)frame
{
	NSLog(@"Init method disabled. Use initWithFrame:likeOrWish:");
error:
	return nil;
}

- (instancetype)initWithFrame:(CGRect)frame likeOrWish:(kSTObjectQualifier)likeOrWish
{
	if(likeOrWish != 0)
	{
		self = [super initWithFrame:frame];
		
		self.likeOrWish = likeOrWish;
		
		if(!self.likeView)
		{
			self.likeView = [[STQualifierView alloc] initWithFrame:frame likeOrWish:kSTObjectLike];
		}
		
		if(!self.wishView)
		{
			self.wishView = [[STQualifierView alloc] initWithFrame:frame likeOrWish:kSTObjectWish];
		}
		
		
//		self.likeView.frame = (self.likeOrWish == kSTObjectLike) ? CGRectMake(0,frame.size.height/4,frame.size.width,frame.size.height-frame.size.height/4) :
//		self.wishView.frame = (self.likeOrWish == kSTObjectWish) ? CGRectMake(frame.size.height/4,0,frame.size.width,frame.size.height-frame.size.height/4) : CGRectMake(frame.size.height/4,0,frame.size.width,frame.size.height-frame.size.height/4);
//		

		if(self.likeOrWish == kSTObjectLike)
		{
			self.likeView.frame = CGRectMake(0,frame.size.height/4,frame.size.width,frame.size.height-frame.size.height/4);
			self.wishView.frame = CGRectMake(frame.size.height/4,0,frame.size.width,frame.size.height-frame.size.height/4);
		}
		else
		{
			self.likeView.frame = CGRectMake(frame.size.height/4,0,frame.size.width,frame.size.height-frame.size.height/4);
			self.wishView.frame = CGRectMake(0,frame.size.height/4,frame.size.width,frame.size.height-frame.size.height/4);
		}
		
		switch (self.likeOrWish) {
			case kSTObjectLike:
				[self addSubview:self.wishView];
				[self addSubview:self.likeView];
				self.whichFirst = kSTObjectLike;
				break;
				
			case kSTObjectWish:
				[self addSubview:self.likeView];
				[self addSubview:self.wishView];
				self.whichFirst = kSTObjectWish;
				break;
			case kStobjectNil:
				fprintf(stderr, "Error. kSTObjectNil not handled.");
				break;
		}
		
		
		return self;
	}
	
error:
	return nil;
}

- (void)switchQualifiers
{
	[UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
			if(self.likeView.type == self.whichFirst)
			{
				self.likeView.frame = ext_front;
				self.wishView.frame = ext_back;
			}
			else
			{
				self.likeView.frame = ext_back;
				self.wishView.frame = ext_front;
			}

	} completion:^(BOOL finished) {
		
		if(self.likeView.type == self.whichFirst)
			[self bringSubviewToFront:self.wishView];
		else
			[self bringSubviewToFront:self.likeView];
		
		[UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
			if(self.likeView.type == self.whichFirst)
			{
				self.likeView.frame = front;
				self.wishView.frame = back;
			}
			else
			{
				self.likeView.frame = back;
				self.wishView.frame = front;
			}
		} completion:^(BOOL finished) {
			if(finished)
			{
				self.whichFirst = (self.whichFirst == kSTObjectLike) ? kSTObjectWish : kSTObjectLike;
				[[NSNotificationCenter defaultCenter] postNotificationName:@"Switch-Strings" object:nil];
			}
		}];
		
	}];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self switchQualifiers];
}

@end
