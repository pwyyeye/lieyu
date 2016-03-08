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
#import "FriendsNewsModel.h"
#import "FriendsUserInfoModel.h"

@implementation LYFriendsHttpTool

//获取最新的玩友圈动态
+ (void)friendsGetRecentInfoWithParams:(NSDictionary *)params compelte:(void(^)(NSMutableArray *dataArray))compelte{
//    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_Friends_Recent baseURL:LY_SERVER params:params success:^(id response) {
        NSDictionary *dictionary = response[@"data"];
        NSArray *itemsArray = dictionary[@"items"];
        if (itemsArray!=nil) {
            NSMutableArray *array = [[NSMutableArray alloc]initWithArray:[FriendsRecentModel initFormNSArray:itemsArray]];
            compelte(array);
        }else{
            compelte([NSMutableArray arrayWithCapacity:0]);
        }
        
        
//        [app stopLoading];
    } failure:^(NSError *err) {
        [MyUtil showMessage:@"请求失败"];
        compelte([NSMutableArray arrayWithCapacity:0]);
//        [app stopLoading];
    }];
}

//获取指定用户的玩友圈动态
+ (void)friendsGetUserInfoWithParams:(NSDictionary *)params compelte:(void (^)(FriendsUserInfoModel*, NSMutableArray *))compelte{
   
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_Friends_User baseURL:LY_SERVER params:params success:^(id response) {
        NSDictionary *dictionary = response[@"data"];
        NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[FriendsRecentModel mj_objectArrayWithKeyValuesArray:dictionary[@"moments"]]];
        FriendsUserInfoModel *userInfo = [FriendsUserInfoModel mj_objectWithKeyValues:dictionary];
        compelte(userInfo, array);
    }failure:^(NSError *err) {
        compelte(nil,nil);
        [MyUtil showMessage:@"请求失败"];
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
            compelte(NO);
            [MyUtil showLikePlaceMessage:@"取消表白成功"];
        }else{
            compelte(YES);
            [MyUtil showLikePlaceMessage:@"表白成功"];
        }
        
        
    } failure:^(NSError *err) {
         [MyUtil showPlaceMessage:@"操作失败,请检查网络连接"];
    }];
}
//给动态或者某人评论
+ (void)friendsCommentWithParams:(NSDictionary *)params compelte:(void (^)(bool,NSString *))compelte{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_Friends_Comment baseURL:LY_SERVER params:params success:^(id response) {
        NSLog(@"------>%@",response[@"message"]);
        if ([response[@"errorcode"] isEqualToString:@"1"]) {
            compelte(YES,response[@"data"][@"commentId"]);
        }
    } failure:^(NSError *err) {
         [MyUtil showPlaceMessage:@"操作失败,请检查网络连接"];
    }];
}

//发布动态
+ (void)friendsSendMessageWithParams:(NSDictionary *)params compelte:(void (^)(bool,NSString *))compelte{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_Friends_Send baseURL:LY_SERVER params:params success:^(id response) {
        NSLog(@"------->%@---------%@",response[@"message"],response);
       dispatch_async(dispatch_get_main_queue(), ^{
           compelte(YES,response[@"data"]);
       });
//        [app stopLoading];
    }failure:^(NSError *err) {
//        [app stopLoading];
        compelte(NO,@"");
        [MyUtil showPlaceMessage:@"操作失败,请检查网络连接"];
     }];
}

//删除我的动态
+ (void)friendsDeleteMyMessageWithParams:(NSDictionary *)params compelte:(void (^)(bool))compelte{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_Friends_DeleteMyMessage baseURL:LY_SERVER params:params success:^(id response) {
        NSLog(@"------->%@",response[@"message"]);
        compelte(YES);
        [MyUtil showCleanMessage:@"删除成功"];
    }failure:^(NSError *err) {
        
    }];
}

//获取动态评论
+ (void)friendsGetMessageDetailAllCommentsWithParams:(NSDictionary *)params compelte:(void (^)(NSMutableArray *commentArray))compelte{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_Friends_AllComments baseURL:LY_SERVER params:params success:^(id response) {
        if ([response[@"errorcode"] isEqualToString:@"1"]) {
            NSArray *dataArray = response[@"data"][@"items"];
            NSMutableArray *commentArray  = [[NSMutableArray alloc] initWithArray:[FriendsCommentModel mj_objectArrayWithKeyValuesArray:dataArray]];
            compelte(commentArray);
        }
    }failure:^(NSError *err) {
        [MyUtil showCleanMessage:@"获取数据失败"];
    }];
}

