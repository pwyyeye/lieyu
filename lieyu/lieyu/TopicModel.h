//
//  TopicModel.h
//  lieyu
//
//  Created by 王婷婷 on 16/3/18.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
//"barid": 5,
//"barname": "MAYA",
//"createDate": "2016-03-17 20:29:21",
//"id": 1,
//"linkurl": "",
//"modifyDate": "",
//"name": "MAYA"
@interface TopicModel : NSObject
@property (nonatomic, strong) NSString *barid;
@property (nonatomic, strong) NSString *barname;
@property (nonatomic, strong) NSString *createDate;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *linkurl;
@property (nonatomic, strong) NSString *modifyDate;
@property (nonatomic, strong) NSString *name;
@end
