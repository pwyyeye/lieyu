//
//  LYYUHttpTool.h
//  lieyu
//
//  Created by 狼族 on 16/1/31.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YUOrderShareModel.h"
@class BarActivityList;

@interface LYYUHttpTool : NSObject
//获取娱模版主页数据
+ (void)yuGetDataOrderShareWithParams:(NSDictionary *)params compelte:(void(^)(NSArray *dataArray))compelte;
+ (void)yuGetYuModelWithParams:(NSDictionary *)params complete:(void(^)(YUOrderShareModel *YUModel))complete;

//娱获取所有需求标签
+ (void)yuGetYUAllTagsWithParams:(NSDictionary *)params complete:(void(^)(NSMutableArray *yuTagsModelArr))complete;
//发布个人需求
+ (void)yuSendMYThemeWithParams:(NSDictionary *)params complete:(void(^)(BOOL))complete;
//获取所有愿望
+ (void)YUGetWishesListWithParams:(NSDictionary *)params complete:(void(^)(NSDictionary *result))complete;
//点击判断实现OR未实现愿望
+ (void)YUFinishWishOrNotWithParams:(NSDictionary *)params complete:(void(^)(BOOL result))complete;
//删除自己的愿望
+ (void)YUDeleteWishWithParams:(NSDictionary *)params complete:(void(^)(BOOL result))complete;
//举报愿望
+ (void)YUReportWishComplete:(void(^)(BOOL result))complete;
//回复愿望
+ (void)yuReplyWishCompleteWithParams:(NSDictionary *)params complete:(void (^)(BOOL))complete;
//将用户踢出聊天室
+ (void)yuRemoveUserFromeChatRoomWith:(NSDictionary *)paraDic complete:(void (^)(BOOL))complete;
//获取聊天室成员
+ (void)yuGetChatRoomAllStaffWith:(NSDictionary *)paraDic complete:(void (^)(NSArray *))complete;

//同步用户群组信息
+ (void)yuUpdataGroupInfoWith:(NSDictionary *) paraDic complete:(void(^)(NSString *))complete;

//创建群
+ (void)yuCreatGroupWith:(NSDictionary *) paraDic complete:(void (^)(NSDictionary *))complete;

//加入群
+ (void)yuJoinGroupWith:(NSDictionary *) paraDic complete: (void (^)(NSDictionary *)) complete;

//退出群
+ (void)yuQuitGroupWith: (NSDictionary *) paraDic complete:(void (^)(NSString *))complete;

//解散群
+ (void)yuDismissGroupWith:(NSDictionary *) paraDic complete: (void (^)(NSDictionary *)) complete;

//刷新群信息
+ (void)yuRefreashGroupWith: (NSDictionary *) paraDic complete: (void (^)(NSDictionary *)) complete;

//获取群内成员
+ (void)yuGetGroupListWith: (NSDictionary *) paraDic complete: (void (^)(NSArray *)) complete;

//添加禁言群成员
+ (void)yuAddLogInWith: (NSDictionary *) paraDic complete: (void (^) (NSDictionary *)) complete;

//移除禁言群成员
+ (void)yuRemoveLogOutWith: (NSDictionary *)  paraDic complete:(void (^)(NSString *)) complete;

//查询被禁言的群成员
+ (void)yuExpandAllLogInWith: (NSDictionary *) paraDioc complete: (void (^)(NSArray *)) complete;


//申请成为群主
+(void)yuRegisterQunZhuWith: (NSDictionary *) paaraDic complete: (void (^)(NSString *)) complete;

@end
