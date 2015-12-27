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

@implementation LYFriendsLikeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setRecentM:(FriendsRecentModel *)recentM{
    _recentM = recentM;
    NSArray *array = recentM.commentList;
    for (int i = 0; i<array.count; i++ ) {
        UIButton *btn = _btnArray[i];
        [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:array[i]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"empyImage120"]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
