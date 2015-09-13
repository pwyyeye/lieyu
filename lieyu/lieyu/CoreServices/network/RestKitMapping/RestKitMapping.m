//
//  RestKitMapping.m
//  LYAppApp
//
//  Created by apple on 15/4/2.
//  Copyright (c) 2015年 zktechnology. All rights reserved.
//

#import "RestKitMapping.h"
#import "RKObjectMapping.h"

inline RKObjectMapping * RestKitMapWithDic(Class ca,NSDictionary *dic)
{
    RKObjectMapping *statusMapping = [RKObjectMapping mappingForClass:ca];
    [statusMapping addAttributeMappingsFromDictionary:dic];
    return statusMapping;
}



