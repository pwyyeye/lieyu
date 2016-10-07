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
#import "BarActivityList.h"
#import "BarTopicInfo.h"
#import "CustomerModel.h"
#import "GameList.h"
#import "HomePageModel.h"
#import "HomepageBannerModel.h"
#import "StrategyCommentModel.h"
#import "ActivityModel.h"

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
            if([[params objectForKey:@"p"] intValue] == 1 && params.count == 2){
                //存储缓存讯息
                LYCoreDataUtil *core = [LYCoreDataUtil shareInstance];
                [core saveOrUpdateCoreData:@"LYCache" withParam:@{@"lyCacheKey":CACHE_PLAY_TOGETHER_HOMEPAGE,@"lyCacheValue":dataList,@"createDate":[NSDate date]} andSearchPara:@{@"lyCacheKey":CACHE_PLAY_TOGETHER_HOMEPAGE}];
            }
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                block(tempArr);
            });
            
        }else{
            [MyUtil showMessage:message];
        }
        [app stopLoading];
    } failure:^(NSError *err) {
        //            [MyUtil showMessage:@"获取数据失败！"];
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
        //[MyUtil showCleanMessage:@"获取数据失败！"];
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
        //[MyUtil showCleanMessage:@"获取数据失败！"];
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
        //[MyUtil showCleanMessage:@"获取数据失败！"];
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
        //[MyUtil showCleanMessage:@"获取数据失败！"];
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
        //[MyUtil showCleanMessage:@"获取数据失败！"];
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
        //[MyUtil showCleanMessage:@"获取数据失败！"];
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
        //[MyUtil showCleanMessage:@"获取数据失败！"];
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
    //    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    //    [app startLoading];
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
            [MyUtil showPlaceMessage:message];
        }
        //        [app stopLoading];
    } failure:^(NSError *err) {
        [MyUtil showCleanMessage:@"获取数据失败！"];
        //        [app stopLoading];
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
        //[MyUtil showCleanMessage:@"获取数据失败！"];
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
    //    [app startLoading];
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
        //        [app stopLoading];
    } failure:^(NSError *err) {
        //[MyUtil showCleanMessage:@"获取数据失败！"];
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
        if ([code isEqualToString:@"success"]) {
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

+ (void)getWeixinAccessTokenWithCode:(NSString *)codeStr compelete:(void(^)(NSString *))compelete{
    
    NSURLRequest *urlRequest= [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=wxb1f5e1de5d4778b9&secret=d4624c36b6795d1d99dcf0547af5443d&code=%@&grant_type=authorization_code",codeStr]]];
    
    
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil];
    // NSLog(@"---->%@",[[NSString  alloc]initWithData:data1 encoding:NSUTF8StringEncoding]);
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    //    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[[NSOperationQueue alloc]init]completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
    //        NSLog(@"----->%@---------%@",response,[[NSString  alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    //    }];
    
    [[NSUserDefaults standardUserDefaults] setObject:dic[@"access_token"] forKey:@"weixinGetAccessToken"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"weixinDate"];
    compelete(dic[@"access_token"]);
    NSString *refreshAccessTokenStr = dic[@"refresh_token"];
    [[NSUserDefaults standardUserDefaults] setObject:refreshAccessTokenStr forKey:@"weixinRefresh_token"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"weixinReDate"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

+ (void)getWeixinNewAccessTokenWithRefreshToken:(NSString *)RefreshToken compelete:(void (^)(NSString *))compelete{
    
    NSLog(@"---->%@------------>%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"weixinRefresh_token"],RefreshToken );
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=wxb1f5e1de5d4778b9&grant_type=refresh_token&refresh_token=%@",RefreshToken]]];
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil];
    NSDictionary *dic= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    [[NSUserDefaults standardUserDefaults] setObject:dic[@"access_token"] forKey:@"weixinGetAccessToken"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"weixinDate"];
    [[NSUserDefaults standardUserDefaults] setObject:dic[@"openid"] forKey:@"weixinOpenid"];
    [[NSUserDefaults standardUserDefaults] setObject:dic[@"refresh_token"] forKey:@"weixinRefresh_token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    compelete(dic[@"access_token"]);
    NSLog(@"--%@",dic);
}

+ (void)getWeixinUserInfoWithAccessToken:(NSString *)accessToken compelete:(void(^)(UserModel *))compelete{
    NSString *openIdStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"weixinOpenid"];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",accessToken,openIdStr]]];
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil];
    NSDictionary *dic= (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"--->%@",dic);
    
    UserModel *userM = [[UserModel alloc]init];
    userM.avatar_img =[dic objectForKey:@"headimgurl"];
    userM.usernick = [dic objectForKey:@"nickname"];
    userM.gender =[dic objectForKey:@"sex"];
    userM.openID =[dic objectForKey:@"openid"];  //dic[@"openi                                                                                                                                                                                                                                        d"];
    compelete(userM);
}

#pragma mark 获取酒吧的活动列表
+ (void)getActivityListWithPara:(NSDictionary *)paraDic compelte:(void(^)(NSMutableArray * result))compelete{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_BAR_ACTIVITYLIST baseURL:LY_SERVER params:paraDic success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *message = [NSString stringWithFormat:@"%@",response[@"message"]];
        NSArray *dataList = response[@"data"];
        if([code isEqualToString:@"1"]){
            NSMutableArray *tempArr = [[NSMutableArray alloc]initWithArray:[BarActivityList mj_objectArrayWithKeyValuesArray:dataList]];
            dispatch_async(dispatch_get_main_queue(), ^{
                compelete(tempArr);
            });
        }else{
            [MyUtil showCleanMessage:message];
        }
        [app stopLoading];
    } failure:^(NSError *err) {
        //        [MyUtil showCleanMessage:@"获取数据失败！"];
        [app stopLoading];
    }];
}

#pragma mark 获取酒吧的活动列表
+ (void)getActivityListNoAppLoadingWithPara:(NSDictionary *)paraDic compelte:(void(^)(NSMutableArray * result))compelete{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_BAR_ACTIVITYLIST baseURL:LY_SERVER params:paraDic success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *message = [NSString stringWithFormat:@"%@",response[@"message"]];
        NSArray *dataList = response[@"data"];
        if([code isEqualToString:@"1"]){
            NSMutableArray *tempArr = [[NSMutableArray alloc]initWithArray:[BarActivityList mj_objectArrayWithKeyValuesArray:dataList]];
            dispatch_async(dispatch_get_main_queue(), ^{
                compelete(tempArr);
            });
        }else{
            [MyUtil showCleanMessage:message];
        }
    } failure:^(NSError *err) {
        [MyUtil showCleanMessage:@"获取数据失败！"];
    }];
}

