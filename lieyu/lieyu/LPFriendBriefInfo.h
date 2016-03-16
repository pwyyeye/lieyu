//
//  LPFriendBriefInfo.h
//  lieyu
//
//  Created by 王婷婷 on 16/3/16.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
//"birthday": "1990-01-01",
//"date": "2015-12-24",
//"icon": "http://source.lie98.com/20160127212540923.jpg?imageView2/0/w/80/h/80",
//"imUserId": "cQvK6QflqrI=",
//"nickName": "albert",
//"sex": 1,
//"userId": 130615
@interface LPFriendBriefInfo : NSObject
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *imUserId;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *userId;
@end
