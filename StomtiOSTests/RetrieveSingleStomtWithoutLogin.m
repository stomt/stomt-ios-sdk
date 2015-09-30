//
//  RetrieveSingleStomt.m
//  StomtiOS
//
//  Created by Max Klenk on 30/09/15.
//  Copyright © 2015 Leonardo Cascianelli. All rights reserved.
//

#import "StomtTestCase.h"
#import <XCTest/XCTest.h>
#import <StomtiOS/StomtiOS.h>

@interface RetrieveSingleStomtWithoutLogin : StomtTestCase

@end

@implementation RetrieveSingleStomtWithoutLogin

- (void)testWithIdentifier {
    NSString *identifier = @"wow-so-much-hashtag-but-we-need-more-dafaq-and--much-amazing-such-stomt-very-amazing-l21";
    
    StomtRequest *requestStomt = [StomtRequest stomtRequestWithIdentifierOrURL:identifier];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
    [requestStomt requestStomtInBackgroundWithBlock:^(NSError *error, STObject *stomt) {
        if (stomt) {
            [expectation fulfill];
            XCTAssertEqualObjects(stomt.identifier, identifier);
        } else {
            NSLog(@"%@",[error localizedDescription]);
        }
    }];
    [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}


- (void)testWithHttpsUrl {
    NSString *identifier = @"wow-so-much-hashtag-but-we-need-more-dafaq-and--much-amazing-such-stomt-very-amazing-l21";
    NSString *url = @"https://test.stomt.com/stomt/";
    url = [url stringByAppendingString:identifier];
    
    StomtRequest *requestStomt = [StomtRequest stomtRequestWithIdentifierOrURL:url];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
    [requestStomt requestStomtInBackgroundWithBlock:^(NSError *error, STObject *stomt) {
        if (stomt) {
            [expectation fulfill];
            XCTAssertEqualObjects(stomt.identifier, identifier);
        } else {
            NSLog(@"%@",[error localizedDescription]);
        }
    }];
    [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testWithHttpUrl {
    NSString *identifier = @"wow-so-much-hashtag-but-we-need-more-dafaq-and--much-amazing-such-stomt-very-amazing-l21";
    NSString *url = @"http://test.stomt.com/stomt/";
    url = [url stringByAppendingString:identifier];
    
    StomtRequest *requestStomt = [StomtRequest stomtRequestWithIdentifierOrURL:url];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
    [requestStomt requestStomtInBackgroundWithBlock:^(NSError *error, STObject *stomt) {
        if (stomt) {
            [expectation fulfill];
            XCTAssertEqualObjects(stomt.identifier, identifier);
        } else {
            NSLog(@"%@",[error localizedDescription]);
        }
    }];
    [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)TODO_testWithUrlWithoutProtocol {
    NSString *identifier = @"wow-so-much-hashtag-but-we-need-more-dafaq-and--much-amazing-such-stomt-very-amazing-l21";
    NSString *url = @"test.stomt.com/stomt/";
    url = [url stringByAppendingString:identifier];
    
    StomtRequest *requestStomt = [StomtRequest stomtRequestWithIdentifierOrURL:url];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
    [requestStomt requestStomtInBackgroundWithBlock:^(NSError *error, STObject *stomt) {
        if (stomt) {
            [expectation fulfill];
            XCTAssertEqualObjects(stomt.identifier, identifier);
        } else {
            NSLog(@"%@",[error localizedDescription]);
        }
    }];
    [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)TODO_testWithWwwUrl {
    NSString *identifier = @"wow-so-much-hashtag-but-we-need-more-dafaq-and--much-amazing-such-stomt-very-amazing-l21";
    NSString *url = @"www.test.stomt.com/stomt/";
    url = [url stringByAppendingString:identifier];
    
    StomtRequest *requestStomt = [StomtRequest stomtRequestWithIdentifierOrURL:url];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
    [requestStomt requestStomtInBackgroundWithBlock:^(NSError *error, STObject *stomt) {
        if (stomt) {
            [expectation fulfill];
            XCTAssertEqualObjects(stomt.identifier, identifier);
        } else {
            NSLog(@"%@",[error localizedDescription]);
        }
    }];
    [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

@end
