//
//  DaShangGiftModel.h
//  lieyu
//
//  Created by 狼族 on 16/10/25.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DaShangGiftModel : NSObject

@property (nonatomic, assign) NSInteger rewardId;
@property (nonatomic, copy) NSString *rewardName;
@property (nonatomic, copy) NSString *rewardImg;
@property (nonatomic ,assign) NSInteger rewardValue;
@property (nonatomic, assign) NSString *sorting;
@property (nonatomic, copy) NSString *rewordType;

-(instancetype)modelWithrewardName:(NSString *)rewardName
                         rewardImg:(NSString *)rewardImg
                       rewardValue:(NSInteger)rewardValue
                        rewardType:(NSString *)rewardType;

@end
