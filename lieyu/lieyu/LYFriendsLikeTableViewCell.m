//
//  LYFriendsLikeTableViewCell.m
//  lieyu
//
//  Created by 狼族 on 15/12/25.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYFriendsLikeTableViewCell.h"
#import "FriendsRecentModel.h"
#import "UIButton+WebCache.h"
#import "FriendsLikeModel.h"

@implementation LYFriendsLikeTableViewCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    for (UIButton *btn in _btnArray) {
        btn.layer.cornerRadius = CGRectGetHeight(btn.frame) / 2.f;
        btn.layer.masksToBounds = YES;
    }
}

- (void)setRecentM:(FriendsRecentModel *)recentM{
    _recentM = recentM;
    for (UIButton *btn in _btnArray) {
        btn.hidden = YES;
    }
    NSArray *array = recentM.likeList;
    for (int i = 0; i<array.count; i++ ) {
        if(i >= 7) return;
        UIButton *btn = _btnArray[i];
        btn.hidden = NO;
        FriendsLikeModel *likeModel = array[i];
        [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:likeModel.icon] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"CommonIcon"]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
