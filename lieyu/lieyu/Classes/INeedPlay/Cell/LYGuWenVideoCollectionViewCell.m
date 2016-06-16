//
//  LYGuWenVideoCollectionViewCell.m
//  lieyu
//
//  Created by 狼族 on 16/6/4.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYGuWenVideoCollectionViewCell.h"
#import "FriendsPicAndVideoModel.h"

@implementation LYGuWenVideoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _userAvatarImage.layer.cornerRadius = 22;
    _userAvatarImage.layer.masksToBounds = YES;
    _videoImage.contentMode = UIViewContentModeScaleAspectFill;
    _videoImage.clipsToBounds = YES;
}

- (void)setRecentM:(FriendsRecentModel *)recentM{
    _recentM = recentM;
    NSString *urlStr = ((FriendsPicAndVideoModel *)recentM.lyMomentsAttachList[0]).imageLink;
    NSString *imageStr = ((FriendsPicAndVideoModel *)recentM.lyMomentsAttachList[0]).thumbnailUrl;
    if (![MyUtil isEmptyString:imageStr]) {
        [_videoImage sd_setImageWithURL:[NSURL URLWithString:[MyUtil getQiniuUrl:imageStr width:0 andHeight:0]] placeholderImage:[UIImage imageNamed:@"empyImage300"]];
    }else{
        [_videoImage sd_setImageWithURL:[NSURL URLWithString:[MyUtil getQiniuUrl:urlStr mediaType:QiNiuUploadTpyeDefault width:0 andHeight:0]] placeholderImage:[UIImage imageNamed:@"empyImage300"]];
    }
    if (recentM.thunbImage) {
        _videoImage.image = recentM.thunbImage;
    }
    [_userAvatarImage sd_setImageWithURL:[NSURL URLWithString:recentM.avatar_img] placeholderImage:[UIImage imageNamed:@""]];
    [_userNickLabel setText:recentM.usernick];
    if (recentM.isManageRelease) {
        [_userIdenLabel setText:@"娱乐顾问"];
    }else{
        [_userIdenLabel setText:@"玩友"];
    }
    if ([recentM.liked isEqualToString:@"1"]) {
        [_likeButton setImage:[UIImage imageNamed:@"videoLiked"] forState:UIControlStateNormal];
    }else{
        [_likeButton setImage:[UIImage imageNamed:@"videounLiked"] forState:UIControlStateNormal];
    }
    
}

@end
