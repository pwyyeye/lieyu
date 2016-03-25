//
//  LYFriendsLikeDetailTableViewCell.h
//  lieyu
//
//  Created by 狼族 on 15/12/28.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FriendsRecentModel;

@interface LYFriendsLikeDetailTableViewCell : UITableViewCell
@property (strong, nonatomic)  NSMutableArray *btnArray;
@property (nonatomic,strong) FriendsRecentModel *recentM;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *like_icon_cons_top;
@property (strong,nonatomic) NSMutableArray *emojiImgVArray;
@end
