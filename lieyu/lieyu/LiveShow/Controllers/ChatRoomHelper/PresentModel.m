//
//  PresentModel.m
//  PresentDemo
//
//  Created by 狼族 on 16/10/10.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "PresentModel.h"

@implementation PresentModel

+ (instancetype)modelWithSender:(NSString *)sender giftName:(NSString *)giftName icon:(NSString *)icon giftImageName:(NSString *)giftImageName
{
    PresentModel *model = [[PresentModel alloc] init];
    model.sender        = sender;
    model.giftName      = giftName;
    model.icon          = icon;
    model.giftImageName = giftImageName;
    return model;
}

@end