#pragma mark - 获取活动列表
+ (void)getNewActivityListWithParam:(NSDictionary *)param complete:(void(^)(NSDictionary *))complete{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_BAR_ACTIVITYLIST baseURL:LY_SERVER params:param success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        if([code isEqualToString:@"1"]){
            NSArray *bannerList = [HomepageBannerModel mj_objectArrayWithKeyValuesArray:[[response objectForKey:@"data"] objectForKey:@"bannerList"]];
            NSArray *activityList = [BarActivityList mj_objectArrayWithKeyValuesArray:[[response objectForKey:@"data"] objectForKey:@"activityList"]];
            NSDictionary *result = @{@"bannerList":bannerList,
                                     @"activityList":activityList};
            complete(result);
        }else{
//            [MyUtil showPlaceMessage:@"获取数据失败，请稍后重试！"];
        }
        [app stopLoading];
    } failure:^(NSError *err) {
        [app stopLoading];
    }];
}

#pragma mark - 获取所有专题列表
+ (void)getActionList:(NSDictionary *)paraDic complete:(void(^)(NSMutableArray *result))complete{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_ACTION_LIST baseURL:LY_SERVER params:paraDic success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *message = [NSString stringWithFormat:@"%@",response[@"message"]];
        NSArray *dataList = response[@"data"];
        if([code isEqualToString:@"1"]){
            NSMutableArray *tempArr = [[NSMutableArray alloc]initWithArray:[BarTopicInfo mj_objectArrayWithKeyValuesArray:dataList]];
            dispatch_async(dispatch_get_main_queue(), ^{
                complete(tempArr);
            });
        }else{
            [MyUtil showCleanMessage:message];
        }
    } failure:^(NSError *err) {
        //        [MyUtil showCleanMessage:@"获取数据失败"];
    }];
}

