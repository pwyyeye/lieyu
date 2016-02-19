//
//  LYFriendsHttpTool.h
//  lieyu
//
//  Created by 狼族 on 15/12/25.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FriendsRecentModel;
@class FriendsUserMessageModel;
@class FriendsUserInfoModel;

@interface LYFriendsHttpTool : NSObject
//获取最新的玩友圈动态
+ (void)friendsGetRecentInfoWithParams:(NSDictionary *)params compelte:(void(^)(NSMutableArray *dataArray))compelte;
//获取我的的玩友圈动态
+ (void)friendsGetUserInfoWithParams:(NSDictionary *)params compelte:(void (^)(FriendsUserInfoModel*, NSMutableArray *))compelte;
//获取我的的玩友圈消息
+ (void)friendsGetMyNewsMessageWithParams:(NSDictionary *)params compelte:(void (^)(FriendsUserMessageModel *))compelte;
//给别人玩友圈动态点赞
+ (void)friendsLikeMessageWithParams:(NSDictionary *)params compelte:(void (^)(bool ))compelte;
//给动态或者某人评论
+ (void)friendsCommentWithParams:(NSDictionary *)params compelte:(void (^)(bool,NSString *))compelte;
//发布动态
+ (void)friendsSendMessageWithParams:(NSDictionary *)params compelte:(void (^)(bool,NSString *))compelte;
//删除我的动态
+ (void)friendsDeleteMyMessageWithParams:(NSDictionary *)params compelte:(void (^)(bool))compelte;
//获取动态评论
+ (void)friendsGetMessageDetailAllCommentsWithParams:(NSDictionary *)params compelte:(void (^)(NSMutableArray *commentArray))compelte;
//删除我的评论
+ (void)friendsDeleteMyCommentWithParams:(NSDictionary *)params compelte:(void (^)(bool))compelte;
//获取最新消息
+ (void)friendsGetFriendsMessageNotificationWithParams:(NSDictionary *)params compelte:(void (^)(NSString *,NSString*))compelte;
//获取最新消息明细
+ (void)friendsGetFriendsMessageNotificationDetailWithParams:(NSDictionary *)params compelte:(void (^)(NSArray *))compelte;
//更改玩友圈背景图片
+ (void)friendsChangeBGImageWithParams:(NSDictionary *)params compelte:(void (^)(bool))compelte;
//根据动态id获取动态
+ (void)friendsGetAMessageWithParams:(NSDictionary *)params compelte:(void (^)(FriendsRecentModel *))compelte;
//举报
+ (void)friendsJuBaoWithParams:(NSDictionary *)params complete:(void(^)(void))complete;
@end
