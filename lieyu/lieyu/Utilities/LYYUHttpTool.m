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
#import "BarActivityList.h"
#import "UserModel.h"
#import "BlockListModel.h"

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
#pragma mark - 娱获取所有需求标签
+ (void)yuGetYUAllTagsWithParams:(NSDictionary *)params complete:(void(^)(NSMutableArray *yuTagsModelArr))complete{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_YU_GETTAG baseURL:LY_SERVER params:params success:^(id response) {
        NSString *errorCodeStr = response[@"errorcode"];
        if([errorCodeStr isEqualToString:@"1"]){
            NSMutableArray *array = [BarActivityList mj_objectArrayWithKeyValuesArray:response[@"data"]];
            complete(array);
        }
//        [app stopLoading];
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

#pragma mark - 举报愿望
+ (void)YUReportWishComplete:(void (^)(BOOL))complete{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_YU_JUBAO baseURL:LY_SERVER params:nil success:^(id response) {
        NSString *errorCode = response[@"errorcode"];
        if ([errorCode isEqualToString:@"1"]) {
            complete(YES);
        }else{
            complete(NO);
        }
        [app stopLoading];
    } failure:^(NSError *err) {
        [app stopLoading];
    }];
}

#pragma mark - 回复愿望
+ (void)yuReplyWishCompleteWithParams:(NSDictionary *)params complete:(void (^)(BOOL))complete{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_YU_REPLY baseURL:LY_SERVER params:params success:^(id response) {
        NSString *errorCode = [response objectForKey:@"errorcode"];
        if ([errorCode isEqualToString:@"1"]) {
            complete(true);
        }
        [app stopLoading];
    } failure:^(NSError *err) {
        [app stopLoading];
    }];
}

#pragma mark - 将用户踢出聊天室
+ (void)yuRemoveUserFromeChatRoomWith:(NSDictionary *)paraDic complete:(void (^)(BOOL))complete{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_YU_CHATROOM_REMOVE baseURL:QINIU_SERVER params:paraDic success:^(id response) {
        NSString *errorCode = response[@"errorcode"];
        if ([errorCode isEqualToString:@"1"]) {
            complete(YES);
            [MyUtil showCleanMessage:@"移除成功"];
        }else{
            complete(NO);
            [MyUtil showCleanMessage:@"移除失败"];
        }
        [app stopLoading];
    } failure:^(NSError *err) {
        [MyUtil showCleanMessage:@"操作错误，请检查网络设置"];
        [app stopLoading];
    }];
}

#pragma mark - 获取聊天室成员
+ (void)yuGetChatRoomAllStaffWith:(NSDictionary *)paraDic complete:(void (^)(NSArray *))complete{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_YU_CHATOOM_ALLSTAFF baseURL:LY_SERVER params:paraDic success:^(id response) {
        NSString *errorCode = response[@"errorcode"];
        if ([errorCode isEqualToString:@"1"]) {
//            NSLog(@"response  %@",response);
            NSArray *dataArr = response[@"data"];
            NSArray *dataArray = [UserModel mj_objectArrayWithKeyValuesArray:dataArr];
            complete(dataArray);
        }else{
            
        }
    } failure:^(NSError *err) {
        
    }];
    
}
#pragma mark - 群组操作
//同步用户群组信息
+ (void)yuUpdataGroupInfoWith:(NSDictionary *) paraDic complete:(void(^)(NSString *))complete {
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_YU_QUNZU_CUSTOM baseURL:LY_SERVER params:paraDic success:^(id response) {
        NSString *data = response[@"data"][@"code"];
        complete(data);
    } failure:^(NSError *err) {
        
    }];
}

//创建群
+ (void)yuCreatGroupWith:(NSDictionary *) paraDic complete:(void (^)(NSDictionary *))complete{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_YU_QUNZU_CREAT baseURL:LY_SERVER params:paraDic success:^(id response) {
        NSDictionary *data = response[@"data"];
        NSString *meeages = response[@"message"];
        NSLog(@"%@",meeages);
        complete(data);
    } failure:^(NSError *err) {
        
    }];
}

