//
//  IntentionalErrorsWithoutLogin.m
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 30/12/15.
//  Copyright © 2015 Leonardo Cascianelli. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "StomtTestCase.h"
#import "Stomt.h"

@interface IntentionalErrorsWithoutLogin : StomtTestCase

@end

@implementation IntentionalErrorsWithoutLogin

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCreateStomtWithNonExistingID
{
	// new request
	NSString *textBody = @"would NOT create a simple anonym stomt. #iOSUnitTest";
	NSString *notExistingID = @"E)=FIU=£$)KOJ03049";
	STObject *ob = [STObject
					objectWithTextBody: textBody
					likeOrWish: kSTObjectWish
					targetID: notExistingID
					];
	StomtRequest* sendStomt = [StomtRequest stomtCreationRequestWithStomtObject:ob];
	
	
	// perform request
	XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
	[sendStomt sendStomtInBackgroundWithBlock:^(NSError *error, STObject *stomt) {
		[expectation fulfill];
		XCTAssertTrue(stomt);
		XCTAssertTrue(!error);
	}];
	[self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testValidateCredentialsEmail
{
	NSString* email = @"h3xept@gmail.com";
	StomtRequest* availabilityRequest = [StomtRequest availabilityRequestForEmail:email];
	
	XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
	
	[availabilityRequest requestUserCredentialsAvailabilityWithBlock:^(NSError *error, NSNumber *available) {
		[expectation fulfill];
		NSLog(@"[!!!!!] %d",[available boolValue]);
		XCTAssertTrue(!error);
	}];
	[self waitForExpectationsWithTimeout:self.timeout handler:nil];
	
}
@end
