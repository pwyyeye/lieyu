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
#import "CarInfoModel.h"
#import "CarModel.h"
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
//参与拼客
-(void) inTogetherOrderInWithParams:(NSDictionary*)params
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
//加入购物车
-(void) addCarWithParams:(NSDictionary*)params
                      block:(void(^)(BOOL result)) block;
//购物车列表
-(void) getCarListWithParams:(NSDictionary*)params
                            block:(void(^)(NSMutableArray* result)) block;
//购物车数量变更
-(void) updataCarNumWithParams:(NSDictionary*)params
        complete:(void (^)(BOOL result))result;
//购物车转订单
-(void) getChiHeOrderWithParams:(NSDictionary*)params
                                block:(void(^)(CarInfoModel* result)) block;
//录入购物车订单
-(void) setChiHeOrderInWithParams:(NSDictionary*)params
                               complete:(void (^)(NSString *result))result;
//购物车删除
-(void) delcarWithParams:(NSDictionary*)params complete:(void (^)(BOOL result))result;

//获取某个酒吧下的专属经理列表
-(void) getBarVipWithParams:(NSDictionary*)params
                       block:(void(^)(NSMutableArray* result)) block;
//收藏专属经理
-(void) scVipWithParams:(NSDictionary*)params
                      complete:(void (^)(BOOL result))result;

//给酒吧点赞
- (void)likeJiuBa:(NSDictionary *)params compelete:(void(^)(bool))result;
//给酒吧取消点赞
- (void)unLikeJiuBa:(NSDictionary *)params compelete:(void(^)(bool))result;

+ (void)getWeixinAccessTokenWithCode:(NSString *)codeStr compelete:(void(^)(NSString *))compelete;

+ (void)getWeixinNewAccessTokenWithRefreshToken:(NSString *)RefreshToken compelete:(void (^)(NSString *))compelete;

+ (void)getWeixinUserInfoWithAccessToken:(NSString *)accessToken compelete:(void(^)(UserModel *))compelete;

//获取酒吧的活动列表
+ (void)getActivityListWithPara:(NSDictionary *)paraDic compelte:(void(^)(NSMutableArray * result))compelete;
//获取所有活动专题
+ (void)getActionList:(NSDictionary *)paraDic complete:(void(^)(NSMutableArray *result))complete;
//获取所有签到
+ (void)getSignListWidth:(NSDictionary *)paraDic complete:(void(^)(NSMutableArray *result))complete;
//签到
+ (void)signWith:(NSDictionary *)paraDic;
@end
