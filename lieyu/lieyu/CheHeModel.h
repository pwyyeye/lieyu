//
//  CheHeModel.h
//  lieyu
//
//  Created by 薛斯岐 on 15/9/20.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheHeModel : NSObject

//"brand": "人头马",
//"brandid": 1,
//"category": "红酒",
//"categoryid": 1,
//"createdate": "2015-09-21",
//"favnum": 0,
//"id": 5,
//"img_260": "",
//"img_450": "abc.jpg",
//"img_80": "",
//"ishot": 0,
//"modifydate": "",
//"name": "黑啤1",
//"ordernum": 0,
//"price": 50,
//"rebate": 0.20000000298023224,
//"upflag": 1

@property(nonatomic,assign)int  id;
@property(nonatomic,assign)int brandid;
@property(nonatomic,assign)int categoryid;
@property(nonatomic,assign)int favnum;
@property(nonatomic,assign)int ishot;
@property(nonatomic,assign)int upflag;
@property(nonatomic,assign)int ordernum;
@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSString * brand;
@property(nonatomic,copy)NSString * category;
@property(nonatomic,copy)NSString * createdate;
@property(nonatomic,copy)NSString * img_260;
@property(nonatomic,copy)NSString * img_450;
@property(nonatomic,copy)NSString * img_80;
@property(nonatomic,assign)double  price;
@property(nonatomic,assign)double  money;
@property(nonatomic,assign)double  rebate;
@property(nonatomic,copy)NSString * modifydate;
@property(nonatomic,assign)int smid;
@end
