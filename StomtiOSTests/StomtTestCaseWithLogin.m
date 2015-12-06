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
    [[Stomt sharedInstance] setAccessToken:@"Sz4qWBSCSlQXqsB94rCpe41wnVgnyRM7338nKuOM"];
}

- (void)tearDown {
    // custom tearDown
    [[Stomt sharedInstance] setAccessToken:nil];
    
    [super tearDown];
}

@end
