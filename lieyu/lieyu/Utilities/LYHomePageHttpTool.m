//
//  LYHomePageHttpTool.m
//  lieyu
//
//  Created by 薛斯岐 on 15/10/15.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYHomePageHttpTool.h"
#import "HTTPController.h"
#import "LYHomePageUrl.h"
#import "ZSUrl.h"
#import "ZSDetailModel.h"
#import "LYCache.h"


@implementation LYHomePageHttpTool
+ (LYHomePageHttpTool *)shareInstance
{
    static LYHomePageHttpTool * instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}
#pragma mark -获取一起玩列表
-(void) getTogetherListWithParams:(NSDictionary*)params block:(void(^)(NSMutableArray* result)) block{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
        [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_YIQIWAN_LIST baseURL:LY_SERVER params:params success:^(id response) {
            NSArray *dataList = response[@"data"];
            NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
            NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
            
            if ([code isEqualToString:@"1"]) {
                NSMutableArray *tempArr = [[NSMutableArray alloc]initWithArray:[PinKeModel mj_objectArrayWithKeyValuesArray:dataList]];
                //存储缓存讯息
                LYCoreDataUtil *core = [LYCoreDataUtil shareInstance];
                [core saveOrUpdateCoreData:@"LYCache" withParam:@{@"lyCacheKey":CACHE_PLAY_TOGETHER_HOMEPAGE,@"lyCacheValue":tempArr,@"createDate":[NSDate date]} andSearchPara:@{@"lyCacheKey":CACHE_PLAY_TOGETHER_HOMEPAGE}];
                //////////////////////////
                NSArray *dataArray = [core getCoreData:@"LYCache" andSearchPara:@{@"lyCacheKey":CACHE_PLAY_TOGETHER_HOMEPAGE}];
                LYCache *lycache = [dataArray objectAtIndex:0];
                NSLog(@"%@",lycache.lyCacheValue);
                
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
#pragma mark 一起玩列表详细
-(void) getTogetherDetailWithParams:(NSDictionary*)params
                              block:(void(^)(PinKeModel* result)) block{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_YIQIWAN_DETAIL baseURL:LY_SERVER params:params success:^(id response) {
        NSDictionary *dataDic = response[@"data"];//到这里有goodList
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        
        if ([code isEqualToString:@"1"]) {
            PinKeModel *pinKeModel=[PinKeModel mj_objectWithKeyValues:dataDic];
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                block(pinKeModel);
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

#pragma mark 一起玩确认订单
-(void) getTogetherOrderWithParams:(NSDictionary*)params
                             block:(void(^)(PinKeModel* result)) block{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_YIQIWAN_DOORDER baseURL:LY_SERVER params:params success:^(id response) {
        NSDictionary *dataDic = response[@"data"];
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        
        if ([code isEqualToString:@"1"]) {
            PinKeModel *pinKeModel=[PinKeModel mj_objectWithKeyValues:dataDic];
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                block(pinKeModel);
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


#pragma mark录入拼客订单
-(void) setTogetherOrderInWithParams:(NSDictionary*)params
                            complete:(void (^)(NSString *result))result{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    
    NSLog(@"params:%@",params);
    
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_YIQIWAN_INORDER baseURL:LY_SERVER params:params success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        NSString *data=[NSString stringWithFormat:@"%@",response[@"data"]];
        if ([code isEqualToString:@"1"]) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                result(data);
            });
            [app stopLoading];
        }else{
            
            [app stopLoading];
            [MyUtil showMessage:message];
        }
        
        
    } failure:^(NSError *err) {
        [app stopLoading];
        
        
        
    }];
}

#pragma mark录入拼客订单
-(void) inTogetherOrderInWithParams:(NSDictionary*)params
                            complete:(void (^)(NSString *result))result{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_MY_ORDER_INPINKER baseURL:LY_SERVER params:params success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        NSString *data=[NSString stringWithFormat:@"%@",response[@"data"]];
        if ([code isEqualToString:@"1"]) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                result(data);
            });
            [app stopLoading];
        }else{
            
            [app stopLoading];
            [MyUtil showMessage:message];
        }
        
        
    } failure:^(NSError *err) {
        [app stopLoading];
    }];
}




