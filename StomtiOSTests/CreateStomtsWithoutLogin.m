//
//  CreateStomtsWithoutLogin.m
//  StomtiOS
//
//  Created by Max Klenk on 30/09/15.
//  Copyright © 2015 Leonardo Cascianelli. All rights reserved.
//

#import "StomtTestCase.h"
#import <XCTest/XCTest.h>
#import "Stomt.h"
#import <CoreLocation/CoreLocation.h>

@interface CreateStomtsWithoutLogin : StomtTestCase

@end

@implementation CreateStomtsWithoutLogin

- (void)testSimple {
	
	[Stomt logout];
	
    // new request
    NSString *textBody = @"would create a simple anonym stomt. #iOSUnitTest";
    NSString *targetID = @"stomt-ios";
    STObject *ob = [STObject
                    objectWithTextBody: textBody
                    likeOrWish: kSTObjectWish
                    targetID: targetID
                    ];
    StomtRequest* sendStomt = [StomtRequest stomtCreationRequestWithStomtObject:ob];
    
    
    // perform request
    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
    [sendStomt sendStomtInBackgroundWithBlock:^(NSError *error, STObject *stomt) {
        [expectation fulfill];
        XCTAssertTrue(stomt.anonym);
        XCTAssertEqualObjects(stomt.text, textBody);
        XCTAssertEqualObjects(stomt.target.identifier, targetID);
    }];
    [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)nontestWithLocation {

    // new request
    NSString *textBody = @"would create an anonym stomt with location. #iOSUnitTest";
    NSString *targetID = @"stomt-ios";
    CLLocation* location = [[CLLocation alloc] initWithLatitude:43.564523 longitude:56.234453];
    STObject *ob = [STObject
                    objectWithTextBody: textBody
                    likeOrWish: kSTObjectWish
                    targetID: targetID
                    geoLocation: location
                    ];
    StomtRequest* sendStomt = [StomtRequest stomtCreationRequestWithStomtObject:ob];
    
    
    // perform request
    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
    [sendStomt sendStomtInBackgroundWithBlock:^(NSError *error, STObject *stomt) {
        [expectation fulfill];
        XCTAssertTrue(stomt.anonym);
        XCTAssertEqualObjects(stomt.text, textBody);
        XCTAssertEqualObjects(stomt.target.identifier, targetID);
        XCTAssertEqualObjects(stomt.geoLocation, location);
    }];
    [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testWithUrl {
	
	[Stomt logout];
	
    // new request
    NSString *textBody = @"would create an anonym stomt with url. #iOSUnitTest";
    NSString *targetID = @"stomt-ios";
    NSString *url = @"https://stomt.com";
    STObject *ob = [STObject
                    objectWithTextBody: textBody
                    likeOrWish: kSTObjectWish
                    targetID: targetID
                    url: url
                    ];
    StomtRequest* sendStomt = [StomtRequest stomtCreationRequestWithStomtObject:ob];
    
    
    // perform request
    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
    [sendStomt sendStomtInBackgroundWithBlock:^(NSError *error, STObject *stomt) {
        [expectation fulfill];
        XCTAssertTrue(stomt.anonym);
        XCTAssertEqualObjects(stomt.text, textBody);
        XCTAssertEqualObjects(stomt.target.identifier, targetID);
        XCTAssertEqualObjects([stomt.url absoluteString], url);
    }];
    [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}


- (void)testWithImage {
	
	[Stomt logout];
	
    UIImage *image = [self createImage];
    
    StomtRequest* uploadImage = [StomtRequest imageUploadRequestWithImage:image forTargetID:nil withImageCategory:kSTImageCategoryStomt];
    
    // perform request
    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
    [uploadImage uploadImageInBackgroundWithBlock:^(NSError *error, STImage *image) {
        [self createStomtWithImage:image expectation:expectation];
    }];
    [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}
- (void)createStomtWithImage:(STImage *)image
                 expectation:(XCTestExpectation *) expectation {
    // new request
    NSString *textBody = @"would create an anonym stomt with image. #iOSUnitTest";
    NSString *targetID = @"stomt-ios";
    STObject *ob = [STObject
                    objectWithTextBody: textBody
                    likeOrWish: kSTObjectWish
                    targetID: targetID
                    image: image
                    ];
    StomtRequest* sendStomt = [StomtRequest stomtCreationRequestWithStomtObject:ob];
    
    
    // perform request
    [sendStomt sendStomtInBackgroundWithBlock:^(NSError *error, STObject *stomt) {
        [expectation fulfill];
        XCTAssertTrue(stomt.anonym);
        XCTAssertEqualObjects(stomt.text, textBody);
        XCTAssertEqualObjects(stomt.target.identifier, targetID);
        XCTAssertNotNil(stomt.image);
    }];
}

@end
