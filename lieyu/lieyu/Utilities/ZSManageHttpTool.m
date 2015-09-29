//
//  ZSManageHttpTool.m
//  lieyu
//
//  Created by 薛斯岐 on 15/9/29.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "ZSManageHttpTool.h"
#import "TaoCanModel.h"
#import "PinKeModel.h"
#import "CheHeModel.h"
#import "KuCunModel.h"
#import "CustomerModel.h"
@implementation ZSManageHttpTool
+ (ZSManageHttpTool *)shareInstance
{
    static ZSManageHttpTool * instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}
#pragma mark -获取专属经理-套餐列表
-(void) getMyTaoCanListWithParams:(NSDictionary*)params
    block:(void(^)(NSMutableArray* result)) block{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:ZS_TAOCANLIST baseURL:LY_SERVER params:params success:^(id response) {
        NSArray *dataList = response[@"data"];
        NSMutableArray *tempArr = [[NSMutableArray alloc]initWithArray:[TaoCanModel objectArrayWithKeyValuesArray:dataList]];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            block(tempArr);
        });
    } failure:^(NSError *err) {
        
    }];
}
#pragma mark -获取专属经理-拼客列表
-(void) getMyPinkerListWithParams:(NSDictionary*)params
                            block:(void(^)(NSMutableArray* result)) block{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:ZS_PINKELIST baseURL:LY_SERVER params:params success:^(id response) {
        NSArray *dataList = response[@"data"];
        NSMutableArray *tempArr = [[NSMutableArray alloc]initWithArray:[PinKeModel objectArrayWithKeyValuesArray:dataList]];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            block(tempArr);
        });
    } failure:^(NSError *err) {
        
    }];
    
}
#pragma mark -获取专属经理-单品列表
-(void) getMyDanPinListWithParams:(NSDictionary*)params
                            block:(void(^)(NSMutableArray* result)) block{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:ZS_DANPINLIST baseURL:LY_SERVER params:params success:^(id response) {
        NSArray *dataList = response[@"data"];
        NSMutableArray *tempArr = [[NSMutableArray alloc]initWithArray:[CheHeModel objectArrayWithKeyValuesArray:dataList]];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            block(tempArr);
        });
    } failure:^(NSError *err) {
        
    }];

}
#pragma mark -获取专属经理-库存列表
-(void) getMyKuCunListWithParams:(NSDictionary*)params
                           block:(void(^)(NSMutableArray* result)) block{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:ZS_KUCUNLIST baseURL:LY_SERVER params:params success:^(id response) {
        NSArray *dataList = response[@"data"];
        NSMutableArray *tempArr = [[NSMutableArray alloc]initWithArray:[KuCunModel objectArrayWithKeyValuesArray:dataList]];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            block(tempArr);
        });
    } failure:^(NSError *err) {
        
    }];

}
#pragma mark -获取一周卡座
-(void) getDeckFullWithParams:(NSDictionary*)params
                        block:(void(^)(NSString* result)) block{
    [HTTPController requestWihtMethod:RequestMethodTypeGet url:ZS_KUZUOISFULL baseURL:QINIU_SERVER  params:params success:^(id response) {
        NSString *dataStr = response[@"data"];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            block(dataStr);
        });
    } failure:^(NSError *err) {
        //        NSLog(err.domain);
    }];

}
#pragma mark -获取我的客户
-(void) getUsersFriendWithParams:(NSDictionary*)params
                           block:(void(^)(NSMutableArray* result)) block{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:ZS_USERS_FRIEND baseURL:LY_SERVER params:params success:^(id response) {
        NSArray *dataList = response[@"data"];
        NSMutableArray *tempArr = [[NSMutableArray alloc]initWithArray:[CustomerModel objectArrayWithKeyValuesArray:dataList]];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            block(tempArr);
        });
    } failure:^(NSError *err) {
        
    }];
}
@end
