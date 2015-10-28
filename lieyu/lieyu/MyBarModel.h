//
//  MyBarModel.h
//  lieyu
//
//  Created by 薛斯岐 on 15/10/28.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JiuBaModel.h"
@interface MyBarModel : NSObject
/*
 {
 "barid": 3,
 "baridall": "",
 "barinfo": {
 "address": "上海浦江",
 "announcement": null,
 "banners": [],
 "baricon": "http://source.lie98.com/%E9%A9%AC%E7%88%B9%E5%88%A9XO.jpg?imageView2/0/w/80/h/80",
 "barid": 3,
 "barlevelid": 2,
 "barlevelname": "",
 "barname": "欣欣酒吧3",
 "bartype": 1,
 "bartypename": "中档",
 "distance": "",
 "environment_num": "",
 "fav_num": 2,
 "id": 3,
 "latitude": "22",
 "longitude": "22",
 "lowest_consumption": 5,
 "recommend_package": [],
 "star_num": "",
 "subtitle": "1",
 "subtype": 2,
 "subtypename": "闹吧",
 "tese": [],
 "today_sm_buynum": ""
 },
 "barname": "欣欣酒吧3",
 "id": 2,
 "userid": 130637,
 "username": "18695722800"
 }
 */
@property(nonatomic,assign)int id;
@property(nonatomic,assign)int barid;
@property(nonatomic,assign)int userid;
@property(nonatomic,retain)JiuBaModel *barinfo;
@property(nonatomic,copy)NSString * baridall;
@property(nonatomic,copy)NSString * barname;
@property(nonatomic,copy)NSString * username;
@end
