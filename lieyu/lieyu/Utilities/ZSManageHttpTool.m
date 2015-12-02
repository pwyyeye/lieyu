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
#import "ProductCategoryModel.h"
#import "BrandModel.h"

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
#pragma mark -获取专属经理订单列表
-(void) getZSOrderListWithParams:(NSDictionary*)params
                           block:(void(^)(NSMutableArray* result)) block{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:ZS_ORDER_LIST baseURL:LY_SERVER params:params success:^(id response) {
        NSArray *dataList = response[@"data"];
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        
        if ([code isEqualToString:@"1"]) {
            NSMutableArray *tempArr = [[NSMutableArray alloc]initWithArray:[OrderInfoModel mj_objectArrayWithKeyValuesArray:dataList]];
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
#pragma mark -获取订单详细
-(void) getZSOrderDetailWithParams:(NSDictionary*)params
                             block:(void(^)(OrderInfoModel* result)) block{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:ZS_ORDER_DETAIL baseURL:LY_SERVER params:params success:^(id response) {
        NSDictionary *dataDic = response[@"data"];
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        
        if ([code isEqualToString:@"1"]) {
            OrderInfoModel *orderInfoModel = [OrderInfoModel mj_objectWithKeyValues:dataDic];
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                block(orderInfoModel);
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
#pragma mark - 专属经理订单对码
-(void) setManagerConfirmOrderWithParams:(NSDictionary*)params complete:(void (^)(BOOL result))result{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:ZS_DUIMA baseURL:LY_SERVER params:params success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        if ([code isEqualToString:@"1"]) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                result(YES);
                
            });
            [app stopLoading];
        }else{
            result(NO);
            [MyUtil showMessage:message];
            [app stopLoading];
        }
        
        
    } failure:^(NSError *err) {
        
        result(NO);
        [app stopLoading];
        
    }];
}
#pragma mark -专属经理-确认卡座
-(void) setManagerConfirmSeatWithParams:(NSDictionary*)params complete:(void (^)(BOOL result))result{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:ZS_KAZUO_SURE baseURL:LY_SERVER params:params success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        if ([code isEqualToString:@"1"]) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                result(YES);
                
            });
            [app stopLoading];
        }else{
            result(NO);
            [MyUtil showMessage:message];
            [app stopLoading];
        }
        
        
    } failure:^(NSError *err) {
        
        result(NO);
        [app stopLoading];
        
    }];
}

#pragma mark -专属经理-取消订单
-(void) setMangerCancelWithParams:(NSDictionary*)params complete:(void (^)(BOOL result))result{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:ZS_KAZUO_CANCEL baseURL:LY_SERVER params:params success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        if ([code isEqualToString:@"1"]) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                result(YES);
                
            });
            [app stopLoading];
        }else{
            result(NO);
            [MyUtil showMessage:message];
            [app stopLoading];
        }
        
        
    } failure:^(NSError *err) {
        
        result(NO);
        [app stopLoading];
        
    }];
}


#pragma mark -获取专属经理-套餐列表
-(void) getMyTaoCanListWithParams:(NSDictionary*)params
    block:(void(^)(NSMutableArray* result)) block{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:ZS_TAOCANLIST baseURL:LY_SERVER params:params success:^(id response) {
        NSArray *dataList = response[@"data"];
        NSMutableArray *tempArr = [[NSMutableArray alloc]initWithArray:[TaoCanModel mj_objectArrayWithKeyValuesArray:dataList]];
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
        NSMutableArray *tempArr = [[NSMutableArray alloc]initWithArray:[PinKeModel mj_objectArrayWithKeyValuesArray:dataList]];
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
        NSMutableArray *tempArr = [[NSMutableArray alloc]initWithArray:[CheHeModel mj_objectArrayWithKeyValuesArray:dataList]];
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
        NSMutableArray *tempArr = [[NSMutableArray alloc]initWithArray:[KuCunModel mj_objectArrayWithKeyValuesArray:dataList]];
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
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        if ([code isEqualToString:@"1"]) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                
                result(YES);
            });
            [app stopLoading];
        }else{
            result(NO);
            [MyUtil showMessage:message];
            [app stopLoading];
        }
        
        
    } failure:^(NSError *err) {
        
        result(NO);
        [app stopLoading];
        
    }];
}

