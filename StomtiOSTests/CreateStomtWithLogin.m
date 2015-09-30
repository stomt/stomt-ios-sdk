//
//  createStomtWithLogin.m
//  StomtiOS
//
//  Created by Max Klenk on 30/09/15.
//  Copyright © 2015 Leonardo Cascianelli. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <StomtiOS/StomtiOS.h>
#import <CoreLocation/CoreLocation.h>

@interface CreateStomtWithLogin : XCTestCase

@property (nonatomic) int timeout;
@property (nonatomic) NSString *username;
@property (nonatomic) NSString *password;

@end

@implementation CreateStomtWithLogin

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.timeout = 5;
    self.username = @"test";
    self.password = @"test";
    [Stomt setAppID:@"t2rxe5v3Ru9nGoGio7fNchE04"];
    [self authenticate];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
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

//-----------------------------------------------------------------------------
// STObject
//-----------------------------------------------------------------------------

- (void)testSimple {
    // new request
    NSString *textBody = @"would create a simple stomt. #unitTest";
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
        if (stomt) {
            [expectation fulfill];
            XCTAssertFalse(stomt.anonym);
            // TODO XCTAssertEqualObjects(stomt.creator.identifier, self.username);
            
            XCTAssertEqualObjects(stomt.text, textBody);
            XCTAssertEqualObjects(stomt.target.identifier, targetID);
        } else {
            NSLog(@"%@",[error localizedDescription]);
        }
        
    }];
    [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testWithLocation {
    // new request
    NSString *textBody = @"would create a simple stomt with location. #unitTest";
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
        if (stomt) {
            [expectation fulfill];
            XCTAssertFalse(stomt.anonym);
            // TODO XCTAssertEqualObjects(stomt.creator.identifier, self.username);
            
            XCTAssertEqualObjects(stomt.text, textBody);
            XCTAssertEqualObjects(stomt.target.identifier, targetID);
            // TODO XCTAssertEqualObjects(stomt.geoLocation, location);
        } else {
            NSLog(@"%@",[error localizedDescription]);
        }
        
    }];
    [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

// TODO
- (void)testWithUrl {
    // new request
    NSString *textBody = @"would create a stomt with url. #unitTest";
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
        if (stomt) {
            [expectation fulfill];
            XCTAssertFalse(stomt.anonym);
            // TODO XCTAssertEqualObjects(stomt.creator.identifier, self.username);
            
            XCTAssertEqualObjects(stomt.text, textBody);
            XCTAssertEqualObjects(stomt.target.identifier, targetID);
            // TODO XCTAssertEqualObjects(stomt.url, url);
        } else {
            NSLog(@"%@",[error localizedDescription]);
        }
        
    }];
    [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testWithImage {
    // new request
    NSString *textBody = @"would create a stomt with image. #unitTest";
    NSString *targetID = @"stomt-ios";
    STImage *image = nil; // TODO
    STObject *ob = [STObject
                    objectWithTextBody: textBody
                    likeOrWish: kSTObjectWish
                    targetID: targetID
                    image: image
                    ];
    StomtRequest* sendStomt = [StomtRequest stomtCreationRequestWithStomtObject:ob];
    
    
    // perform request
    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
    [sendStomt sendStomtInBackgroundWithBlock:^(NSError *error, STObject *stomt) {
        if (stomt) {
            [expectation fulfill];
            XCTAssertFalse(stomt.anonym);
            // TODO XCTAssertEqualObjects(stomt.creator.identifier, self.username);
            
            XCTAssertEqualObjects(stomt.text, textBody);
            XCTAssertEqualObjects(stomt.target.identifier, targetID);
            XCTAssertEqualObjects(stomt.image, image);
        } else {
            NSLog(@"%@",[error localizedDescription]);
        }
        
    }];
    [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}


@end