#pragma mark - 活动详情
+ (void)getActionDetail:(NSDictionary *)paraDic complete:(void(^)(BarActivityList *action))complete{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_ACTIVITY_DETAIL baseURL:LY_SERVER params:paraDic success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        
        if ([code isEqualToString:@"1"]) {
            BarActivityList *actionDetail = [BarActivityList mj_objectWithKeyValues:response[@"data"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                complete(actionDetail);
            });
        }else{
            [MyUtil showCleanMessage:response[@"message"]];
        }
        [app stopLoading];
    } failure:^(NSError *err) {
        [app stopLoading];
    }];
}

#pragma mark - 获取所有签到
+ (void)getSignListWidth:(NSDictionary *)paraDic complete:(void(^)(NSMutableArray *result))complete{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_SIGN baseURL:LY_SERVER params:paraDic success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"] ];
        if ([code isEqualToString:@"1"]) {
            NSArray *array = response[@"data"];
            NSMutableArray *dataArray = [[CustomerModel mj_objectArrayWithKeyValuesArray:array] mutableCopy];
            complete(dataArray);
        }
    }failure:^(NSError *err) {
        [MyUtil showCleanMessage:@"获取数据失败"];
    }];
}

#pragma mark - 签到
+ (void)signWith:(NSDictionary *)paraDic complete:(void(^)(bool))complete{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_GOTOSIGN baseURL:LY_SERVER params:paraDic success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"] ];
        [MyUtil showCleanMessage:response[@"message"]];
        if ([code isEqualToString:@"1"]) {
            complete(YES);
        }else{
            complete(NO);
        }
    }failure:^(NSError *err) {
        [MyUtil showCleanMessage:@"获取数据失败"];
    }];
}

#pragma mark - 获取游戏列表
+ (void)getGameFromWith:(NSDictionary *)paraDic complete:(void(^)(NSArray *))complete{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_GAMELIST baseURL:LY_SERVER params:paraDic success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"] ];
        if ([code isEqualToString:@"1"]) {
            NSArray *dataArray = [response objectForKey:@"data"];
            NSArray *gameListArray = (NSArray *)[GameList mj_objectArrayWithKeyValuesArray:dataArray];
            complete(gameListArray);
        }else{
            complete(nil);
        }
        
    } failure:^(NSError *err) {
        
    }];
}

#pragma mark - 获取娱乐顾问数据
+ (void)homePageGetGuWenDataWith:(NSDictionary *)paraDic complete:(void(^)(HomePageModel *))complete{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_HOME_GUWEN baseURL:LY_SERVER params:paraDic success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"] ];
        if ([code isEqualToString:@"1"]) {
            HomePageModel *homePageM = [[HomePageModel alloc]init];
            NSDictionary *dataDic = response[@"data"];
            
            LYCoreDataUtil *core=[LYCoreDataUtil shareInstance];
            [core saveOrUpdateCoreData:@"LYCache" withParam:@{
                                                              @"lyCacheKey":CACHE_INEED_PLAY_HOMEPAGE_GUWEN,
                                                              @"lyCacheValue":dataDic,
                                                              @"createDate":[NSDate date]}
                         andSearchPara:@{@"lyCacheKey":CACHE_INEED_PLAY_HOMEPAGE_GUWEN}];
            
            
            homePageM.banner = [dataDic valueForKey:@"banner"];
            homePageM.newbanner=[dataDic valueForKey:@"newbanner"];
            homePageM.filterImages = [dataDic valueForKey:@"filterImages"];
            homePageM.viplist = [UserModel mj_objectArrayWithKeyValuesArray:[dataDic valueForKey:@"viplist"]];
            complete(homePageM);
        }else{
            complete(nil);
        }
        
    } failure:^(NSError *err) {
        
    }];
}

//获取地理位置信息
+ (void) getAllLocationInfoWith:(NSDictionary *)paraDic complete: (void(^)(NSString *locationArr))complete
{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_HOME_ALLLOCATION baseURL:LY_SERVER params:paraDic success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@", response[@"errorcode"]];
        if ([code isEqualToString:@"1"]) {
            NSArray *dataArr = response[@"data"];
            complete(dataArr);
        } else {
            complete(nil);
        }
    } failure:^(NSError *err) {
        
    }];
}

