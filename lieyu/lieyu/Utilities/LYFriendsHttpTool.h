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
+ (void)friendsGetUserInfoWithParams:(NSDictionary *)params needLoading:(BOOL)need compelte:(void (^)(FriendsUserInfoModel*, NSMutableArray *))compelte;
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
+ (void)friendsJuBaoWithParams:(NSDictionary *)params complete:(void(^)(NSString *))complete;
//屏蔽
+ (void)friendsPingBiUserWithParams:(NSDictionary *)params complete:(void(^)(NSString *))complete;
//根据话题ID获取玩友圈动态
+ (void)friendsGetFriendsTopicWithParams:(NSDictionary *)params complete:(void(^)(NSArray *))complete;


#pragma mark ----  直播方法

//获取stream
+(void)getStreamWithParms: (NSDictionary *)parms complete:(void(^)(NSDictionary *dict))complete failure:(void(^)(NSString *error))err;


//开始直播
+(void) beginToLiveShowWithParams:(NSDictionary *)params complete:(void(^)(NSDictionary *dict))complete;

//获取直播列表
+(void) getLiveShowlistWithParams:(NSDictionary *)params complete: (void (^)(NSArray *Arr)) complete;

//进入直播间
+(void) getLiveShowRoomWithParams:(NSDictionary *)params complete: (void (^)(NSDictionary *Arr))complete;

//结束直播
+(void) closeLiveShowWithParams: (NSDictionary *)params complete : (void(^)(NSDictionary *dict))complete;

//获取直播间打赏金额
+(void)getLiveMoneyWithParams:(NSDictionary *) params complete: (void(^)(NSDictionary *dict))complete;

//点赞
+(void) watchLikeWithParms: (NSDictionary *) parms complete: (void(^)(NSDictionary *dict))complete;

//请求人员列表
+(void) requestListWithParms:(NSDictionary *) parms complete: (void(^)(NSDictionary *dict))complete;

//获取直播状态
+(void) getLiveStatusWithParms:(NSDictionary *) parms complete: (void(^)(NSDictionary *dict))complete;

#pragma mark --- 最新玩友列表和粉丝
+(void) getfFriensGroupWithPrams: (NSDictionary *)prams complete: (void(^)(NSDictionary *dict)) complete;

+(void) getNewFansListWithParms: (NSDictionary *) parms complete: (void(^)(NSArray *Arr)) complete;

#pragma mark --- 最新关注-取消关注
+(void) followFriendWithParms:(NSDictionary *) parms complete: (void(^)(NSDictionary *dict))complete;

+(void) unFollowFriendWithParms:(NSDictionary *) parms complete: (void(^)(NSDictionary *dict))complete;

#pragma mark ---- 打赏
+(void) daShangWithParms:(NSDictionary *) parms complete: (void(^)(NSDictionary *))complete;
#pragma mark --- 打赏列表
+(void) getDaShangListParms: (NSDictionary *) parms complete: (void(^)(NSArray *)) complete;
#pragma mark - 删除直播
+ (void)deleteMyLiveRecord:(NSDictionary *)params complete:(void(^)(BOOL result))complete;

#pragma mark --- 是否拉黑
+(void) isBlackWithUserid:(NSString *) userid complete:(void(^)(NSDictionary *dic))complete;

#pragma mark --- 加入黑名单
+(void) setBlackWithUserid:(NSString *) userid complete:(void(^)(NSDictionary *dic))complete;

#pragma mark --- 移除黑名单
+(void) removeBlackWithUserid:(NSString *) userid complete:(void(^)(NSDictionary *dic))complete;


@end
