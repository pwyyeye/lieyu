//
//  LYFriendsCommentTableViewCell.m
//  lieyu
//
//  Created by 狼族 on 15/12/25.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYFriendsCommentTableViewCell.h"
#import "FriendsCommentModel.h"
#import "UIButton+WebCache.h"

@implementation LYFriendsCommentTableViewCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _btn_headerImg.layer.cornerRadius = CGRectGetHeight(_btn_headerImg.frame)/2.f;
    _btn_headerImg.layer.masksToBounds = YES;
}

- (void)setCommentM:(FriendsCommentModel *)commentM{
    _commentM = commentM;
    [_btn_headerImg sd_setBackgroundImageWithURL:[NSURL URLWithString:commentM.icon] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"empyImage120"]];
    NSString *string = [NSString stringWithFormat:@"%@:%@",commentM.nickName,commentM.comment];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:string];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:RGBA(114, 5, 147, 1) range:NSMakeRange(0, commentM.nickName.length + 1)];
    
    _label_comment.attributedText = attributedStr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
