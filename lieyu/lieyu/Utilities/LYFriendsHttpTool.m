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
#import "LYLiveShowListModel.h"
#import "ChatUseres.h"
#import "FriendsListModel.h"
#import "FansModel.h"


#import "AFNetworking.h"//主要用于网络请求方法
#import "UIKit+AFNetworking.h"//里面有异步加载图片的方法

@implementation LYFriendsHttpTool

//获取最新的玩友圈动态
+ (void)friendsGetRecentInfoWithParams:(NSDictionary *)params compelte:(void(^)(NSMutableArray *dataArray))compelte{
//    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_Friends_Recent baseURL:LY_SERVER params:params success:^(id response) {
        if ([response[@"message"] isEqualToString:@"获取失败错误"]) {
            [MyUtil showMessage:@"获取失败"];
        } else {
            NSDictionary *dictionary = response[@"data"];
            if (dictionary) {
                NSArray *itemsArray = dictionary[@"items"];
                if (itemsArray!=nil) {
                    NSMutableArray *array = [[NSMutableArray alloc]initWithArray:[FriendsRecentModel initFormNSArray:itemsArray]];
                    compelte(array);
                }else{
                    compelte([NSMutableArray arrayWithCapacity:0]);
                }
            } else {
                
            }
        }
        
//        [app stopLoading];
    } failure:^(NSError *err) {
        [MyUtil showMessage:@"请求失败"];
        compelte([NSMutableArray arrayWithObject:@"0"]);
//        [app stopLoading];
    }];
}


//获取指定用户的玩友圈动态
+ (void)friendsGetUserInfoWithParams:(NSDictionary *)params needLoading:(BOOL)need compelte:(void (^)(FriendsUserInfoModel*, NSMutableArray *))compelte{
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_Friends_User baseURL:LY_SERVER params:params success:^(id response) {
        if ([response[@"message"] isEqualToString:@"获取失败错误"]) {
//            [MyUtil showMessage:@"获取失败"];
        } else {
            NSDictionary *dictionary = response[@"data"];
            NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[FriendsRecentModel mj_objectArrayWithKeyValuesArray:dictionary[@"moments"]]];
            FriendsUserInfoModel *userInfo = [FriendsUserInfoModel mj_objectWithKeyValues:dictionary];
            compelte(userInfo, array);
        }
       
    }failure:^(NSError *err) {
        compelte(nil,nil);
        [MyUtil showMessage:@"请求失败"];
        [app stopLoading];
    }];
}

//获取我的的玩友圈消息
+ (void)friendsGetMyNewsMessageWithParams:(NSDictionary *)params compelte:(void (^)(FriendsUserMessageModel *))compelte{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_Friends_MyNewsMessage baseURL:LY_SERVER params:params success:^(id response) {
//        NSLog(@"-->%@",response);
    } failure:^(NSError *err) {
        
    }];
}



