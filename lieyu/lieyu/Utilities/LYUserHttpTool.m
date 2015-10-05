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

@end
