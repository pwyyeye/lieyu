//
//  LYFriendsAllCommentTableViewCell.h
//  lieyu
//
//  Created by 狼族 on 15/12/26.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FriendsRecentModel;

@interface LYFriendsAllCommentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label_commentCount;
@property (nonatomic,strong) FriendsRecentModel *recentM;
@end
