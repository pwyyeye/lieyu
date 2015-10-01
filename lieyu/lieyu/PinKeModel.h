//
//  PinKeModel.h
//  lieyu
//
//  Created by 薛斯岐 on 15/9/20.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
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
@property(nonatomic,assign)int buynum;
@property(nonatomic,assign)int maxnum;
@property(nonatomic,assign)int minnum;
@property(nonatomic,copy)NSString * title;
@property(nonatomic,copy)NSString * linkicon;
@property(nonatomic,copy)NSString * subtitle;
@property(nonatomic,assign)double  price;
@property(nonatomic,assign)double  money;
@property(nonatomic,assign)double  rebate;
@property(nonatomic,copy)NSString * smdate;
@property(nonatomic,assign)int smid;
@end
