//
//  MWStackTests.m
//  MWStackTests
//
//  Created by Michael Welch on 8/17/12.
//  Copyright (c) 2012 Michael Welch. All rights reserved.
//

#import "MWStackTests.h"

@implementation MWStackTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testDefaultStackShouldBeEmptySoPopShouldReturnNil
{
    MWStack *stack = [[MWStack alloc] init];
    id element = [stack pop];
    STAssertNil(element, @"Expect stack to be empty");
}

- (void)testPushWithDefaultStackShouldResultInOneElement
{
    MWStack *stack = [[MWStack alloc] init];
    [stack push:@"This is a string"];
    NSArray *expected = @[@"This is a string"];
    
    NSArray *actual = [stack state];
    
    STAssertEqualObjects(expected, actual, nil);
    
    
}

@end