#pragma mark - 获取首页数据
//获取首页数据 part－1
+ (void)getHomepageFirstScreenDataWith:(NSDictionary *)param complete:(void (^)(NSDictionary *))complete{
    AppDelegate *app = ((AppDelegate *)[UIApplication sharedApplication].delegate);
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_HOME_FIRSTSCREEN baseURL:LY_SERVER params:param success:^(id response) {
        NSString *errorCode = [response objectForKey:@"errorcode"];
        if ([errorCode isEqualToString:@"1"]) {
            NSArray *arrayBanner = [HomepageBannerModel mj_objectArrayWithKeyValuesArray:[[response objectForKey:@"data"] objectForKey:@"bannerList"]];
            BarTopicInfo *activeModel;
            if ([[response objectForKey:@"data"] objectForKey:@"recommendedTopic"]) {
                activeModel = [BarTopicInfo mj_objectWithKeyValues:[[response objectForKey:@"data"] objectForKey:@"recommendedTopic"]];
            }
            NSDictionary *result = @{@"bannerList":arrayBanner,
                                     @"filterImageList":[[response objectForKey:@"data"] objectForKey:@"filterImageList"],
                                     @"recommendedTopic":activeModel};
            complete(result);
        }else{
            
        }
//        [app stopLoading];
    } failure:^(NSError *err) {
//        [app stopLoading];
    }];
}

+ (void)getHomepageListDataWith:(NSDictionary *)param complete:(void (^)(NSDictionary *))complete{
    AppDelegate *app = ((AppDelegate *)[UIApplication sharedApplication].delegate);
//    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_HOME_LIST baseURL:LY_SERVER params:param success:^(id response) {
        NSString *errorCode = [response objectForKey:@"errorcode"];
        if ([errorCode isEqualToString:@"1"]) {
            NSArray *arrayRec = [JiuBaModel mj_objectArrayWithKeyValuesArray:[[response objectForKey:@"data"] objectForKey:@"recommendBarList"]];
            NSArray *arrayBar = [JiuBaModel mj_objectArrayWithKeyValuesArray:[[response objectForKey:@"data"] objectForKey:@"barList"]];
            NSDictionary *result = @{@"recommendBarList":arrayRec,
                                     @"barList":arrayBar};
            complete(result);
        }else{
            
        }
        [app stopLoading];
    } failure:^(NSError *err) {
        [app stopLoading];
    }];
}

#pragma mark - 获取banner列表
+ (void)getBannerListWith:(NSDictionary *)param complete:(void(^)(NSArray *))complete{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_GET_BANNERLIST baseURL:LY_SERVER params:param success:^(id response) {
        NSString *errorCode = [response objectForKey:@"errorcode"];
        if ([errorCode isEqualToString:@"1"]) {
            NSArray *array = [HomepageBannerModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
            complete(array);
        }else{
            
        }
    } failure:^(NSError *err) {
        
    }];
}

#pragma mark - 获取攻略列表
+ (void)getStrategyListWith:(NSDictionary *)param complete:(void (^)(NSArray *))complete{
    AppDelegate *app = ((AppDelegate *)[UIApplication sharedApplication].delegate);
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_GET_STRATEGYLIST baseURL:LY_SERVER params:param success:^(id response) {
        NSString *errorCode = [response objectForKey:@"errorcode"];
        if ([errorCode isEqualToString:@"1"]) {
            NSArray *array = [StrategryModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
            complete(array);
        }else{
            [MyUtil showPlaceMessage:@"获取数据失败，请稍后重试！"];
        }
        [app stopLoading];
    } failure:^(NSError *err) {
        [app stopLoading];
    }];
}


#pragma mark - 获取攻略详情
+ (void)getStrategyDetailWith:(NSDictionary *)param complete:(void (^)(StrategryModel *))complete{
    AppDelegate *app = ((AppDelegate *)[UIApplication sharedApplication].delegate);
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_GET_STRATEGYDETAIL baseURL:LY_SERVER params:param success:^(id response) {
        NSString *errorCode = [response objectForKey:@"errorcode"];
        if ([errorCode isEqualToString:@"1"]) {
            StrategryModel *model = [StrategryModel mj_objectWithKeyValues:[response objectForKey:@"data"]];
            complete(model);
        }
        [app stopLoading];
    } failure:^(NSError *err) {
        [app stopLoading];
    }];
}

