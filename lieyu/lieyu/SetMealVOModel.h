//
//  SetMealVOModel.h
//  lieyu
//
//  Created by 薛斯岐 on 15/10/6.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SetMealVOModel : NSObject
@property(nonatomic,copy)NSString * auditDate;
@property(nonatomic,assign)int auditStatus;
@property(nonatomic,copy)NSString * auditStatusName;
@property(nonatomic,assign)int barid;
@property(nonatomic,copy)NSString * barname;
@property(nonatomic,copy)NSString * begindate;
@property(nonatomic,assign)double buynum;
@property(nonatomic,assign)int checkuserid;
@property(nonatomic,copy)NSString * createDate;
@property(nonatomic,copy)NSString * enddate;
@property(nonatomic,assign)int id;
@property(nonatomic,retain)NSArray * images;
@property(nonatomic,copy)NSString * introduction;
@property(nonatomic,assign)int ispinker;
@property(nonatomic,copy)NSString * ispinkerName;
@property(nonatomic,copy)NSString * linkUrl;
@property(nonatomic,copy)NSString *maxnum;
@property(nonatomic,copy)NSString *minnum;
@property(nonatomic,copy)NSString * modifyDate;
@property(nonatomic,copy)NSString * offshelfDate;
@property(nonatomic,assign)int orders;
@property(nonatomic,copy)NSString * price;
@property(nonatomic,copy)NSString * marketprice;
@property(nonatomic,copy)NSString * rebate;
@property(nonatomic,copy)NSString * recommended;
@property(nonatomic,copy)NSString * referprice;
@property(nonatomic,copy)NSString * requstvip;
@property(nonatomic,copy)NSString * servicetype;
@property(nonatomic,copy)NSString * smdate;
@property(nonatomic,copy)NSString * smname;
@property(nonatomic,copy)NSString * upflag;
@property(nonatomic,copy)NSString * upflagName;
@property(nonatomic,copy)NSString * userid;
@property(nonatomic,copy)NSString * username;
/*
 "auditDate": "",
 "auditStatus": 1,
 "auditStatusName": "未审核",
 "barid": 17,
 "barname": "玛雅酒吧",
 "begindate": "2015-09-20",
 "buynum": 0,
 "checkuserid": 0,
 "createDate": "2015-10-02",
 "enddate": "2015-10-22",
 "id": 23,
 "images": [],
 "introduction": "帅气",
 "ispinker": 0,
 "ispinkerName": "普通套餐",
 "linkUrl": "http://7xn0lq.com2.z0.glb.qiniucdn.com/www.245.com",
 "lyUsersByAuditUseridvo": null,
 "lyUsersByoffshelfUseridvo": null,
 "maxnum": 10,
 "minnum": 3,
 "modifyDate": "2015-10-03",
 "offshelfDate": "",
 "orders": 0,
 "price": 2000,
 "rebate": 0.3,
 "recommended": 0,
 "referprice": 0,
 "requstvip": "",
 "servicetype": "1",
 "smdate": "2015-09-20",
 "smname": "普通套餐3",
 "upflag": 1,
 "upflagName": "上架",
 "userid": 1,
 "username": "pwy"
 */
@end
