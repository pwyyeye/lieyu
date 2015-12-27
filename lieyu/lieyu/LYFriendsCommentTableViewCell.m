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
    // Initialization code
}

- (void)setCommentM:(FriendsCommentModel *)commentM{
    _commentM = commentM;
//    _btn_headerImg sd_setBackgroundImageWithURL:[NSURL URLWithString:commentM] forState:<#(UIControlState)#> placeholderImage:<#(UIImage *)#>
    _label_comment.text = [NSString stringWithFormat:@"%@:%@",commentM.nickName,commentM.comment];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
