//
//  RoomHostUserModel.h
//  lieyu
//
//  Created by 狼族 on 16/8/17.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface roomHostUser : NSObject
//列表
@property (nonatomic, assign) int id;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *avatar_img;
@property (nonatomic, assign) int roleid;
@property (nonatomic, assign) int sex;//1表示男，0表示女
@property (nonatomic, strong) NSArray *userTag;

//单个的
@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *usernick;
@property (nonatomic, strong) NSString *usertype;
@property (nonatomic , assign) int applyStatus;
@property (nonatomic, assign) int gender;

@end
