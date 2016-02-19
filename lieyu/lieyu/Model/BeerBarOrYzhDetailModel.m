//
//  BeerBarOrYzhDetailModel.m
//  lieyu
//
//  Created by newfly on 10/5/15.
//  Copyright (c) 2015 狼族（上海）网络科技有限公司. All rights reserved.
//
#import "MJExtension.h"
#import "BeerBarOrYzhDetailModel.h"
#import "RecommendPackageModel.h"
#import "CustomerModel.h"

@implementation BeerBarOrYzhDetailModel

+(void)load
{
    [BeerBarOrYzhDetailModel mj_setupObjectClassInArray:^NSDictionary *{
        return @{
                    @"recommend_package":@"RecommendPackageModel",@"signUsers":@"CustomerModel"
                };
    }];
}

+(BeerBarOrYzhDetailModel *)initFormDictionary:(NSDictionary *)dic
{
    BeerBarOrYzhDetailModel * model = [BeerBarOrYzhDetailModel mj_objectWithKeyValues:dic];
    return model;
}

@end
