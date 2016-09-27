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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setRecommendFriendModel:(UserModel *)RecommendFriendModel{
    _RecommendFriendModel = RecommendFriendModel;
    
}

@end
