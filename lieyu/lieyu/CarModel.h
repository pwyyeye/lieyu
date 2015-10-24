//
//  CarModel.h
//  lieyu
//
//  Created by 薛斯岐 on 15/10/23.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductVOModel.h"
@interface CarModel : NSObject
@property(nonatomic,assign)int checkuserid;
@property(nonatomic,assign)int product_id;
@property(nonatomic,retain)ProductVOModel * product;
@property(nonatomic,copy)NSString * create_date;
@property(nonatomic,assign)int id;
@property(nonatomic,retain)NSArray * ids;
@property(nonatomic,copy)NSString * modify_date;
@property(nonatomic,copy)NSString * price;
@property(nonatomic,copy)NSString * quantity;
@property(nonatomic,assign)int userid;
@property(nonatomic,assign)BOOL isSel;
@end
