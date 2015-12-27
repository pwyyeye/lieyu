//
//  LYFriendsImgTwoTableViewCell.m
//  lieyu
//
//  Created by 狼族 on 15/12/25.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYFriendsImgTwoTableViewCell.h"
#import "FriendsRecentModel.h"
#import "FriendsPicAndVideoModel.h"

@implementation LYFriendsImgTwoTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRecentM:(FriendsRecentModel *)recentM{
    _recentM = recentM;
    NSArray *imgArray = recentM.lyMomentsAttachList;
    switch (imgArray.count) {
        case 2:
        {
            FriendsPicAndVideoModel *pvModel1 = imgArray[0];
            FriendsPicAndVideoModel *pvModel2 = imgArray[1];
            [_imageView_one sd_setImageWithURL:[NSURL URLWithString:pvModel1.imageLink] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
            [_imageView_two sd_setImageWithURL:[NSURL URLWithString:pvModel2.imageLink] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
        }
            break;
        case 3:
        {
            FriendsPicAndVideoModel *pvModel1 = imgArray[2];
            FriendsPicAndVideoModel *pvModel2 = imgArray[3];
            [_imageView_one sd_setImageWithURL:[NSURL URLWithString:pvModel1.imageLink] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
            [_imageView_two sd_setImageWithURL:[NSURL URLWithString:pvModel2.imageLink] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
        }
        default:
            break;
    }
}

@end
