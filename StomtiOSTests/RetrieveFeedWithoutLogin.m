//
//  RetrieveFeedWithoutLogin.m
//  StomtiOS
//
//  Created by Max Klenk on 30/09/15.
//  Copyright © 2015 Leonardo Cascianelli. All rights reserved.
//

#import "StomtTestCase.h"
#import <XCTest/XCTest.h>
#import <StomtiOS/StomtiOS.h>

@interface RetrieveFeedWithoutLogin : StomtTestCase

@end

@implementation RetrieveFeedWithoutLogin

- (void)testWithTerm {
    NSString *term = @"test";
    STFeed *feed = [STFeed feedWithTerm: term];
    
    StomtRequest *requestStomt = [StomtRequest feedRequestWithStomtFeedObject:feed];
    XCTAssertEqualObjects(requestStomt.apiRequest.URL.query, @"q=test");
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
    [requestStomt requestFeedInBackgroundWithBlock:^(NSError *error, STFeed *feed) {
        if (feed) {
            [expectation fulfill];
            XCTAssertEqual(feed.stomts.count, 15);
        } else {
            NSLog(@"%@",[error localizedDescription]);
        }

    }];
    [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testWithBelongsTo {
    NSString *targetID = @"stomt-iOS";
    STFeed *feed = [STFeed feedWhichBelongsTo: targetID];
    
    StomtRequest *requestStomt = [StomtRequest feedRequestWithStomtFeedObject:feed];
    XCTAssertEqualObjects(requestStomt.apiRequest.URL.query, @"at=stomt-iOS");
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
    [requestStomt requestFeedInBackgroundWithBlock:^(NSError *error, STFeed *feed) {
        if (feed) {
            [expectation fulfill];
            XCTAssertEqual(feed.stomts.count, 15);
        } else {
            NSLog(@"%@",[error localizedDescription]);
        }
        
    }];
    [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}


- (void)testReceivedDirectly {
    NSArray *targetIDs = @[@"stomt-iOS"];
    STFeed *feed = [STFeed feedWithStomtsDirectlyReceivedBy: targetIDs];
    
    StomtRequest *requestStomt = [StomtRequest feedRequestWithStomtFeedObject:feed];
    XCTAssertEqualObjects(requestStomt.apiRequest.URL.query, @"to=stomt-iOS");
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
    [requestStomt requestFeedInBackgroundWithBlock:^(NSError *error, STFeed *feed) {
        if (feed) {
            [expectation fulfill];
            XCTAssertEqual(feed.stomts.count, 15);
        } else {
            NSLog(@"%@",[error localizedDescription]);
        }
        
    }];
    [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testReceivedDirectlyMultiple {
    NSArray *targetIDs = @[@"stomt-iOS", @"stomt"];
    STFeed *feed = [STFeed feedWithStomtsDirectlyReceivedBy: targetIDs];
    
    StomtRequest *requestStomt = [StomtRequest feedRequestWithStomtFeedObject:feed];
    // TODO XCTAssertEqualObjects(requestStomt.apiRequest.URL.query, @"to=stomt-iOS,stomt");
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
    [requestStomt requestFeedInBackgroundWithBlock:^(NSError *error, STFeed *feed) {
        if (feed) {
            [expectation fulfill];
            XCTAssertEqual(feed.stomts.count, 15);
        } else {
            NSLog(@"%@",[error localizedDescription]);
        }
        
    }];
    [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)TODO_testSendBy {
    NSArray *targetIDs = @[@"test"];
    STFeed *feed = nil; //TODO [STFeed feedSendBy: targetIDs];
    
    StomtRequest *requestStomt = [StomtRequest feedRequestWithStomtFeedObject:feed];
    XCTAssertEqualObjects(requestStomt.apiRequest.URL.query, @"from=test");
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
    [requestStomt requestFeedInBackgroundWithBlock:^(NSError *error, STFeed *feed) {
        if (feed) {
            [expectation fulfill];
            XCTAssertEqual(feed.stomts.count, 15);
        } else {
            NSLog(@"%@",[error localizedDescription]);
        }
        
    }];
    [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}


- (void)TODO_testSendByMultiple {
    NSArray *targetIDs = @[@"test", @"stomt"];
    STFeed *feed = nil; //TODO [STFeed feedSendBy: targetIDs];
    
    StomtRequest *requestStomt = [StomtRequest feedRequestWithStomtFeedObject:feed];
    XCTAssertEqualObjects(requestStomt.apiRequest.URL.query, @"from=test,stomt");
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
    [requestStomt requestFeedInBackgroundWithBlock:^(NSError *error, STFeed *feed) {
        if (feed) {
            [expectation fulfill];
            XCTAssertEqual(feed.stomts.count, 15);
        } else {
            NSLog(@"%@",[error localizedDescription]);
        }
        
    }];
    [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)TODO_testWithFilterKeywords {
    NSArray *keywords = @[]; // TODO has image
    STFeed *feed = [STFeed feedWithFilterKeywords: keywords];
    
    StomtRequest *requestStomt = [StomtRequest feedRequestWithStomtFeedObject:feed];
    XCTAssertEqualObjects(requestStomt.apiRequest.URL.query, @"has=image");
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
    [requestStomt requestFeedInBackgroundWithBlock:^(NSError *error, STFeed *feed) {
        if (feed) {
            [expectation fulfill];
            XCTAssertEqual(feed.stomts.count, 15);
        } else {
            NSLog(@"%@",[error localizedDescription]);
        }
        
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
        if (feed) {
            [expectation fulfill];
            XCTAssertEqual(feed.stomts.count, 15);
        } else {
            NSLog(@"%@",[error localizedDescription]);
        }
        
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
        if (feed) {
            [expectation fulfill];
            XCTAssertEqual(feed.stomts.count, 15);
        } else {
            NSLog(@"%@",[error localizedDescription]);
        }
        
    }];
    [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)TODO_testWithLabel {
    NSArray *labels = @[@"faq"];
    STFeed *feed = [STFeed feedWhichContainsLabels: labels];
    
    StomtRequest *requestStomt = [StomtRequest feedRequestWithStomtFeedObject:feed];
    XCTAssertEqualObjects(requestStomt.apiRequest.URL.query, @"label=faq");
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
    [requestStomt requestFeedInBackgroundWithBlock:^(NSError *error, STFeed *feed) {
        if (feed) {
            [expectation fulfill];
            XCTAssertNotEqual(feed.stomts.count, 0);
        } else {
            NSLog(@"%@",[error localizedDescription]);
        }
        
    }];
    [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)TODO_testWithLabels {
    NSArray *labels = @[@"faq", @"test"];
    STFeed *feed = [STFeed feedWhichContainsLabels: labels];
    
    StomtRequest *requestStomt = [StomtRequest feedRequestWithStomtFeedObject:feed];
    XCTAssertEqualObjects(requestStomt.apiRequest.URL.query, @"label=faq,text");
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
    [requestStomt requestFeedInBackgroundWithBlock:^(NSError *error, STFeed *feed) {
        if (feed) {
            [expectation fulfill];
            XCTAssertNotEqual(feed.stomts.count, 0);
        } else {
            NSLog(@"%@",[error localizedDescription]);
        }
        
    }];
    [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testWithAll {
    NSString *term = @"test";
    NSString *belongsTargetID = @"stomt-iOS";
    NSArray *directTargetIDs = @[@"stomt-iOS"];
    NSArray *fromTargetIDs = @[@"test"];
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
    // TODO XCTAssertEqualObjects(requestStomt.apiRequest.URL.query, @"at=stomt-iOS&is=wish&to=stomt-iOS&q=test&from=test&label=test");
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
    [requestStomt requestFeedInBackgroundWithBlock:^(NSError *error, STFeed *feed) {
        if (feed) {
            [expectation fulfill];
            XCTAssertNotEqual(feed.stomts.count, 0);
        } else {
            NSLog(@"%@",[error localizedDescription]);
        }
        
    }];
    [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

@end
