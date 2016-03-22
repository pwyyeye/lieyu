//
//  LYFriendsTopicViewController.h
//  lieyu
//
//  Created by 狼族 on 16/3/21.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"
#import "LYFriendsToUserMessageViewController.h"

@interface LYFriendsTopicViewController : LYFriendsToUserMessageViewController
@property (nonatomic,copy) NSString *topicTypeId;
@property (nonatomic,copy) NSString *topicName;
@property (nonatomic,copy) NSString *headerViewImgLink;
@end
