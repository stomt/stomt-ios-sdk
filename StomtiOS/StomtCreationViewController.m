//
//  StomtCreationViewController.m
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 28/02/16.
//  Copyright © 2016 Leonardo Cascianelli. All rights reserved.
//


#import "StomtCreationViewController.h"
#import "Stomt.h"
#import "DoubleSideView.h"
#import "LikeWishView.h"
#import "TargetView.h"
#import "TargetViewOutline.h"
#import "CharCounterLabel.h"
#import "StomtCreationAccessoryView.h"
#import "SimpleButtonDelegate.h"
#import "TempLikeWishView.h"

@interface StomtCreationViewController () <UITextViewDelegate,SimpleButtonDelegate> {
	CGPoint offset;
}

@property (nonatomic) BOOL keyboardShown;
@property (nonatomic) kSTObjectQualifier likeOrWish;
@property (nonatomic,strong) NSString* defaultText;

@property (nonatomic,strong) IBOutlet UIImageView* userProfileImage;
@property (nonatomic,strong) IBOutlet NSLayoutConstraint* topOffsetUserProfileImage;
@property (nonatomic,strong) IBOutlet UIImageView* closeButton;
@property (nonatomic,strong) IBOutlet UIImageView* anonymousButton;
@property (nonatomic,strong) IBOutlet UILabel* userNameLabel;
@property (nonatomic,strong) STUser* currentUser;
@property (nonatomic,strong) STTarget* target;
@property (nonatomic,strong) IBOutlet TempLikeWishView* likeOrWishView;
@property (nonatomic,strong) IBOutlet TargetView* targetView;
@property (nonatomic,strong) IBOutlet UITextView* textView;
@property (nonatomic,strong) CharCounterLabel* charCounter;
@property (nonatomic,strong) StomtCreationAccessoryView* accessoryView;

- (void)simpleDismiss;

@end

@implementation StomtCreationViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil target:(STTarget *)target defaultText:(NSString *)defaultText likeOrWish:(kSTObjectQualifier)likeOrWish
{
	if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
	{
		_currentUser = [Stomt loggedUser];
		if(!target)
		{
			fprintf(stderr, "[!] No target provided. Aborting...");
			return nil;
		}
		
		_target = target;
		_defaultText = defaultText;
		_likeOrWish = likeOrWish;

	}
	
	return  self;
}

- (void)loadView
{
	UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	scrollView.contentSize = [[UIScreen mainScreen] bounds].size;
	
	UIView* mainView = [[[NSBundle bundleWithIdentifier:@"com.h3xept.StomtiOS"] loadNibNamed:@"StomtCreationViewController" owner:self options:nil] firstObject];
	
	mainView.frame = scrollView.frame;
	[mainView layoutIfNeeded];
	
	scrollView.backgroundColor = [UIColor whiteColor];
	scrollView.scrollEnabled = YES;
	scrollView.alwaysBounceVertical = YES;
	scrollView.bounces = YES;
	scrollView.showsHorizontalScrollIndicator = NO;
	scrollView.showsVerticalScrollIndicator = NO;
	scrollView.contentMode = UIViewContentModeScaleAspectFill;
	scrollView.delegate = self;
	scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
	[scrollView addSubview:mainView];
	
	self.view = scrollView;
	
}
- (void)viewDidLoad {
	
    [super viewDidLoad];

	_textView.delegate = self;
	if(_defaultText)
		_textView.text = _defaultText;
	else
		_textView.text = (_likeOrWish == kSTObjectWish) ? @"would " : @"because ";
	
	_charCounter = [[CharCounterLabel alloc] init];
	[_charCounter setupWithDefaultText:_defaultText];
	_charCounter.font = [UIFont systemFontOfSize:12];
	_charCounter.alpha = .59f;
	
	_accessoryView = [[StomtCreationAccessoryView alloc] initWithCharCounter:_charCounter];
	_accessoryView.delegate = self;
	
	STImage* userImage;
	if(_currentUser)
	{
		userImage = [[STImage alloc] initWithUrl:_currentUser.profileImage];
		[userImage downloadInBackgroundWithBlock:nil];
		_userProfileImage.image = userImage.image;
	}
	else
		_userProfileImage.image = [UIImage imageNamed:@"AnonymousUserImage" inBundle:[NSBundle bundleWithIdentifier:@"com.h3xept.StomtiOS"] compatibleWithTraitCollection:nil];
	
	
	[_likeOrWishView setupWithFrontView:_likeOrWish];
		
	_userProfileImage.layer.cornerRadius = _userProfileImage.bounds.size.width/2;
	_userProfileImage.layer.masksToBounds = YES;
	_userProfileImage.contentMode = UIViewContentModeScaleAspectFit;
	
	_userNameLabel.text = _currentUser.displayName ? _currentUser.displayName : @"Anonymous user" ;
	_userNameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
	
	_anonymousButton.alpha = (_currentUser) ? .54f : .24f;
	_anonymousButton.userInteractionEnabled = (_currentUser) ? YES : NO;
	
	//Temporary
	[_closeButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(simpleDismiss)]];
	
	[_targetView setupWithTarget:_target];

}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	[_textView becomeFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
	BOOL rt = NO;
	
	if([text containsString:@"\n"])
		return rt;
	
	if(range.length > 0 && [_charCounter decreaseCharsBy:range.length] == YES)
	{
		rt = YES;
	}
	else if([_charCounter increaseCharsBy:text.length] == YES)
	{
		rt = YES;
	}
	
	return rt;
}

