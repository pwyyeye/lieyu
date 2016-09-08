//
//  ZSBalance.h
//  lieyu
//
//  Created by 狼族 on 16/3/30.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZSBalance : NSObject
@property (nonatomic,copy) NSString *accountName;
@property (nonatomic,copy) NSString *accountNo;
@property (nonatomic,copy) NSString *accountType;
@property (nonatomic,copy) NSString *activeAmount;
@property (nonatomic,copy) NSString *balances;
@property (nonatomic,copy) NSString *check_date;
@property (nonatomic, strong) NSString *coin;
@property (nonatomic,copy) NSString *id;
@property (nonatomic,copy) NSString *userid;
@property (nonatomic,copy) NSString *withdrawalsSum;
@end
