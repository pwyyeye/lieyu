//
//  BarActivityList.m
//  lieyu
//
//  Created by 狼族 on 16/2/18.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "BarActivityList.h"
#import "BeerBarOrYzhDetailModel.h"
#import "BarTopicInfo.h"

@implementation BarActivityList

+ (NSDictionary *)objectClassInArray
{
    return @{
             @"barInfo" : @"BeerBarOrYzhDetailModel",@"topicInfo":@"BarTopicInfo",
             };
}


@end
