//
//  OrderInfoModel.h
//  lieyu
//
//  Created by SEM on 15/9/17.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PinkInfoModel.h"
#import "SetMealInfoModel.h"
@interface OrderInfoModel : NSObject
@property(nonatomic,copy)NSString *allnum;
@property(nonatomic,copy)NSString *amountPay;
@property(nonatomic,copy)NSString * avatar_img;
@property(nonatomic,assign)int barid;
@property(nonatomic,retain)NSArray * barinfo;
@property(nonatomic,assign)int checkuserid;
@property(nonatomic,assign)int ordertype;
@property(nonatomic,copy)NSString * consumptionCode;
@property(nonatomic,assign)int consumptionCodeId;
@property(nonatomic,assign)int consumptionStatus;
@property(nonatomic,copy)NSString * createDate;
@property(nonatomic,copy)NSString * expire;
@property(nonatomic,retain)NSArray * goodslist;
@property(nonatomic,assign)int id;
@property(nonatomic,copy)NSString * imuserid;
@property(nonatomic,assign)int isbreak;
@property(nonatomic,copy)NSString * lockExpire;
@property(nonatomic,copy)NSString * memo;
@property(nonatomic,copy)NSString * modifyDate;
@property(nonatomic,assign)int orderStatus;
@property(nonatomic,copy)NSString * orderTypeName;
@property(nonatomic,assign)int paymentStatus;
@property(nonatomic,copy)NSString * penalty;
@property(nonatomic,copy)NSString * phone;
@property(nonatomic,retain)NSArray * pinkerList;
@property(nonatomic,assign)int pinkerType;
@property(nonatomic,retain)SetMealVOModel * pinkerinfo;
@property(nonatomic,copy)NSString * reachtime;
@property(nonatomic,retain)SetMealInfoModel * setMealInfo;
@property(nonatomic,copy)NSString * sn;
@property(nonatomic,assign)int userid;
@property(nonatomic,copy)NSString * username;
@property(nonatomic,assign)int tax;
@property(nonatomic,copy)NSString *rebateAmout;
/*
{
    "allnum": 1,
    "amountPay": 2000,
    "avatar_img": "",
    "barid": 0,
    "barinfo": {
        "address": "上海市宝山区XXXX",
        "baricon": "http://7xn0lq.com2.z0.glb.qiniucdn.com/ZSKC2015-10-01_11:01:07_ofiX4xUE.jpg?imageView2/0/w/80/h/80",
        "barid": 0,
        "barname": "玛雅酒吧",
        "bartype": 1,
        "bartypename": "酒吧",
        "city": "上海",
        "createdate": "2015-10-03",
        "distance": "",
        "fav_num": 0,
        "id": 17,
        "imageid": 0,
        "latitude": "112.112",
        "level": 2,
        "levelname": "中档",
        "longitude": "111.111",
        "lowest_consumption": 100,
        "lybannerimages": [],
        "modifydate": "2015-10-05",
        "need_page": "",
        "requstall": "",
        "smdate": "",
        "smid": "",
        "subtitle": "玛雅文化",
        "subtype": 2,
        "subtypename": "闹吧"
    },
    "checkuserid": 0,
    "consumptionCode": "",
    "consumptionCodeId": 0,
    "consumptionStatus": 0,
    "createDate": "2015-10-05",
    "expire": "",
    "goodslist": [],
    "id": 18,
    "imuserid": "ISm8H83sCD4=",
    "isbreak": 0,
    "lockExpire": "",
    "memo": "",
    "modifyDate": "2015-10-04",
    "offsetAmount": 0,
    "orderStatus": 0,
    "orderTypeName": "套餐订单",
    "ordertype": 0,
    "paymentStatus": 0,
    "penalty": 0,
    "phone": "18695722800",
    "pinkerList": [],
    "pinkerType": 0,
    "pinkerinfo": null,
    "reachtime": "2015-09-30",
    "setMealInfo": {
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
    },
    "sn": "S130637201510040121400",
    "tax": 0,
    "userid": 130637,
    "username": ""
}
*/

@end
