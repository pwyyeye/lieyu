//
//  LYMessageDetailViewController.h
//  lieyu
//
//  Created by 狼族 on 15/12/27.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"

#import "EmojisView.h"

@class FriendsRecentModel;

@interface LYFriendsMessageDetailViewController : LYBaseViewController<emojiClickDelegate>
@property (nonatomic,strong) FriendsRecentModel *recentM;
@property (nonatomic,unsafe_unretained) BOOL *isTopicDetail;
@end
