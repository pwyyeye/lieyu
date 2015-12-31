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
#import "FriendsCommentModel.h"

@implementation LYFriendsHttpTool

//获取最新的玩友圈动态
+ (void)friendsGetRecentInfoWithParams:(NSDictionary *)params compelte:(void(^)(NSMutableArray *dataArray))compelte{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_Friends_Recent baseURL:LY_SERVER params:params success:^(id response) {
        NSDictionary *dictionary = response[@"data"];
        NSArray *itemsArray = dictionary[@"items"];
        NSMutableArray *array = [[NSMutableArray alloc]initWithArray:[FriendsRecentModel initFormNSArray:itemsArray]];
        compelte(array);
        [app stopLoading];
    } failure:^(NSError *err) {
        [MyUtil showMessage:@"请求失败"];
        [app stopLoading];
    }];
}

//获取指定用户的玩友圈动态
+ (void)friendsGetUserInfoWithParams:(NSDictionary *)params compelte:(void (^)(NSMutableArray *))compelte{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSLog(@"------>%@",params);
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_Friends_User baseURL:LY_SERVER params:params success:^(id response) {
        NSDictionary *dictionary = response[@"data"];
        NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[FriendsRecentModel mj_objectArrayWithKeyValuesArray:dictionary[@"moments"]]];
        compelte(array);
        [app stopLoading];
    }failure:^(NSError *err) {
        [MyUtil showMessage:@"请求失败"];
        [app stopLoading];
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
        NSLog(@"-->%@",response[@"message"]);
        if([response[@"message"] isEqualToString:@"取消点赞成功"]){
            [MyUtil showPlaceMessage:@"点赞成功"];
            compelte(YES);
        }else{
            [MyUtil showPlaceMessage:@"取消点赞成功"];
            compelte(NO);
        }
        
        
    } failure:^(NSError *err) {
         [MyUtil showPlaceMessage:@"操作失败,请检查网络连接"];
    }];
}
//给动态或者某人评论
+ (void)friendsCommentWithParams:(NSDictionary *)params compelte:(void (^)(bool))compelte{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_Friends_Comment baseURL:LY_SERVER params:params success:^(id response) {
        NSLog(@"------>%@",response[@"message"]);
        if ([response[@"errorcode"] isEqualToString:@"1"]) {
            compelte(YES);
        }
    } failure:^(NSError *err) {
         [MyUtil showPlaceMessage:@"操作失败,请检查网络连接"];
    }];
}

//发布动态
+ (void)friendsSendMessageWithParams:(NSDictionary *)params compelte:(void (^)(bool))compelte{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_Friends_Send baseURL:LY_SERVER params:params success:^(id response) {
        NSLog(@"------->%@",response[@"message"]);
         [MyUtil showPlaceMessage:response[@"message"]];
        [app stopLoading];
    }failure:^(NSError *err) {
        [app stopLoading];
     }];
}

//删除我的动态
+ (void)friendsDeleteMyMessageWithParams:(NSDictionary *)params compelte:(void (^)(bool))compelte{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_Friends_DeleteMyMessage baseURL:LY_SERVER params:params success:^(id response) {
        NSLog(@"------->%@",response[@"message"]);
        compelte(YES);
        [MyUtil showPlaceMessage:response[@"message"]];
    }failure:^(NSError *err) {
        
    }];
}

//获取动态评论
+ (void)friendsGetMessageDetailAllCommentsWithParams:(NSDictionary *)params compelte:(void (^)(NSMutableArray *commentArray))compelte{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_Friends_AllComments baseURL:LY_SERVER params:params success:^(id response) {
        NSLog(@"------->%@",response[@"message"]);
        if ([response[@"errorcode"] isEqualToString:@"1"]) {
            NSArray *dataArray = response[@"data"][@"items"];
            NSMutableArray *commentArray  = [[NSMutableArray alloc] initWithArray:[FriendsCommentModel mj_objectArrayWithKeyValuesArray:dataArray]];
            compelte(commentArray);
        }
        [app stopLoading];
    }failure:^(NSError *err) {
        [app stopLoading];
    }];
}

//删除我的评论
+ (void)friendsDeleteMyCommentWithParams:(NSDictionary *)params compelte:(void (^)(bool))compelte{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_Friends_DeleteMyComment baseURL:LY_SERVER params:params success:^(id response) {
        NSLog(@"------->%@",response[@"message"]);
        compelte(YES);
    }failure:^(NSError *err) {
        
    }];
}

@end
