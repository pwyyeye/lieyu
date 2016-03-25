//
//  LYFriendsLikeTableViewCell.h
//  lieyu
//
//  Created by 狼族 on 15/12/25.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FriendsRecentModel;

@interface LYFriendsLikeTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btnArray;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imageArray;

@property (weak, nonatomic) IBOutlet UIButton *btn_more;
@property (nonatomic,strong) FriendsRecentModel *recentM;
@end
