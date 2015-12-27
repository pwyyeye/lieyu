//
//  LYFriendsNameTableViewCell.m
//  lieyu
//
//  Created by 狼族 on 15/12/25.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYFriendsNameTableViewCell.h"
#import "UIButton+WebCache.h"
#import "FriendsRecentModel.h"

@implementation LYFriendsNameTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setRecentM:(FriendsRecentModel *)recentM{
    _recentM = recentM;
    [_btn_headerImg sd_setBackgroundImageWithURL:[NSURL URLWithString:recentM.avatar_img] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"empyImage120"]];
    _btn_headerImg.layer.cornerRadius = CGRectGetHeight(_btn_headerImg.frame) / 2.f;
    _btn_headerImg.layer.masksToBounds = YES;
    [_btn_name setTitle:recentM.usernick forState:UIControlStateNormal];
    [_label_time setText:recentM.date];
    [_label_content setText:recentM.message];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
