//
//  LYUserHttpTool.h
//  lieyu
//
//  Created by 薛斯岐 on 15/10/3.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZSUrl.h"
#import "UserModel.h"
#import "CustomerModel.h"
#import "AFNetworking.h"
#import "LYMineUrl.h"
#import "OrderTTL.h"
#import "OrderInfoModel.h"
#import "ZSApplyStatusModel.h"

#import "find_userInfoModel.h"
@interface LYUserHttpTool : NSObject
+ (LYUserHttpTool *)shareInstance;
// 登录
-(void) userLoginWithParams:(NSDictionary*)params
                      block:(void(^)(UserModel* result)) block;
//自动登录
-(void) userAutoLoginWithParams:(NSDictionary*)params
                          block:(void(^)(UserModel* result)) block;

//第三方登录
+ (void)userLoginFromQQWeixinAndSinaWithParams:(NSDictionary*)params compelte:(void(^)(NSInteger flag,UserModel *))compelte;

//是否强制更新
-(void) getAppUpdateStatus:(NSDictionary*)params
                  complete:(void (^)(BOOL result))result;

//登出
-(void) userLogOutWithParams:(NSDictionary*)params
                       block:(void(^)(BOOL result)) block;
// 获取验证码
-(void) getYanZhengMa:(NSDictionary*)params
             complete:(void (^)(BOOL result))result;

// 获取忘记密码验证码
-(void) getResetYanZhengMa:(NSDictionary*)params
                  complete:(void (^)(BOOL result))result;
// 注册
-(void) setZhuCe:(NSDictionary*)params
        complete:(void (^)(BOOL result))result;

-(void) setThirdZhuCe:(NSDictionary*)params
             complete:(void (^)(BOOL result))result;

// 用户忘记更新密码
-(void) setNewPassWord:(NSDictionary*)params
              complete:(void (^)(BOOL result))result;
// 我的专属经理收藏
-(void) getMyVipStore:(NSDictionary*)params
                block:(void(^)(NSMutableArray* result)) block;
// 删除我的专属经理收藏
-(void) delMyVipStore:(NSDictionary*)params
             complete:(void (^)(BOOL result))result;

// 获取酒吧信息
-(void) getJiuBaList:(NSDictionary*)params
               block:(void(^)(NSMutableArray* result)) block;
//申请专属经理
-(void) setApplyVip:(NSDictionary*)params block:(void (^)(id <AFMultipartFormData> formData))block complete:(void (^)(BOOL result))result;
//我的订单
-(void) getMyOrderListWithParams:(NSDictionary*)params
                           block:(void(^)(NSMutableArray* result)) block;

//通过sn获取订单号
-(void) getOrderDetailWithSN:(NSDictionary*)params
                       block:(void(^)(OrderInfoModel* result)) block;

//订单详情
-(void) getMyOrderDetailWithParams:(NSDictionary*)params
                             block:(void(^)(OrderInfoModel* result)) block;

//分享拼客订单
-(void) sharePinkerOrder:(NSDictionary*)params
                complete:(void (^)(BOOL result))result;

//删除订单
-(void) delMyOrder:(NSDictionary*)params
          complete:(void (^)(BOOL result))result;


//删除参与人订单
-(void) delMyOrderByCanYu:(NSDictionary*)params
                 complete:(void (^)(BOOL result))result;
//取消订单
-(void) cancelMyOrder:(NSDictionary*)params
             complete:(void (^)(BOOL result))result;

//微信预支付
-(void) prepareWeixinPayWithParams:(NSDictionary*)params
                          complete:(void (^)(NSDictionary *result))result;

//一定会去
-(void) sureMyOrder:(NSDictionary*)params
           complete:(void (^)(BOOL result))result;

//获取订单统计状况
-(void)getOrderTTL:(void (^)(OrderTTL* result))result;

//订单评价
-(void) addEvaluation:(NSDictionary*)params
             complete:(void (^)(BOOL result))result;

// 添加评价商家回复
-(void) addEvaluationReview:(NSDictionary*)params
                   complete:(void (^)(BOOL result))result;
//好友列表
-(void) getFriendsList:(NSDictionary*)params
                 block:(void(^)(NSMutableArray* result)) block;
//加好友
-(void) addFriends:(NSDictionary*)params
          complete:(void (^)(BOOL result))result;
//删除好友
-(void) delMyFriends:(NSDictionary*)params
            complete:(void (^)(BOOL result))result;
//用户信息
-(void) getUserInfo:(NSDictionary*)params
              block:(void(^)(CustomerModel* result)) block;

