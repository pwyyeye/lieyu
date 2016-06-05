//
//  LYAdviserInfoModel.h
//  lieyu
//
//  Created by 狼族 on 16/5/30.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface LYAdviserInfoModel : NSObject
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *age;
@property (nonatomic, strong) NSString *avatar_img;
@property (nonatomic, strong) NSString *baricon;
@property (nonatomic, assign) int barid;
@property (nonatomic, strong) NSString *barname;
@property (nonatomic, assign) int beCollectNum;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, assign) int faceScoreNum;
@property (nonatomic, assign) int gender;
@property (nonatomic, assign) int id;
@property (nonatomic, strong) NSString *imuserid;
@property (nonatomic, strong) NSString *introduction;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *wechatId;
@property (nonatomic, strong) NSString *liked;
@property (nonatomic, strong) NSArray *recentImages;
@property (nonatomic, assign) int popularityNum;
@property (nonatomic, assign) int receptionNum;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *usernick;

@end
