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
