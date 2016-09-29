//
//  LYFriendsRecommendTableViewCell.h
//  lieyu
//
//  Created by 王婷婷 on 16/9/24.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@interface LYFriendsRecommendTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userType;
@property (weak, nonatomic) IBOutlet UILabel *userFirstTag;
@property (weak, nonatomic) IBOutlet UILabel *userSecondTag;
@property (weak, nonatomic) IBOutlet UIButton *userSelectButton;
@property (weak, nonatomic) IBOutlet UIButton *addCareButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userTypeWidth;

@property (nonatomic, strong) UserModel *RecommendFriendModel;
@property (nonatomic, strong) UserModel *FanOrCareModel;

@end
