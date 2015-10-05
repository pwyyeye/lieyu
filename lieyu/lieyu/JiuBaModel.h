//
//  JiuBaModel.h
//  lieyu
//
//  Created by 薛斯岐 on 15/9/25.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JiuBaModel : NSObject

//"address": "莉莉玛莲街道",
//"announcement": null,
//"banners": [],
//"baricon": "http://7xn0lq.com2.z0.glb.qiniucdn.com/?imageView2/0/w/80/h/80",
//"barid": 2,
//"barlevelid": 0,
//"barlevelname": "",
//"barname": "丽丽酒吧",
//"bartypename": "",
//"distance": "0",
//"environment_num": "",
//"fav_num": 11,
//"id": 2,
//"latitude": "26.074508",
//"longitude": "119.29649399999994",
//"lowest_consumption": 30,
//"recommend_package": [],
//"star_num": "",
//"subtitle": "丽丽",
//"subtypename": "",
//"tese": [],
//"today_sm_buynum": ""
@property(nonatomic,assign)int id;
@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * announcement;
@property (nonatomic, retain) NSArray * banners;
@property (nonatomic, retain) NSArray * tese;
@property (nonatomic, copy) NSString * baricon;
@property (nonatomic, copy) NSString * today_sm_buynum;
@property(nonatomic,assign)int barid;
@property(nonatomic,assign)int barlevelid;
@property (nonatomic, copy) NSString * barlevelname;
@property (nonatomic, copy) NSString * bartypename;
@property (nonatomic, copy) NSString * distance;
@property (nonatomic, copy) NSString * environment_num;
@property(nonatomic,assign)int fav_num;
@property (nonatomic, copy) NSString * barname;
@property (nonatomic, copy) NSString * latitude;
@property (nonatomic, copy) NSString * longitude;
@property(nonatomic,assign)int lowest_consumption;
@property (nonatomic, retain) NSArray * recommend_package;
@property(nonatomic,copy)NSString * star_num;
@property(nonatomic,copy)NSString * subtitle;
@property(nonatomic,copy)NSString * subtypename;
@property NSInteger sectionNumber;
@property BOOL rowSelected;
@end
