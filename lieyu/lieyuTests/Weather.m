//
//  Weather.m
//  lieyu
//
//  Created by newfly on 9/13/15.
//  Copyright (c) 2015 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "Weather.h"

@implementation Weather

+ (RKObjectMapping *)mapping
{
    return RestKitMapWithDic([Weather class],
                             @{@"city":@"city",
                              @"cityid":@"cityid",
                              @"WD":@"WD"}
                             );
}

@end
