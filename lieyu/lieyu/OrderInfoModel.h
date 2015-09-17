//
//  OrderInfoModel.h
//  lieyu
//
//  Created by SEM on 15/9/17.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderInfoModel : NSObject
@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSString * img;
@property(nonatomic,copy)NSString * orderType;
@property(nonatomic,copy)NSString * orderStu;
@property(nonatomic,copy)NSString * money;
@property(nonatomic,copy)NSString * paytime;
@property(nonatomic,retain)NSArray * detailModel;
@end