//给别人玩友圈动态点赞
+ (void)friendsLikeMessageWithParams:(NSDictionary *)params compelte:(void (^)(bool))compelte{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_Friends_Like baseURL:LY_SERVER params:params success:^(id response) {
//        NSLog(@"-->%@",response[@"message"]);
        if([response[@"message"] isEqualToString:@"取消点赞成功"]){
            compelte(NO);
//            [MyUtil showLikePlaceMessage:@"取消表白成功"];
        }else{
            compelte(YES);
//            [MyUtil showLikePlaceMessage:@"表白成功"];
        }
        
        
    } failure:^(NSError *err) {
         [MyUtil showPlaceMessage:@"操作失败,请检查网络连接"];
    }];
}
//给动态或者某人评论
+ (void)friendsCommentWithParams:(NSDictionary *)params compelte:(void (^)(bool,NSString *))compelte{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_Friends_Comment baseURL:LY_SERVER params:params success:^(id response) {
//        NSLog(@"------>%@",response[@"message"]);
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
//        NSLog(@"------->%@---------%@",response[@"message"],response);
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
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_Friends_DeleteMyMessage baseURL:LY_SERVER params:params success:^(id response) {
//        NSLog(@"------->%@",response[@"message"]);
        compelte(YES);
        [app stopLoading];
//        [MyUtil showCleanMessage:@"删除成功"];
    }failure:^(NSError *err) {
         [app stopLoading];
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
//        NSLog(@"------->%@",response);
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
//        NSLog(@"------->%@",response);
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
//        NSLog(@"------->%@",response);
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
    if ([params objectForKey:@"needLoading"]!=nil && [[params objectForKey:@"needLoading"] isEqualToString:@"0"]) {
    
    }else{
        [app startLoading];
    }
    
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_Friends_GetAMessage baseURL:LY_SERVER params:params success:^(id response) {
        [app stopLoading];
//        NSLog(@"------->%@",response);
        if ([response[@"errorcode"] isEqual:@"1"]) {
          FriendsRecentModel *mod = [FriendsRecentModel initFromNSDictionary:response[@"data"]];
            compelte(mod);
        }else{
            compelte(nil);
        }
    }failure:^(NSError *err) {
        compelte(nil);
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

#pragma mark - 根据话题ID获取玩友圈动态
+ (void)friendsGetFriendsTopicWithParams:(NSDictionary *)params complete:(void(^)(NSArray *))complete{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_Friends_TopicMessage baseURL:LY_SERVER params:params success:^(id response) {
        NSString *errorCodeStr = response[@"errorcode"];
        if ([errorCodeStr isEqualToString:@"1"]) {
            NSDictionary *dataDic = response[@"data"];
            NSArray *dataArray = dataDic[@"items"];
            NSArray *friendRecentArray = [FriendsRecentModel mj_objectArrayWithKeyValuesArray:dataArray];
            complete(friendRecentArray);
        }
    } failure:^(NSError *err) {
        [MyUtil showLikePlaceMessage:@"获取失败，请检查网络"];
    }];
}

#pragma mark ----  直播
//获取stream
+(void)getStreamWithParms: (NSDictionary *)parms complete:(void(^)(NSDictionary *dict))complete failure:(void(^)(NSString *error))err{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_Live_getstream baseURL:LY_SERVER params:parms success:^(id response) {
        if ([response[@"message"] isEqualToString:@"0"]) {
            complete(response[@"data"]);
        } else {
            [MyUtil showMessage:[NSString stringWithFormat:@"%@",response[@"message"]]];
            err([NSString stringWithFormat:@"%@",response[@"errorcode"]]);
        }
    } failure:^(NSError *err) {
        
    }];
}
//开始直播
+(void) beginToLiveShowWithParams:(NSDictionary *)params complete:(void(^)(NSDictionary *dict))complete{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_Live_beginLive baseURL:LY_SERVER params:params success:^(id response) {
        if ([response[@"errorcode"] isEqualToString:@"success"]) {
            NSDictionary *dic = (NSDictionary *)response[@"data"];
            complete(dic);
        } else {
            [MyUtil showMessage:@"创建直播间失败"];
        }
    } failure:^(NSError *err) {
        NSLog(@"数据错误");
    }];
}

//获取直播列表
+(void) getLiveShowlistWithParams:(NSDictionary *)params complete: (void (^)(NSArray *Arr)) complete{
    
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_Live_getList baseURL:LY_SERVER params:params success:^(id response) {
        NSArray *array = [LYLiveShowListModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
        complete(array);
    } failure:^(NSError *err) {
        NSLog(@"数据错误");
    }];

}

//进入直播间
+(void) getLiveShowRoomWithParams:(NSDictionary *)params complete: (void (^)(NSDictionary *Arr))complete{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_Live_enter baseURL:LY_SERVER params:params success:^(id response) {
//        if ([response[@"message"] isEqualToString:@"return success!"]) {
            NSDictionary *dict = (NSDictionary *)response[@"data"];
            complete(dict);
//        } else {
//            [MyUtil showLikePlaceMessage:@"获取失败，请检查网络"];
//        }
    } failure:^(NSError *err) {
        [MyUtil showLikePlaceMessage:@"获取失败，请检查网络"];
    }];
}


//结束直播
+(void) closeLiveShowWithParams: (NSDictionary *)params complete : (void(^)(NSDictionary *dict))complete{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_Live_closeLive baseURL:LY_SERVER params:params success:^(id response) {
        
    } failure:^(NSError *err) {
        NSLog(@"%@", [err localizedDescription]);
    }];
}

//获取直播间打赏金额
+(void)getLiveMoneyWithParams:(NSDictionary *) params complete: (void(^)(NSDictionary *dict))complete{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_Live_getMoney baseURL:LY_SERVER params:params success:^(id response) {
        if ([response[@"errorcode"] isEqualToString:@"success"]) {
            NSDictionary *temp = response[@"data"];
            complete(temp);
        }
    } failure:^(NSError *err) {
        NSLog(@"%@", [err localizedDescription]);
    }];
}

//点赞
+(void) watchLikeWithParms: (NSDictionary *) parms complete: (void(^)(NSDictionary *dict))complete {
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_Live_like baseURL:LY_SERVER params:parms success:^(id response) {
        
    } failure:^(NSError *err) {
        
    }];
}

//请求人员列表
+(void) requestListWithParms:(NSDictionary *) parms complete: (void(^)(NSDictionary *dict))complete{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_Live_requestlist baseURL:LY_SERVER params:parms success:^(id response) {
        if ([response[@"errorcode"] isEqualToString:@"success"]) {
            NSDictionary *dic = response[@"data"];
            if ([dic[@"roomUserList"] objectForKey:@"users"]) {
                NSArray *users = [ChatUseres mj_objectArrayWithKeyValuesArray:dic[@"roomUserList"][@"users"]];
                NSDictionary *results = @{@"users":users,@"likeNum":dic[@"likeNum"],@"total":dic[@"roomUserList"][@"total"]};
                complete(results);
            } else {
                NSDictionary *results  = @{@"likeNum":dic[@"likeNum"]};
                complete(results);
            }
        } else {
//            [MyUtil showMessage:@"获取观众失败"];
        }
    } failure:^(NSError *err) {
        
    }];
}


