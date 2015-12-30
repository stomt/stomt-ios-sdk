//
//  RetrieveFeedWithoutLogin.m
//  StomtiOS
//
//  Created by Max Klenk on 30/09/15.
//  Copyright © 2015 Leonardo Cascianelli. All rights reserved.
//

#import "StomtTestCase.h"
#import <XCTest/XCTest.h>
#import "Stomt.h"

@interface RetrieveFeedWithoutLogin : StomtTestCase

@end

@implementation RetrieveFeedWithoutLogin

- (void)testWithTerm {
    NSString *term = @"iOSUnitTest";
    STFeed *feed = [STFeed feedWithTerm: term];
    
    StomtRequest *requestStomt = [StomtRequest feedRequestWithStomtFeedObject:feed];
    XCTAssertEqualObjects(requestStomt.apiRequest.URL.query, @"q=iOSUnitTest");
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
    [requestStomt requestFeedInBackgroundWithBlock:^(NSError *error, STFeed *feed) {
        [expectation fulfill];
        XCTAssertEqual(feed.stomts.count, 15);
    }];
    [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testWithBelongsTo {

    NSString *targetID = @"stomt-ios";
    STFeed *feed = [STFeed feedWhichBelongsTo: targetID];
    
    StomtRequest *requestStomt = [StomtRequest feedRequestWithStomtFeedObject:feed];
	XCTAssertEqualObjects(requestStomt.apiRequest.URL.query, @"at=stomt-ios");
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
    [requestStomt requestFeedInBackgroundWithBlock:^(NSError *error, STFeed *feed) {
        [expectation fulfill];
        XCTAssertGreaterThan(feed.stomts.count, 0);
    }];
    [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}


- (void)testReceivedDirectly {
    NSArray *targetIDs = @[@"stomt-ios"];
    STFeed *feed = [STFeed feedWithStomtsDirectlyReceivedBy: targetIDs];
    
    StomtRequest *requestStomt = [StomtRequest feedRequestWithStomtFeedObject:feed];
    XCTAssertEqualObjects(requestStomt.apiRequest.URL.query, @"to=stomt-ios");
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
    [requestStomt requestFeedInBackgroundWithBlock:^(NSError *error, STFeed *feed) {
        [expectation fulfill];
        XCTAssertEqual(feed.stomts.count, 15);
    }];
    [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testReceivedDirectlyMultiple {
    NSArray *targetIDs = @[@"stomt-ios", @"stomt"];
    STFeed *feed = [STFeed feedWithStomtsDirectlyReceivedBy: targetIDs];
    
    StomtRequest *requestStomt = [StomtRequest feedRequestWithStomtFeedObject:feed];
    XCTAssertEqualObjects(requestStomt.apiRequest.URL.query, @"to=stomt-ios,stomt");
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
    [requestStomt requestFeedInBackgroundWithBlock:^(NSError *error, STFeed *feed) {
        [expectation fulfill];
        XCTAssertEqual(feed.stomts.count, 15);
    }];
    [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testSendBy {
    NSArray *targetIDs = @[@"stomt-ios"];
	STFeed *feed = [STFeed feedFrom:targetIDs];
	
    StomtRequest *requestStomt = [StomtRequest feedRequestWithStomtFeedObject:feed];
    XCTAssertEqualObjects(requestStomt.apiRequest.URL.query, @"from=stomt-ios");
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
    [requestStomt requestFeedInBackgroundWithBlock:^(NSError *error, STFeed *feed) {
        [expectation fulfill];
        XCTAssertEqual(feed.stomts.count, 15);
    }];
    [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}


- (void)testSendByMultiple {
    NSArray *targetIDs = @[@"stomt-ios", @"stomt"];
    STFeed *feed = [STFeed feedFrom:targetIDs];
    
    StomtRequest *requestStomt = [StomtRequest feedRequestWithStomtFeedObject:feed];
    XCTAssertEqualObjects(requestStomt.apiRequest.URL.query, @"from=stomt-ios,stomt");
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
    [requestStomt requestFeedInBackgroundWithBlock:^(NSError *error, STFeed *feed) {
        [expectation fulfill];
        XCTAssertEqual(feed.stomts.count, 15);
    }];
    [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testWithFilterKeywords {
	STSearchFilterKeywords* key = [STSearchFilterKeywords searchFilterWithPositiveKeywords:STKeywordFilterImage|STKeywordFilterLabels
																		   negatedKeywords:STKeywordFilterUrl];
    STFeed *feed = [STFeed feedWithFilterKeywords:key];
    
    StomtRequest *requestStomt = [StomtRequest feedRequestWithStomtFeedObject:feed];
    XCTAssertEqualObjects(requestStomt.apiRequest.URL.query, @"has=labels,image,!url");
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
    [requestStomt requestFeedInBackgroundWithBlock:^(NSError *error, STFeed *feed) {
        [expectation fulfill];
        XCTAssertNotEqual(feed.stomts.count, 0);
    }];
    [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}


- (void)testIsLike {
    kSTObjectQualifier qualifier = kSTObjectLike;
    STFeed *feed = [STFeed feedWithLikeOrWish: qualifier];
    
    StomtRequest *requestStomt = [StomtRequest feedRequestWithStomtFeedObject:feed];
    XCTAssertEqualObjects(requestStomt.apiRequest.URL.query, @"is=like");
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
    [requestStomt requestFeedInBackgroundWithBlock:^(NSError *error, STFeed *feed) {
        [expectation fulfill];
        XCTAssertEqual(feed.stomts.count, 15);
    }];
    [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testIsWish {
    kSTObjectQualifier qualifier = kSTObjectWish;
    STFeed *feed = [STFeed feedWithLikeOrWish: qualifier];
    
    StomtRequest *requestStomt = [StomtRequest feedRequestWithStomtFeedObject:feed];
    XCTAssertEqualObjects(requestStomt.apiRequest.URL.query, @"is=wish");
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
    [requestStomt requestFeedInBackgroundWithBlock:^(NSError *error, STFeed *feed) {
        [expectation fulfill];
        XCTAssertEqual(feed.stomts.count, 15);
    }];
    [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testWithLabel {
    NSArray *labels = @[@"test"];
    STFeed *feed = [STFeed feedWhichContainsLabels: labels];
    
    StomtRequest *requestStomt = [StomtRequest feedRequestWithStomtFeedObject:feed];
    XCTAssertEqualObjects(requestStomt.apiRequest.URL.query, @"label=test");
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
    [requestStomt requestFeedInBackgroundWithBlock:^(NSError *error, STFeed *feed) {
        [expectation fulfill];
		XCTAssertNil(error);
    }];
    [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testWithLabels {
    NSArray *labels = @[@"faq", @"test"];
    STFeed *feed = [STFeed feedWhichContainsLabels: labels];
    
    StomtRequest *requestStomt = [StomtRequest feedRequestWithStomtFeedObject:feed];
    XCTAssertEqualObjects(requestStomt.apiRequest.URL.query, @"label=faq,test");
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
    [requestStomt requestFeedInBackgroundWithBlock:^(NSError *error, STFeed *feed) {
        [expectation fulfill];
        XCTAssertNil(error);
    }];
    [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testWithAll {
    NSString *term = @"iOSUnitTest";
    NSString *belongsTargetID = @"stomt-ios";
    NSArray *directTargetIDs = @[@"stomt-ios"];
    NSArray *fromTargetIDs = @[@"stomt-ios"];
    STSearchFilterKeywords *keywords = nil;
    kSTObjectQualifier likeOrWish = kSTObjectWish;
    NSArray *labels = @[@"test"];
    STFeed *feed = [STFeed feedWithTerm: term
                              belongsTo: belongsTargetID
                     directlyReceivedBy: directTargetIDs
                                 sentBy: fromTargetIDs
                         filterKeywords: keywords
                             likeOrWish: likeOrWish
                         containsLabels: labels
                    ];
    
    StomtRequest *requestStomt = [StomtRequest feedRequestWithStomtFeedObject:feed];
	
    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
    [requestStomt requestFeedInBackgroundWithBlock:^(NSError *error, STFeed *feed) {
        [expectation fulfill];
		XCTAssertNil(error);
    }];
    [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

@end