#pragma mark我要订位
-(void) getWoYaoDinWeiDetailWithParams:(NSDictionary*)params
                                 block:(void(^)(JiuBaModel* result)) block{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_WOYAODINWEI_INFO baseURL:LY_SERVER params:params success:^(id response) {
        NSDictionary *dataDic = response[@"data"];
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        NSLog(@"---->%@",response);
        if ([code isEqualToString:@"1"]) {
            JiuBaModel *jiuBaModel=[JiuBaModel mj_objectWithKeyValues:dataDic];
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                block(jiuBaModel);
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
#pragma mark 请求获取套餐信息
-(void) getWoYaoDinWeiTaoCanDetailWithParams:(NSDictionary*)params
                                       block:(void(^)(TaoCanModel* result)) block{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_WOYAODINWEI_TAOCAN_INFO baseURL:LY_SERVER params:params success:^(id response) {
        NSDictionary *dataDic = response[@"data"];
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        
        if ([code isEqualToString:@"1"]) {
            TaoCanModel *taoCanModel=[TaoCanModel mj_objectWithKeyValues:dataDic];
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                block(taoCanModel);
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
#pragma mark 我要订位确认订单
-(void) getWoYaoDinWeiOrderWithParams:(NSDictionary*)params
                                block:(void(^)(TaoCanModel* result)) block{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_YIQIWAN_DOORDER baseURL:LY_SERVER params:params success:^(id response) {
        NSDictionary *dataDic = response[@"data"];
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        
        if ([code isEqualToString:@"1"]) {
            TaoCanModel *taoCanModel=[TaoCanModel mj_objectWithKeyValues:dataDic];
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                block(taoCanModel);
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
#pragma mark 录入套餐订单
-(void) setWoYaoDinWeiOrderInWithParams:(NSDictionary*)params
                               complete:(void (^)(NSString *result))result{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_WOYAODINWEI_INORDER baseURL:LY_SERVER params:params success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        NSString *data=[NSString stringWithFormat:@"%@",response[@"data"]];
        if ([code isEqualToString:@"1"]) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                result(data);
            });
            [app stopLoading];
        }else{
            
            [app stopLoading];
            [MyUtil showMessage:message];
        }
        
        
    } failure:^(NSError *err) {
        [app stopLoading];
    }];
    
}

#pragma mark 吃喝列表
-(void) getCHListWithParams:(NSDictionary*)params
                      block:(void(^)(NSMutableArray* result)) block{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_CH_LISt baseURL:LY_SERVER params:params success:^(id response) {
        NSArray *dataList = response[@"data"];
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        
        if ([code isEqualToString:@"1"]) {
            NSMutableArray *tempArr = [[NSMutableArray alloc]initWithArray:[CheHeModel mj_objectArrayWithKeyValuesArray:dataList]];
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
#pragma mark 请求获取吃喝信息
-(void) getCHDetailWithParams:(NSDictionary*)params
                        block:(void(^)(CheHeModel* result)) block{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_CH_DETAIL baseURL:LY_SERVER params:params success:^(id response) {
        NSDictionary *dataDic = response[@"data"];
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        
        if ([code isEqualToString:@"1"]) {
            CheHeModel *chiHeModel=[CheHeModel mj_objectWithKeyValues:dataDic];
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                block(chiHeModel);
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
#pragma mark 添加购物车
-(void) addCarWithParams:(NSDictionary*)params
                   block:(void(^)(BOOL result)) result{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_CH_ADDCAR baseURL:LY_SERVER params:params success:^(id response) {
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
#pragma mark购物车列表
-(void) getCarListWithParams:(NSDictionary*)params
                       block:(void(^)(NSMutableArray* result)) block{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_CH_CARLIST baseURL:LY_SERVER params:params success:^(id response) {
        NSArray *dataList = response[@"data"];
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        
        if ([code isEqualToString:@"1"]) {
            NSMutableArray *tempArr = [[NSMutableArray alloc]initWithArray:[CarInfoModel mj_objectArrayWithKeyValuesArray:dataList]];
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
#pragma mark购物车数量变更
-(void) updataCarNumWithParams:(NSDictionary*)params
                      complete:(void (^)(BOOL result))result{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_CH_NUMCHANGE baseURL:LY_SERVER params:params success:^(id response) {
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
#pragma mark购物车转订单
-(void) getChiHeOrderWithParams:(NSDictionary*)params
                          block:(void(^)(CarInfoModel* result)) block{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_CH_INORDER baseURL:LY_SERVER params:params success:^(id response) {
        NSArray *arr = response[@"data"];
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        
        if ([code isEqualToString:@"1"]) {
            if(arr.count>0){
                NSDictionary *dataDic =arr[0];
                CarInfoModel *carInfoModel=[CarInfoModel mj_objectWithKeyValues:dataDic];
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    block(carInfoModel);
                });
            }
            
            
        }else{
            [MyUtil showMessage:message];
        }
        [app stopLoading];
    } failure:^(NSError *err) {
        [MyUtil showMessage:@"获取数据失败！"];
        [app stopLoading];
    }];
}
#pragma mark购物车删除
-(void) delcarWithParams:(NSDictionary*)params complete:(void (^)(BOOL result))result{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_CH_DEL baseURL:LY_SERVER params:params success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        if ([code isEqualToString:@"1"]) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                result(YES);
            });
//            [app stopLoading];
        }else{
            result(NO);
            [MyUtil showMessage:message];
//            [app stopLoading];
        }
        
        
    } failure:^(NSError *err) {
        
        result(NO);
        [app stopLoading];
        
    }];
}
#pragma mark录入购物车订单
-(void) setChiHeOrderInWithParams:(NSDictionary*)params
                         complete:(void (^)(NSString *result))result{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_CH_ORDERIN baseURL:LY_SERVER params:params success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        NSString *data=[NSString stringWithFormat:@"%@",response[@"data"]];
        if ([code isEqualToString:@"1"]) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                result(data);
            });
            [app stopLoading];
        }else{
            
            [app stopLoading];
            [MyUtil showMessage:message];
        }
        
        
    } failure:^(NSError *err) {
        [app stopLoading];
        
        
        
    }];
}
-(void) getBarVipWithParams:(NSDictionary*)params
                      block:(void(^)(NSMutableArray* result)) block{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_BAR_VIPLIST baseURL:LY_SERVER params:params success:^(id response) {
        NSArray *dataList = response[@"data"];
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        
        if ([code isEqualToString:@"1"]) {
            NSMutableArray *tempArr = [[NSMutableArray alloc]initWithArray:[ZSDetailModel mj_objectArrayWithKeyValuesArray:dataList]];
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
//收藏专属经理
-(void) scVipWithParams:(NSDictionary*)params
               complete:(void (^)(BOOL result))result{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_SC_VIPLIST baseURL:LY_SERVER params:params success:^(id response) {
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

#pragma mark 给酒吧点赞
- (void)likeJiuBa:(NSDictionary *)params compelete:(void(^)(bool))result{
//    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_DIANZANG baseURL:LY_SERVER params:params success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        if ([code isEqualToString:@"1"]) {
            result(YES);
            [MyUtil showPlaceMessage:message];
//            [app stopLoading];
        }else{
            result(NO);
//            [app stopLoading];
            [MyUtil showPlaceMessage:message];
        }
    } failure:^(NSError *err) {
//          [app stopLoading];
        [MyUtil showPlaceMessage:@"点赞失败，请检查网络连接"];
        result(NO);
    }];
}

#pragma mark 给酒吧取消点赞
- (void)unLikeJiuBa:(NSDictionary *)params compelete:(void(^)(bool))result{
//    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_QUXIAOZANG baseURL:LY_SERVER params:params success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        if ([code isEqualToString:@"1"]) {
            result(YES);
            [MyUtil showPlaceMessage:message];
//            [app stopLoading];
        }else{
            result(NO);
//            [app stopLoading];
            [MyUtil showPlaceMessage:message];
        }
    } failure:^(NSError *err) {
        result(NO);
        [MyUtil showPlaceMessage:@"取消点赞失败，请检查网络连接"];
    }];
}
@end