//获取直播状态
+(void) getLiveStatusWithParms:(NSDictionary *) parms complete: (void(^)(NSDictionary *dict))complete{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_Live_liveStatus baseURL:LY_SERVER params:parms success:^(id response) {
        
        if ([response[@"errorcode"] isEqualToString:@"success"]) {
            NSDictionary *dic = response[@"data"];
            complete(dic);
        } else {
            [MyUtil showMessage:@"请求状态失败"];
        }
    } failure:^(NSError *err) {
        
    }];
}


#pragma mark --- 最新玩友列表和粉丝
+(void) getfFriensGroupWithPrams: (NSDictionary *)prams complete: (void(^)(NSDictionary *dict)) complete{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_Friends_friendsGroup baseURL:LY_SERVER params:prams success:^(id response) {
        if ([response[@"errorcode"] isEqualToString:@"success"]) {
            NSDictionary *tempDic = response[@"data"];
            if (![tempDic valueForKey:@"friendsList"]) {
                return;
            }
            NSArray *tempsArr = tempDic[@"friendsList"];
            NSMutableArray *friendsListArr = [NSMutableArray array];
                for (int i = 0; i<tempsArr.count; i++) {
                    FriendsListModel *model = [FriendsListModel new];
                    [model setValue:tempsArr[i][@"usernick"] forKey:@"userFriendName"];
                    [model setValue:tempsArr[i][@"username"] forKey:@"username"];
                    [model setValue:tempsArr[i][@"id"] forKey:@"id"];
                    if ([tempsArr valueForKey:@"mobile"]) {
                        [model setValue:tempsArr[i][@"mobile"] forKey:@"mobile"];
                    }
                    if ([tempsArr valueForKey:@"birthday"]) {
                        [model setValue:tempsArr[i][@"birthday"] forKey:@"birthday"];
                    }
                    if ([tempsArr valueForKey:@"avatar_img"]) {
                        [model setValue:tempsArr[i][@"avatar_img"] forKey:@"avatar_img"];
                    }
                    if ([tempsArr[i] valueForKey:@"sex"]) {
                        [model setValue:tempsArr[i][@"sex"] forKey:@"sex"];
                    }
                    [friendsListArr addObject:model];
                }

            
            NSDictionary *resultsDic = @{@"friendsList":friendsListArr,@"newFansListSize":tempDic[@"newFansListSize"]};
            complete(resultsDic);
        } else {
            [MyUtil showMessage:@"获取列表失败"];
        }
    } failure:^(NSError *err) {
        
    }];
}

+(void) getNewFansListWithParms: (NSDictionary *) parms complete: (void(^)(NSArray *Arr)) complete{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_Friends_newFriendsList baseURL:LY_SERVER params:parms success:^(id response) {
        if ([response[@"errorcode"] isEqualToString:@"success"]) {
            NSDictionary *tempDic = response[@"data"];
            NSArray *newFriendsList = [FansModel mj_objectArrayWithKeyValuesArray:tempDic[@"newFansList"]];
            complete(newFriendsList);
        } else {
            [MyUtil showMessage:@"获取粉丝失败"];
        }
    } failure:^(NSError *err) {
        
    }];
    
}
#pragma mark --- 最新关注-取消关注
+(void) followFriendWithParms:(NSDictionary *) parms complete: (void(^)(NSDictionary *dict))complete{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_Friends_follow baseURL:LY_SERVER params:parms success:^(id response) {
        if ([response[@"errorcode"] isEqualToString:@"success"]) {
            NSDictionary *dic = response[@"data"];
            [MyUtil showMessage:@"关注成功"];
            complete(dic);
        } else {
            [MyUtil showMessage:@"关注失败"];
        }
    } failure:^(NSError *err) {
        
    }];
}

+(void) unFollowFriendWithParms:(NSDictionary *) parms complete: (void(^)(NSDictionary *dict))complete{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_Frienfs_Unfollow baseURL:LY_SERVER params:parms success:^(id response) {
        if ([response[@"errorcode"] isEqualToString:@"success"]) {
            NSDictionary *dic = response[@"data"];
            [MyUtil showMessage:@"取消关注成功"];
            complete(dic);
        } else {
            [MyUtil showMessage:@"取消关注失败"];
        }
    } failure:^(NSError *err) {
        
    }];
}

#pragma mark ---- 打赏
+(void) daShangWithParms:(NSDictionary *) parms complete: (void(^)(NSDictionary *))complete{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_DaShang baseURL:LY_SERVER params:parms success:^(id response) {
        if ([response[@"errorcode"] isEqualToString:@"1"]) {
            complete(response);
        } else {
            complete(response);
        }
    } failure:^(NSError *err) {
        
    }];
}


@end
