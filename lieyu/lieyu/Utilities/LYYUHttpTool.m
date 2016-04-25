//
//  LYYUHttpTool.m
//  lieyu
//
//  Created by 狼族 on 16/1/31.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYYUHttpTool.h"
#import "HTTPController.h"
#import "LYYUUrl.h"
#import "YUOrderInfo.h"
#import "YUWishesModel.h"

@implementation LYYUHttpTool

+ (void)yuGetDataOrderShareWithParams:(NSDictionary *)params compelte:(void(^)(NSArray *dataArray))compelte{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_YU_ORDERSHARE baseURL:LY_SERVER params:params success:^(id response) {
        NSLog(@"---->%@",response);
        NSString *errorCodeStr = response[@"errorcode"];
        if ([errorCodeStr isEqualToString:@"1"]) {
            NSArray *array = response[@"data"];
            NSArray *dataArray = [YUOrderShareModel mj_objectArrayWithKeyValuesArray:array];
            compelte(dataArray);
        }
    } failure:^(NSError *err) {
        
    }];
}

+ (void)yuGetYuModelWithParams:(NSDictionary *)params complete:(void(^)(YUOrderShareModel *YUModel))complete{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_YU_YUMODEL baseURL:LY_SERVER params:params success:^(id response) {
//        NSLog(@"----->%@",response);
        NSString *errorCodeStr = response[@"errorcode"];
        if([errorCodeStr isEqualToString:@"1"]){
            YUOrderShareModel *model = [YUOrderShareModel mj_objectWithKeyValues:response[@"data"]];
            complete(model);
        }
        [app stopLoading];
    } failure:^(NSError *err) {
        [app stopLoading];
    }];
}

#pragma mark - 获取愿望列表
+ (void)YUGetWishesListWithParams:(NSDictionary *)params complete:(void (^)(NSDictionary *))complete{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_YU_WISHES baseURL:LY_SERVER params:params success:^(id response) {
        NSString *errorCode = response[@"errorcode"];
        if ([errorCode isEqualToString:@"1"]) {
            NSDictionary *result1 = [response objectForKey:@"data"];
            NSArray *dataArray = [YUWishesModel mj_objectArrayWithKeyValuesArray:[result1 objectForKey:@"items"]];
            NSDictionary *result = @{@"items":dataArray,
                                     @"results":[result1 objectForKey:@"results"]};
//            [result removeObjectForKey:@"items"];
//            [result setObject:dataArray forKey:@"items"];
            complete(result);
        }
        [app stopLoading];
    } failure:^(NSError *err) {
        [app stopLoading];
    }];
}

+ (void)YUFinishWishOrNotWithParams:(NSDictionary *)params complete:(void (^)(BOOL))complete{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_YU_FINISH baseURL:LY_SERVER params:params success:^(id response) {
        NSString *errorCode = [response objectForKey:@"errorcode"];
        if ([errorCode isEqualToString:@"1"]) {
            //成功
            complete(YES);
        }else{
            complete(NO);
        }
        [app stopLoading];
    } failure:^(NSError *err) {
        complete(NO);
        [app stopLoading];
    }];
}

+ (void)YUDeleteWishWithParams:(NSDictionary *)params complete:(void (^)(BOOL))complete{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_YU_DELETE baseURL:LY_SERVER params:params success:^(id response) {
        NSString *errorCode = [response objectForKey:@"errorcode"];
        if ([errorCode isEqualToString:@"1"]) {
            complete(YES);
        }else{
            complete(NO);
        }
        [app stopLoading];
    } failure:^(NSError *err) {
        complete(NO);
        [app stopLoading];
    }];
}



@end
