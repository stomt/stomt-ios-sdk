//
//  RetrieveSingleStomt.m
//  StomtiOS
//
//  Created by Max Klenk on 30/09/15.
//  Copyright © 2015 Leonardo Cascianelli. All rights reserved.
//

#import "StomtTestCase.h"
#import <XCTest/XCTest.h>
#import "Stomt.h"

@interface RetrieveSingleStomtWithoutLogin : StomtTestCase
@property (strong,nonatomic) NSString* surelyExistingIdentifier;
@property (strong,nonatomic) NSString* surelyExistingProfile;

@end

@implementation RetrieveSingleStomtWithoutLogin

- (void)setUp
{
	[super setUp];
	self.surelyExistingIdentifier = @"test";
	self.surelyExistingProfile = @"stomt-ios";
}

- (void)testWithIdentifier {
    
    StomtRequest *requestStomt = [StomtRequest stomtRequestWithIdentifierOrURL:self.surelyExistingIdentifier];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
    [requestStomt requestStomtInBackgroundWithBlock:^(NSError *error, STObject *stomt) {
        [expectation fulfill];
        XCTAssertNotNil(stomt);
        XCTAssertEqualObjects(stomt.identifier, self.surelyExistingIdentifier);
    }];
    [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}


- (void)testWithHttpsUrl {
	NSString *url = [NSString stringWithFormat:@"https://test.stomt.com/%@/",self.surelyExistingProfile];
	url = [url stringByAppendingString:self.surelyExistingIdentifier];
	
    StomtRequest *requestStomt = [StomtRequest stomtRequestWithIdentifierOrURL:url];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
    [requestStomt requestStomtInBackgroundWithBlock:^(NSError *error, STObject *stomt) {
        [expectation fulfill];
        XCTAssertEqualObjects(stomt.identifier, self.surelyExistingIdentifier);
    }];
    [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testWithHttpUrl {
	NSString *url = [NSString stringWithFormat:@"https://test.stomt.com/%@/",self.surelyExistingProfile];
	url = [url stringByAppendingString:self.surelyExistingIdentifier];
	
    StomtRequest *requestStomt = [StomtRequest stomtRequestWithIdentifierOrURL:url];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
    [requestStomt requestStomtInBackgroundWithBlock:^(NSError *error, STObject *stomt) {
        [expectation fulfill];
        XCTAssertEqualObjects(stomt.identifier, self.surelyExistingIdentifier);
    }];
    [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testWithUrlWithoutProtocol {
	NSString *url = [NSString stringWithFormat:@"https://test.stomt.com/%@/",self.surelyExistingProfile];
	url = [url stringByAppendingString:self.surelyExistingIdentifier];
	
    StomtRequest *requestStomt = [StomtRequest stomtRequestWithIdentifierOrURL:url];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
    [requestStomt requestStomtInBackgroundWithBlock:^(NSError *error, STObject *stomt) {
        [expectation fulfill];
        XCTAssertEqualObjects(stomt.identifier, self.surelyExistingIdentifier);
    }];
    [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testWithWwwUrl {
	NSString *url = [NSString stringWithFormat:@"https://test.stomt.com/%@/",self.surelyExistingProfile];
	url = [url stringByAppendingString:self.surelyExistingIdentifier];
	
    StomtRequest *requestStomt = [StomtRequest stomtRequestWithIdentifierOrURL:url];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
    [requestStomt requestStomtInBackgroundWithBlock:^(NSError *error, STObject *stomt) {
        [expectation fulfill];
        XCTAssertEqualObjects(stomt.identifier, self.surelyExistingIdentifier);
    }];
    [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

@end
