
//
//  ActivityModel.m
//  lieyu
//
//  Created by 王婷婷 on 16/9/3.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "ActivityModel.h"
#import "BarActivityList.h"

@implementation ActivityModel

+ (NSDictionary *)objectClassInArray
{
    return @{
             @"barActivity" : @"BarActivityList",
             };
}

@end
