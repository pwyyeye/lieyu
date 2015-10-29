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
        UserModel *userModel=[UserModel objectWithKeyValues:dataDic];
        if ([code isEqualToString:@"1"]) {
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
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        
        NSDictionary *dataDic = response[@"data"];
        UserModel *userModel=[UserModel objectWithKeyValues:dataDic];
        if ([code isEqualToString:@"1"]) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                block(userModel);
            });
        }else{
            [MyUtil showMessage:message];
        }
        
    } failure:^(NSError *err) {
    }];
}


#pragma mark - 登出
-(void) userLogOutWithParams:(NSDictionary*)params
                      block:(void(^)(BOOL result)) block{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_LOGOUT baseURL:LY_SERVER params:params success:^(id response) {
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
            NSMutableArray *tempArr = [[NSMutableArray alloc]initWithArray:[ZSDetailModel objectArrayWithKeyValuesArray:dataList]];
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
            NSMutableArray *tempArr = [[NSMutableArray alloc]initWithArray:[JiuBaModel objectArrayWithKeyValuesArray:dataList]];
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
//    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_MY_ORDER baseURL:LY_SERVER params:params success:^(id response) {
        NSArray *dataList = response[@"data"];
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        
        if ([code isEqualToString:@"1"]) {
            NSMutableArray *tempArr = [[NSMutableArray alloc]initWithArray:[OrderInfoModel objectArrayWithKeyValuesArray:dataList]];
                block(tempArr);
            
            
        }else{
            [MyUtil showMessage:message];
        }
//        [app stopLoading];
    } failure:^(NSError *err) {
        [MyUtil showMessage:@"获取数据失败！"];
//        [app stopLoading];
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
            NSMutableArray *tempArr = [[NSMutableArray alloc]initWithArray:[CustomerModel objectArrayWithKeyValuesArray:dataList]];
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
    
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_ADDFRIEND_LIST baseURL:QINIU_SERVER params:params success:^(id response) {
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
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_MY_BAR_LIST baseURL:LY_SERVER params:params success:^(id response) {
        NSArray *dataList = response[@"data"];
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        
        if ([code isEqualToString:@"1"]) {
            NSMutableArray *tempArr = [[NSMutableArray alloc]initWithArray:[MyBarModel objectArrayWithKeyValuesArray:dataList]];
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                block(tempArr);
            });
            
        }else{
            [MyUtil showMessage:message];
        }
        [app stopLoading];
    } failure:^(NSError *err) {
        [MyUtil showMessage:@"获取数据失败！"];
        [app stopLoading];
    }];
}
#pragma mark 收藏酒吧
-(void) addMyBarWithParams:(NSDictionary*)params
                  complete:(void (^)(BOOL result))result{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_MY_BAR_ADD baseURL:LY_SERVER params:params success:^(id response) {
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
#pragma mark 删除收藏酒吧
-(void) delMyBarWithParams:(NSDictionary*)params
                  complete:(void (^)(BOOL result))result{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_MY_BAR_DEL baseURL:LY_SERVER params:params success:^(id response) {
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
            NSMutableArray *tempArr = [[NSMutableArray alloc]initWithArray:[CustomerModel objectArrayWithKeyValuesArray:dataList]];
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                block(tempArr);
            });
            
        }else{
            [MyUtil showMessage:message];
        }
        [app stopLoading];
    } failure:^(NSError *err) {
        [MyUtil showMessage:@"获取数据失败！"];
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
            NSMutableArray *tempArr = [[NSMutableArray alloc]initWithArray:[CustomerModel objectArrayWithKeyValuesArray:dataList]];
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                block(tempArr);
            });
            
        }else{
            [MyUtil showMessage:message];
        }
        [app stopLoading];
    } failure:^(NSError *err) {
        [MyUtil showMessage:@"获取数据失败！"];
        [app stopLoading];
    }];
}
//附近玩家
-(void) getFindNearFriendListWithParams:(NSDictionary*)params
                                  block:(void(^)(NSMutableArray* result)) block{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_FINDNEARFRIEND_LIST baseURL:LY_SERVER params:params success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        
        if ([code isEqualToString:@"1"]) {
            NSArray *dataList= response[@"data"];
            NSMutableArray *tempArr = [[NSMutableArray alloc]initWithArray:[CustomerModel objectArrayWithKeyValuesArray:dataList]];
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                block(tempArr);
            });
            
        }else{
            [MyUtil showMessage:message];
        }
        [app stopLoading];
    } failure:^(NSError *err) {
        [MyUtil showMessage:@"获取数据失败！"];
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
            NSMutableArray *tempArr=[UserTagModel objectArrayWithKeyValuesArray:dataList];
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                block(tempArr);
            });
        }else{
            [MyUtil showMessage:message];
        }
        
    } failure:^(NSError *err) {
    }];
}

@end
