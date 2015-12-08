//
//  MReqToPlayHomeList.h
//  lieyu
//
//  Created by newfly on 10/5/15.
//  Copyright (c) 2015 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYBaseQuery.h"

@interface MReqToPlayHomeList : LYBaseQuery

@property(nonatomic,strong)NSDecimalNumber *longitude;
@property(nonatomic,strong)NSDecimalNumber *latitude;
@property(nonatomic,strong)NSString *city;
@property(nonatomic,strong)NSString *bartype;
@property(nonatomic,strong)NSString *subtype;
@property(nonatomic,strong)NSString *barname;
@property (nonatomic,copy) NSString *subids;

@property (nonatomic,copy)NSString *addressStr;
@property (nonatomic,copy)NSString *pricedescStr;// 人均最高
@property (nonatomic,copy)NSString *priceascStr;//人均最低
@property (nonatomic,copy)NSString *rebatedescStr;

@end
