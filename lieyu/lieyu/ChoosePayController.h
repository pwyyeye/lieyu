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
@interface ChoosePayController : LYBaseTableViewController<SingletonAlipayProtocol>

@property(strong,nonatomic) NSString *orderNo;

@property(strong,nonatomic) NSString *productName;

@property(strong,nonatomic) NSString *productDescription;

@property(assign,nonatomic) double payAmount;

@property(strong,nonatomic) NSArray *data;

@property(assign,nonatomic) NSInteger isPinker;

@property(strong,nonatomic) NSDate *createDate;

@property(assign,nonatomic) BOOL isFaqi;

@property (assign, nonatomic) BOOL isBalanceEnough;

@property (nonatomic, assign) BOOL isRechargeCoin;

@end
