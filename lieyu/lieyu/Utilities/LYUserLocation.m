//
//  LYUserLocation.m
//  lieyu
//
//  Created by newfly on 10/5/15.
//  Copyright (c) 2015 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYUserLocation.h"

@implementation LYUserLocation

+(LYUserLocation *)instance
{
    static LYUserLocation * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LYUserLocation alloc] init];
    });
    return instance;
}


@end
