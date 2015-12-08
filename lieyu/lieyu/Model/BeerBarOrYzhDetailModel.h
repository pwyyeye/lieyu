//
//  BeerBarOrYzhDetailModel.h
//  lieyu
//
//  Created by newfly on 10/5/15.
//  Copyright (c) 2015 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AnnouncementModel;
@class RecommendPackageModel;

@interface BeerBarOrYzhDetailModel : NSObject
@property(nonatomic,copy)NSString * address;
@property(nonatomic,strong) AnnouncementModel* announcement;
@property(nonatomic,strong) NSArray* banners;

@property(nonatomic,copy)NSString * baricon;
@property(nonatomic,strong)NSNumber * barid;
@property(nonatomic,strong)NSNumber * barlevelid;
@property(nonatomic,copy)NSString * barlevelname;
@property(nonatomic,copy)NSString * barname;
@property(nonatomic,strong)NSNumber * bartype;
@property(nonatomic,copy)NSString * bartypename;
@property (nonatomic,strong) NSString * descriptions;
@property(nonatomic,copy)NSString * distance;
@property(nonatomic,copy)NSString * environment_num;
@property(nonatomic,strong)NSNumber *  fav_num;
@property(nonatomic,strong)NSNumber * id;
@property(nonatomic,copy)NSString * latitude;
@property(nonatomic,copy)NSString * longitude;
@property(nonatomic,copy)NSNumber * lowest_consumption;
@property(nonatomic,strong)NSArray *recommend_package;  //RecommendPackageModel
@property(nonatomic,copy)NSString *star_num;
@property (nonatomic,copy) NSString *like_num;
@property(nonatomic,copy)NSString *subtitle;
@property(nonatomic,strong)NSNumber *subtype;
@property(nonatomic,copy)NSString *subtypename;
@property(nonatomic,copy)NSArray *tese;
@property(nonatomic,copy)NSString *today_sm_buynum;

+(BeerBarOrYzhDetailModel *)initFormDictionary:(NSDictionary *)dic;

@end







