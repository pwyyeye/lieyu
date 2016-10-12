//
//  LYAdviserHttpTool.m
//  lieyu
//
//  Created by 狼族 on 16/5/30.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYAdviserHttpTool.h"
#import "HTTPController.h"
#import "LYAdviserUrl.h"
#import "LYAdviserManagerBriefInfo.h"
#import "FriendsRecentModel.h"

@implementation LYAdviserHttpTool
#pragma mark - 获取专属经理
+ (void)lyGetManagerInfoWithParams:(NSDictionary *)params complete:(void (^)(LYAdviserInfoModel *))complete{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_ADVISER_GETMANAGERINFO baseURL:LY_SERVER params:params success:^(id response) {
        NSString *errorCode = [response objectForKey:@"errorcode"];
        if ([errorCode isEqualToString:@"1"]) {
            NSDictionary *dict = [response objectForKey:@"data"];
            LYAdviserInfoModel *model = [LYAdviserInfoModel mj_objectWithKeyValues:dict];
            complete(model);
        }else{
            [MyUtil showCleanMessage:@"获取数据失败！"];
        }
        [app stopLoading];
    } failure:^(NSError *err) {
        [app stopLoading];
    }];
}


#pragma mark - 免费预订
+ (void)lyFreeBookWithParams:(NSDictionary *)params complete:(void (^)(NSString *))complete{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_ADVISER_FREEBOOK baseURL:LY_SERVER params:params success:^(id response) {
        NSString *errorCode = [response objectForKey:@"errorcode"];
        if ([errorCode isEqualToString:@"1"]) {
            complete(@"免费订台成功！");
        }else{
            complete(@"免费订台失败，请稍后重试！");
        }
        [app stopLoading];
    } failure:^(NSError *err) {
        [app stopLoading];
    }];
}

#pragma mark - 关注专属经理
+ (void)lyAddCollectWithParams:(NSDictionary *)params complete:(void (^)(BOOL))complete{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_ADVISER_ADDCARE baseURL:LY_SERVER params:params success:^(id response) {
        NSString *errorCode = [response objectForKey:@"errorcode"];
        BOOL result;
        if ([errorCode isEqualToString:@"1"]) {
            result = YES;
            complete(result);
        }else{
            result = NO;
            complete(result);
        }
        [app stopLoading];
    } failure:^(NSError *err) {
        [app stopLoading];
        complete(NO);
    }];
}

#pragma mark - 取消关注专属经理
+ (void)lyDeleteCollectWithParams:(NSDictionary *)params complete:(void (^)(BOOL))complete{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_ADVISER_DELCARE baseURL:LY_SERVER params:params success:^(id response) {
        NSString *errorCode = [response objectForKey:@"errorcode"];
        BOOL result;
        if ([errorCode isEqualToString:@"1"]) {
            result = YES;
            complete(result);
        }else{
            result = NO;
            complete(result);
        }
        [app stopLoading];
    } failure:^(NSError *err) {
        complete(NO);
        [app stopLoading];
    }];
}

#pragma mark - 查看粉丝
+ (void)lyCheckFansWithParams:(NSDictionary *)params complete:(void (^)(NSArray *))complete{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_ADVISER_CHECKFANS baseURL:LY_SERVER params:params success:^(id response) {
        NSString *errorCode = [response objectForKey:@"errorcode"];
        if ([errorCode isEqualToString:@"1"]) {
            NSArray *dataList = [LYAdviserManagerBriefInfo mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
            complete(dataList);
        }else{
            [MyUtil showCleanMessage:@"获取数据失败！"];
        }
        [app stopLoading];
    } failure:^(NSError *err) {
        [app stopLoading];
    }];
}

#pragma mark - 新的获取粉丝列表
+ (void)lyGetNewFansListWithParams:(NSDictionary *)params complete:(void (^)(NSArray *))complete{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_NEWGET_FANSLIST baseURL:LY_SERVER params:params success:^(id response) {
        NSString *errorCode = [response objectForKey:@"errorcode"];
        if ([errorCode isEqualToString:@"1"]) {
            NSArray *dataList = [UserModel mj_objectArrayWithKeyValuesArray:[[response objectForKey:@"data"] objectForKey:@"fansList"]];
            complete(dataList);
        }else{
            [MyUtil showPlaceMessage:[response objectForKey:@"message"]];
        }
        [app stopLoading];
    } failure:^(NSError *err) {
        [app stopLoading];
    }];
}

#pragma mark - 新的获取关注列表
+ (void)lyGetNewFollowsListWithParams:(NSDictionary *)params complete:(void (^)(NSArray *))complete{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_NEWGET_FOLLOWLIST baseURL:LY_SERVER params:params success:^(id response) {
        NSString *errorCode = [response objectForKey:@"errorcode"];
        if ([errorCode isEqualToString:@"1"]) {
            NSArray *dataList = [UserModel mj_objectArrayWithKeyValuesArray:[[response objectForKey:@"data"] objectForKey:@"followlist"]];
            complete(dataList);
        }else{
            [MyUtil showPlaceMessage:[response objectForKey:@"message"]];
        }
        [app stopLoading];
    } failure:^(NSError *err) {
        [app stopLoading];
    }];
}

#pragma mark - 获取专属经理列表
+ (void)lyGetAdviserListWithParams:(NSDictionary *)params complete:(void (^)(HomePageModel *))complete{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_ADVISER_GETMANAGERS baseURL:LY_SERVER params:params success:^(id response) {
        NSString *errorCode = [response objectForKey:@"errorcode"];
        if ([errorCode isEqualToString:@"1"]) {
            HomePageModel *model = [HomePageModel mj_objectWithKeyValues:[response objectForKey:@"data"]];
            complete(model);
        }else{
            [MyUtil showLikePlaceMessage:@"获取数据失败！"];
        }
        [app stopLoading];
    } failure:^(NSError *err) {
        [app stopLoading];
    }];
}

#pragma mark - 获取专属经理直播列表
+ (void)lyGetAdviserVideoWithParams:(NSDictionary *)params complete:(void (^)(NSArray *))complete{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_ADVISER_GETVIDEOS baseURL:LY_SERVER params:params success:^(id response) {
        NSString *errorCode = [response objectForKey:@"errorcode"];
        if ([errorCode isEqualToString:@"1"]) {
            NSArray *dataList = [FriendsRecentModel mj_objectArrayWithKeyValuesArray:[[response objectForKey:@"data"] objectForKey:@"items"]];
            complete(dataList);
        }else{
            [MyUtil showLikePlaceMessage:@"获取数据失败！"];
        }
        [app stopLoading];
    } failure:^(NSError *err) {
        [app stopLoading];
    }];
}


@end
