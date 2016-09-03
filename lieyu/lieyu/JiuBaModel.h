//
//  JiuBaModel.h
//  lieyu
//
//  Created by 薛斯岐 on 15/9/25.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnnouncementModel.h"
#import "RecommendPackageModel.h"
@interface JiuBaModel : NSObject

@property(nonatomic,assign)int id;
@property (nonatomic, copy) NSString * address;
@property (nonatomic, retain) AnnouncementModel * announcement;
@property (nonatomic, retain) NSArray * banners;
@property (nonatomic, retain) NSArray * tese;
@property (nonatomic, copy) NSString * baricon;
@property (nonatomic, copy) NSString * today_sm_buynum;//预订量
@property(nonatomic,assign)int barid;
@property(nonatomic,assign)int barlevelid;
@property (nonatomic, copy) NSString * barlevelname;
@property (nonatomic, copy) NSString * bartypename;
@property (nonatomic, copy) NSString * distance;
@property (nonatomic, copy) NSString * environment_num;
@property(nonatomic,assign)int fav_num;
@property(nonatomic,assign) int like_num;
@property (nonatomic, assign) int commentNum;
@property (nonatomic, copy) NSString * barname;
@property (nonatomic, copy) NSString * latitude;
@property (nonatomic, copy) NSString * longitude;
@property(nonatomic,copy)NSString * lowest_consumption;
@property (nonatomic, retain) NSArray * recommend_package;
@property(nonatomic,copy)NSString * star_num;
@property(nonatomic,copy)NSString * subtitle;
@property(nonatomic,copy)NSString * subtypename;
@property NSInteger sectionNumber;
@property (nonatomic,copy) NSString *rebate;
@property (nonatomic,copy) NSString *isSign;
@property (nonatomic,copy) NSString *addressabb;
@property (nonatomic,copy) NSString *recommended;
@property BOOL rowSelected;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSString *vipCity;


@property (nonatomic,copy) NSString *topicTypeId;
@property (nonatomic,copy) NSString *topicTypeName;

@property(nonatomic, assign) BOOL hasGroup;//群聊
@property(nonatomic, strong) NSString *groupManage;//拼接了所有的老司机

@property (nonatomic, assign) int isLiked;


-(NSComparisonResult)compareJiuBaModel:(JiuBaModel *)model;
- (NSComparisonResult)compareJiuBaModelGao:(JiuBaModel *)modelGao;
-(NSComparisonResult)compareJiuBaModelDi:(JiuBaModel *)modelDi;
@end
