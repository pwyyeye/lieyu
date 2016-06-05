//
//  LYGuWenVideoCollectionViewCell.h
//  lieyu
//
//  Created by 狼族 on 16/6/4.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendsRecentModel.h"

@interface LYGuWenVideoCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *videoImage;
@property (weak, nonatomic) IBOutlet UIButton *reportButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIImageView *userAvatarImage;
@property (weak, nonatomic) IBOutlet UILabel *userNickLabel;
@property (weak, nonatomic) IBOutlet UILabel *userIdenLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@property (nonatomic, strong) FriendsRecentModel *recentM;

@end
