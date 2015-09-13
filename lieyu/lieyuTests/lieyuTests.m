//
//  lieyuTests.m
//  lieyuTests
//
//  Created by pwy on 15/9/5.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "WeathGetManager.h"

@interface lieyuTests : XCTestCase

@end

@implementation lieyuTests

- (void)setUp {
    [super setUp];
    WeathGetManager *weath  = [[WeathGetManager alloc ] init];
    [weath getWeath:^(LYErrorMessage *erMsg, id data) {
        
    }];
    CFRunLoopRun();
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
