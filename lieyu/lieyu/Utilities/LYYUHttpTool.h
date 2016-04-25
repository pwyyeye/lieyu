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
@end
