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
    if (model.pinkerList.count > self.tag){
        NSDictionary *dict = [model.pinkerList objectAtIndex:self.tag];
        _avatar_img = [dict objectForKey:@"inmenberAvatar_img"];
        _imuserId = [dict objectForKey:@"inmenberImUserid"];
        _username = [dict objectForKey:@"inmemberName"];
        _usernick = [dict objectForKey:@"inmemberName"];
        _mobile = [dict objectForKey:@"inmenbermobile"];
        _userid = [[dict objectForKey:@"inmember"] intValue];
        [_userAvatarImg sd_setImageWithURL:[NSURL URLWithString:_avatar_img] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
        [_userNameLbl setText:_usernick?_usernick:(_username?_username:_mobile)];
        if ([[dict objectForKey:@"quantity"] intValue] <= 1) {
            NSLog(@"%d",(int)[dict objectForKey:@"quantity"]);
            _quantityLbl.hidden = YES;
        }else{
            _quantityLbl.hidden = NO;
            [_quantityLbl setText:[dict objectForKey:@"quantity"]];
        }
    }
}

- (void)configureManagerCell:(OrderInfoModel *)model{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UserModel *myModel = app.userModel;
    _quantityLbl.hidden = YES;
    if (model.ordertype == 1 && myModel.userid != model.userid) {//拼客的参与者
        _avatar_img = model.avatar_img;
        _imuserId = model.imuserid;
        _username = model.username;
        _usernick = model.username;
        _mobile = model.phone;
        _userid = model.userid;
        [_userAvatarImg sd_setImageWithURL:[NSURL URLWithString:_avatar_img] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
        [_userNameLbl setText:_usernick?_usernick:(_username?_username:_mobile)];
    }else{
        //非拼客订单［都是自己订单］自己发起的拼客订单
        _avatar_img = model.checkUserAvatar_img;
        _imuserId = model.checkUserImUserid;
        _username = model.checkUserName;
        _usernick = model.checkUserName;
        _mobile = model.checkUserMobile;
        _userid = model.checkuserid;
        [_userAvatarImg sd_setImageWithURL:[NSURL URLWithString:_avatar_img] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
        [_userNameLbl setText:_usernick?_usernick:(_username?_username:_mobile)];
    }
}

@end
