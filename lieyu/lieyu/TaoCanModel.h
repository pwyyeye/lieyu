//
//  TaoCanModel.h
//  lieyu
//
//  Created by 薛斯岐 on 15/9/20.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JiuBaModel.h"
@interface TaoCanModel : NSObject

@property(nonatomic,retain)JiuBaModel * barinfo;
@property(nonatomic,assign)int id;
@property(nonatomic,assign)int buynum;
@property(nonatomic,assign)int maxnum;
@property(nonatomic,assign)int minnum;
@property(nonatomic,copy)NSString * title;
@property(nonatomic,copy)NSString * linkicon;
@property(nonatomic,copy)NSString * linkUrl;
@property(nonatomic,copy)NSString * subtitle;
@property(nonatomic,assign)double  price;
@property(nonatomic,assign)double  money;
@property(nonatomic,assign)double  rebate;
@property(nonatomic,copy)NSString * smdate;
@property(nonatomic,copy)NSString * serviceType;
@property(nonatomic,copy)NSString * smtime;
@property(nonatomic,copy)NSString * ispinker;
@property(nonatomic,copy)NSString *marketprice;
@property(nonatomic,copy)NSString *introduction;
@property(nonatomic,assign)int smid;
@property(nonatomic,retain)NSArray * goodsList;
@property(nonatomic,retain)NSArray * managerList;
@property(nonatomic,retain)NSArray * banner;
@end
