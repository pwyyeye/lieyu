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
#import "FriendsLikeModel.h"

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
    NSArray *array = recentM.likeList;
    for (int  i = 0; i < recentM.likeList.count; i ++) {
        if(i >= 16) return;
        UIButton *btn = _btnArray[i];
//        btn.tag = i;
        FriendsLikeModel *likeM = array[i];
//        NSLog(@"------>%ld------%@",array.count,commentModel.icon);
        [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:likeM.icon] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"empyImage120"]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
