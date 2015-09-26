//
//  STViewController.m
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 22/09/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#import "STCreationViewController.h"
#import "STCreationView.h"

CGFloat const ThrowingThreshold = 1000;
CGFloat const ThrowingVelocityPadding = 20;

#define sWidth [UIScreen mainScreen].bounds.size.width
#define sHeight [UIScreen mainScreen].bounds.size.height
#define baseSize CGRectMake(100,100,MAX(sWidth/3,sHeight/3),50)

@interface STCreationViewController ()
- (void)handlePanGesture:(UIPanGestureRecognizer*)gesture;
- (void)returnCenter;
@end

@implementation STCreationViewController

- (instancetype)init
{
	self = [super init];
	
	if(!self.view)
		self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	self.view.backgroundColor = [UIColor clearColor];
	
	self.STView = [[STCreationView alloc] initWithFrame:CGRectMake(0,0,MAX(sWidth/3,sHeight/3),50)];
	self.STView.center = self.view.center;
	
	UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
	[self.STView addGestureRecognizer:pan];
	[self.view addSubview:self.STView];
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.dyAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
	self.originalCenter = self.view.center;
	
}

- (void)handlePanGesture:(UIPanGestureRecognizer*)gesture
{
	CGPoint location = [gesture locationInView:self.view];
	CGPoint boxLocation = [gesture locationInView:self.STView];
 
	switch (gesture.state)
	{
		case UIGestureRecognizerStateBegan:
		{
			[self.dyAnimator removeAllBehaviors];
			UIOffset centerOffset = UIOffsetMake(boxLocation.x - CGRectGetMidX(self.STView.bounds),
												 boxLocation.y - CGRectGetMidY(self.STView.bounds));
			self.attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:self.STView
																offsetFromCenter:centerOffset
																attachedToAnchor:location];
			[self.dyAnimator addBehavior:self.attachmentBehavior];
			break;
		}
		case UIGestureRecognizerStateEnded:
		{
			[self.dyAnimator removeBehavior:self.attachmentBehavior];
			CGPoint velocity = [gesture velocityInView:self.view];
			CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
			
			if (magnitude > ThrowingThreshold)
			{
				UIPushBehavior *pushBehavior = [[UIPushBehavior alloc]
												initWithItems:@[self.STView]
												mode:UIPushBehaviorModeInstantaneous];
				pushBehavior.pushDirection = CGVectorMake((velocity.x / 10) , (velocity.y / 10));
				pushBehavior.magnitude = magnitude / ThrowingVelocityPadding;
				
				self.pushBehavior = pushBehavior;
				[self.dyAnimator addBehavior:self.pushBehavior];
				
				NSInteger angle = arc4random_uniform(20) - 10;
				
				self.itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.STView]];
				self.itemBehavior.friction = 0.2;
				self.itemBehavior.allowsRotation = YES;
				[self.itemBehavior addAngularVelocity:angle forItem:self.STView];
				[self.dyAnimator addBehavior:self.itemBehavior];
			}
			
			else
			{
				[self returnCenter];
			}
			
			break;
		}
		default:
			[self.attachmentBehavior setAnchorPoint:[gesture locationInView:self.view]];
			break;
	}
}

- (void)returnCenter
{
	[self.dyAnimator removeAllBehaviors];
	UISnapBehavior* snap = [[UISnapBehavior alloc] initWithItem:self.STView snapToPoint:self.originalCenter];
	[self.dyAnimator addBehavior:snap];
}

@end
