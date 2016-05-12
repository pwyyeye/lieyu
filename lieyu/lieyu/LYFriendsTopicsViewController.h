//
//  LYFriendsTopicsViewController.h
//  lieyu
//
//  Created by 狼族 on 16/5/6.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYFriendsMessagesViewController.h"

@interface LYFriendsTopicsViewController : LYFriendsMessagesViewController
@property (nonatomic,copy) NSString *topicName;
@property (nonatomic,copy) NSString *topicTypeId;
@property (nonatomic,copy) NSString *headerViewImgLink;
@property (nonatomic,unsafe_unretained) BOOL isFriendsTopic;
@end
