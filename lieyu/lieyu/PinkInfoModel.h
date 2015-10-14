//
//  PinkInfoModel.h
//  lieyu
//
//  Created by 薛斯岐 on 15/10/6.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductVOModel.h"
#import "SetMealVOModel.h"
@interface PinkInfoModel : NSObject
@property(nonatomic,copy)NSString * createDate;
@property(nonatomic,copy)NSString * fullName;
@property(nonatomic,assign)int id;
@property(nonatomic,assign)int inmember;
@property(nonatomic,copy)NSString * inmemberName;
@property(nonatomic,copy)NSString * inmenberAvatar_img;
@property(nonatomic,copy)NSString * inmenberImUserid;
@property(nonatomic,copy)NSString * inmenbermobile;
@property(nonatomic,copy)NSString * modifyDate;
@property(nonatomic,assign)int paymentStatus;
@property(nonatomic,copy)NSString * price;
@property(nonatomic,retain)ProductVOModel * productVO;
@property(nonatomic,copy)NSString * quantity;
@property(nonatomic,copy)NSString * returnQuantity;
@property(nonatomic,retain)SetMealVOModel * setMealVO;
@property(nonatomic,copy)NSString * shippedQuantity;
@property(nonatomic,copy)NSString * sn;
@property(nonatomic,copy)NSString * thumbnail;
@property(nonatomic,copy)NSString * weight;
/*
"createDate": "2015-10-06 10:53:47",
"fullName": "雪花",
"id": 19,
"inmember": 130637,
"inmemberName": "帅爆了",
"inmenberAvatar_img": "http://source.lie98.com/pwyArtboard1.png?imageView2/0/w/80/h/80",
"modifyDate": "2015-10-06 10:53:47",
"paymentStatus": 0,
"price": 100,
"productVO": null,
"quantity": 1,
"returnQuantity": 0,
"setMealVO": null,
"shippedQuantity": 0,
"sn": "P130610201510061053470",
"thumbnail": "",
"weight": 0
 */
@end
