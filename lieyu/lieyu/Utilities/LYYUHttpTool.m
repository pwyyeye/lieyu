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
#import "YUOrderShareModel.h"

@implementation LYYUHttpTool

+ (void)yuGetDataOrderShareWithParams:(NSDictionary *)params compelte:(void(^)(NSArray *dataArray))compelte{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_YU_ORDERSHARE baseURL:LY_SERVER params:params success:^(id response) {
        NSLog(@"---->%@",response);
        if ([response[@"errorcode"] isEqualToString:@"1"]) {
            NSArray *array = response[@"data"];
            NSArray *dataArray = [YUOrderShareModel mj_objectArrayWithKeyValuesArray:array];
            compelte(dataArray);
        }
    } failure:^(NSError *err) {
        
    }];
}

@end
