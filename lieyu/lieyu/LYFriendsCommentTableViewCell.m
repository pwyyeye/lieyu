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
    [_btn_headerImg sd_setBackgroundImageWithURL:[NSURL URLWithString:commentM.icon] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"CommonIcon"]];
    NSString *string = nil;
    if([commentM.toUserId isEqualToString:@"0"]) {
        string = [NSString stringWithFormat:@"%@:%@",commentM.nickName,commentM.comment];
    }else {
        string = [NSString stringWithFormat:@"回复%@:%@",commentM.toUserNickName,commentM.comment];
    }
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:string];
    if([commentM.toUserId isEqualToString:@"0"]) {
        if([MyUtil isEmptyString:commentM.nickName] || [MyUtil isEmptyString:commentM.nickName]) return;
        [attributedStr addAttribute:NSForegroundColorAttributeName value:RGBA(186, 40, 227, 1) range:NSMakeRange(0, commentM.nickName.length + 1)];
    }else{
        if([MyUtil isEmptyString:commentM.toUserNickName] || [MyUtil isEmptyString:commentM.toUserNickName]) return;
         [attributedStr addAttribute:NSForegroundColorAttributeName value:RGBA(186, 40, 227, 1) range:NSMakeRange(2, commentM.toUserNickName.length + 1)];
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:3];
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
    
    _label_comment.attributedText = attributedStr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
