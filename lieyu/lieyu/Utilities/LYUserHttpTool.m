//
//  LYUserHttpTool.m
//  lieyu
//
//  Created by 薛斯岐 on 15/10/3.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYUserHttpTool.h"
#import "HTTPController.h"
#import "ZSDetailModel.h"
#import "JiuBaModel.h"
#import "OrderInfoModel.h"
#import "MyBarModel.h"
#import "UserTagModel.h"
#import "MineUserNotification.h"
@implementation LYUserHttpTool

+ (LYUserHttpTool *)shareInstance{
    static LYUserHttpTool * instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}
#pragma mark - 登录
-(void) userLoginWithParams:(NSDictionary*)params
                      block:(void(^)(UserModel* result)) block{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypeGet url:LY_DL baseURL:LY_SERVER params:params success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        
        NSDictionary *dataDic = response[@"data"];
        if ([code isEqualToString:@"1"]) {
            UserModel *userModel=[UserModel mj_objectWithKeyValues:dataDic];
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                block(userModel);
            });
        }else{
            [MyUtil showMessage:message];
        }
        
        [app stopLoading];
    } failure:^(NSError *err) {
        [app stopLoading];
    }];
}

#pragma mark - 自动登录
-(void) userAutoLoginWithParams:(NSDictionary*)params
                          block:(void(^)(UserModel* result)) block{
    [HTTPController requestWihtMethod:RequestMethodTypeGet url:LY_DL baseURL:LY_SERVER params:params success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        //        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        
        NSDictionary *dataDic = response[@"data"];
        UserModel *userModel=[UserModel mj_objectWithKeyValues:dataDic];
        if ([code isEqualToString:@"1"]) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                block(userModel);
            });
        }else{
            //            [MyUtil showMessage:message];
        }
        
    } failure:^(NSError *err) {
    }];
}

#pragma mark - 第三方登录
+ (void)userLoginFromQQWeixinAndSinaWithParams:(NSDictionary*)params compelte:(void(^)(NSInteger flag,UserModel *userModel))compelte{
    NSLog(@"---->%@",params);
    [HTTPController requestWihtMethod:RequestMethodTypeGet url:LY_DL_THIRD baseURL:LY_SERVER params:params success:^(id response) {
        if([response[@"errorcode"] isEqualToString:@"-2"]){//登录失败
            compelte(0,nil);
//            [MyUtil showPlaceMessage:@"登录失败"];
        }else{//登录成功
            UserModel *userM = [UserModel mj_objectWithKeyValues:response[@"data"]];
            compelte(1,userM);
        }
        NSLog(@"----->%@",response);
    } failure:^(NSError *err) {
        NSLog(@"----->%@",err);
    }];
}


#pragma mark - 登出
-(void) userLogOutWithParams:(NSDictionary*)params
                       block:(void(^)(BOOL result)) block{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_LOGOUT baseURL:QINIU_SERVER params:params success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        if ([code isEqualToString:@"1"]) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                block(YES);
            });
        }else{
            block(NO);
            [MyUtil showMessage:message];
        }
        
        [app stopLoading];
    } failure:^(NSError *err) {
        [app stopLoading];
    }];
}

#pragma mark - 获取验证码
-(void) getYanZhengMa:(NSDictionary*)params
             complete:(void (^)(BOOL result))result{
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_YZM baseURL:LY_SERVER params:params success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        if ([code isEqualToString:@"1"]) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                result(YES);
            });
            [app stopLoading];
        }else{
            result(NO);
            [app stopLoading];
            [MyUtil showMessage:message];
        }
        
        
    } failure:^(NSError *err) {
        [app stopLoading];
        result(NO);
        
        
    }];
    
}

#pragma mark - 获取忘记密码验证码
-(void) getResetYanZhengMa:(NSDictionary*)params
                  complete:(void (^)(BOOL result))result{
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_RYZM baseURL:LY_SERVER params:params success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        if ([code isEqualToString:@"1"]) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                result(YES);
            });
            [app stopLoading];
        }else{
            result(NO);
            [app stopLoading];
            [MyUtil showMessage:message];
        }
        
        
    } failure:^(NSError *err) {
        [app stopLoading];
        result(NO);
        
        
    }];
    
}
#pragma mark -注册
-(void) setZhuCe:(NSDictionary*)params
        complete:(void (^)(BOOL result))result{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_ZC baseURL:LY_SERVER params:params success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        if ([code isEqualToString:@"1"]) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                result(YES);
                
                //                mobile
                //                password
                [[NSUserDefaults standardUserDefaults] setObject:params[@"mobile"] forKey:@"username"];
                [[NSUserDefaults standardUserDefaults] setObject:params[@"password"] forKey:@"password"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            });
            [app stopLoading];
        }else{
            result(NO);
            [app stopLoading];
            [MyUtil showMessage:message];
        }
        
        
    } failure:^(NSError *err) {
        [app stopLoading];
        result(NO);
        
        
    }];
}