//加入群
+ (void)yuJoinGroupWith:(NSDictionary *) paraDic complete: (void (^)(NSDictionary *)) complete{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_YU_QUNZU_JOIN baseURL:QINIU_SERVER params:paraDic success:^(id response) {
        NSDictionary *data = response[@"data"];
        NSString *meeages = response[@"message"];
        NSLog(@"%@",meeages);
        complete(data);
    } failure:^(NSError *err) {
        
    }];
}

//退出群
+ (void)yuQuitGroupWith: (NSDictionary *) paraDic complete:(void (^)(NSDictionary *))complete{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_YU_QUNZU_QUIT baseURL:LY_SERVER params:paraDic success:^(id response) {
        NSDictionary *data = response[@"data"];
        complete(data);
    } failure:^(NSError *err) {
        
    }];
}

//解散群
+ (void)yuDismissGroupWith:(NSDictionary *) paraDic complete: (void (^)(NSDictionary *)) complete{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_YU_QUNZU_DISMISS baseURL:LY_SERVER params:paraDic success:^(id response) {
        NSDictionary *data = response[@"data"];
        complete(data);
    } failure:^(NSError *err) {
        
    }];
}

//刷新群信息
+ (void)yuRefreashGroupWith: (NSDictionary *) paraDic complete: (void (^)(NSDictionary *)) complete{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_YU_QUNZU_REFREASH baseURL:LY_SERVER params:paraDic success:^(id response) {
        NSDictionary *data = response[@"data"];
        complete(data);
    } failure:^(NSError *err) {
        
    }];
}

//获取群内成员
+ (void)yuGetGroupListWith: (NSDictionary *) paraDic complete: (void (^)(NSArray *)) complete{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_YU_QUNZU_LIST baseURL:LY_SERVER params:paraDic success:^(id response) {
        NSArray *usersArr = response[@"data"];
        
        NSArray *dataArr = [UserModel mj_objectArrayWithKeyValuesArray:usersArr];
        NSString *meeages = response[@"message"];
        NSLog(@"%@",meeages);
        complete(dataArr);
    } failure:^(NSError *err) {
        
    }];
}

#pragma mark - 禁言操作
//添加禁言群成员
+ (void)yuAddLogInWith: (NSDictionary *) paraDic complete: (void (^) (NSDictionary *)) complete{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_YU_QUNZU_LOGIN baseURL:LY_SERVER params:paraDic success:^(id response) {
        NSDictionary *data = response[@"data"];
        complete(data);
    } failure:^(NSError *err) {
        
    }];
}

//移除禁言群成员
+ (void)yuRemoveLogOutWith: (NSDictionary *)  paraDic complete:(void (^)(NSDictionary *)) complete{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_YU_QUNZU_LOGOUT baseURL:LY_SERVER params:paraDic success:^(id response) {
        NSDictionary *data = response[@"data"];
        complete(data);
    } failure:^(NSError *err) {
        
    }];
}

//查询被禁言的群成员
+ (void)yuExpandAllLogInWith: (NSDictionary *) paraDioc complete: (void (^)(NSArray *)) complete{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_YU_QUNZU_EXPAND baseURL:LY_SERVER params:paraDioc success:^(id response) {
        NSArray *Arr = response[@"users"];
        NSArray *dataArr = [BlockListModel mj_objectArrayWithKeyValuesArray:Arr];
        NSString *meeages = response[@"message"];
        NSLog(@"%@",meeages);
        complete(dataArr);
    } failure:^(NSError *err) {
        
    }];
}

//申请成为群主
+(void)yuRegisterQunZhuWith: (NSDictionary *) paaraDic complete: (void (^)(NSString *)) complete{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_YU_QUNZU_BARMANNGER baseURL:LY_SERVER params:paaraDic success:^(id response) {

        complete(response[@"message"]);
        
    } failure:^(NSError *err) {
        
    }];
}

@end
