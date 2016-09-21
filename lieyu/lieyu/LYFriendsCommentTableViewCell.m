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
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [_label_comment setContentMode:UIViewContentModeTopLeft];
    
}

- (void)drawRect:(CGRect)rect{
    
    _btn_headerImg.layer.cornerRadius = CGRectGetHeight(_btn_headerImg.frame)/2.f;
    _btn_headerImg.layer.masksToBounds = YES;
}

- (void)setCommentM:(FriendsCommentModel *)commentM{
    _commentM = commentM;
    [_btn_headerImg sd_setBackgroundImageWithURL:[NSURL URLWithString:commentM.icon] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"CommonIcon"]];
    NSString *string = nil;
    NSString *strrr = nil;
    if([commentM.toUserId isEqualToString:@"0"]) {
        string = [NSString stringWithFormat:@"%@",commentM.nickName];
        strrr = [NSString stringWithFormat:@"%@:%@",commentM.nickName,commentM.comment];
        _label_huifu.text = @"";
        [_btn_secondName setTitle:@"" forState:UIControlStateNormal];
        _btn_secondName.enabled = NO;
    } else {
        _label_huifu.text = @" 回复 ";
        string = [NSString stringWithFormat:@"%@ 回复 %@",commentM.nickName,commentM.toUserNickName];
        strrr = [NSString stringWithFormat:@"%@ 回复 %@：%@",commentM.nickName,commentM.toUserNickName,commentM.comment];
        [_btn_secondName setTitle:commentM.toUserNickName forState:UIControlStateNormal];
        _btn_secondName.enabled = YES;
    }
    [_btn_firstName setTitle:commentM.nickName forState:UIControlStateNormal];
    [_btn_firstName setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
     [_btn_secondName setTitleColor:[UIColor clearColor] forState:UIControlStateNormal] ;
    [_label_huifu setTextColor:[UIColor clearColor]];
    
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.firstLineHeadIndent = size.width + 10;
                                                   paragraphStyle.lineSpacing = 5;
    
                                                   NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14], NSParagraphStyleAttributeName:paragraphStyle};
    
    
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:strrr];
    [attributedStr addAttributes:attributes range:NSMakeRange(0, attributedStr.length)];
    [attributedStr addAttributes:@{NSForegroundColorAttributeName:COMMON_PURPLE} range:NSMakeRange(0, commentM.nickName.length)];
    if (![commentM.toUserId isEqualToString:@"0"]) {
        [attributedStr addAttributes:@{NSForegroundColorAttributeName:COMMON_PURPLE} range:NSMakeRange(commentM.nickName.length + 3, commentM.toUserNickName.length + 1)];
    }
//    if([commentM.toUserId isEqualToString:@"0"]) {
//        if([MyUtil isEmptyString:commentM.nickName] || [MyUtil isEmptyString:commentM.nickName]) return;
//        [attributedStr addAttribute:NSForegroundColorAttributeName value:RGBA(186, 40, 227, 1) range:NSMakeRange(0, commentM.nickName.length + 1)];
//    }else{
//        if([MyUtil isEmptyString:commentM.toUserNickName] || [MyUtil isEmptyString:commentM.toUserNickName]) return;
//         [attributedStr addAttribute:NSForegroundColorAttributeName value:RGBA(186, 40, 227, 1) range:NSMakeRange(2, commentM.toUserNickName.length + 1)];
//    }
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
//    [paragraphStyle setLineSpacing:3];
//    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
//    
    _label_comment.attributedText = attributedStr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