#pragma mark -第三方注册
-(void) setThirdZhuCe:(NSDictionary*)params
        complete:(void (^)(BOOL result))result{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_ZC baseURL:LY_SERVER params:params success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        if ([code isEqualToString:@"1"]) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                result(YES);
            });
            [app stopLoading];
        }else{
            result(NO);
            [app stopLoading];
            [MyUtil showMessage:message];
        }
        
        
    } failure:^(NSError *err) {
        [app stopLoading];
        result(NO);
        
        
    }];
}

#pragma mark  -用户忘记更新密码
-(void) setNewPassWord:(NSDictionary*)params
              complete:(void (^)(BOOL result))result{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_GET_PW baseURL:LY_SERVER params:params success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        if ([code isEqualToString:@"1"]) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                result(YES);
            });
            [app stopLoading];
        }else{
            result(NO);
            [app stopLoading];
            [MyUtil showMessage:message];
        }
        
        
    } failure:^(NSError *err) {
        [app stopLoading];
        result(NO);
        
        
    }];
}

#pragma mark  - 我的专属经理收藏
-(void) getMyVipStore:(NSDictionary*)params
                block:(void(^)(NSMutableArray* result)) block{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_MY_ZSJL baseURL:LY_SERVER params:params success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        if([code isEqualToString:@"1"]){
            NSArray *dataList = response[@"data"];
            NSMutableArray *tempArr = [[NSMutableArray alloc]initWithArray:[ZSDetailModel mj_objectArrayWithKeyValuesArray:dataList]];
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                block(tempArr);
            });
        }else{
            [MyUtil showMessage:message];
        }
        
        [app stopLoading];
    } failure:^(NSError *err) {
        [app stopLoading];
    }];
}
#pragma mark 删除我的专属经理收藏
-(void) delMyVipStore:(NSDictionary*)params
             complete:(void (^)(BOOL result))result{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_MY_ZSJL_DEL baseURL:LY_SERVER params:params success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        if ([code isEqualToString:@"1"]) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                result(YES);
            });
            [app stopLoading];
        }else{
            result(NO);
            [app stopLoading];
            [MyUtil showMessage:message];
        }
        
        
    } failure:^(NSError *err) {
        [app stopLoading];
        result(NO);
        
        
    }];
    
}
#pragma mark  - 我的专属经理申请-酒吧列表
-(void) getJiuBaList:(NSDictionary*)params
               block:(void(^)(NSMutableArray* result)) block{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_JIUBA_LIST baseURL:LY_SERVER params:params success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        if([code isEqualToString:@"1"]){
            NSDictionary *dicTemp = response[@"data"];
            NSArray *dataList =[dicTemp objectForKey:@"barlist"];
            NSMutableArray *tempArr = [[NSMutableArray alloc]initWithArray:[JiuBaModel mj_objectArrayWithKeyValuesArray:dataList]];
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                block(tempArr);
            });
        }else{
            [MyUtil showMessage:message];
        }
        
        [app stopLoading];
    } failure:^(NSError *err) {
        [app stopLoading];
    }];
}
#pragma mark  - 我的专属经理申请
-(void) setApplyVip:(NSDictionary*)params block:(void (^)(id <AFMultipartFormData> formData))block complete:(void (^)(BOOL result))result{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    [HTTPController requestFileWihtUrl:LY_APPLY_MANAGER  baseURL:LY_SERVER params:params block:block success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        if ([code isEqualToString:@"1"]) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                result(YES);
            });
            [app stopLoading];
        }else{
            result(NO);
            [app stopLoading];
            [MyUtil showMessage:message];
        }
        
    } failure:^(NSError *err) {
        [app stopLoading];
    }];
}

#pragma mark -获取我的订单列表
-(void) getMyOrderListWithParams:(NSDictionary*)params
                           block:(void(^)(NSMutableArray* result)) block{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_MY_ORDER baseURL:LY_SERVER params:params success:^(id response) {
        NSArray *dataList = response[@"data"];
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        
        if ([code isEqualToString:@"1"]) {
            NSMutableArray *tempArr = [[NSMutableArray alloc]initWithArray:[OrderInfoModel mj_objectArrayWithKeyValuesArray:dataList]];
            block(tempArr);
            
            
        }else{
            [MyUtil showMessage:message];
        }
        [app stopLoading];
    } failure:^(NSError *err) {
        //[MyUtil showCleanMessage:@"获取数据失败！"];
        [app stopLoading];
    }];
    
}

