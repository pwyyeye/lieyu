//
//  LYFindHttpTool.h
//  lieyu
//
//  Created by 狼族 on 16/3/9.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYFindHttpTool : NSObject
//获取当前用户未读推送信息
+ (void)getNotificationMessageWithParams:(NSDictionary *)params compelte:(void(^)(NSArray *dataArray))compelte;

//获取用户推送记录
+ (void)getNotificationMessageListWithParams:(NSDictionary *)params compelte:(void (^)(NSArray *))compelte;

//推送信息标识为已读
+ (void)NotificationMessageListReadedWithParams:(NSDictionary *)params compelte:(void (^)(NSArray *))compelte;
@end