//删除我的评论
+ (void)friendsDeleteMyCommentWithParams:(NSDictionary *)params compelte:(void (^)(bool))compelte{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_Friends_DeleteMyComment baseURL:LY_SERVER params:params success:^(id response) {
          if ([response[@"errorcode"] isEqualToString:@"1"]) {
              compelte(YES);
          }
    }failure:^(NSError *err) {
        
    }];
}

//获取最新消息
+ (void)friendsGetFriendsMessageNotificationWithParams:(NSDictionary *)params compelte:(void (^)(NSString *,NSString*))compelte{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_Friends_NewMessage baseURL:LY_SERVER params:params success:^(id response) {
        NSLog(@"------->%@",response);
        if ([response[@"errorcode"] isEqualToString:@"1"]) {
            NSArray *array = response[@"data"];
            if(!array.count) return;
            NSDictionary *dic = array[0];
            compelte(dic[@"results"],dic[@"icon"]);
        }
    }failure:^(NSError *err) {
        
    }];
}

//获取最新消息明细
+ (void)friendsGetFriendsMessageNotificationDetailWithParams:(NSDictionary *)params compelte:(void (^)(NSArray *))compelte{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_Friends_NewMessageDetail baseURL:LY_SERVER params:params success:^(id response) {
        NSLog(@"------->%@",response);
        if ([response[@"errorcode"] isEqualToString:@"1"]) {
            NSDictionary *dic = response[@"data"];
            NSArray *array = dic[@"items"];
            NSArray *dataArray = [FriendsNewsModel mj_objectArrayWithKeyValuesArray:array];
            compelte(dataArray);
        }
        [app stopLoading];
    }failure:^(NSError *err) {
        [app stopLoading];        
    }];
}

//更改玩友圈背景图片
+ (void)friendsChangeBGImageWithParams:(NSDictionary *)params compelte:(void (^)(bool))compelte{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_SAVE_USERINFO baseURL:LY_SERVER params:params success:^(id response) {
        [app stopLoading];
        NSLog(@"------->%@",response);
          if ([response[@"errorcode"] isEqual:@"1"]) {
              compelte(YES);
          }
    } failure:^(NSError *err) {
         [app stopLoading];
    }];
}

//根据动态id获取动态
+ (void)friendsGetAMessageWithParams:(NSDictionary *)params compelte:(void (^)(FriendsRecentModel *))compelte{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_Friends_GetAMessage baseURL:LY_SERVER params:params success:^(id response) {
        [app stopLoading];
        NSLog(@"------->%@",response);
        if ([response[@"errorcode"] isEqual:@"1"]) {
          FriendsRecentModel *mod = [FriendsRecentModel initFromNSDictionary:response[@"data"]];
            compelte(mod);
        }
    }failure:^(NSError *err) {
        NSLog(@"----pass-friendsGetAMessageWithParams:%@---",err);
                [app stopLoading];
    }];
}

+ (void)friendsJuBaoWithParams:(NSDictionary *)params complete:(void(^)(NSString *))complete{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_Friends_JuBaoDT baseURL:LY_SERVER params:params success:^(id response) {
//        [MyUtil showCleanMessage:response[@"message"]];
        NSString *message = response[@"message"];
        complete(message);
    } failure:^(NSError *err) {
//        [MyUtil showCleanMessage:@"举报失败，请检查网络！"];
        [MyUtil showLikePlaceMessage:@"举报失败，请检查网络！"];
    }];
}

+ (void)friendsPingBiUserWithParams:(NSDictionary *)params complete:(void(^)(NSString *))complete{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_Friends_PingBiUser baseURL:LY_SERVER params:params success:^(id response) {
        NSString *message = response[@"message"];
        complete(message);
    } failure:^(NSError *err) {
        [MyUtil showLikePlaceMessage:@"屏蔽失败，请检查网络"];
    }];
}
@end
