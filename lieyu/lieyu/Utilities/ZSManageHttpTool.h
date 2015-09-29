//
//  ZSManageHttpTool.h
//  lieyu
//
//  Created by 薛斯岐 on 15/9/29.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZSUrl.h"
#import "HTTPController.h"
@interface ZSManageHttpTool : NSObject
+ (ZSManageHttpTool *)shareInstance;
//获取专属经理-商铺套餐列表
-(void) getMyTaoCanListWithParams:(NSDictionary*)params
                            block:(void(^)(NSMutableArray* result)) block;
//获取专属经理-拼客列表
-(void) getMyPinkerListWithParams:(NSDictionary*)params
                            block:(void(^)(NSMutableArray* result)) block;
//获取专属经理-单品列表
-(void) getMyDanPinListWithParams:(NSDictionary*)params
                            block:(void(^)(NSMutableArray* result)) block;
//获取专属经理-库存列表
-(void) getMyKuCunListWithParams:(NSDictionary*)params
                            block:(void(^)(NSMutableArray* result)) block;
//获取卡座一周是否满座
-(void) getDeckFullWithParams:(NSDictionary*)params
                            block:(void(^)(NSMutableArray* result)) block;
//专属经理 设置某天卡座满座
-(void) setDeckADDWithParams:(NSDictionary*)params complete:(void (^)(BOOL result))result;
//专属经理 设置某天卡座(未)满座
-(void) setDeckDelWithParams:(NSDictionary*)params complete:(void (^)(BOOL result))result;

//获取我的客户
-(void) getUsersFriendWithParams:(NSDictionary*)params
                           block:(void(^)(NSMutableArray* result)) block;
@end
