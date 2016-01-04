//
//  LYFriendsCommentDetailTableViewCell.m
//  lieyu
//
//  Created by 狼族 on 15/12/28.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYFriendsCommentDetailTableViewCell.h"
#import "UIButton+WebCache.h"
#import "FriendsCommentModel.h"

@implementation LYFriendsCommentDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _btn_headerImg.layer.cornerRadius = CGRectGetHeight(_btn_headerImg.frame) / 2.f;
    _btn_headerImg.layer.masksToBounds = YES;
}

- (void)setCommentModel:(FriendsCommentModel *)commentModel{
    _commentModel = commentModel;
    [_btn_headerImg sd_setBackgroundImageWithURL:[NSURL URLWithString:commentModel.icon] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"empyImage120"]];
    NSString *string = nil;
    if ([commentModel.toUserId isEqualToString:@"0"]) {
        string = [NSString stringWithFormat:@"%@:%@",commentModel.nickName,commentModel.comment];
    }else{
        string = [NSString stringWithFormat:@"回复%@:%@",commentModel.nickName,commentModel.comment];
    }
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:string];
        if ([commentModel.toUserId isEqualToString:@"0"]) {
            [attributedStr addAttribute:NSForegroundColorAttributeName value:RGBA(114, 5, 147, 1) range:NSMakeRange(0, commentModel.nickName.length + 1)];
        }else{
            [attributedStr addAttribute:NSForegroundColorAttributeName value:RGBA(114, 5, 147, 1) range:NSMakeRange(2, commentModel.nickName.length + 1)];
        }
    
    _label_comment.attributedText = attributedStr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
