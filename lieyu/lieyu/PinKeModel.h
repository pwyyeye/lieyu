//
//  PinKeModel.h
//  lieyu
//
//  Created by 薛斯岐 on 15/9/20.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JiuBaModel.h"
//"buynum": 0,
//"id": 0,
//"linkicon": "www.245.com",
//"maxnum": 10,
//"minnum": 3,
//"price": 2000,
//"rebate": 0.3,
//"smdate": "",
//"smid": 3,
//"subtitle": "",
//"title": "普通套餐"
@interface PinKeModel : NSObject
@property(nonatomic,assign)int id;
@property(nonatomic,copy)NSString * buynum;
@property(nonatomic,retain)JiuBaModel * barinfo;
@property(nonatomic,retain)NSArray * banner;
@property(nonatomic,retain)NSArray * goodsList;
@property(nonatomic,retain)NSArray * managerList;
@property(nonatomic,copy)NSString * introduction;
@property(nonatomic,copy)NSString * ispinker;
@property(nonatomic,copy)NSString * linkUrl;
@property(nonatomic,copy)NSString * marketprice;
@property(nonatomic,copy)NSString * maxnum;
@property(nonatomic,copy)NSString * minnum;
@property(nonatomic,copy)NSString * num;
@property(nonatomic,copy)NSString * title;
@property(nonatomic,copy)NSString * linkicon;
@property(nonatomic,copy)NSString * orders;
@property(nonatomic,copy)NSString * subtitle;
@property(nonatomic,copy)NSString *  price;
@property(nonatomic,copy)NSString *  money;
@property(nonatomic,copy)NSString *  rebate;
@property(nonatomic,copy)NSString * serviceType;
@property(nonatomic,copy)NSString * smtime;
@property(nonatomic,copy)NSString * smdate;
@property(nonatomic,assign)int smid;
@end
