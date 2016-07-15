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
@class CustomerModel;

@interface BeerBarOrYzhDetailModel : NSObject
@property(nonatomic,copy)NSString * address;
@property(nonatomic,strong) AnnouncementModel* announcement;
@property(nonatomic,strong) NSArray* banners;

@property(nonatomic, assign) BOOL hasGroup;//群聊
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
@property (nonatomic,copy) NSString *allowDistance;
@property(nonatomic,strong)NSNumber *  fav_num;
@property(nonatomic,strong)NSNumber * id;
@property(nonatomic,copy)NSString * latitude;
@property(nonatomic,copy)NSString * longitude;
@property (nonatomic,unsafe_unretained) NSInteger isSign;//是否签约
@property(nonatomic,copy)NSNumber * lowest_consumption;
@property(nonatomic,strong)NSArray *recommend_package;  //RecommendPackageModel
@property(nonatomic,copy)NSString *star_num;
@property (nonatomic,copy) NSString *like_num;
@property(nonatomic,copy)NSString *subtitle;
@property(nonatomic,strong)NSNumber *subtype;
@property(nonatomic,copy)NSString *subtypename;
@property(nonatomic,copy)NSArray *tese;
@property (nonatomic,unsafe_unretained) CGFloat rebate;
@property(nonatomic,copy)NSString *today_sm_buynum;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;

@property (nonatomic,copy) NSString *addressabb;
@property (nonatomic,copy) NSString *imageid;
@property (nonatomic,copy) NSString *level;
@property (nonatomic,copy) NSString *levelname;
@property (nonatomic,copy) NSString *modifydate;
@property (nonatomic,copy) NSString *need_page;
@property (nonatomic,copy) NSString *online;
@property (nonatomic,copy) NSString *recommended;
@property (nonatomic,copy) NSString *requstall;
@property (nonatomic,copy) NSString *smdate;
@property (nonatomic,copy) NSString *smid;
@property (nonatomic,copy) NSString *sort;
@property (nonatomic,copy) NSString *subids;
@property (nonatomic,copy) NSString *telephone;

@property (nonatomic,copy) NSString *signCount;
@property (nonatomic,strong) NSMutableArray *signUsers;

@property (nonatomic,copy) NSString *topicTypeMommentNum;
@property (nonatomic,copy) NSString *topicTypeId;
@property (nonatomic,copy) NSString *topicTypeName;

+(BeerBarOrYzhDetailModel *)initFormDictionary:(NSDictionary *)dic;

@end







