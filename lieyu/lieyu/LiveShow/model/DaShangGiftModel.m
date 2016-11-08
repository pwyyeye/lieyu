//
//  DaShangGiftModel.m
//  lieyu
//
//  Created by 狼族 on 16/10/25.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "DaShangGiftModel.h"

@implementation DaShangGiftModel

-(instancetype)modelWithrewardName:(NSString *)rewardName rewardImg:(NSString *)rewardImg rewardValue:(NSInteger)rewardValue rewardType:(NSString *)rewardType
{
    DaShangGiftModel *model = [DaShangGiftModel new];
    model.rewardName = rewardName;
    model.rewardImg = rewardImg;
    model.rewardValue = rewardValue;
    model.rewordType = rewardType;
    return model;
}


@end
