//
//  FriendsUserMessageModel.m
//  lieyu
//
//  Created by 狼族 on 15/12/26.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "FriendsUserMessageModel.h"
#import "FriendsRecentModel.h"
#import "MJExtension.h"

@implementation FriendsUserMessageModel
+ (void)load{
    [FriendsUserMessageModel mj_setupObjectClassInArray:^NSDictionary *{
        return @{@"moments":@"FriendsRecentModel"
                 };
    }];
}

+(FriendsUserMessageModel *)initFormDictionary:(NSDictionary *)dic
{
    FriendsUserMessageModel * model = [FriendsUserMessageModel mj_objectWithKeyValues:dic];
    return model;
}

@end
