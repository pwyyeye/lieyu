//
//  SingletonRegiste.m
//  lieyu
//
//  Created by 狼族 on 15/12/8.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "SingletonRegiste.h"

@implementation SingletonRegiste
static SingletonRegiste *_registe;

+ (instancetype)shareRegist{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _registe = [[SingletonRegiste alloc]init];
    });
    return _registe;
}


@end