#pragma mark - 攻略点赞
+ (void)addLikeStrategyWith:(NSDictionary *)param complete:(void (^)(BOOL))complete{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_ADDLIKE_STRATEGY baseURL:LY_SERVER params:param success:^(id response) {
        NSString *errorCode = [response objectForKey:@"errorcode"];
        if ([errorCode isEqualToString:@"1"]) {
            [MyUtil showPlaceMessage:@"感谢您的点赞！"];
            complete(YES);
        }else{
            [MyUtil showPlaceMessage:@"点赞失败，请稍后重试"];
            complete(NO);
        }
    } failure:^(NSError *err) {
    }];
}

#pragma mark - 攻略取消点赞
+ (void)cancelLikeStrategyWith:(NSDictionary *)param complete:(void (^)(BOOL))complete{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_CANCELLIKE_STRATEGY baseURL:LY_SERVER params:param success:^(id response) {
        NSString *errorCode = [response objectForKey:@"errorcode"];
        if ([errorCode isEqualToString:@"1"]) {
            [MyUtil showPlaceMessage:@"取消点赞成功！"];
            complete(YES);
        }else{
            [MyUtil showPlaceMessage:@"取消点赞失败，请稍后重试"];
            complete(NO);
        }
    } failure:^(NSError *err) {
    }];
}

#pragma mark - 攻略收藏
+ (void)addCollectStrategyWith:(NSDictionary *)param complete:(void (^)(BOOL))complete{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_ADDCOLL_STRATEGY baseURL:LY_SERVER params:param success:^(id response) {
        NSString *errorCode = [response objectForKey:@"errorcode"];
        if ([errorCode isEqualToString:@"1"]) {
            [MyUtil showPlaceMessage:@"感谢您的收藏！"];
            complete(YES);
        }else{
            [MyUtil showPlaceMessage:@"收藏失败，请稍后重试"];
            complete(NO);
        }
    } failure:^(NSError *err) {
    }];
}

#pragma mark - 攻略取消收藏
+ (void)cancelCollectStrategyWith:(NSDictionary *)param complete:(void (^)(BOOL))complete{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_CANCELCOLL_STRATEGY baseURL:LY_SERVER params:param success:^(id response) {
        NSString *errorCode = [response objectForKey:@"errorcode"];
        if ([errorCode isEqualToString:@"1"]) {
            [MyUtil showPlaceMessage:@"取消收藏成功！"];
            complete(YES);
        }else{
            [MyUtil showPlaceMessage:@"取消收藏失败，请稍后重试"];
            complete(NO);
        }
    } failure:^(NSError *err) {
        
    }];
}

#pragma mark - 获取攻略评论列表
+ (void)getStrategyCommentWithParam:(NSDictionary *)param complete:(void (^)(NSArray *))complete{
    AppDelegate *app = ((AppDelegate *)[UIApplication sharedApplication].delegate);
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_GET_STRATEGYCOMMENT baseURL:LY_SERVER params:param success:^(id response) {
        NSString *errorCode = [response objectForKey:@"errorcode"];
        if ([errorCode isEqualToString:@"1"]) {
            NSArray *array = [StrategyCommentModel mj_objectArrayWithKeyValuesArray:[[response objectForKey:@"data"] objectForKey:@"items"]];
            complete(array);
        }
        [app stopLoading];
    } failure:^(NSError *err) {
        [app stopLoading];
    }];
}

#pragma mark - 攻略添加评论
+ (void)addStrategyCommentWithParam:(NSDictionary *)param complete:(void (^)(BOOL))complete{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_ADDCOMMENT_STRATEGY baseURL:LY_SERVER params:param success:^(id response) {
        NSString *errorCode = [response objectForKey:@"errorcode"];
        if ([errorCode isEqualToString:@"1"]) {
            complete(YES);
        }else{
            complete(NO);
        }
    } failure:^(NSError *err) {
        
    }];
}

#pragma mark - 攻略删除评论
+ (void)deleteStrategyCommentWithParam:(NSDictionary *)param complete:(void (^)(BOOL))complete{
    [HTTPController requestWihtMethod:RequestMethodTypePost url:LY_DELETECOMMENT_STRATEGY baseURL:LY_SERVER params:param success:^(id response) {
        NSString *errorCode = [response objectForKey:@"errorcode"];
        if ([errorCode isEqualToString:@"1"]) {
            complete(YES);
        }else{
            complete(NO);
        }
    } failure:^(NSError *err) {
        
    }];
}




@end
