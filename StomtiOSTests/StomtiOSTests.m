//
//  StomtiOSTests.m
//  StomtiOSTests
//
//  Created by Leonardo Cascianelli on 10/09/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <StomtiOS/StomtiOS.h>
#import <CoreLocation/CoreLocation.h>

@interface StomtiOSTests : XCTestCase

@property (nonatomic) int timeout;

@end

@implementation StomtiOSTests

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

@end