#pragma mark -获取我的订单明细
-(void) getMyOrderDetailWithParams:(NSDictionary*)params
                           block:(void(^)(OrderInfoModel* result)) block{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_MY_ORDERDETAIL baseURL:LY_SERVER params:params success:^(id response) {
        NSDictionary *data = response[@"data"];
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        
        if ([code isEqualToString:@"1"]) {

            OrderInfoModel *orderInfo=[OrderInfoModel mj_objectWithKeyValues:data];
            block(orderInfo);
            
            
        }else{
            [MyUtil showMessage:message];
        }
        [app stopLoading];
    } failure:^(NSError *err) {
        //[MyUtil showCleanMessage:@"获取数据失败！"];
        [app stopLoading];
    }];
    
}

#pragma mark -通过sn获取我的订单明细
-(void) getOrderDetailWithSN:(NSDictionary*)params
                             block:(void(^)(OrderInfoModel* result)) block{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_MY_ORDERDETAILSN baseURL:LY_SERVER params:params success:^(id response) {
        NSDictionary *data = response[@"data"];
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        
        if ([code isEqualToString:@"1"]) {
            
            OrderInfoModel *orderInfo=[OrderInfoModel mj_objectWithKeyValues:data];
            
            block(orderInfo);
            
            
        }else{
            [MyUtil showMessage:message];
        }
        [app stopLoading];
    } failure:^(NSError *err) {
        //[MyUtil showCleanMessage:@"获取数据失败！"];
        [app stopLoading];
    }];
    
}

#pragma mark -分享拼客订单
-(void) sharePinkerOrder:(NSDictionary*)params
          complete:(void (^)(BOOL result))result{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_MY_ORDER_SHARE baseURL:LY_SERVER params:params success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        if ([code isEqualToString:@"1"]) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                result(YES);
            });
            [app stopLoading];
        }else{
            result(NO);
            [app stopLoading];
            [MyUtil showMessage:message];
        }
    } failure:^(NSError *err) {
        [app stopLoading];
        result(NO);
        
        
    }];
}


#pragma mark -删除我的订单
-(void) delMyOrder:(NSDictionary*)params
          complete:(void (^)(BOOL result))result{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_MY_ORDER_DEL baseURL:LY_SERVER params:params success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        if ([code isEqualToString:@"1"]) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                result(YES);
            });
            [app stopLoading];
        }else{
            result(NO);
            [app stopLoading];
            [MyUtil showMessage:message];
        }
        
        
    } failure:^(NSError *err) {
        [app stopLoading];
        result(NO);
        
        
    }];
}


#pragma mark -删除参与人订单
-(void) delMyOrderByCanYu:(NSDictionary*)params
                 complete:(void (^)(BOOL result))result{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_MY_ORDER_DELBYCANYU baseURL:LY_SERVER params:params success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        if ([code isEqualToString:@"1"]) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                result(YES);
            });
            [app stopLoading];
        }else{
            result(NO);
            [app stopLoading];
            [MyUtil showMessage:message];
        }
        
        
    } failure:^(NSError *err) {
        [app stopLoading];
        result(NO);
        
        
    }];
}

#pragma mark -取消我的订单
-(void) cancelMyOrder:(NSDictionary*)params
             complete:(void (^)(BOOL result))result{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_MY_ORDER_CANCEL baseURL:LY_SERVER params:params success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        if ([code isEqualToString:@"1"]) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                result(YES);
            });
            [app stopLoading];
        }else{
            result(NO);
            [app stopLoading];
            [MyUtil showMessage:message];
        }
        
        
    } failure:^(NSError *err) {
        [app stopLoading];
        result(NO);
        
        
    }];
}
#pragma mark 一定会去
-(void) sureMyOrder:(NSDictionary*)params
           complete:(void (^)(BOOL result))result{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_MY_ORDER_GO baseURL:LY_SERVER params:params success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        if ([code isEqualToString:@"1"]) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                result(YES);
            });
            [app stopLoading];
        }else{
            result(NO);
            [app stopLoading];
            [MyUtil showMessage:message];
        }
        
        
    } failure:^(NSError *err) {
        [app stopLoading];
        result(NO);
        
        
    }];
}
#pragma mark 获取订单统计
-(void)getOrderTTL:(void (^)(OrderTTL* result))block{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_MY_ORDER_TTL baseURL:LY_SERVER params:nil success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        NSDictionary *data=response[@"data"];
        OrderTTL *ttl=[OrderTTL mj_objectWithKeyValues:data];
        if ([code isEqualToString:@"1"]) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                block(ttl);
            });
        }else{
            [MyUtil showMessage:message];
        }
        
        
    } failure:^(NSError *err) {
        NSLog(@"----pass-err%@---",err);
        
    }];
    
}

