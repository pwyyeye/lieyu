//
//  HomePageModel.m
//  lieyu
//
//  Created by 狼族 on 16/1/27.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "HomePageModel.h"
#import "JiuBaModel.h"
#import "bartypeslistModel.h"
#import "RecommendedTopic.h"

@implementation HomePageModel
+ (NSDictionary *)objectClassInArray
{
    return @{
             @"barlist" : @"JiuBaModel",@"bartypeslist":@"bartypeslistModel"
             };
}
@end
