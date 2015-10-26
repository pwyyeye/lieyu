//
//  ChoosePayController.h
//  haitao
//
//  Created by pwy on 15/8/9.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayCell.h"
#import "SingletonAlipay.h"
#import "AlipayOrder.h"
@interface ChoosePayController : UITableViewController<SingletonAlipayProtocol>

@property(strong,nonatomic) NSString *orderNo;

@property(strong,nonatomic) NSString *productName;

@property(strong,nonatomic) NSString *productDescription;

@property(assign,nonatomic) double payAmount;

@end
