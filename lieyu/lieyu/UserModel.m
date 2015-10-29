//
//  UserModel.m
//  lieyu
//
//  Created by 薛斯岐 on 15/10/3.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel
+ (NSDictionary *)objectClassInArray
{
    return @{
             @"tags" : @"UserTagModel",
             };
}
@end
