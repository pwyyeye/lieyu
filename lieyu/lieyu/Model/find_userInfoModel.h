//
//  find_userInfoModel.h
//  lieyu
//
//  Created by 王婷婷 on 16/3/15.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface find_userInfoModel : NSObject
@property (nonatomic, strong) NSString *age;
@property (nonatomic, strong) NSString *avatar_img;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, assign) int gender;
@property (nonatomic, assign) int id;
@property (nonatomic, strong) NSString *imuserId;
@property (nonatomic, strong) NSString *introduction;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSArray *recentImages;
@property (nonatomic, strong) NSString *tag;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, assign) int userid;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *usernick;



@end
