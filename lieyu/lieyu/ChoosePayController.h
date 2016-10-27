//
//  ChoosePayController.h
//  haitao
//
//  Created by pwy on 15/8/9.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayCell.h"
#import "SingletonAlipay.h"
#import "AlipayOrder.h"
#import "LYBaseTableViewController.h"

@protocol RechargeDelegate <NSObject>

- (void)rechargeDelegateRefreshData;

@end

@interface ChoosePayController : LYBaseTableViewController<SingletonAlipayProtocol>

@property(strong,nonatomic) NSString *orderNo;

@property(strong,nonatomic) NSString *productName;

@property(strong,nonatomic) NSString *productDescription;

@property(assign,nonatomic) double payAmount;

@property(strong,nonatomic) NSArray *data;

@property(assign,nonatomic) NSInteger isPinker;

@property(strong,nonatomic) NSDate *createDate;

@property(assign,nonatomic) BOOL isFaqi;

@property (assign, nonatomic) BOOL isRechargeBalance;//为了充值余额
@property (assign, nonatomic) BOOL isRechargeCoin;//为了充值娱币

@property (nonatomic, assign) id<RechargeDelegate> delegate;

@end
