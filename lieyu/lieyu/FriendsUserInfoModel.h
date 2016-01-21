//
//  FriendsUserInfoModel.h
//  lieyu
//
//  Created by 狼族 on 16/1/4.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendsUserInfoModel : NSObject
@property (nonatomic,copy) NSString *age;
@property (nonatomic,copy) NSString *attendNum;
@property (nonatomic,copy) NSString *avatar_img;
@property (nonatomic,copy) NSString *birthday;
@property (nonatomic,copy) NSString *fansNum;
@property (nonatomic,copy) NSString *friends_img;
@property (nonatomic,copy) NSString *gender;
@property (nonatomic,copy) NSString *id;
@property (nonatomic,copy) NSString *imUserId;
@property (nonatomic,copy) NSString *introduction;
@property (nonatomic,copy) NSString *isAttention;
@property (nonatomic,copy) NSString *liked;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *usernick;
@property (nonatomic,copy) NSString *type;
@property(strong,nonatomic) NSArray *tags;
@end