//确认打招呼
-(void) sureFriends:(NSDictionary*)params
           complete:(void (^)(BOOL result))result;
//拒绝打招呼
-(void) refuseFriends:(NSDictionary*)params
             complete:(void (^)(BOOL result))result;

//收藏的店铺
-(void) getMyBarWithParams:(NSDictionary*)params
                     block:(void(^)(NSMutableArray* result)) block;
//点赞的酒吧
-(void) getMyBarZangWithParams:(NSDictionary*)params
                     block:(void(^)(NSMutableArray* result)) block;
//收藏酒吧
-(void) addMyBarWithParams:(NSDictionary*)params
                  complete:(void (^)(BOOL result))result;
//删除收藏酒吧
-(void) delMyBarWithParams:(NSDictionary*)params
                  complete:(void (^)(BOOL result))result;

//信息中心
-(void) getAddMeListWithParams:(NSDictionary*)params
                         block:(void(^)(NSMutableArray* result)) block;

//获取用户标签
-(void) getUserTags:(NSDictionary*)params
              block:(void(^)(NSMutableArray* result)) block;
//保存用户资料
-(void) saveUserInfo:(NSDictionary*)params
            complete:(void (^)(BOOL result))result;

//查找好友
-(void) getFindFriendListWithParams:(NSDictionary*)params
                              block:(void(^)(NSMutableArray* result)) block;
//附近玩家
-(void) getFindNearFriendListWithParams:(NSDictionary*)params
                                  block:(void(^)(NSMutableArray* result)) block;
//摇一摇
-(void) getYaoYiYaoFriendListWithParams:(NSDictionary*)params
                                  block:(void(^)(NSMutableArray* result)) block;
//摇到的历史
-(void) getYaoYiYaoHisFriendListWithParams:(NSDictionary*)params
                                     block:(void(^)(NSMutableArray* result)) block;
//获取用户收藏的酒吧
+ (void)getUserCollectionJiuBarListWithCompelet:(void(^)(NSArray *array))compelte;

//获取用户赞的酒吧
+ (void)getUserZangJiuBarListWithCompelet:(void(^)(NSArray *array))compelte;

// 判断手机是否注册过
+ (void)getYZMForThirdthLoginWithPara:(NSDictionary *)paraDic compelte:(void(^)(NSString *))compelte;

//绑定手机号
+ (void)tieQQWeixinAndSinaWithPara:(NSDictionary *)paraDic compelte:(void(^)(NSInteger))compelte;
//绑定手机号 已登陆
+ (void)tieQQWeixinAndSinaWithPara2:(NSDictionary *)paraDic compelte:(void(^)(NSInteger))compelte;

//绑定手机后用openId登录
+ (void)userLoginFromOpenIdWithPara:(NSDictionary *)paraDic compelte:(void(^)(UserModel *))compelte;

//获取用户的推送配置
+ (void)getUserNotificationWithPara:(NSDictionary *)paraDic compelte:(void (^)(NSArray *))compelte;
//扫描述二维码加好友或订单验码
+ (void)userScanQRCodeWithPara:(NSDictionary *)paraDic complete:(void(^)(NSDictionary *))complete;

//修改用户的推送配置
+ (void)changeUserNotificationWithPara:(NSDictionary *)paraDic compelte:(void (^)(bool))compelte;
//根据用户ID，获取好友详情
+ (void)GetUserInfomationWithID:(NSDictionary *)paraDic complete:(void(^)(find_userInfoModel *))complete;
//速核码校验订单
+ (void)QuickCheckOrderWithParam:(NSDictionary *)paraDic complete:(void(^)(NSString *))complete;
//获取deskey
- (void) getAppDesKey:(NSDictionary*)params complete:(void (^)(NSString * result))result;
#pragma mark - 专属经理直接核对消费码
+ (void)zsCheckConsumerIDWith:(NSDictionary *)params complete:(void(^)())complete;
//根据用户ID获取关注或粉丝列表
+ (void)getCaresOrFansList:(NSDictionary *)params complete:(void(^)(NSMutableArray *))result;
#pragma mark - 关注或取关
+ (void)addCareOrDeleteCare:(NSDictionary *)params complete:(void(^)())result;

//获取话题列表
+ (void)getTopicList:(NSDictionary *)params complete:(void(^)(NSArray *))result;

//获取专属经理申请状态
+ (void)getZSJLStatusComplete:(void(^)(ZSApplyStatusModel *))complete;
//专属经理验证微信
+ (void)checkZSwechatComplete:(void(^)(NSString *))complete;

@end