#pragma mark -专属经理-单品添加
-(void) addProductWithParams:(NSDictionary*)params complete:(void (^)(BOOL result))result{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:ZS_DANPIN_ADD baseURL:LY_SERVER params:params success:^(id response) {
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
        
        result(NO);
        [app stopLoading];
        
    }];
}
#pragma mark专属经理 单品下架
-(void) delProductWithParams:(NSDictionary*)params complete:(void (^)(BOOL result))result{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:ZS_DANPIN_DEL baseURL:LY_SERVER params:params success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        if ([code isEqualToString:@"1"]) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                result(YES);
            });
            [app stopLoading];
        }else{
            result(NO);
            [MyUtil showMessage:message];
            [app stopLoading];
        }
        
        
    } failure:^(NSError *err) {
        
        result(NO);
        [app stopLoading];
        
    }];
}
#pragma mark专属经理 套餐下架
-(void) delTaoCanWithParams:(NSDictionary*)params complete:(void (^)(BOOL result))result{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:ZS_TAOCAN_DEL baseURL:LY_SERVER params:params success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        if ([code isEqualToString:@"1"]) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                result(YES);
            });
            [app stopLoading];
        }else{
            result(NO);
            [MyUtil showMessage:message];
            [app stopLoading];
        }
        
        
    } failure:^(NSError *err) {
        
        result(NO);
        [app stopLoading];
        
    }];
}
#pragma mark专属经理 库存下架
-(void) delItemProductWithParams:(NSDictionary*)params complete:(void (^)(BOOL result))result{
    
}
#pragma mark专属经理 拼客下架
-(void) delPinKeWithParams:(NSDictionary*)params complete:(void (^)(BOOL result))result{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:ZS_PINKE_DEL baseURL:LY_SERVER params:params success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        NSString *message=[NSString stringWithFormat:@"%@",response[@"message"]];
        if ([code isEqualToString:@"1"]) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                result(YES);
            });
            [app stopLoading];
        }else{
            result(NO);
            [MyUtil showMessage:message];
            [app stopLoading];
        }
        
        
    } failure:^(NSError *err) {
        
        result(NO);
        [app stopLoading];
        
    }];
}
#pragma mark专属经理-套餐添加
-(void) addTaoCanWithParams:(NSDictionary*)params complete:(void (^)(BOOL result))result{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:ZS_TAOCAN_ADD baseURL:LY_SERVER params:params success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"errorcode"]];
        
        if ([code isEqualToString:@"1"]) {
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
#pragma mark -获取酒水分类列表
-(void) getProductCategoryListWithParams:(NSDictionary*)params
                                   block:(void(^)(NSMutableArray* result)) block{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:ZS_JIUSHUI_FENLEI_LIST baseURL:LY_SERVER params:params success:^(id response) {
        NSArray *dataList = response[@"data"];
        NSMutableArray *tempArr = [[NSMutableArray alloc]initWithArray:[ProductCategoryModel mj_objectArrayWithKeyValuesArray:dataList]];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            block(tempArr);
        });
        [app stopLoading];
    } failure:^(NSError *err) {
        [app stopLoading];
    }];

}
#pragma mark -获取酒水品牌列表
-(void) getBrandListWithParams:(NSDictionary*)params
                         block:(void(^)(NSMutableArray* result)) block{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    [HTTPController requestWihtMethod:RequestMethodTypePost url:ZS_JIUSHUI_BRAND_LIST baseURL:LY_SERVER params:params success:^(id response) {
        NSArray *dataList = response[@"data"];
        NSMutableArray *tempArr = [[NSMutableArray alloc]initWithArray:[ProductCategoryModel mj_objectArrayWithKeyValuesArray:dataList]];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            block(tempArr);
        });
        [app stopLoading];
    } failure:^(NSError *err) {
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
        NSMutableArray *tempArr = [[NSMutableArray alloc]initWithArray:[DeckFullModel mj_objectArrayWithKeyValuesArray:dataList]];
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
        NSMutableArray *tempArr = [[NSMutableArray alloc]initWithArray:[CustomerModel mj_objectArrayWithKeyValuesArray:dataList]];
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
        
            if ([code isEqualToString:@"1"]) {
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
        
            if ([code isEqualToString:@"1"]) {
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