#pragma mark 添加评价
-(void) addEvaluation:(NSDictionary*)params
             complete:(void (^)(BOOL result))result{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    NSLog(@"----pass-LY_MY_ORDER_PINGJIA%@---",LY_MY_ORDER_PINGJIA);
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_MY_ORDER_PINGJIA baseURL:LY_SERVER params:params success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        if ([code isEqualToString:@"1"]) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                result(YES);
            });
            [app stopLoading];
        }else{
            result(NO);
            [app stopLoading];
            [MyUtil showMessage:message];
        }
        
        
    } failure:^(NSError *err) {
        [app stopLoading];
        result(NO);
        
        
    }];
}
#pragma mark 添加评价商家回复
-(void) addEvaluationReview:(NSDictionary*)params
                   complete:(void (^)(BOOL result))result{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    NSLog(@"----pass-LY_MY_ORDER_REVIEW%@---",LY_MY_ORDER_REVIEW);
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_MY_ORDER_REVIEW baseURL:LY_SERVER params:params success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        if ([code isEqualToString:@"1"]) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                result(YES);
            });
            [app stopLoading];
        }else{
            result(NO);
            [app stopLoading];
            [MyUtil showMessage:message];
        }
        
        
    } failure:^(NSError *err) {
        [app stopLoading];
        result(NO);
        
        
    }];
}
#pragma mark微信预支付
-(void) prepareWeixinPayWithParams:(NSDictionary*)params
                          complete:(void (^)(NSDictionary *result))block{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_WEIXIN_YUFU baseURL:LY_SERVER params:params success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        NSDictionary *data=response[@"data"];
        if ([code isEqualToString:@"1"]) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                block(data);
            });
            [app stopLoading];
        }else{
            
            [app stopLoading];
            [MyUtil showMessage:message];
        }
        
        
    } failure:^(NSError *err) {
        NSLog(@"----pass-err%@---",err);
        [app stopLoading];
        
        
        
    }];
}

