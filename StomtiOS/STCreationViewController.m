//
//  STViewController.m
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 22/09/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//


#define __DBG__

#import "STCreationViewController.h"
#import "STCreationView.h"
#import "STTextView.h"
#import "STTarget.h"
#import "STObject.h"
#import "StomtRequest.h"
#import "dbg.h"

CGFloat const ThrowingThreshold = 1000;
CGFloat const ThrowingVelocityPadding = 20;

#define sWidth [UIScreen mainScreen].bounds.size.width
#define sHeight [UIScreen mainScreen].bounds.size.height
#define baseSize CGRectMake(100,100,MAX(sWidth/3,sHeight/3),50)

@interface STCreationViewController ()
@property (nonatomic) CGSize centerTranslation;
- (void)handlePanGesture:(UIPanGestureRecognizer*)gesture;
- (void)returnCenter;
- (void)keyboardWillShow:(NSNotification*)notification;
- (void)keyboardWillHide:(NSNotification*)notification;
- (void)dismiss;
- (void)sendStomtWithDict:(NSNotification*)notification;
@end

@implementation STCreationViewController

- (instancetype)init
{
	fprintf(stderr, "Init method disabled. Use designated constructor initWithBody:likeOrWIsh:targetID: .");
error:
	return nil;
}

- (instancetype)initWithBody:(NSString*)body likeOrWish:(kSTObjectQualifier)likeOrWish target:(STTarget*)target completionBlock:(StomtCreationBlock)completion
{
	UIPanGestureRecognizer* pan;
	
	self = [super init];
	
	int maxChars = (likeOrWish == kSTObjectLike) ? 100-8 : 100-5;
	if(!body)
	{
		body = @"";
	}
	if(strlen([body UTF8String]) > maxChars) _err("Text needs to be less than %d chars long!",maxChars);
	
	if(!self.view)
		self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	self.view.backgroundColor = [UIColor clearColor];
	
	if(!self.backgroundView)
		self.backgroundView  = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	self.backgroundView.backgroundColor = [UIColor blackColor];
	self.backgroundView.alpha = 0.2;
	
	self.STView = [[STCreationView alloc] initWithFrame:CGRectMake(0,0,sWidth-20,150) textBody:body likeOrWish:likeOrWish target:target];
	self.STView.center = self.view.center;
	
	self.completionBlock = completion;
	
	pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
	[self.STView addGestureRecognizer:pan];
	[self.view addSubview:self.backgroundView];
	[self.view addSubview:self.STView];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(prepareForDismiss) name:@"PrepareForDismiss-StomtCreation" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss) name:@"Dismiss-StomtCreation" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendStomtWithDict:) name:@"Send-Stomt-Notification" object:nil];
	
	self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	self.modalPresentationStyle = UIModalPresentationCustom;
	
	return self;
	
error:
	return nil;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.dyAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
	self.originalCenter = self.view.center;
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[self.STView.textView becomeFirstResponder];
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
				[NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
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

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
	[self dismiss];
}


- (void)keyboardWillShow:(NSNotification *)notification
{
	self.STView.center = CGPointMake(self.STView.center.x,self.STView.center.y - self.STView.frame.size.height/2 - [UIScreen mainScreen].bounds.size.height/12);
	self.originalCenter = self.STView.center;
}

- (void)keyboardWillHide:(NSNotification *)notification
{
	self.STView.center = CGPointMake(self.STView.center.x,self.STView.center.y + self.STView.frame.size.height/2 + [UIScreen mainScreen].bounds.size.height/12);
	self.originalCenter = self.STView.center;
	self.centerTranslation = CGSizeZero;
}

- (void)dismiss
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForDismiss
{
	[self.dyAnimator removeAllBehaviors];
	self.STView.userInteractionEnabled = NO;
	
	UIGravityBehavior* gB = [[UIGravityBehavior alloc] initWithItems:@[self.STView]];
	gB.magnitude = 60.0;
	
	[NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
	[self.dyAnimator addBehavior:gB];
}

- (void)sendStomtWithDict:(NSNotification*)notification//Body:(NSString *)body likeOrWish:(kSTObjectQualifier)likeOrWish targetID:(NSString *)targetID
{
	NSDictionary* userInfo = [notification userInfo];
	STObject* stomtObject = [STObject objectWithTextBody:[userInfo objectForKey:@"body"] likeOrWish:(kSTObjectQualifier)[[userInfo objectForKey:@"likeOrWish"] intValue] targetID:[userInfo objectForKey:@"targetID"]];
	StomtRequest* request = [StomtRequest stomtCreationRequestWithStomtObject:stomtObject];
	
	[request sendStomtInBackgroundWithBlock:self.completionBlock];
	[NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(prepareForDismiss) userInfo:nil repeats:NO];
}

@end
