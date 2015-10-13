# Stomt-iOS-SDK
[![Build Status](https://travis-ci.org/stomt/stomt-ios-sdk.svg?branch=master)](https://travis-ci.org/stomt/stomt-ios-sdk)
[![Stomt API](https://img.shields.io/badge/stomt-v2.0.X-brightgreen.svg)](https://rest.stomt.com/)
[![CocoaPod](https://img.shields.io/cocoapods/v/Stomt-iOS-SDK.svg)](https://github.com/stomt/ios-sdk)

Our SDK allows you to add the feedback solution [www.stomt.com](https://www.stomt.com/) in your iPhone or iPad app. 

To connect your app to stomt, first create the projects page on [stomt](https://www.stomt.com/).


## Installation

To install Stomt-iOS-SDK you just need to add the projects source to your app and add a simple configuration.

### CocoaPods

Add the SDK to your app by adding the following line to your Podfile.
```
pod 'Stomt-iOS-SDK', '~> 0.0.x'
```

(Alternatively [download](https://github.com/stomt/stomt-ios-sdk/archive/master.zip) the source from GitHub and add it to your project.)


### Configuration

Import the SDK:
```Objective-C
#import <Stomt-iOS-SDK/Stomt-iOS-SDK.h>
```


Next initilize the package once:
```Objective-C
// Setup Stomt with your AppID
// -> get yours at: https://www.stomt.com/dev/my-apps
//
[Stomt setAppID:@"abcdefghijklmnopqrstuvwxy"];
```


You can now start to use the full [API](http://cocoadocs.org/docsets/Stomt-iOS-SDK/) of the SDK, the most important method will be opening a feedback form:
```Objective-C
// Open a creation modal for your applications page
// -> the targetID is your pages identifier you can copy it from the pages url
//    https://www.stomt.com/stomt-ios-sdk -> stomt-ios-sdk
//
[Stomt presentStomtCreationPanelWithTargetID:@"stomt-ios-sdk"
								 defaultText:@" "
								  likeOrWish:kSTObjectWish
							 completionBlock:^(NSError *error, STObject *stomt) {}];
```

## Documentation

The full documentation of the SDK can be found on [CocoaDocs](http://cocoadocs.org/docsets/Stomt-iOS-SDK/).


## Contribution

We would love to see you contributing to our iOS SDK. Feel free to fork it and we're also awaiting your pull-requests!

## Authors

* [Leonardo Cascianelli](https://github.com/h3xept)
* [Max Klenk](https://github.com/maxklenk)
