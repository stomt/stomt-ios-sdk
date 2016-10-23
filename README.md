# stomt iOS-SDK [![Build Status](https://travis-ci.org/stomt/stomt-ios-sdk.svg?branch=master)](https://travis-ci.org/stomt/stomt-ios-sdk) [![Stomt API](https://img.shields.io/badge/stomt-v2.1.X-brightgreen.svg)](https://rest.stomt.com/) [![CocoaPod](https://img.shields.io/cocoapods/v/Stomt-iOS-SDK.svg)](https://github.com/stomt/ios-sdk)

<img alt="Easy integration" src="https://github.com/stomt/stomt-ios-sdk/blob/master/createStomt.gif" align="right" width="300">

Our SDK allows you to add the feedback solution [www.stomt.com](https://www.stomt.com/) to your iPhone or iPad app. 


To connect your app to stomt, [create a project page on stomt](https://www.stomt.com/createTarget) first.


## Installation

To install the stomt-iOS-SDK you have multiple choices.

### CocoaPods - (Easiest method)

Add the SDK to your app by adding the following line into your Podfile.
```
pod 'Stomt-iOS-SDK', '~> 0.0.x'
```

### Versioning for pod

From version *2.0.2* the pod works for iOS 8/9/10 seamlessly.

### Manually

- Issue from command line `git clone https://github.com/stomt/stomt-ios-sdk` to download the github project. 
- Locate `StomtiOS.xcodeproj` in the cloned repo and drag it into your current Xcode project. **Be sure to place it outside your project hierarchy!**
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
[Stomt presentStomtCreationPanelWithTargetID:@"target-id" 
				defaultText:@"..."
				 likeOrWish:kSTObjectWish 
			 fromViewController:self 
			    completionBlock:^(NSError *error, STObject *stomt) {

				}];
```
####Authenticate
Authentication to Stomt can be accomplished in two ways: 

Via normal OAuth flow, using the handy class method `+[Stomt promptAuthenticationIfNecessaryWithCompletionBlock:]`
You also have to provide your app with the url schema "stomtAPI" and override the following methods in your *AppDelegate*

```
//For iOS 8
- (BOOL)application:(UIApplication*)application openURL:(nonnull NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(nonnull id)annotation
{
	return [[Stomt sharedInstance] application:application openURL:url sourceApplication:nil annotation:nil];
}
//For iOS 9 or higher
- (BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<NSString *,id> *)options
{
	return [[Stomt sharedInstance] application:application openURL:url sourceApplication:nil annotation:nil];
}
```
*This is still on development. It will be updated soon, please check for updates.*

Or via **Facebook connect**.

**Documentation coming soon!**


## Contribution

We would love to see you contributing to our iOS SDK. Feel free to fork it and we're also awaiting your pull-requests!

## Authors

* [Leonardo Cascianelli](https://github.com/h3xept)
* [Max Klenk](https://github.com/maxklenk)

## More about stomt

* On the web [www.stomt.com](https://www.stomt.com)
* [stomt for iOS](http://stomt.co/ios)
* [stomt for Android](http://stomt.co/android)
