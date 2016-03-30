//
//  ZSTiXianRecord.h
//  lieyu
//
//  Created by 狼族 on 16/3/29.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZSTiXianRecord : NSObject
@property (nonatomic,copy) NSString *amount;
@property (nonatomic,copy) NSString *create_date;
@property (nonatomic,copy) NSString *id;
@property (nonatomic,copy) NSString *isToday;
@property (nonatomic,copy) NSString *poundage;
@property (nonatomic,copy) NSString *userid;
@property (nonatomic,copy) NSString *wtype;//1 支付宝 2银联 3wechat
@property (nonatomic,copy) NSString *checkMark;

@property (nonatomic,copy) NSString *month;
@property (nonatomic,copy) NSString *amountSum;
@property (nonatomic,copy) NSString *receivedAmountSum;
@end
