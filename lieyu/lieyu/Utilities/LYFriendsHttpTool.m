//
//  LYFriendsHttpTool.m
//  lieyu
//
//  Created by 狼族 on 15/12/25.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYFriendsHttpTool.h"
#import "HTTPController.h"
#import "LYFriendsPageUrl.h"
#import "FriendsRecentModel.h"
#import "FriendsUserMessageModel.h"

@implementation LYFriendsHttpTool

//获取最新的玩友圈动态
+ (void)friendsGetRecentInfoWithParams:(NSDictionary *)params compelte:(void(^)(NSArray *dataArray))compelte{

    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_Friends_Recent baseURL:LY_SERVER params:params success:^(id response) {
        NSDictionary *dictionary = response[@"data"];
        NSArray *itemsArray = dictionary[@"items"];
        NSArray *array = [FriendsRecentModel initFormNSArray:itemsArray];
        compelte(array);
    } failure:^(NSError *err) {
        [MyUtil showMessage:@"请求失败"];
    }];
}

//获取我的的玩友圈动态
+ (void)friendsGetUserInfoWithParams:(NSDictionary *)params compelte:(void (^)(FriendsUserMessageModel *))compelte{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_Friends_User baseURL:LY_SERVER params:params success:^(id response) {
        NSDictionary *dictionary = response[@"data"];
        FriendsUserMessageModel *userModel = [FriendsUserMessageModel initFormDictionary:dictionary];
        compelte(userModel);
    }failure:^(NSError *err) {
        
    }];
}

//获取我的的玩友圈消息
+ (void)friendsGetMyNewsMessageWithParams:(NSDictionary *)params compelte:(void (^)(FriendsUserMessageModel *))compelte{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_Friends_MyNewsMessage baseURL:LY_SERVER params:params success:^(id response) {
        NSLog(@"-->%@",response);
    } failure:^(NSError *err) {
        
    }];
}

//给别人玩友圈动态点赞
+ (void)friendsLikeMessageWithParams:(NSDictionary *)params compelte:(void (^)(bool))compelte{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_Friends_Like baseURL:LY_SERVER params:params success:^(id response) {
        NSLog(@"-->%@",response);
    } failure:^(NSError *err) {
        
    }];
}
@end
