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

@end
