//
//  CustomerModel.h
//  lieyu
//
//  Created by SEM on 15/9/16.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TagModel.h"
@interface CustomerModel : NSObject
//"avatar_img": "null",
//"id": 0,
//"tag": [
//        {
//            "id": 0,
//            "tagId": "2",
//            "tagName": "歌手"
//        }
//        ],
//"userid": 3,
//"username": "aaa"

//"friend": 108888,
//"friendName": "马东",
//"icon": "http://source.lie98.com/1",
//"id": 3,
//"imUserId": "bX0gUrK6LVw=",
//"makeDate": 0,
//"makeWay": 1,
//"mobile": "1",
//"online": "",
//"user": 130610,
//"username": "陈华阳"
@property(nonatomic,copy)NSString * friend;
@property(nonatomic,copy)NSString * friendName;
@property(nonatomic,copy)NSString * icon;
@property(nonatomic,copy)NSString * imUserId;
@property(nonatomic,copy)NSString * makeDate;
@property(nonatomic,copy)NSString * makeWay;
@property(nonatomic,copy)NSString * mobile;
@property(nonatomic,copy)NSString * online;
@property(nonatomic,copy)NSString * user;
@property(nonatomic,copy)NSString * sex;
@property(nonatomic,copy)NSString * usernick;
@property(nonatomic,assign)int id;
@property(nonatomic,assign)int userid;
@property(nonatomic,copy)NSString * username;
@property(nonatomic,copy)NSString * avatar_img;
@property(nonatomic,copy)NSString * username_en;
@property(nonatomic,copy)NSString * phone;
@property(nonatomic,retain)NSArray * tag;
@property NSInteger sectionNumber;
@property BOOL rowSelected;
@end
