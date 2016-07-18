//
//  UserModel.h
//  lieyu
//
//  Created by 薛斯岐 on 15/10/3.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
//"beCollectNum": 5,
//"friends_img": "20160122035539955.jpg",
//"isFriend": 0,
//"recentImages": [],
//"type": 0,

@property(nonatomic,assign)int applyStatus;
@property(nonatomic,copy)NSString * avatar_img;
@property(nonatomic,copy)NSString * captchas;
@property(nonatomic,copy)NSString * confirm;
@property(nonatomic,copy)NSString * email;
@property(nonatomic,assign)int id;
@property(nonatomic,copy)NSString * imuserId;
@property(nonatomic,copy)NSString * mobile;
@property(nonatomic,copy)NSString * mobilecontent;
@property(nonatomic,copy)NSString * newpassword;
@property(nonatomic,assign)int roleid;
@property(nonatomic,copy)NSString * rolename;
@property(nonatomic,copy)NSString * token;
@property(nonatomic,assign)int userid;
@property(nonatomic,copy)NSString * username;
@property(nonatomic,copy)NSString * usernick;
@property(nonatomic,copy)NSString * usertype;
@property(strong,nonatomic) NSString *gender;
@property(strong,nonatomic) NSString *age;
@property(strong,nonatomic) NSString *birthday;
@property(assign,nonatomic) BOOL isGrpupManage;
@property(strong,nonatomic) NSArray *tags;
@property (nonatomic,copy) NSString *tag;
@property(nonatomic,assign)int barid;
@property (nonatomic,copy) NSString *openID;
@property(strong,nonatomic) NSString *weibo;
@property(strong,nonatomic) NSString *wechat;
@property(strong,nonatomic) NSString *qq;
@property (nonatomic,copy) NSString *manageUserids;

@property (nonatomic,copy) NSString *introduction;//
@property (nonatomic,copy) NSString *sex;//

@property (nonatomic,copy) NSString *addressabb;//
@property (nonatomic,copy) NSString *barname;
@property (nonatomic,copy) NSString *distance;//
@property (nonatomic,copy) NSString *facescoreNum;
@property (nonatomic,copy) NSString *popularityNum;
@property (nonatomic,copy) NSString *receptionNum;
@property (nonatomic,copy) NSString *beCollectNum;
@property (nonatomic,copy) NSString *collectNum;


@end
