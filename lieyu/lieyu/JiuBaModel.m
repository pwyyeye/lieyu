//
//  JiuBaModel.m
//  lieyu
//
//  Created by 薛斯岐 on 15/9/25.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "JiuBaModel.h"

@implementation JiuBaModel
+ (NSDictionary *)objectClassInArray
{
    return @{
             @"recommend_package" : @"RecommendPackageModel",
             };
}

//自定义排序方法
-(NSComparisonResult)compareJiuBaModel:(JiuBaModel *)model{
    //默认按年龄排序
    NSComparisonResult result = [self.distance compare:model.distance];//注意:基本数据类型要进行数据转换
    //如果年龄一样，就按照名字排序
    if (result == NSOrderedSame) {
        result = [self.barname compare:model.barname];
    }
    return result;
}

//自定义排序最高方法
- (NSComparisonResult)compareJiuBaModelGao:(JiuBaModel *)modelGao{
    //默认按年龄排序
    NSComparisonResult result = [modelGao.lowest_consumption compare:self.lowest_consumption];//注意:基本数据类型要进行数据转换
    //如果年龄一样，就按照名字排序
    if (result == NSOrderedSame) {
        result = [self.barname compare:modelGao.barname];
    }
    return result;
}

//自定义排序方法
-(NSComparisonResult)compareJiuBaModelDi:(JiuBaModel *)modelDi{
    //默认按年龄排序
    NSComparisonResult result = [self.lowest_consumption compare:modelDi.lowest_consumption];//注意:基本数据类型要进行数据转换
    //如果年龄一样，就按照名字排序
    if (result == NSOrderedSame) {
        result = [self.barname compare:modelDi.barname];
    }
    return result;
}


@end
