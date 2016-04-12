//
//  DetailUserInfoCell.h
//  lieyu
//
//  Created by 王婷婷 on 16/4/11.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderInfoModel.h"
#import "UserModel.h"
@interface DetailUserInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userAvatarImg;
@property (weak, nonatomic) IBOutlet UILabel *userNameLbl;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;
@property (weak, nonatomic) IBOutlet UILabel *quantityLbl;

@property (nonatomic, strong)OrderInfoModel *orderInfoModel;
@property (nonatomic, strong)UserModel *userModel;

- (void)configureManagerCell:(OrderInfoModel *)model;
- (void)configureFriendsCell:(OrderInfoModel *)model;

@end
