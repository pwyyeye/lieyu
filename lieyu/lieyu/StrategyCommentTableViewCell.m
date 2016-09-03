//
//  StrategyCommentTableViewCell.m
//  lieyu
//
//  Created by 王婷婷 on 16/9/2.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "StrategyCommentTableViewCell.h"

@implementation StrategyCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _shadowView.layer.shadowColor = [[UIColor blackColor] CGColor];
    _shadowView.layer.shadowOffset = CGSizeMake(0, 1);
    _shadowView.layer.shadowOpacity = 0.3;
    
    _userAvatarImage.layer.cornerRadius = _userAvatarImage.frame.size.width / 2;
    _userAvatarImage.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setCommentModel:(StrategyCommentModel *)commentModel{
    _commentModel = commentModel;
    [_userAvatarImage sd_setImageWithURL:[NSURL URLWithString:commentModel.icon] placeholderImage:[UIImage imageNamed:@"empyImage120"]];
    [_userNameLabel setText:commentModel.nickName];
    [_userTimeLabel setText:[MyUtil isEmptyString:commentModel.date] ? @"" : [commentModel.date substringWithRange:NSMakeRange(0, 10)]];
    [_userCommentLabel setText:commentModel.comment];
}

@end