#pragma mark 好友列表
-(void) getFriendsList:(NSDictionary*)params
                 block:(void(^)(NSMutableArray* result)) block{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    NSString *ss = [NSString stringWithFormat:@"%@&userId=%@",LY_MY_FRIENDS_LIST,[params objectForKey:@"userid"]];
    [HTTPController requestWihtMethod:RequestMethodTypeGet url:ss baseURL:QINIU_SERVER params:nil success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        if([code isEqualToString:@"1"]){
            NSDictionary *dicTemp=response[@"data"];
            NSArray *dataList = dicTemp[@"items"];
            NSMutableArray *tempArr = [[NSMutableArray alloc]initWithArray:[CustomerModel mj_objectArrayWithKeyValuesArray:dataList]];
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                block(tempArr);
            });
        }else{
            [MyUtil showMessage:message];
        }
        
        [app stopLoading];
    } failure:^(NSError *err) {
        [app stopLoading];
    }];
}
#pragma mark加好友
-(void) addFriends:(NSDictionary*)params
          complete:(void (^)(BOOL result))result{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_GREETINGS_LIST baseURL:LY_SERVER params:params success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        if ([code isEqualToString:@"1"]) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                result(YES);
            });
            [app stopLoading];
        }else{
            result(NO);
            [app stopLoading];
            [MyUtil showMessage:message];
        }
        
        
    } failure:^(NSError *err) {
        [app stopLoading];
        result(NO);
        
        
    }];
}
#pragma mark删除好友
-(void) delMyFriends:(NSDictionary*)params
            complete:(void (^)(BOOL result))result{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    NSString *ss = [NSString stringWithFormat:@"%@&Ids=%@",LY_MY_FRIENDS_DEL,[params objectForKey:@"id"]];
    [HTTPController requestWihtMethod:RequestMethodTypeGet url:ss baseURL:QINIU_SERVER params:params success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        if ([code isEqualToString:@"1"]) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                result(YES);
            });
            [app stopLoading];
        }else{
            result(NO);
            [app stopLoading];
            [MyUtil showMessage:message];
        }
        
        
    } failure:^(NSError *err) {
        [app stopLoading];
        result(NO);
        
        
    }];
}
#pragma mark用户信息
-(void) getUserInfo:(NSDictionary*)params
              block:(void(^)(CustomerModel* result)) block{
    
    NSString *ss = [NSString stringWithFormat:@"%@&imUserId=%@",LY_USER_INFO,[params objectForKey:@"imUserId"]];
    [HTTPController requestWihtMethod:RequestMethodTypeGet url:ss baseURL:QINIU_SERVER params:nil success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *meessage = [NSString stringWithFormat:@"%@",response[@"message"]];
        NSLog(@"message:%@",meessage);
        if([code isEqualToString:@"1"]){
            NSDictionary *dicTemp=response[@"data"];
            CustomerModel *model=[CustomerModel mj_objectWithKeyValues:dicTemp];
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                block(model);
                
            });
            
        }else{
            //            [MyUtil showMessage:message];
        }
        
        
    } failure:^(NSError *err) {
        
    }];
}
#pragma mark确认打招呼
-(void) sureFriends:(NSDictionary*)params
           complete:(void (^)(BOOL result))result{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_ACCEPT_GREETINGS baseURL:LY_SERVER params:params success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        if ([code isEqualToString:@"1"]) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                result(YES);
            });
            [app stopLoading];
        }else{
            result(NO);
            [app stopLoading];
            [MyUtil showMessage:message];
        }
        
        
    } failure:^(NSError *err) {
        [app stopLoading];
        result(NO);
        
        
    }];
}
#pragma mark拒绝打招呼
-(void) refuseFriends:(NSDictionary*)params
             complete:(void (^)(BOOL result))result{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_DEL_GREETINGS baseURL:LY_SERVER params:params success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        if ([code isEqualToString:@"1"]) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                result(YES);
            });
            [app stopLoading];
        }else{
            result(NO);
            [app stopLoading];
            [MyUtil showMessage:message];
        }
        
        
    } failure:^(NSError *err) {
        [app stopLoading];
        result(NO);
        
        
    }];
}
#pragma mark 收藏的店铺
-(void) getMyBarWithParams:(NSDictionary*)params
                     block:(void(^)(NSMutableArray* result)) block{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_MY_BAR_LIST baseURL:LY_SERVER params:params success:^(id response) {
        NSArray *dataList = response[@"data"];
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        
        if ([code isEqualToString:@"1"]) {
            NSMutableArray *tempArr = [[NSMutableArray alloc]initWithArray:[MyBarModel mj_objectArrayWithKeyValuesArray:dataList]];
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                block(tempArr);
            });
            
        }else{
            [MyUtil showMessage:message];
        }
    } failure:^(NSError *err) {
        //[MyUtil showCleanMessage:@"获取数据失败！"];
    }];
}

