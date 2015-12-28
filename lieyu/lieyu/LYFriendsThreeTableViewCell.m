//
//  LYFriendsThreeTableViewCell.m
//  lieyu
//
//  Created by 狼族 on 15/12/25.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYFriendsThreeTableViewCell.h"
#import "FriendsRecentModel.h"
#import "FriendsPicAndVideoModel.h"

@implementation LYFriendsThreeTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setRecentM:(FriendsRecentModel *)recentM{
    _recentM = recentM;
    NSArray *array = recentM.lyMomentsAttachList;
    FriendsPicAndVideoModel *pvModel1 = array[1];
        FriendsPicAndVideoModel *pvModel2 = array[2];
        FriendsPicAndVideoModel *pvModel3 = array[3];
    [_imageView_one sd_setImageWithURL:[NSURL URLWithString:pvModel1.imageLink] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
    [_imageView_two sd_setImageWithURL:[NSURL URLWithString:pvModel2.imageLink] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
    [_imageView_three sd_setImageWithURL:[NSURL URLWithString:pvModel3.imageLink] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
