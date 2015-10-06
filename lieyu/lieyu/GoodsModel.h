//
//  GoodsModel.h
//  lieyu
//
//  Created by 薛斯岐 on 15/10/6.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductVOModel.h"
@interface GoodsModel : NSObject
@property(nonatomic,assign)int id;
@property(nonatomic,copy)NSString * createDate;
@property(nonatomic,copy)NSString * fullName;
@property(nonatomic,copy)NSString * inmember;
@property(nonatomic,copy)NSString * inmemberName;
@property(nonatomic,copy)NSString * inmenberAvatar_img;
@property(nonatomic,copy)NSString * modifyDate;
@property(nonatomic,copy)NSString * price;
@property(nonatomic,retain)ProductVOModel * productVO;
@property(nonatomic,copy)NSString * quantity;
@property(nonatomic,copy)NSString * returnQuantity;
@property(nonatomic,copy)NSString * shippedQuantity;
@property(nonatomic,copy)NSString * sn;
@property(nonatomic,copy)NSString * thumbnail;
@property(nonatomic,copy)NSString * weight;
//"createDate": "2015-10-06",
//"fullName": "绝对伏特加",
//"id": 18,
//"inmember": 0,
//"inmemberName": "",
//"inmenberAvatar_img": "",
//"modifyDate": "2015-10-06",
//"price": 980,
//@end