#pragma mark - 点赞的酒吧
-(void) getMyBarZangWithParams:(NSDictionary*)params
                     block:(void(^)(NSMutableArray* result)) block{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_MY_BAR_ZANG baseURL:LY_SERVER params:params success:^(id response) {
        NSArray *dataList = response[@"data"];
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        
        if ([code isEqualToString:@"1"]) {
            NSMutableArray *tempArr = [[NSMutableArray alloc]initWithArray:[MyBarModel mj_objectArrayWithKeyValuesArray:dataList]];
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                block(tempArr);
            });
            
        }else{
            [MyUtil showMessage:message];
        }
    } failure:^(NSError *err) {
        //[MyUtil showCleanMessage:@"获取数据失败！"];
    }];
}

        
#pragma mark 收藏酒吧
-(void) addMyBarWithParams:(NSDictionary*)params
                  complete:(void (^)(BOOL result))result{
    //    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    //    [app startLoading];
    
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_MY_BAR_ADD baseURL:LY_SERVER params:params success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        if ([code isEqualToString:@"1"]) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                result(YES);
            });
            //            [app stopLoading];
            [MyUtil showPlaceMessage:message];
        }else{
            result(NO);
            //            [app stopLoading];
            [MyUtil showPlaceMessage:message];
        }
    } failure:^(NSError *err) {
        //        [app stopLoading];
        [MyUtil showPlaceMessage:@"点赞失败，请检查网络连接"];
        result(NO);
    }];
}
#pragma mark 删除收藏酒吧
-(void) delMyBarWithParams:(NSDictionary*)params
                  complete:(void (^)(BOOL result))result{
    //    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    //    [app startLoading];
    
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_MY_BAR_DEL baseURL:LY_SERVER params:params success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        if ([code isEqualToString:@"1"]) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                result(YES);
            });
            [MyUtil showPlaceMessage:message];
        }else{
            result(NO);
            [MyUtil showPlaceMessage:message];
        }
        
        
    } failure:^(NSError *err) {
        //        [app stopLoading];
        [MyUtil showPlaceMessage:@"取消点赞失败，请检查网络连接"];
        result(NO);
        
    }];
}
#pragma mark 信息中心
-(void) getAddMeListWithParams:(NSDictionary*)params
                         block:(void(^)(NSMutableArray* result)) block{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_ADDME_LIST baseURL:LY_SERVER params:params success:^(id response) {
        NSArray *dataList = response[@"data"];
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        
        if ([code isEqualToString:@"1"]) {
            NSMutableArray *tempArr = [[NSMutableArray alloc]initWithArray:[CustomerModel mj_objectArrayWithKeyValuesArray:dataList]];
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                block(tempArr);
            });
            
        }else{
            [MyUtil showMessage:message];
        }
        [app stopLoading];
    } failure:^(NSError *err) {
        //[MyUtil showCleanMessage:@"获取数据失败！"];
        [app stopLoading];
    }];
    
}
#pragma mark查找好友
-(void) getFindFriendListWithParams:(NSDictionary*)params
                              block:(void(^)(NSMutableArray* result)) block{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_FINDFRIEND_LIST baseURL:QINIU_SERVER params:params success:^(id response) {
        NSDictionary *data = response[@"data"];
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        
        if ([code isEqualToString:@"1"]) {
            NSArray *dataList= data[@"items"];
            NSMutableArray *tempArr = [[NSMutableArray alloc]initWithArray:[CustomerModel mj_objectArrayWithKeyValuesArray:dataList]];
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                block(tempArr);
            });
            
        }else{
            [MyUtil showMessage:message];
        }
        [app stopLoading];
    } failure:^(NSError *err) {
        //[MyUtil showCleanMessage:@"获取数据失败！"];
        [app stopLoading];
    }];
}
#pragma mark附近玩家
-(void) getFindNearFriendListWithParams:(NSDictionary*)params
                                  block:(void(^)(NSMutableArray* result)) block{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_FINDNEARFRIEND_LIST baseURL:LY_SERVER params:params success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        
        if ([code isEqualToString:@"1"]) {
            NSArray *dataList= response[@"data"];
            NSMutableArray *tempArr = [[NSMutableArray alloc]initWithArray:[CustomerModel mj_objectArrayWithKeyValuesArray:dataList]];
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                block(tempArr);
            });
            
        }else{
            [MyUtil showMessage:message];
        }
        [app stopLoading];
    } failure:^(NSError *err) {
        //[MyUtil showCleanMessage:@"获取数据失败！"];
        [app stopLoading];
    }];
}
#pragma mark摇一摇
-(void) getYaoYiYaoFriendListWithParams:(NSDictionary*)params
                                  block:(void(^)(NSMutableArray* result)) block{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_YAOYIYAO_LIST baseURL:LY_SERVER params:params success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        
        if ([code isEqualToString:@"1"]) {
            NSArray *dataList= response[@"data"];
            NSMutableArray *tempArr = [[NSMutableArray alloc]initWithArray:[CustomerModel mj_objectArrayWithKeyValuesArray:dataList]];
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                block(tempArr);
            });
            
        }else{
            [MyUtil showMessage:message];
        }
        [app stopLoading];
    } failure:^(NSError *err) {
        //[MyUtil showCleanMessage:@"获取数据失败！"];
        [app stopLoading];
    }];
}
#pragma mark摇到的历史
-(void) getYaoYiYaoHisFriendListWithParams:(NSDictionary*)params
                                     block:(void(^)(NSMutableArray* result)) block{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_YAOHIS_LIST baseURL:LY_SERVER params:params success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        
        if ([code isEqualToString:@"1"]) {
            NSArray *dataList= response[@"data"];
            NSMutableArray *tempArr = [[NSMutableArray alloc]initWithArray:[CustomerModel mj_objectArrayWithKeyValuesArray:dataList]];
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                block(tempArr);
            });
            
        }else{
            [MyUtil showMessage:message];
        }
        [app stopLoading];
    } failure:^(NSError *err) {
        //[MyUtil showCleanMessage:@"获取数据失败！"];
        [app stopLoading];
    }];
    
}
#pragma mark - 获取用户标签
-(void) getUserTags:(NSDictionary*)params
              block:(void(^)(NSMutableArray* result)) block{
    [HTTPController requestWihtMethod:RequestMethodTypeGet url:LY_GETUSERTAGS baseURL:LY_SERVER params:params success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        
        NSArray *dataList = response[@"data"];
        
        if ([code isEqualToString:@"1"]) {
            NSMutableArray *tempArr=[UserTagModel mj_objectArrayWithKeyValuesArray:dataList];
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                block(tempArr);
            });
        }else{
            [MyUtil showMessage:message];
        }
        
    } failure:^(NSError *err) {
    }];
}


