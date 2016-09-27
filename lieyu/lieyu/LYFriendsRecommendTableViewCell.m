//
//  LYFriendsRecommendTableViewCell.m
//  lieyu
//
//  Created by 王婷婷 on 16/9/24.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYFriendsRecommendTableViewCell.h"

@implementation LYFriendsRecommendTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)drawRect:(CGRect)rect{
    _avatarImage.layer.cornerRadius = _avatarImage.frame.size.width / 2.f ;
    _avatarImage.layer.masksToBounds = YES;
    
    _userType.layer.cornerRadius = _userType.frame.size.height / 2.f;
    _userType.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setRecommendFriendModel:(UserModel *)RecommendFriendModel{
    _RecommendFriendModel = RecommendFriendModel;
    [_avatarImage sd_setImageWithURL:[NSURL URLWithString:[MyUtil getQiniuUrl:RecommendFriendModel.avatar_img width:0 andHeight:0]] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
    [_userName setText:RecommendFriendModel.usernick];
    [_userType setText:([RecommendFriendModel.usertype isEqualToString:@"2"] || [RecommendFriendModel.usertype isEqualToString:@"3"]) ? @"娱乐顾问" : @"玩友"];
    CGSize size = [_userType.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 13) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} context:nil].size;
    _userTypeWidth.constant = size.width + 10 ;
//    if ([MyUtil isEmptyString:RecommendFriendModel.birthday]) {
//        [_userFirstTag setText:@"天蝎座"];
//    }else{
        [_userFirstTag setText:[MyUtil getAstroWithBirthday:RecommendFriendModel.birthday]];
//    }
    if (RecommendFriendModel.userTag.count) {
        [_userSecondTag setText:[RecommendFriendModel.userTag objectAtIndex:0]];
    }else{
        [_userSecondTag setText:@"首富"];
    }
}

@end
