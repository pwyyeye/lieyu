//
//  SetMealInfoModel.h
//  lieyu
//
//  Created by 薛斯岐 on 15/10/6.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SetMealVOModel.h"
#import "ProductVOModel.h"
@interface SetMealInfoModel : NSObject

@property(nonatomic,copy)NSString * createDate;
@property(nonatomic,copy)NSString * fullName;
@property(nonatomic,assign)int id;
@property(nonatomic,assign)int inmember;
@property(nonatomic,copy)NSString * inmemberName;
@property(nonatomic,copy)NSString * inmenberAvatar_img;
@property(nonatomic,copy)NSString * modifyDate;
@property(nonatomic,assign)double price;

@property(nonatomic,retain)ProductVOModel * productVO;
@property(nonatomic,assign)double quantity;
@property(nonatomic,assign)double returnQuantity;
@property(nonatomic,retain)SetMealVOModel * setMealVO;
@property(nonatomic,retain)NSString * sn;
@property(nonatomic,assign)double weight;
@property(nonatomic,assign)double shippedQuantity;
@property(nonatomic,copy)NSString * thumbnail;
/*
"createDate": "2015-10-04",
"fullName": "普通套餐3",
"id": 15,
"inmember": 0,
"inmemberName": "",
"inmenberAvatar_img": "",
"modifyDate": "2015-10-04",
"price": 2000,
"productVO": null,
"quantity": 0,
"returnQuantity": 0,
"setMealVO": {
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
},
"shippedQuantity": 0,
"sn": "",
"thumbnail": "",
"weight": 0
 */
@end
