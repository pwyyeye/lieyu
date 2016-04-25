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
#import "BarActivityList.h"

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

#pragma mark - 娱获取所有需求标签
+ (void)yuGetYUAllTagsWithParams:(NSDictionary *)params complete:(void(^)(NSMutableArray *yuTagsModelArr))complete{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_YU_GETTAG baseURL:LY_SERVER params:params success:^(id response) {
        NSString *errorCodeStr = response[@"errorcode"];
        if([errorCodeStr isEqualToString:@"1"]){ 
            NSMutableArray *array = [BarActivityList mj_objectArrayWithKeyValuesArray:response[@"data"]];
            complete(array);
        }
    } failure:^(NSError *err) {
        [MyUtil showCleanMessage:@"获取标签错误！"];
    }];
}

#pragma mark - 发布个人需求
+ (void)yuSendMYThemeWithParams:(NSDictionary *)params complete:(void(^)(BOOL))complete{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_YU_SENDMYTHEME baseURL:LY_SERVER params:params success:^(id response) {
        NSString *errorCodeStr = response[@"errorcode"];
        if([errorCodeStr isEqualToString:@"1"]){
           [MyUtil showCleanMessage:@"发布成功！"];
            complete(YES);
        }else{
            complete(NO);
        }
        [app stopLoading];
    } failure:^(NSError *err) {
        [MyUtil showCleanMessage:@"发布失败！"];
        [app stopLoading];
    }];
}

@end
