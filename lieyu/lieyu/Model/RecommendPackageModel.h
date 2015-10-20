//
//  RecommendPackageModel.h
//  lieyu
//
//  Created by newfly on 10/5/15.
//  Copyright (c) 2015 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecommendPackageModel : NSObject

@property(nonatomic,copy)NSString *barinfo;
@property(nonatomic,strong)NSNumber *buynum;
@property(nonatomic,strong)NSArray *goodsList;
@property(nonatomic,strong)NSNumber *id;
@property(nonatomic,copy)NSString *introduction;
@property(nonatomic,strong)NSNumber *ispinker;
@property(nonatomic,copy)NSString *linkUrl;
@property(nonatomic,strong)NSArray *managerList;
@property(nonatomic,strong)NSNumber *maxnum;
@property(nonatomic,strong)NSNumber *minnum;
@property(nonatomic,strong)NSNumber *num;
@property(nonatomic,strong)NSNumber *orders;
@property(nonatomic,strong)NSNumber *price;
@property(nonatomic,strong)NSNumber *rebate;
@property(nonatomic,strong)NSNumber *maketprice;
@property(nonatomic,strong)NSNumber *serviceType;
@property(nonatomic,strong)NSNumber *smid;
@property(nonatomic,strong)NSNumber *smtime;
@property(nonatomic,copy)NSString  *subtitle;
@property(nonatomic,copy)NSString  *title;
@property(nonatomic,copy)NSString  *marketprice;

@end




