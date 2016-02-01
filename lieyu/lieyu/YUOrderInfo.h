//
//  YUOrderInfo.h
//  lieyu
//
//  Created by 狼族 on 16/1/31.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JiuBaModel;
@class YUPinkerListModel;
@class YUPinkerinfo;

@interface YUOrderInfo : NSObject
@property (nonatomic,strong) NSNumber *allnum;
@property (nonatomic,strong) NSNumber *amountPay;
@property (nonatomic,copy) NSString *avatar_img;
@property (nonatomic,strong) NSNumber *barid;
@property (nonatomic,strong)JiuBaModel *barinfo;
@property (nonatomic,copy) NSString *beforeOrAfter;
@property (nonatomic,copy) NSString *begindate;
@property (nonatomic,copy) NSString *checkUserAge;
@property (nonatomic,copy) NSString *checkUserAvatar_img;
@property (nonatomic,copy) NSString *checkUserImUserid;
@property (nonatomic,copy) NSString *checkUserMobile;
@property (nonatomic,copy) NSString *checkUserName;
@property (nonatomic,copy) NSString *checkuserid;
@property (nonatomic,copy) NSString *consumptionCode;
@property (nonatomic,copy) NSString *consumptionCodeId;
@property (nonatomic,copy) NSString *consumptionStatus;
@property (nonatomic,copy) NSString *createDate;
@property (nonatomic,copy) NSString *endate;
@property (nonatomic,copy) NSString *expire;
@property (nonatomic,copy) NSString *fullicon;
@property (nonatomic,copy) NSString *fullname;
@property (nonatomic,strong) NSArray *goodslist;
@property (nonatomic,copy) NSString *id;
@property (nonatomic,copy) NSString *imuserid;
@property (nonatomic,copy) NSString *isClear;
@property (nonatomic,copy) NSString *isRebate;
@property (nonatomic,copy) NSString *isbreak;
@property (nonatomic,copy) NSString *ispayback;
@property (nonatomic,copy) NSString *lockExpire;
@property (nonatomic,copy) NSString *memo;
@property (nonatomic,copy) NSString *modifyDate;
@property (nonatomic,copy) NSString *offsetAmount;
@property (nonatomic,copy) NSString *orderStatus;
@property (nonatomic,copy) NSString *orderStatusName;
@property (nonatomic,copy) NSString *orderTypeName;
@property (nonatomic,copy) NSString *ordertype;
@property (nonatomic,copy) NSString *paymentMethodName;
@property (nonatomic,copy) NSString *paymentStatus;
@property (nonatomic,copy) NSString *paytype;
@property (nonatomic,copy) NSString *penalty;
@property (nonatomic,copy) NSString *phone;
@property (nonatomic,strong) NSArray *pinkerList;//YUPinkerListModel
@property (nonatomic,copy) NSString *pinkerNeedPayAmount;
@property (nonatomic,copy) NSString *pinkerNum;
@property (nonatomic,copy) NSString *pinkerType;
@property (nonatomic,strong) YUPinkerinfo *pinkerinfo;
@property (nonatomic,copy) NSString *reachtime;
@property (nonatomic,copy) NSString *rebateAmout;
@property (nonatomic,copy) NSString *setMealInfo;
@property (nonatomic,copy) NSString *sn;
@property (nonatomic,strong) NSArray *tags;
@property (nonatomic,copy) NSString *tax;
@property (nonatomic,copy) NSString *userid;
@property (nonatomic,copy) NSString *username;

@end
