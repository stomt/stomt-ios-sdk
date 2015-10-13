//
//  StomtTestCaseWithLogin.m
//  StomtiOS
//
//  Created by Max Klenk on 30/09/15.
//  Copyright © 2015 Leonardo Cascianelli. All rights reserved.
//

#import "StomtTestCaseWithLogin.h"
#import "Stomt.h"

@implementation StomtTestCaseWithLogin

- (void)setUp {
    [super setUp];
    
    // custom setUp
    self.username = @"test";
    [Stomt setAccessToken:@"3m2jPXc2ZsvhiECT8rPBtsqCXV4gPGGr0vEDLR09"];
}

- (void)tearDown {
    // custom tearDown
    [Stomt setAccessToken:nil];
    
    [super tearDown];
}

@end
