//
//  LYFriendsImgTwoTableViewCell.h
//  lieyu
//
//  Created by 狼族 on 15/12/25.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FriendsRecentModel;

@interface LYFriendsImgTwoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView_one;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_two;
@property (nonatomic,strong) FriendsRecentModel *recentM;
@end
