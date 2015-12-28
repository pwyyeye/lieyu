//
//  LYFriendsHeaderTableViewCell.m
//  lieyu
//
//  Created by 狼族 on 15/12/27.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYFriendsHeaderTableViewCell.h"
#import "UIButton+WebCache.h"
#import "FriendsRecentModel.h"
#import "FriendsPicAndVideoModel.h"

@implementation LYFriendsHeaderTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _btn_headerImg.layer.cornerRadius = CGRectGetHeight(_btn_headerImg.frame) / 2.f;
    _btn_headerImg.layer.masksToBounds = YES;
}

- (void)setRecentM:(FriendsRecentModel *)recentM{
    _recentM = recentM;
//    FriendsPicAndVideoModel *pvModel = recentM.lyMomentsAttachList[
    [_btn_headerImg sd_setBackgroundImageWithURL:[NSURL URLWithString:recentM.avatar_img] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"empy120"]];
    _label_name.text = recentM.usernick;
    _label_content.text = recentM.message;
    
    for (int i = 0; i < recentM.lyMomentsAttachList.count; i ++) {
        FriendsPicAndVideoModel *pvModel = recentM.lyMomentsAttachList[i];
        UIImageView *imgView = _imageViewArray[i];
        [imgView sd_setImageWithURL:[NSURL URLWithString:pvModel.imageLink] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
    }
    _label_time.text = [NSString stringWithFormat:@"%@\n%@",recentM.date,recentM.location];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
