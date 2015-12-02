//
//  OrderTTL.h
//  lieyu
//
//  Created by pwy on 15/12/2.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderTTL : NSObject

@property(nonatomic,assign) NSInteger waitConsumption;
@property(nonatomic,assign) NSInteger waitEvaluation;
@property(nonatomic,assign) NSInteger waitPay;
@property(nonatomic,assign) NSInteger waitPayBack;
@property(nonatomic,assign) NSInteger waitRebate;
@property(nonatomic,assign) NSInteger messageNum;
@end
