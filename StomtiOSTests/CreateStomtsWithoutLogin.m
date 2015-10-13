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
    // new request
    NSString *textBody = @"would create a simple anonym stomt. #unitTest";
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

- (void)testWithLocation {
    // new request
    NSString *textBody = @"would create a anonym stomt with location. #unitTest";
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
    // new request
    NSString *textBody = @"would create a anonym stomt with url. #unitTest";
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
        XCTAssertEqualObjects(stomt.url, url);
    }];
    [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}


- (void)testWithImage {
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
    NSString *textBody = @"would create a anonym stomt with image. #unitTest";
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
