//
//  CustomerModel.h
//  lieyu
//
//  Created by SEM on 15/9/16.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TagModel.h"
@class UserModel;
@interface CustomerModel : NSObject

@property(nonatomic,assign)int friend;
@property (nonatomic, strong) NSString *friendStatus;
@property (nonatomic, strong) NSString *password;
@property(nonatomic,copy)NSString * friendName;
@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSString * icon;
@property(nonatomic,copy)NSString * imUserId;
@property(nonatomic,copy)NSString * imuserid;
@property(nonatomic,copy)NSString * makeDate;
@property(nonatomic,copy)NSString * makeWay;
@property(nonatomic,copy)NSString * message;
@property(nonatomic,copy)NSString * distance;
@property(nonatomic,copy)NSString * mobile;
@property(nonatomic,copy)NSString * online;
@property(nonatomic,copy)NSString * user;
@property(nonatomic,copy)NSString * sex;
@property(nonatomic,copy)NSString * usernick;
@property(nonatomic,copy)NSString *mark;
@property(nonatomic,assign)int id;
@property(nonatomic,assign)int userid;
@property(nonatomic,copy)NSString * username;
@property(nonatomic,copy)NSString * avatar_img;
@property(nonatomic,copy)NSString * username_en;
@property(nonatomic,copy)NSString * phone;
@property(nonatomic,retain)NSArray * tag;
@property(nonatomic,retain)NSArray * tags;
@property(nonatomic,retain)NSArray *userTag;
@property(strong,nonatomic) NSString *age;
@property(strong,nonatomic) NSString *birthday;
@property NSInteger sectionNumber;
@property BOOL rowSelected;
@property(strong,nonatomic) NSString *ordernum;

@property (nonatomic,copy) NSString *barid;
@property (nonatomic,copy) NSString *createdate;
@property (nonatomic,copy) NSString *signdate;
@property (nonatomic,strong) UserModel *userInfo;

@end
