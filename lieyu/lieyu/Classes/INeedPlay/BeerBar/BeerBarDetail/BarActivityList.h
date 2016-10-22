//
//  BarActivityList.h
//  lieyu
//
//  Created by 狼族 on 16/2/18.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BeerBarOrYzhDetailModel;
@class BarTopicInfo;

@interface BarActivityList : NSObject
@property (nonatomic,strong) BeerBarOrYzhDetailModel *barInfo;
@property (nonatomic, strong) NSString *address;
@property (nonatomic,copy) NSString *beginDate;
@property (nonatomic,copy) NSString *contents;
@property (nonatomic,copy) NSString *createDate;
@property (nonatomic,copy) NSString *endDate;
@property (nonatomic,copy) NSString *environment;
@property (nonatomic,copy) NSString *id;
@property (nonatomic,copy) NSString *imageUrl;
@property (nonatomic,copy) NSString *imageid;
@property (nonatomic,copy) NSString *music;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *smInfo;
@property (nonatomic,strong) BarTopicInfo *topicInfo;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *activityType;
@end
