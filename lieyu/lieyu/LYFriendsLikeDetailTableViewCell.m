//
//  LYFriendsLikeDetailTableViewCell.m
//  lieyu
//
//  Created by 狼族 on 15/12/28.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYFriendsLikeDetailTableViewCell.h"
#import "FriendsRecentModel.h"
#import "FriendsCommentModel.h"
#import "UIButton+WebCache.h"

@implementation LYFriendsLikeDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    for (UIButton *btn in _btnArray) {
        btn.layer.cornerRadius = CGRectGetHeight(btn.frame) / 2.f;
        btn.layer.masksToBounds = YES;
    }
}

- (void)setRecentM:(FriendsRecentModel *)recentM{
    _recentM = recentM;
    NSArray *array = recentM.commentList;
    for (int  i = 0; i < recentM.commentNum.integerValue; i ++) {
        UIButton *btn = _btnArray[i];
        FriendsCommentModel *commentModel = array[i];
        [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:commentModel.icon] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"empyImage120"]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
