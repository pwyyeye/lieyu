//
//  LYFriendsLikeDetailTableViewCell.m
//  lieyu
//
//  Created by 狼族 on 15/12/28.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYFriendsLikeDetailTableViewCell.h"

@implementation LYFriendsLikeDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    for (UIButton *btn in _btnArray) {
        btn.layer.cornerRadius = CGRectGetHeight(btn.frame) / 2.f;
        btn.layer.masksToBounds = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
