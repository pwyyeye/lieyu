//
//  FriendsNewsModel.h
//  lieyu
//
//  Created by 狼族 on 15/12/31.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendsNewsModel : NSObject
@property (nonatomic,copy) NSString *avatar_img;
@property (nonatomic,copy) NSString *comment;
@property (nonatomic,copy) NSString *date;
@property (nonatomic,copy) NSString *id;
@property (nonatomic,copy) NSString *likeImUserId;
@property (nonatomic,copy) NSString *likeNickName;
@property (nonatomic,copy) NSString *likeUserIcon;
@property (nonatomic,copy) NSString *likeUserId;
@property (nonatomic,copy) NSString *message;
@property (nonatomic,copy) NSString *messageId;
@property (nonatomic,copy) NSString *type;//0是赞 1是评论
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *usernick;
@property (nonatomic,copy) NSString *toUserId;

@end