- (BOOL)canBecomeFirstResponder{
	return YES;
}

- (UIView *)inputAccessoryView{
	return _accessoryView;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
	_keyboardShown = YES;
	
	if([[UIScreen mainScreen] bounds].size.width > [[UIScreen mainScreen] bounds].size.height)
	{
		self->offset = ((UIScrollView*)self.view).contentOffset;
		CGPoint pt;
		CGRect rc = [textView bounds];
		rc = [textView convertRect:rc toView:(UIScrollView*)self.view];
		pt = rc.origin;
		pt.x = 0;
		pt.y -= 60;
		[(UIScrollView*)self.view setContentOffset:pt animated:NO];
	}
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
	[self.view setNeedsLayout];
	_keyboardShown = NO;
}

//Offset related

- (void)textViewDidChange:(UITextView *)textView
{
	if([[UIScreen mainScreen] bounds].size.width > [[UIScreen mainScreen] bounds].size.height)
	{
		self->offset = ((UIScrollView*)self.view).contentOffset;
		CGPoint pt;
		CGRect rc = [textView bounds];
		rc = [textView convertRect:rc toView:(UIScrollView*)self.view];
		pt = rc.origin;
		pt.x = 0;
		pt.y -= 60;
		[(UIScrollView*)self.view setContentOffset:pt animated:YES];
	}
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
	((UIScrollView*)self.view).contentSize = size;
	[self.view setNeedsDisplay];
	[_targetView setNeedsDisplay];
	
	
	if(size.width > size.height)
	{
		_topOffsetUserProfileImage.constant -= 15;
		[self.view layoutIfNeeded];
		
		if(_keyboardShown == YES)
		{
			self->offset = ((UIScrollView*)self.view).contentOffset;
			CGPoint pt;
			CGRect rc = [_textView bounds];
			rc = [_textView convertRect:rc toView:(UIScrollView*)self.view];
			pt = rc.origin;
			pt.x = 0;
			pt.y -= 60;
			[(UIScrollView*)self.view setContentOffset:pt animated:YES];
		}
	}
	else
		_topOffsetUserProfileImage.constant += 15;
}

- (void)buttonTouchUpInside:(UIButton *)button
{
	if([_textView.text isEqualToString:@""] || ([[_textView.text componentsSeparatedByString:@" "] count] == 2 && [[[_textView.text componentsSeparatedByString:@" "] lastObject] isEqualToString:@""]) || ([[_textView.text lowercaseString] isEqualToString:@"would"] || [[_textView.text lowercaseString] isEqualToString:@"because"]))
	   return;
	   
	STObject* object = [STObject objectWithTextBody:_textView.text likeOrWish:_likeOrWish targetID:_target.identifier];
	StomtRequest* stomtRequest = [StomtRequest stomtCreationRequestWithStomtObject:object];
	[stomtRequest sendStomtInBackgroundWithBlock:^(NSError *error, STObject *stomt) {
		if(stomt)
		{
			[self dismissViewControllerAnimated:YES completion:nil];
		}
		else
		{
			fprintf(stderr, "[!] Error in sending stomt. Aborting...");
			[self dismissViewControllerAnimated:YES completion:nil];
		}
	}];
}

- (void)simpleDismiss
{
	[_textView resignFirstResponder];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[self dismissViewControllerAnimated:YES completion:nil];
	});
	
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
