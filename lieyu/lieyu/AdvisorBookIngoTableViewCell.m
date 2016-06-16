//
//  AdvisorBookIngoTableViewCell.m
//  lieyu
//
//  Created by 狼族 on 16/5/30.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "AdvisorBookIngoTableViewCell.h"

@implementation AdvisorBookIngoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _avatar_image.layer.cornerRadius = _avatar_image.frame.size.width / 2;
    _avatar_image.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setBarDict:(NSDictionary *)barDict{
    _barDict = barDict;
    [_title_label setText:@"消费酒吧"];
    [_avatar_image sd_setImageWithURL:[NSURL URLWithString:[barDict objectForKey:@"baricon"]] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
    [_name_label setText:[barDict objectForKey:@"barname"]];
}

- (void)setUserDict:(NSDictionary *)userDict{
    _userDict = userDict;
    [_title_label setText:@"服务经理"];
    [_avatar_image sd_setImageWithURL:[NSURL URLWithString:[userDict objectForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
    [_name_label setText:[userDict objectForKey:@"usernick"]];
}

@end