#pragma mark 保存用户信息
-(void) saveUserInfo:(NSDictionary*)params
            complete:(void (^)(BOOL result))result{
    
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_SAVE_USERINFO baseURL:LY_SERVER params:params success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        NSLog(@"------>%@----->%@",code,message);
        if ([code isEqualToString:@"1"]) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                result(YES);
            });
        }else{
            result(NO);
            
            [MyUtil showMessage:message];
        }
        
    } failure:^(NSError *err) {
        result(NO);
        
        
    }];
}

#pragma mark 获取用户收藏的酒吧
+ (void)getUserCollectionJiuBarListWithCompelet:(void(^)(NSArray *array))compelte{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_GETUSERCOLLECTJIUBAR baseURL:LY_SERVER params:nil success:^(id response) {
        NSLog(@"------>%@",response);
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        if ([code isEqualToString:@"1"]) {
            NSArray *jiubaArray = [JiuBaModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
            compelte(jiubaArray);
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"NEEDGETLIKE"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    } failure:^(NSError *err) {
        
    }];
}

#pragma mark 获取用户赞的酒吧
+ (void)getUserZangJiuBarListWithCompelet:(void(^)(NSArray *array))compelte{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_GETUSERZANGJIUBA baseURL:LY_SERVER params:nil success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        if ([code isEqualToString:@"1"]) {
            NSArray *jiubaArray = [JiuBaModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
            compelte(jiubaArray);
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"NEEDGETCOLLECT"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    } failure:^(NSError *err) {
        
    }];
}

#pragma mark - 判断手机是否注册过
+ (void)getYZMForThirdthLoginWithPara:(NSDictionary *)paraDic compelte:(void(^)(NSString *))compelte{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_YZM_THIRDLOGIN baseURL:LY_SERVER params:paraDic success:^(id response) {
        NSString *flag = response[@"data"][@"result"];
        compelte(flag);
    } failure:^(NSError *err) {
        
    }];
}

#pragma mark - 绑定手机号
+ (void)tieQQWeixinAndSinaWithPara:(NSDictionary *)paraDic compelte:(void(^)(NSInteger))compelte{
    NSLog(@"---->%@",paraDic);
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_TIE_OPENID baseURL:QINIU_SERVER params:paraDic success:^(id response) {
        NSString *errorCode = response[@"errorcode"];
        compelte(errorCode.integerValue);
    } failure:^(NSError *err) {
        NSLog(@"--->%@",err.description);
    }];
    
}

#pragma mark - 绑定手机号已登陆情况下
+ (void)tieQQWeixinAndSinaWithPara2:(NSDictionary *)paraDic compelte:(void(^)(NSInteger))compelte{
    NSLog(@"---->%@",paraDic);
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_TIE_OPENID2 baseURL:QINIU_SERVER params:paraDic success:^(id response) {
        NSString *errorCode = response[@"errorcode"];
        compelte(errorCode.integerValue);
    } failure:^(NSError *err) {
        NSLog(@"--->%@",err.description);
    }];
    
}

#pragma mark - 绑定手机后用openId登录
+ (void)userLoginFromOpenIdWithPara:(NSDictionary *)paraDic compelte:(void (^)(UserModel *))compelte{
    [HTTPController requestWihtMethod:RequestMethodTypeGet url:LY_OPENID_LOGIN baseURL:LY_SERVER params:paraDic success:^(id response) {
        UserModel *userModel=[UserModel mj_objectWithKeyValues:response[@"data"]];
        compelte(userModel);
    } failure:^(NSError *err) {
        
    }];
}

#pragma mark - 获取用户的推送配置
+ (void)getUserNotificationWithPara:(NSDictionary *)paraDic compelte:(void (^)(NSArray *))compelte{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_USERNOTIFITION baseURL:QINIU_SERVER params:paraDic success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        if ([code isEqualToString:@"1"]) {
            NSArray *itemsArray = response[@"items"];
            NSArray *dataArray = [MineUserNotification mj_objectArrayWithKeyValuesArray:itemsArray];
            compelte(dataArray);
        }else{
            compelte(nil);
        }
        [app stopLoading];
    } failure:^(NSError *err) {
        compelte(nil);
                [app stopLoading];
    }];
}

