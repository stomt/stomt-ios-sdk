//
//  CreateStomtsWithoutLogin.m
//  StomtiOS
//
//  Created by Max Klenk on 30/09/15.
//  Copyright © 2015 Leonardo Cascianelli. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <StomtiOS/StomtiOS.h>
#import <CoreLocation/CoreLocation.h>

@interface CreateStomtsWithoutLogin : XCTestCase

@property (nonatomic) int timeout;

@end

@implementation CreateStomtsWithoutLogin

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [Stomt setAppID:@"t2rxe5v3Ru9nGoGio7fNchE04"];
    self.timeout = 5;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


//-----------------------------------------------------------------------------
// Helper
//-----------------------------------------------------------------------------
- createImage {
    UIImage *image1 = [UIImage imageNamed:@"image1.png"];
    UIImage *image2 = [UIImage imageNamed:@"image2.png"];
    
    CGSize newSize = CGSizeMake(300, 300);
    UIGraphicsBeginImageContext( newSize );
    
    [image1 drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    [image2 drawInRect:CGRectMake(0,0,newSize.width,newSize.height) blendMode:kCGBlendModeNormal alpha:0.8];
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return finalImage;
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
        if (stomt) {
            [expectation fulfill];
            XCTAssertTrue(stomt.anonym);
            XCTAssertEqualObjects(stomt.text, textBody);
            XCTAssertEqualObjects(stomt.target.identifier, targetID);
            XCTAssertNotNil(stomt.image);
        } else {
            NSLog(@"%@",[error localizedDescription]);
        }
        
    }];
}

//-----------------------------------------------------------------------------
// STObject
//-----------------------------------------------------------------------------

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
        if (stomt) {
            [expectation fulfill];
            XCTAssertTrue(stomt.anonym);
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
        if (stomt) {
            [expectation fulfill];
            XCTAssertTrue(stomt.anonym);
            XCTAssertEqualObjects(stomt.text, textBody);
            XCTAssertEqualObjects(stomt.target.identifier, targetID);
            XCTAssertEqualObjects(stomt.geoLocation, location);
        } else {
            NSLog(@"%@",[error localizedDescription]);
        }
        
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
        if (stomt) {
            [expectation fulfill];
            XCTAssertTrue(stomt.anonym);
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
    UIImage *image = [self createImage];
    
    StomtRequest* uploadImage = [StomtRequest imageUploadRequestWithImage:image forTargetID:nil withImageCategory:kSTImageCategoryStomt];
    
    // perform request
    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
    [uploadImage uploadImageInBackgroundWithBlock:^(NSError *error, STImage *image) {
        if (image) {
            [self createStomtWithImage:image expectation:expectation];
        } else {
            NSLog(@"%@",[error localizedDescription]);
        }
    }];
    [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

@end
