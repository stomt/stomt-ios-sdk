//
//  StomtTestCaseWithLogin.m
//  StomtiOS
//
//  Created by Max Klenk on 30/09/15.
//  Copyright © 2015 Leonardo Cascianelli. All rights reserved.
//

#import "StomtTestCaseWithLogin.h"
#import <StomtiOS/StomtiOS.h>

@implementation StomtTestCaseWithLogin

- (void)setUp {
    [super setUp];
    
    // custom setUp
    self.username = @"test";
    self.password = @"test";
    [self authenticate];
}

- (void)tearDown {
    // custom tearDown
    [Stomt logout];
    
    [super tearDown];
}

- (void)authenticate {
    StomtRequest* authRequest = [StomtRequest authenticationRequestWithEmailOrUser:self.username password:self.password];
    
    // perform request
    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
    [authRequest autenticateInBackgroundWithBlock:^(NSError *error, STUser *user) {
        if (user) {
            [expectation fulfill];
            XCTAssertEqualObjects(user.identifier, self.username);
        } else {
            NSLog(@"%@",[error localizedDescription]);
        }
    }];
    [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

@end
