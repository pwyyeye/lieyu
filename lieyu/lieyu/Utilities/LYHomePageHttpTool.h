//
//  LYHomePageHttpTool.h
//  lieyu
//
//  Created by 薛斯岐 on 15/10/15.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PinKeModel.h"
#import "JiuBaModel.h"
#import "TaoCanModel.h"
#import "CheHeModel.h"
@interface LYHomePageHttpTool : NSObject
+ (LYHomePageHttpTool *)shareInstance;
//一起玩列表
-(void) getTogetherListWithParams:(NSDictionary*)params
                           block:(void(^)(NSMutableArray* result)) block;
//一起玩列表详细
-(void) getTogetherDetailWithParams:(NSDictionary*)params
                            block:(void(^)(PinKeModel* result)) block;
//一起玩确认订单
-(void) getTogetherOrderWithParams:(NSDictionary*)params
                              block:(void(^)(PinKeModel* result)) block;
//录入拼客订单
-(void) setTogetherOrderInWithParams:(NSDictionary*)params
        complete:(void (^)(NSString *result))result;


//我要订位
-(void) getWoYaoDinWeiDetailWithParams:(NSDictionary*)params
                              block:(void(^)(JiuBaModel* result)) block;
// 请求获取套餐信息
-(void) getWoYaoDinWeiTaoCanDetailWithParams:(NSDictionary*)params
                                 block:(void(^)(TaoCanModel* result)) block;
//我要订位确认订单
-(void) getWoYaoDinWeiOrderWithParams:(NSDictionary*)params
                             block:(void(^)(TaoCanModel* result)) block;
//录入套餐订单
-(void) setWoYaoDinWeiOrderInWithParams:(NSDictionary*)params
                            complete:(void (^)(NSString *result))result;

//吃喝专场
//获取吃喝列表
-(void) getCHListWithParams:(NSDictionary*)params
                            block:(void(^)(NSMutableArray* result)) block;
// 请求获取吃喝信息
-(void) getCHDetailWithParams:(NSDictionary*)params
                                       block:(void(^)(CheHeModel* result)) block;
@end
