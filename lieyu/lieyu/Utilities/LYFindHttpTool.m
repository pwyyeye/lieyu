//
//  LYFindHttpTool.m
//  lieyu
//
//  Created by 狼族 on 16/3/9.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYFindHttpTool.h"
#import "HTTPController.h"
#import "ZSUrl.h"
#import "LYFindUrl.h"
#import "FindNewMessage.h"
#import "FindNewMessageList.h"

@implementation LYFindHttpTool

#pragma  mark - 获取当前用户未读推送信息

+ (void)getNotificationMessageWithParams:(NSDictionary *)params compelte:(void(^)(NSArray *dataArray))compelte{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LYNewMessage baseURL:QINIU_SERVER params:params success:^(id response) {
        NSLog(@"---->%@",response);
        NSString *errorCodeStr = response[@"errorcode"];
        if ([errorCodeStr isEqualToString:@"1"]) {
            NSArray *dataArray = response[@"data"];
            NSArray *newMessageArr = [FindNewMessage mj_objectArrayWithKeyValuesArray:dataArray];
            compelte(newMessageArr);
        }else{
            compelte(nil);
        }
    } failure:^(NSError *err) {
        compelte(nil);
    }];
}

#pragma mark - 获取用户推送记录
+ (void)getNotificationMessageListWithParams:(NSDictionary *)params compelte:(void (^)(NSArray *))compelte{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LYNewMessageDetail baseURL:QINIU_SERVER params:params success:^(id response) {
        NSLog(@"---->%@",response);
        NSString *errorCodeStr = response[@"errorcode"];
        if ([errorCodeStr isEqualToString:@"1"]) {
            NSArray *dataArray = response[@"items"];
            NSArray *newMessageArr = [FindNewMessageList mj_objectArrayWithKeyValuesArray:dataArray];
            compelte(newMessageArr);
        }else{
            compelte(nil);
        }
    } failure:^(NSError *err) {
        compelte(nil);
    }];
}

#pragma mark - 推送信息标识为已读
+ (void)NotificationMessageListReadedWithParams:(NSDictionary *)params compelte:(void (^)(NSArray *))compelte{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LYNewMessageReaded baseURL:QINIU_SERVER params:params success:^(id response) {
        NSLog(@"---->%@",response);
        NSString *errorCodeStr = response[@"errorcode"];
        if ([errorCodeStr isEqualToString:@"1"]) {
            
        }else{
            
        }
    } failure:^(NSError *err) {
        compelte(nil);
    }];
}

@end
