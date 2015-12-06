//
//  lieyuTests.m
//  lieyuTests
//
//  Created by pwy on 15/9/5.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "LYRestfulBussiness.h"

@interface lieyuTests : XCTestCase

@end

@implementation lieyuTests

- (void)setUp {
    [super setUp];
    [LYRestfulBussiness queryDrinksAction:@(1) maxPrice:@(2000) minnum:@(1) maxnum:@(1000) handle:^(LYErrorMessage *erMsg, id data)
    {
        
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

- (void)testQiuniu{
   NSString *url= [MyUtil getQiniuUrl:@"lieyu_ios_2015-10-30 01:16:39_LfouZxj2.jpg" width:80 andHeight:80];
    NSLog(@"----pass-pass%@---",URL);
}

- (void)testXingzuo{
//    NSString *xingzuo =[MyUtil getAstroWithMonth:@"1986-09-01"];
//    NSLog(@"----pass-xingzuo%@---",xingzuo);
//    XCTAssert(YES, @"Pass");
    
}

@end