#pragma mark - 修改用户的推送配置
+ (void)changeUserNotificationWithPara:(NSDictionary *)paraDic compelte:(void (^)(bool))compelte{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_USERCHANGENOTIFICATION baseURL:QINIU_SERVER params:paraDic success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        if ([code isEqualToString:@"1"]) {
            compelte(YES);
        }else{
            compelte(NO);
        }
        [app stopLoading];
    } failure:^(NSError *err) {
        compelte(NO);
        [app stopLoading];
    }];
}

#pragma mark - 扫描述二维码加好友或订单验码
+ (void)userScanQRCodeWithPara:(NSDictionary *)paraDic complete:(void (^)(NSDictionary *))complete{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_QRCODE_SCAN baseURL:LY_SERVER params:paraDic success:^(id response) {
        NSString *errorCode = [response valueForKey:@"errorcode"];
        
//        if ([errorCode isEqualToString:@"1"]) {
            if ([[paraDic valueForKey:@"usertype"] isEqualToString:@"1"]) {
                //普通用户进行扫码
                dispatch_async(dispatch_get_main_queue(), ^{
                    complete(response);
                });
            }else if ([[paraDic valueForKey:@"usertype"] isEqualToString:@"2"]){
                //商家扫码
                NSString *message = [response valueForKey:@"message"];
                NSArray *dataArr = [response valueForKey:@"data"];
                NSMutableArray *tempArr = [[NSMutableArray alloc]initWithArray:[OrderInfoModel mj_objectArrayWithKeyValuesArray:dataArr]];
                NSDictionary *dict = @{@"errorcode":errorCode,
                                       @"message":message,
                                       @"data":tempArr};
                dispatch_async(dispatch_get_main_queue(), ^{
                    complete(dict);
                });
//            }
        }else{
            [MyUtil showLikePlaceMessage:[response valueForKey:@"message"]];
        }
        [app stopLoading];
    } failure:^(NSError *err) {
        NSLog(@"------>%@",err.description);
        [app stopLoading];
    }];
}

#pragma mark - 根据用户ID，获取好友详情
+ (void)GetUserInfomationWithID:(NSDictionary *)paraDic complete:(void(^)(NSDictionary *))complete{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_GET_USERINFO baseURL:LY_SERVER params:paraDic success:^(id response) {
        NSString *errorCode = [response valueForKey:@"errorcode"];
        NSString *message = [response valueForKey:@"message"];
        NSDictionary *result = [response valueForKey:@"data"];
        if([errorCode isEqualToString:@"1"]){
            dispatch_async(dispatch_get_main_queue(), ^{
                complete(result);
            });
        }else{
            [MyUtil showLikePlaceMessage:message];
        }
    } failure:^(NSError *err) {
        
    }];
}

+ (void)QuickCheckOrderWithParam:(NSDictionary *)paraDic complete:(void (^)(NSString *))complete{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_QUICK_CHECK baseURL:LY_SERVER params:paraDic success:^(id response) {
        NSString *message = [response valueForKey:@"message"];
        NSString *errorCode = [response valueForKey:@"errorcode"];
        if ([errorCode isEqualToString:@"1"]) {
            complete(message);
        }else{
            [MyUtil showLikePlaceMessage:message];
        }
    } failure:^(NSError *err) {
        
    }];
}

#pragma mark - 获取远程版本 判断是否强制升级
- (void) getAppUpdateStatus:(NSDictionary*)params
                  complete:(void (^)(BOOL result))result{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_FORCED_UPDATE baseURL:LY_SERVER params:params success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        if ([code isEqualToString:@"1"]) {
            NSDictionary *dataDic = response[@"data"];
            NSString *forced_update=[dataDic objectForKey:@"forced_update"];
            NSString *version=[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
            NSString *remote_version=[dataDic objectForKey:@"version"];
            BOOL b=NO;
            //对比班底
            if (![MyUtil isEmptyString:remote_version]) {
                if (![version isEqualToString:remote_version] ) {
                    b=YES;
                }
            }
            if (![MyUtil isEmptyString:forced_update]&&forced_update.intValue==1 &&b) {
                
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    result(YES);
                });
            }else{
                result(NO);
            }
            
        }else{
            result(NO);
        }
    } failure:^(NSError *err) {
    }];
    
}

#pragma mark - 获取DES KEY
-(void) getAppDesKey:(NSDictionary*)params
                  complete:(void (^)(NSString * result))result{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_GET_DES baseURL:LY_SERVER params:params success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        if ([code isEqualToString:@"1"]) {
            NSString *key = response[@"data"];
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    result(key);
                });
        }
    } failure:^(NSError *err) {
    }];
    
}



@end
