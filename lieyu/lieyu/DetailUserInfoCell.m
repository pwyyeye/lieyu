//
//  DetailUserInfoCell.m
//  lieyu
//
//  Created by 王婷婷 on 16/4/11.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "DetailUserInfoCell.h"

@implementation DetailUserInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _quantityLbl.layer.cornerRadius = 6;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureFriendsCell:(OrderInfoModel *)model{
    NSDictionary *dict = [model.pinkerList objectAtIndex:self.tag];
    _userModel.avatar_img = [dict objectForKey:@"inmenberAvatar_img"];
    _userModel.imuserId = [dict objectForKey:@"inmenberImUserid"];
    _userModel.username = [dict objectForKey:@"inmemberName"];
    _userModel.usernick = [dict objectForKey:@"inmemberName"];
    _userModel.mobile = [dict objectForKey:@"inmenbermobile"];
    _userModel.userid = (int)[dict objectForKey:@"inmember"];
    [_userAvatarImg sd_setImageWithURL:[NSURL URLWithString:_userModel.avatar_img] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
    [_userNameLbl setText:_userModel.usernick?_userModel.usernick:(_userModel.username?_userModel.username:_userModel.mobile)];
    if ((int)[dict objectForKey:@"quantity"] <= 1) {
        _quantityLbl.hidden = YES;
    }else{
        _quantityLbl.hidden = NO;
        [_quantityLbl setText:[dict objectForKey:@"quantity"]];
    }
}

- (void)configureManagerCell:(OrderInfoModel *)model{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UserModel *myModel = app.userModel;
    _quantityLbl.hidden = YES;
    if (model.ordertype == 1 && myModel.userid != model.userid) {//拼客的参与者
        _userModel.avatar_img = model.avatar_img;
        _userModel.imuserId = model.imuserid;
        _userModel.username = model.username;
        _userModel.usernick = model.username;
        _userModel.mobile = model.phone;
        _userModel.userid = model.userid;
        [_userAvatarImg sd_setImageWithURL:[NSURL URLWithString:_userModel.avatar_img] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
        [_userNameLbl setText:_userModel.usernick?_userModel.usernick:(_userModel.username?_userModel.username:_userModel.mobile)];
    }else{
        //非拼客订单［都是自己订单］自己发起的拼客订单
        _userModel.avatar_img = model.checkUserAvatar_img;
        _userModel.imuserId = model.checkUserImUserid;
        _userModel.username = model.checkUserName;
        _userModel.usernick = model.checkUserName;
        _userModel.mobile = model.checkUserMobile;
        _userModel.userid = model.checkuserid;
        _userModel.age = model.checkUserAge;
        [_userAvatarImg sd_setImageWithURL:[NSURL URLWithString:_userModel.avatar_img] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
        [_userNameLbl setText:_userModel.usernick?_userModel.usernick:(_userModel.username?_userModel.username:_userModel.mobile)];
    }
}

@end
