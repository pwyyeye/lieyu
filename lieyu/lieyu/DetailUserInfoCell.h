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
@property (weak, nonatomic) IBOutlet UIImageView *shaperLine;
@property (weak, nonatomic) IBOutlet UIView *backGround;

@property (nonatomic, strong) NSString *avatar_img;
@property (nonatomic, strong) NSString *imuserId;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *usernick;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, assign) int userid;

@property (nonatomic, strong)OrderInfoModel *orderInfoModel;

- (void)configureManagerCell:(OrderInfoModel *)model;
- (void)configureFriendsCell:(OrderInfoModel *)model;

@end
