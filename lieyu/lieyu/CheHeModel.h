//
//  CheHeModel.h
//  lieyu
//
//  Created by 薛斯岐 on 15/9/20.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductVOModel.h"
@interface CheHeModel : NSObject
/*
"allocatestock": 1,
"barid": 17,
"brand": "绝对伏特加",
"category": "伏特加",
"categoryid": 1,
"cost": 100,
"favnum": 0,
"fullname": "绝对伏特加",
"goodsList": [],
"id": 1,
"image": "http://source.lie98.com/%E7%BA%A2%E8%8C%B6.jpg",
"img_260": "http://source.lie98.com/%E7%BA%A2%E8%8C%B6.jpg?imageView2/0/w/260/h/260",
"img_450": "http://source.lie98.com/%E7%BA%A2%E8%8C%B6.jpg?imageView2/0/w/450/h/450",
"img_80": "http://source.lie98.com/%E7%BA%A2%E8%8C%B6.jpg?imageView2/0/w/80/h/80",
"introduction": "介绍",
"ishot": 1,
"ismarketable": 1,
"keyword": "关键词",
"marketprice": 0,
"maxprice": 0,
"memo": "备注",
"minprice": 0,
"name": "名字",
"num": 0,
"price": 0,
"product_item": null,
"rebate": 0,
"sales": 1000,
"scorecount": 1,
"sort": "",
"stock": 100,
"totalscore": 100,
"unit": "件",
"weight": 0.8999999761581421
*/
@property(nonatomic,assign)int  id;
@property(nonatomic,assign)int barid;
@property(nonatomic,assign)int brandid;
@property(nonatomic,assign)int categoryid;
@property(nonatomic,assign)int favnum;
@property(nonatomic,assign)int num;
@property(nonatomic,assign)int ishot;
@property(nonatomic,assign)int scorecount;
@property(nonatomic,assign)int upflag;
@property(nonatomic,assign)int ordernum;
@property(nonatomic,copy)NSString *sales;
@property(nonatomic,copy)NSString *ismarketable;
@property(nonatomic,copy)NSString *keyword;
@property(nonatomic,copy)NSString *marketprice;
@property(nonatomic,copy)NSString *maxprice;
@property(nonatomic,copy)NSString *memo;
@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSString *image;
@property(nonatomic,copy)NSString *barname;
@property(nonatomic,copy)NSString * fullname;
@property(nonatomic,copy)NSString * unit;
@property(nonatomic,copy)NSString *minprice;
@property(nonatomic,copy)NSString * cost;
@property(nonatomic,copy)NSString *allocatestock;
@property(nonatomic,copy)NSString * brand;
@property(nonatomic,copy)NSString * category;
@property(nonatomic,copy)NSString * createdate;
@property(nonatomic,copy)NSString * img_260;
@property(nonatomic,copy)NSString * img_450;
@property(nonatomic,copy)NSString * img_80;
@property(nonatomic,copy)NSString  *price;
@property(nonatomic,assign)double  money;
@property(nonatomic,assign)double  rebate;
@property(nonatomic,copy)NSString * modifydate;
@property(nonatomic,copy)NSString * introduction;
@property(nonatomic,assign)int smid;
@property(nonatomic,copy)NSString *totalscore;
@property(nonatomic,retain) ProductVOModel *product_item;
@end
