//
//  LYAdviserHttpTool.h
//  lieyu
//
//  Created by 狼族 on 16/5/30.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYAdviserInfoModel.h"
#import "HomePageModel.h"

@interface LYAdviserHttpTool : NSObject
//获取专属经理
+ (void)lyGetManagerInfoWithParams:(NSDictionary *)params complete:(void(^)(LYAdviserInfoModel *adviserModel))complete;
//免费预订
+ (void)lyFreeBookWithParams:(NSDictionary *)params complete:(void(^)(NSString *message))complete;
//添加关注
+ (void)lyAddCollectWithParams:(NSDictionary *)params complete:(void(^)(BOOL result))complete;
//删除关注
+ (void)lyDeleteCollectWithParams:(NSDictionary *)params complete:(void(^)(BOOL result))complete;
//查看粉丝列表
+ (void)lyCheckFansWithParams:(NSDictionary *)params complete:(void(^)(NSArray *dataList))complete;
//获取专属经理列表
+ (void)lyGetAdviserListWithParams:(NSDictionary *)params complete:(void(^)(HomePageModel *model))complete;
//获取专属经理直播列表
+ (void)lyGetAdviserVideoWithParams:(NSDictionary *)params complete:(void(^)(NSArray *dataList))complete;
#pragma mark - 新的获取粉丝列表
+ (void)lyGetNewFansListWithParams:(NSDictionary *)params complete:(void(^)(NSArray *dataList))complete;
#pragma mark - 新的获取关注列表
+ (void)lyGetNewFollowsListWithParams:(NSDictionary *)params complete:(void(^)(NSArray *dataList))complete;
@end
