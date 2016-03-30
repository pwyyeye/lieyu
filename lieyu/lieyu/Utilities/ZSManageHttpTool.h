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
#import "OrderInfoModel.h"
@class ZSBalance;

@interface ZSManageHttpTool : NSObject
+ (ZSManageHttpTool *)shareInstance;
//专属经理订单列表
-(void) getZSOrderListWithParams:(NSDictionary*)params
                            block:(void(^)(NSMutableArray* result)) block;
//订单详细
-(void) getZSOrderDetailWithParams:(NSDictionary*)params
                           block:(void(^)(OrderInfoModel* result)) block;
//专属经理订单对码
-(void) setManagerConfirmOrderWithParams:(NSDictionary*)params complete:(void (^)(BOOL result))result;
//专属经理-确认卡座
-(void) setManagerConfirmSeatWithParams:(NSDictionary*)params complete:(void (^)(BOOL result))result;
//专属经理-取消订单
-(void) setMangerCancelWithParams:(NSDictionary*)params complete:(void (^)(BOOL result))result;

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

//获取酒水分类列表
-(void) getProductCategoryListWithParams:(NSDictionary*)params
                           block:(void(^)(NSMutableArray* result)) block;
//获取酒水品牌列表
-(void) getBrandListWithParams:(NSDictionary*)params
                           block:(void(^)(NSMutableArray* result)) block;
//专属经理 单品下架
-(void) delItemProductWithParams:(NSDictionary*)params complete:(void (^)(BOOL result))result;
//专属经理 套餐下架
-(void) delTaoCanWithParams:(NSDictionary*)params complete:(void (^)(BOOL result))result;
//专属经理 库存下架
-(void) delProductWithParams:(NSDictionary*)params complete:(void (^)(BOOL result))result;
//专属经理 拼客下架
-(void) delPinKeWithParams:(NSDictionary*)params complete:(void (^)(BOOL result))result;

//专属经理-套餐添加
-(void) addTaoCanWithParams:(NSDictionary*)params complete:(void (^)(BOOL result))result;
//专属经理-库存添加
-(void) addItemProductWithParams:(NSDictionary*)params complete:(void (^)(BOOL result))result;
//专属经理-单品添加
-(void) addProductWithParams:(NSDictionary*)params complete:(void (^)(BOOL result))result;


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

//获取账户余额记录
- (void)getPersonBalanceWithParams:(NSDictionary*)params complete:(void (^)(ZSBalance*))result;

//获取提现记录
- (void)getPersonTiXianRecordWithParams:(NSDictionary *)params complete:(void (^)(NSArray *))complete;

//申请提现
- (void)applicationWithdrawWithParams:(NSDictionary *)params complete:(void (^)(NSString *))complete;
@end
