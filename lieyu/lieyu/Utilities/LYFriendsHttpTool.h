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

@interface LYFriendsHttpTool : NSObject
//获取最新的玩友圈动态
+ (void)friendsGetRecentInfoWithParams:(NSDictionary *)params compelte:(void(^)(NSMutableArray *dataArray))compelte;
//获取我的的玩友圈动态
+ (void)friendsGetUserInfoWithParams:(NSDictionary *)params compelte:(void (^)(NSMutableArray *))compelte;
//获取我的的玩友圈消息
+ (void)friendsGetMyNewsMessageWithParams:(NSDictionary *)params compelte:(void (^)(FriendsUserMessageModel *))compelte;
//给别人玩友圈动态点赞
+ (void)friendsLikeMessageWithParams:(NSDictionary *)params compelte:(void (^)(bool ))compelte;
//给动态或者某人评论
+ (void)friendsCommentWithParams:(NSDictionary *)params compelte:(void (^)(bool))compelte;
//发布动态
+ (void)friendsSendMessageWithParams:(NSDictionary *)params compelte:(void (^)(bool))compelte;
//删除我的动态
+ (void)friendsDeleteMyMessageWithParams:(NSDictionary *)params compelte:(void (^)(bool))compelte;
//获取动态评论
+ (void)friendsGetMessageDetailAllCommentsWithParams:(NSDictionary *)params compelte:(void (^)(NSMutableArray *commentArray))compelte;
@end
