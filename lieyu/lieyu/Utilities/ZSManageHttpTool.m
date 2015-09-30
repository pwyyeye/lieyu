//
//  ZSManageHttpTool.m
//  lieyu
//
//  Created by 薛斯岐 on 15/9/29.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "ZSManageHttpTool.h"
#import "TaoCanModel.h"
#import "PinKeModel.h"
#import "CheHeModel.h"
#import "KuCunModel.h"
#import "CustomerModel.h"
#import "DeckFullModel.h"
@implementation ZSManageHttpTool
+ (ZSManageHttpTool *)shareInstance
{
    static ZSManageHttpTool * instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}
#pragma mark -获取专属经理-套餐列表
-(void) getMyTaoCanListWithParams:(NSDictionary*)params
    block:(void(^)(NSMutableArray* result)) block{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:ZS_TAOCANLIST baseURL:LY_SERVER params:params success:^(id response) {
        NSArray *dataList = response[@"data"];
        NSMutableArray *tempArr = [[NSMutableArray alloc]initWithArray:[TaoCanModel objectArrayWithKeyValuesArray:dataList]];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            block(tempArr);
        });
        [app stopLoading];
    } failure:^(NSError *err) {
        [app stopLoading];
    }];
}
#pragma mark -获取专属经理-拼客列表
-(void) getMyPinkerListWithParams:(NSDictionary*)params
                            block:(void(^)(NSMutableArray* result)) block{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:ZS_PINKELIST baseURL:LY_SERVER params:params success:^(id response) {
        NSArray *dataList = response[@"data"];
        NSMutableArray *tempArr = [[NSMutableArray alloc]initWithArray:[PinKeModel objectArrayWithKeyValuesArray:dataList]];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            block(tempArr);
        });
        [app stopLoading];
    } failure:^(NSError *err) {
        [app stopLoading];
    }];
    
}
#pragma mark -获取专属经理-单品列表
-(void) getMyDanPinListWithParams:(NSDictionary*)params
                            block:(void(^)(NSMutableArray* result)) block{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:ZS_DANPINLIST baseURL:LY_SERVER params:params success:^(id response) {
        NSArray *dataList = response[@"data"];
        NSMutableArray *tempArr = [[NSMutableArray alloc]initWithArray:[CheHeModel objectArrayWithKeyValuesArray:dataList]];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            block(tempArr);
        });
        [app stopLoading];
    } failure:^(NSError *err) {
        [app stopLoading];
    }];

}
#pragma mark -获取专属经理-库存列表
-(void) getMyKuCunListWithParams:(NSDictionary*)params
                           block:(void(^)(NSMutableArray* result)) block{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:ZS_KUCUNLIST baseURL:LY_SERVER params:params success:^(id response) {
        NSArray *dataList = response[@"data"];
        NSMutableArray *tempArr = [[NSMutableArray alloc]initWithArray:[KuCunModel objectArrayWithKeyValuesArray:dataList]];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            block(tempArr);
        });
        [app stopLoading];
    } failure:^(NSError *err) {
        [app stopLoading];
    }];

}

#pragma mark -专属经理-库存添加
-(void) addItemProductWithParams:(NSDictionary*)params complete:(void (^)(BOOL result))result{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:ZS_KUCUN_ADD baseURL:LY_SERVER params:params success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        
        if ([code isEqualToString:@"0"]) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                result(YES);
            });
            [app stopLoading];
        }else{
            result(NO);
            [app stopLoading];
        }
        
        
    } failure:^(NSError *err) {
        
        result(NO);
        [app stopLoading];
        
    }];
}


#pragma mark -获取一周卡座
-(void) getDeckFullWithParams:(NSDictionary*)params
                        block:(void(^)(NSMutableArray* result)) block{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:ZS_KUZUOISFULL baseURL:LY_SERVER  params:params success:^(id response) {
        NSArray *dataList = response[@"data"];
        NSMutableArray *tempArr = [[NSMutableArray alloc]initWithArray:[DeckFullModel objectArrayWithKeyValuesArray:dataList]];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            block(tempArr);
        });
        [app stopLoading];
    } failure:^(NSError *err) {
        [app stopLoading];
        //        NSLog(err.domain);
    }];

}
#pragma mark -获取我的客户
-(void) getUsersFriendWithParams:(NSDictionary*)params
                           block:(void(^)(NSMutableArray* result)) block{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:ZS_USERS_FRIEND baseURL:LY_SERVER params:params success:^(id response) {
        NSArray *dataList = response[@"data"];
        NSMutableArray *tempArr = [[NSMutableArray alloc]initWithArray:[CustomerModel objectArrayWithKeyValuesArray:dataList]];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            block(tempArr);
        });
        [app stopLoading];
    } failure:^(NSError *err) {
        [app stopLoading];
    }];
}
#pragma mark -专属经理 设置某天卡座满座

-(void) setDeckADDWithParams:(NSDictionary*)params complete:(void (^)(BOOL result))result{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];

    [HTTPController requestWihtMethod:RequestMethodTypePost url:ZS_KAZUO_ADD baseURL:LY_SERVER params:params success:^(id response) {
            NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        
            if ([code isEqualToString:@"0"]) {
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    result(YES);
                });
                [app stopLoading];
            }else{
                result(NO);
                [app stopLoading];
            }
            
        
        } failure:^(NSError *err) {
            [app stopLoading];
                result(NO);
            
        
    }];
}
#pragma mark -专属经理 设置某天卡座(未)满座
-(void) setDeckDelWithParams:(NSDictionary*)params complete:(void (^)(BOOL result))result{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:ZS_KAZUO_DEL baseURL:LY_SERVER params:params success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        
            if ([code isEqualToString:@"0"]) {
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    result(YES);
                    
                });
                [app stopLoading];
            }else{
                result(NO);
                [app stopLoading];
            }
            
        
    } failure:^(NSError *err) {
        
            result(NO);
        [app stopLoading];
        
    }];
}


@end
