//
//  LYFriendsAMessageDetailViewController.h
//  lieyu
//
//  Created by 狼族 on 16/4/23.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYFriendsPersonMessageViewController.h"

typedef void (^ReturnModelBlock)(NSString *liked);

@interface LYFriendsAMessageDetailViewController : LYFriendsPersonMessageViewController

//@property (nonatomic,copy) NSString *messageId;
@property (nonatomic,strong) FriendsRecentModel *recentM;

@property (nonatomic, copy) ReturnModelBlock returnModelBlock;

- (void)returnLiked:(ReturnModelBlock)block;

@end
