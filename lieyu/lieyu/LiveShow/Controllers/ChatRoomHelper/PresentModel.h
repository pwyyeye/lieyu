//
//  PresentModel.h
//  PresentDemo
//
//  Created by 狼族 on 16/10/10.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PresentModelAble.h"

@interface PresentModel : NSObject<PresentModelAble>

@property (copy, nonatomic) NSString *sender;
@property (copy, nonatomic) NSString *giftName;
@property (copy, nonatomic) NSString *icon;
@property (copy, nonatomic) NSString *giftImageName;

+ (instancetype)modelWithSender:(NSString *)sender
                       giftName:(NSString *)giftName
                           icon:(NSString *)icon
                  giftImageName:(NSString *)giftImageName;

@end
