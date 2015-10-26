# stomt iOS-SDK [![Build Status](https://travis-ci.org/stomt/stomt-ios-sdk.svg?branch=master)](https://travis-ci.org/stomt/stomt-ios-sdk) [![Stomt API](https://img.shields.io/badge/stomt-v2.1.X-brightgreen.svg)](https://rest.stomt.com/) [![CocoaPod](https://img.shields.io/cocoapods/v/Stomt-iOS-SDK.svg)](https://github.com/stomt/ios-sdk)

<img alt="Easy integration" src="https://rest.stomt.com/uploads/y8I4/origin/y8I4ZtARHa0ReOOT8SIkZAzDMawN9c671SlEtVVf_origin.png" width="500">

Our SDK allows you to add the feedback solution [www.stomt.com](https://www.stomt.com/) to your iPhone or iPad app. 


To connect your app to stomt, [create a project page on stomt](https://www.stomt.com/createTarget) first.


## Installation

To install the stomt-iOS-SDK you have multiple choices.

### CocoaPods - (Easiest method)

Add the SDK to your app by adding the following line into your Podfile.
```
pod 'Stomt-iOS-SDK', '~> 0.0.x'
```
*(Version can be omitted)*

### Manually

- Issue from command line `git clone https://github.com/stomt/stomt-ios-sdk` to download the github project. 
- Locate `StomtiOS.xcodeproj` in the cloned repo and drag it into your current XCode project. **Be sure to place it outside your project hierarchy!**
- Goto *Build Phases* pane of your app and add **StomtiOS.framework** inside *Link Bynary With Libraries*.

Done!


## Configuration

Import the SDK:

**(If installed via CocoaPods)**
```Objective-C
#import "Stomt.h"
```
**(If installed manually)**
```Objective-C
#import <StomtiOS/Stomt.h>
```

Initialize the framework:
```Objective-C
// Setup Stomt with your AppID
// -> get yours at: https://www.stomt.com/dev/my-apps
//
[Stomt setAppID:@"abcdefghijklmnopqrstuvwxy"];
```


## Documentation

###Common Usages
####Create a stomt
The most common action while using the SDK is to send a Stomt.
```Objective-C
// Open a creation modal for your applications page
// -> the targetID is your pages identifier you can copy it from the pages url
//    https://www.stomt.com/stomt-ios-sdk -> stomt-ios-sdk
//
[Stomt presentStomtCreationPanelWithTargetID:@"stomt-ios-sdk"
							defaultText:@" "
							likeOrWish:kSTObjectWish
							 completionBlock:^(NSError *error, STObject *stomt) {
							 	//Completion block
							 }];
```
####Authenticate
Authentication to Stomt can be accomplished in two ways: 

Via normal OAuth flow, using the handy method `+[Stomt promptAuthenticationIfNecessaryWithCompletionBlock:]

Or via **Facebook connect**. This approach requires some setup, which is explained step-by-step below.

*Setup of the Facebook SDK* - *The complete documentation can be found [here](https://developers.facebook.com/docs/ios)*

1. Go to the [Facebook developers center](https://developers.facebook.com) and register your application. [Snapshot](http://bit.ly/1MfjFRf)
2. In the app's page, navigate in the "Settings" pane. [Snapshot](http://bit.ly/1MPApzd)
3. Click "Add Platform" and after choosing iOS, enter your app's bundle ID. [Snapshot](http://bit.ly/1H59HAw)
4. Download the latest version of the Facebook iOS SDK from [here].(https://developers.facebook.com/docs/ios/downloads) **Warning! Version '20151007' appears to be broken. Confirmed to be working with '20150813'**
5. Link all frameworks and bundles inside the SDK in XCode. [Snapshot](http://bit.ly/1ib0tfu)
6. Insert in the "AppDelegate.m" file `#import <FBSDKCoreKit/FBSDKCoreKit.h>`
7. Implement in the "AppDelegate.m" file the following method:

```Objective-C
- (BOOL)application:(UIApplication *)application
			openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
		 annotation:(id)annotation {
	return [[FBSDKApplicationDelegate sharedInstance] application:application
														  openURL:url
												sourceApplication:sourceApplication
													   annotation:annotation];
}
```
*Login using the Facebook SDK*

1. Insert in "ViewController.m" file:

```Objective-C
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
```
2. Create the login button and set the delegate to **self** *(Ensure that the ViewController class conforms to 'FBSDKLoginButtonDelegate' protocol, and implement the required methods)*:

```Objective-C
	FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
	// Optional: Place the button in the center of your view.
	loginButton.center = self.view.center;
	loginButton.delegate = self;
	[self.view addSubview:loginButton];
```
3. Once the Facebook login has been completed, execute the following code in the *loginButton:didCompleteWithResult:error:* method.

```Objective-C
		StomtRequest* req = [StomtRequest facebookAuthenticationRequestWithAccessToken:result.token.tokenString userID:result.token.userID];
		[req authenticateWithFacebookInBackgroundWithBlock:^(BOOL succeeded, NSError *error, STUser *user) {
			// Code...
		}];
```



## Contribution

We would love to see you contributing to our iOS SDK. Feel free to fork it and we're also awaiting your pull-requests!

## Authors

* [Leonardo Cascianelli](https://github.com/h3xept)
* [Max Klenk](https://github.com/maxklenk)
