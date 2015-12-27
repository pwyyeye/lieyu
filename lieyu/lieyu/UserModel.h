//
//  UserModel.h
//  lieyu
//
//  Created by 薛斯岐 on 15/10/3.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
//"applyStatus": 0,
//"avatar_img": "",
//"captchas": "",
//"confirm": "",
//"email": "",
//"id": 130635,
//"imuserId": "rMRw8QarX9o=",
//"mobile": "13799996422",
//"mobilecontent": "",
//"newpassword": "",
//"roleid": 0,
//"rolename": "",
//"token": "",
//"userid": 130635,
//"username": "13799996422",
//"usernick": "",
//"usertype": "1"
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
@property(strong,nonatomic) NSArray *tags;
@property (nonatomic,copy) NSString *tag;
@property(nonatomic,assign)int barid;

@end
