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
#import "LYCoreDataUtil.h"
#import "LYCache.h"
@interface lieyuTests : XCTestCase

@end

@implementation lieyuTests

- (void)setUp {
    [super setUp];
//    [LYRestfulBussiness queryDrinksAction:@(1) maxPrice:@(2000) minnum:@(1) maxnum:@(1000) handle:^(LYErrorMessage *erMsg, id data)
//    {
//        
//    }];
//      CFRunLoopRun();
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
//   NSString *url= [MyUtil getQiniuUrl:@"lieyu_ios_2015-10-30 01:16:39_LfouZxj2.jpg" width:80 andHeight:80];
    NSString *encodeKey=[@"美女" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    
    NSLog(@"----pass-pass%@---",encodeKey);
}

- (void)testXingzuo{
//    NSString *xingzuo =[MyUtil getAstroWithMonth:@"1986-09-01"];
//    NSLog(@"----pass-xingzuo%@---",xingzuo);
//    XCTAssert(YES, @"Pass");
//    LYCoreDataUtil *core=[LYCoreDataUtil shareInstance];
//    [core saveOrUpdateCoreData:@"LYCache" withParam:@{@"lyCacheKey":CACHE_INEED_PLAY_HOMEPAGE,@"lyCacheValue":@{@"key":@"value"},@"createDate":[NSDate date]} andSearchPara:@{@"lyCacheKey":CACHE_INEED_PLAY_HOMEPAGE}];
    
//    NSLog(@"----pass-pass   %@     ---",[MyUtil encryptUseDES:@"2" withKey:@"LY888888"]);
//    NSLog(@"----pass-pass  : %@    :---",[MyUtil decryptUseDES:@"IxwbsiHqgnw=" withKey:@"LY888888"]);
//    ;
     NSLog(@"----pass-pass1%@---",[MyUtil getAreaWithName:@"中国" withStyle:LYAreaStyleWithState]);
     NSLog(@"----pass-pass2%@---",[MyUtil getAreaWithName:@"福建" withStyle:LYAreaStyleWithStateAndCity]);
    NSLog(@"----pass-pass3%@---",[MyUtil getAreaWithName:@"重庆" withStyle:LYAreaStyleWithStateAndCityAndDistrict]);
    NSLog(@"----pass-pass4%@---",[MyUtil getAreaWithName:@"无锡" withStyle:LYAreaStyleWithStateAndCityAndDistrict]);
    NSLog(@"----pass-pass5%@---",[MyUtil getAreaWithName:@"天津" withStyle:LYAreaStyleWithStateAndCityAndDistrict]);

}

@end
